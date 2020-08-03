//
//  WeatherListViewController.swift
//  Travel Weather
//
//  Created by Renee Sajedian on 1/19/20.
//  Copyright © 2020 Renee Sajedian. All rights reserved.
//

import Foundation
import UIKit

class WeatherListViewController: UITableViewController {

    // MARK: - Properties

    var stateController: StateController! {
        didSet {
            stateController.weatherListDelegate = self
        }
    }
    //default number of rows if there is no "No Internet" Warning
    var numberOfRows = 15

    // MARK: - Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.clipsToBounds = false
        tableView.backgroundColor = .systemGray6

        tableView.register(UINib(nibName: "DayCell", bundle: nil), forCellReuseIdentifier: "DayCell")
        tableView.register(UINib(nibName: "DarkSkyAttributionCell", bundle: nil),
                           forCellReuseIdentifier: "AttributionCell")
        tableView.register(UINib(nibName: "NoInternetCell", bundle: nil), forCellReuseIdentifier: "NoInternetCell")
        tableView.reloadData()

    }

    // MARK: - Internal Functions
    private func configureCell(day: Day, cell: DayCell) {
        cell.weekdayLabel.text = day.weekday
        cell.dateLabel.text = day.date.shortMonthAndDay
        cell.cityLabel.text = day.location.display

        if stateController.temperatureUnits == .fahrenheit {
            cell.lowTempLabel.text = day.lowTempDisplayFahrenheit
            cell.highTempLabel.text = day.highTempDisplayFahrenheit
        } else {
            cell.lowTempLabel.text = day.lowTempDisplayCelsius
            cell.highTempLabel.text = day.highTempDisplayCelsius
        }

        cell.weatherImageView.image = day.weatherImage
        cell.colorView.backgroundColor = stateController.getAssociatedColor(for: day.location.placeID)
    }

    // MARK: - Table View Data Source

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        if stateController.networkError != nil {
            numberOfRows = 16
        } else {
            numberOfRows = 15
        }
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //offset determines which date corresponds to a cell
        let offset: Int
        //show no internet cell if there's a network error
        if stateController.networkError != nil {
            //adjust offset due to extra cell at top of table
            offset = indexPath.row - 1
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoInternetCell",
                                                               for: indexPath) as? WeatherListCell else {
                   fatalError("Failed to dequeue WeatherListCell")
                }
                return cell

            }
        } else {
            offset = indexPath.row
        }
        //last cell is Dark Sky attribution cell
        if indexPath.row == numberOfRows - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AttributionCell",
                                                           for: indexPath) as? WeatherListCell else {
                fatalError("Failed to dequeue WeatherListCell")
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as? DayCell else {
                fatalError("Failed to dequeue DayCell")
            }
            let date = Date.dayFromToday(offset: offset)
            let day = stateController.getDayForDate(for: date)
            configureCell(day: day, cell: cell)
            return cell
        }
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == numberOfRows - 1 {
            if let url = URL(string: "https://darksky.net/poweredby/") {
                UIApplication.shared.open(url)
            }
        }
    }
}

extension WeatherListViewController: StateControllerDelegate {

    func didUpdateForecast() {
        tableView.reloadData()
    }

}
