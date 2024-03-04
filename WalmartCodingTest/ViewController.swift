//
//  ViewController.swift
//  WalmartCodingTest
//
//  Created by Brian Hogan on 3/3/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var countries: [Country] = []
    var filteredCountries: [Country] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCountries()
        setupSearchController()
    }

    func fetchCountries() {
        guard let url = URL(string: "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                self?.countries = countries
                self?.filteredCountries = countries
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Countries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        let country = filteredCountries[indexPath.row]
        cell.configure(with: country)
        return cell
    }
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.capital.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}

