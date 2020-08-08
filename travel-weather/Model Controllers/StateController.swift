//
//  DayWeatherModelController.swift
//  travel-weather
//
//  Created by Renee Sajedian on 1/25/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//
import UIKit
import Foundation
import GooglePlaces
import CoreData

protocol StateControllerDelegate: class {
    func didUpdateForecast()
}

class StateController: NetworkControllerDelegate {

    // MARK: - Properties
    private var networkController: NetworkController!
    private var storageController: StorageController!
    weak var weatherListDelegate: StateControllerDelegate?
    private var timer: Timer?
    private var errorTimer: Timer?

    // MARK: - App State
    var colorSettingsArray = [ColorSetting]()
    private var days = [Date: Day]()
    var defaultLocation: Location {
        return storageController.getDefaultLocation()
    }
    var temperatureUnits: TemperatureUnits {
        return TemperatureUnits(rawValue: UserDefaults.standard.integer(forKey: "temperatureUnits")) ?? .fahrenheit
    }
    var networkError: NetworkError? {
        return networkController.currentNetworkError
    }
    var defaultColor: UIColor {
        if let colorHex = UserDefaults.standard.string(forKey: "defaultColor"),
            let defaultColor = UIColor(hex: colorHex) {
            return defaultColor
        } else {
            return .charcoalGrayLight
        }
    }

    init(storageController: StorageController, networkController: NetworkController) {
        self.storageController = storageController
        self.networkController = networkController
        networkController.delegate = self
        colorSettingsArray = storageController.getColorSettings()
        //listens for notification when time is midnight (or other important change ie Daylight Savings)
        NotificationCenter.default.addObserver(self, selector: #selector(onTimeChange(_:)),
                                               name: UIApplication.significantTimeChangeNotification, object: nil)
        loadAndUpdateData()
    }

    // MARK: - NetworkControllerDelegate Functions
    func didUpdateForecast() {
        storageController.saveContext()
        weatherListDelegate?.didUpdateForecast()
        if let networkError = networkError, networkError == .noInternet {
            startErrorTimer()
        } else {
            stopErrorTimer()
        }
        print("forecastUpdated")
    }

    // MARK: - Interface- Updating data

    //notification will be received when midnight or another important time change occurs
    @ objc func onTimeChange(_ notification: Notification) {
        loadAndUpdateData()
    }

    func clearOldData() {
       let dateThreeDaysAgo = Date.dayFromToday(offset: -3)
        days = days.filter { date, _ in
            return date >= dateThreeDaysAgo
        }
        //deletes dates older than three days ago from database
        storageController.deleteDaysBefore(date: dateThreeDaysAgo)
    }

    func updateForecast() {
        networkController.requestFullForecast(for: days)
    }

    func loadAndUpdateData() {
        for dayIndex in 0..<14 {
            let date = Date.dayFromToday(offset: dayIndex)
            let day = getDayForDate(for: date)
            days[date] = day
        }
        networkController.requestFullForecast(for: days)
    }

    //Timer for updating data, fires every 10 minutes
    func startUpdateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 600, target: self,
                                     selector: #selector(fireTimer), userInfo: nil, repeats: true)
        timer?.tolerance = 10
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }

    func stopUpdateTimer() {
        timer?.invalidate()
    }

    @objc private func fireTimer() {
        loadAndUpdateData()
    }

    //Checks for updates every 10s if there is no network connection
    func startErrorTimer() {
        guard errorTimer == nil else { return }
        errorTimer = Timer.scheduledTimer(timeInterval: 10, target: self,
                                          selector: #selector(fireTimer), userInfo: nil, repeats: true)
        errorTimer?.tolerance = 2
        RunLoop.current.add(errorTimer!, forMode: RunLoop.Mode.common)
    }
    func stopErrorTimer() {
        errorTimer?.invalidate()
        errorTimer = nil
    }

    // MARK: - Color Interface
    func getAssociatedColor(for placeID: String) -> UIColor {
        if let colorHex = storageController.getColorSetting(for: placeID)?.colorHex,
            let color = UIColor(hex: colorHex) {
            return color
        } else {
            return defaultColor
        }
    }

    func updateAssociatedColor(color: UIColor, for setting: ColorSettingType) {
        switch setting {
        case .defaultColor:
            UserDefaults.standard.set(color.toHex(), forKey: "defaultColor")
        case .place(let placeID):
            let date = Date()
            storageController.updateColorSetting(colorHex: color.toHex(), placeID: placeID, date: date)
            colorSettingsArray = storageController.getColorSettings()
        }
    }

    func addAssociatedColor(color: UIColor?, for place: GMSPlace) {
        //current date is used to organize color settings by the time they were set
        let date = Date()
        if let color = color {
            storageController.createOrUpdateColorSetting(colorHex: color.toHex(), place: place, date: date)
        } else {
            storageController.createOrUpdateColorSetting(colorHex: defaultColor.toHex(), place: place, date: date)
        }
        colorSettingsArray = storageController.getColorSettings()
    }

    func deleteColorSetting(row index: Int) {
        let colorSetting = colorSettingsArray[index]
        colorSettingsArray.remove(at: index)
        storageController.deleteColorSetting(colorSetting: colorSetting)
    }

    // MARK: - Day Interface

    func getDayForDate(for date: Date) -> Day {
        if let day = days[date] {
            return day
        } else if let day = storageController.getDayForDate(for: date) {
            return day
        } else {
            let newDay = storageController.createDefaultDay(date: date)
            return newDay
        }
    }

    func getLocationDisplay(for date: Date) -> String {
        if let day = storageController.getDayForDate(for: date) {
            return day.location.display
        } else {
            return storageController.getDefaultLocation().display
        }
    }

    func locationWasSet(for date: Date) -> Bool {
        if let day = storageController.getDayForDate(for: date) {
            return day.locationWasSet
        } else {
            return false
        }
    }

    func updateOrCreateDay(didSelect newLocation: GMSPlace, for date: Date) {
        storageController.updateOrCreateDay(date: date, place: newLocation)
        if let day = days[date] {
            networkController.requestDayForecast(for: day)
        }
    }

    //should refactor this to update locations in batch rather than passing to updateOrCreateDay
    func updateOrCreateDays(didSelect newLocation: GMSPlace, for dates: [Date]) {
        for date in dates {
            updateOrCreateDay(didSelect: newLocation, for: date)
        }
    }

    func changeDefaultLocation(didSelect newLocation: GMSPlace) {
        storageController.setDefaultLocation(place: newLocation)
        let defaultDays = days.filter { $0.value.locationWasSet == false }
        storageController.updateDefaultDays(days: defaultDays)
        networkController.requestFullForecast(for: defaultDays)
    }

}
