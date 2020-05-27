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
    
    //MARK:- Properties
    private var networkController: NetworkController!
    private var storageController: StorageController!
    weak var delegate: StateControllerDelegate?
    private var timer: Timer?
    
    //MARK:- App State
    var colorSettingsArray = [ColorSetting]()
    private var days = [Date:Day]()
    var defaultLocation: Location {
        return storageController.getDefaultLocation()
    }
    var temperatureUnits: TemperatureUnits {
        return TemperatureUnits(rawValue: UserDefaults.standard.integer(forKey: "temperatureUnits")) ?? .fahrenheit
    }
    
    
    init(networkController: NetworkController, storageController: StorageController) {
        self.networkController = networkController
        self.storageController = storageController
        networkController.delegate = self
        colorSettingsArray = storageController.getColorSettings()
        NotificationCenter.default.addObserver(self, selector: #selector(onTimeChange(_:)), name: UIApplication.significantTimeChangeNotification, object: nil)
    }
    
    //notification will be received when midnight
    @ objc func onTimeChange(_ notification: Notification) {
        loadAndUpdateData()
    }
    
    //MARK:- NetworkControllerDelegate Functions
    func didUpdateForecast() {
          storageController.saveContext()
          delegate?.didUpdateForecast()
       }
    
    
    //MARK:- Interface
    
    func loadAndUpdateData() {
        
        let dateThreeDaysAgo = DateHelper.dayFromToday(offset: -3)
        days = days.filter { date, day in
            return date >= dateThreeDaysAgo
        }
        for i in 0..<14 {
            let date = DateHelper.dayFromToday(offset: i)
            let day = getDayForDate(for: date)
            days[date] = day
        }
        //deletes dates older than three days ago from database
        storageController.deleteDaysBefore(date: dateThreeDaysAgo)
        networkController.requestFullForecast(for: days)
        
    }
    
    //Timer for updating data
    func startUpdateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 600, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        timer?.tolerance = 10
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    func stopUpdateTimer() {
        timer?.invalidate()
    }
    @objc private func fireTimer() {
        print("Updating Data")
        loadAndUpdateData()
    }
    
    func updateForecast() {
        networkController.requestFullForecast(for: days)
    }
    
    
    
    //MARK:- Color Interface
    func getAssociatedColor(for placeID: String) -> UIColor {
        if let colorHex = storageController.getColorSetting(for: placeID)?.colorHex {
            return UIColor(hex: colorHex)!
        }
        else if let defaultColor = UIColor(hex: UserDefaults.standard.string(forKey: "defaultColor")!) {
            return defaultColor
        } else {
            return .charcoalGray
        }
    }
    
    func updateAssociatedColor(color: UIColor, for setting: ColorSettingType)  {
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
        let date = Date()
        if let color = color {
            storageController.createOrUpdateColorSetting(colorHex: color.toHex(), place: place, date: date )
        } else {
            storageController.createOrUpdateColorSetting(colorHex: UserDefaults.standard.string(forKey: "defaultColor")!, place: place, date: date)
        }
        colorSettingsArray = storageController.getColorSettings()
    }
    
    func deleteColorSetting(row index: Int) {
        let colorSetting = colorSettingsArray[index]
        colorSettingsArray.remove(at: index)
        storageController.deleteColorSetting(colorSetting: colorSetting)
    }
    
    //MARK:- Day Interface
    

    func getDayForDate(for date: Date) -> Day {
        if let day = days[date] {
            return day
        }
        else if let day = storageController.getDayForDate(for: date) {
            return day
        } else {
            let newDay = storageController.createDefaultDay(date: date)
            return newDay
        }
    }
    
    func getCityForDate(for date: Date) -> String {
        if let day = storageController.getDayForDate(for: date){
            return day.location.locality
        } else {
            return storageController.getDefaultLocation().locality
        }
    }
    
//    func getDaysForDates(for dates: [Date]) -> [String]{
//    
//    }
//    
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

    
    //should refactor this to do updates locations in batch rather than passing to updateOrCreateDay
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



    
