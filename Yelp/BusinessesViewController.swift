//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var term: String = "Restaurants"
    var filter: Filter = Filter()
    
    var businesses: [Business]! = []
    
    var displayBusinesses: [Business]! = []
    
    @IBOutlet weak var businessTableView: UITableView!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet var searchBar: UISearchBar!
    //var searchBar: UISearchBar!
    //var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = searchBar
        
        searchBar.delegate = self
        
        businessTableView.delegate = self
        businessTableView.dataSource = self
        
        searchBusiness()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Implementing UITableViewDataSource, UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayBusinesses.count
    }
    
    // Create a cell to display
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell") as! BusinessTableViewCell
        let business = self.displayBusinesses[indexPath.row]
        cell.setContent(business: business)
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchButton.isHidden = false
        if (searchText.isEmpty) {
            self.displayBusinesses = self.businesses
        } else {
            self.displayBusinesses = self.businesses.filter({ (business: Business) -> Bool in
                (business.name?.contains(searchText))! || (business.address?.contains(searchText))! || (business.categories?.contains(searchText))!
        
            })
        }
        self.businessTableView.reloadData()
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        if (self.searchBar.text == nil) {
            self.term = "Restaurants"
        } else {
            let searchText = self.searchBar.text!
            if (searchText.isEmpty) {
                self.term = "Restaurants"
            } else {
                self.term = searchText
            }
        }
        searchBusiness()
    }
    
    func reloadBusiness(term: String) {
        if (term.isEmpty) {
            self.displayBusinesses = self.businesses
        } else {
            Business.searchWithTerm(term: term, completion: self.storeBusinesses)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! UINavigationController
        let vc = controller.topViewController as! FilterViewController
        vc.filter.setFilter(filter)
    }
    
    private func searchBusiness() {
        //Business.searchWithTerm(term: self.term, completion: self.storeBusinesses)
        /* Example of Yelp search with more search options specified */
        print("search \(filter.toString())")
        Business.searchWithTerm(
            term: self.term,
            sort: self.filter.getSortType(),
            categories: self.filter.getSelectedCategory(),
            deals: self.filter.offerDeal,
            completion: self.storeBusinesses)
    }
    
    private func filterDistance(business: Business) -> Bool {
        let s: String = business.distance!
        let v: Float = Float(s.substring(to: s.index(s.endIndex, offsetBy: -2)))!
        return v <= filter.getDistanceValue()
    }
    
    private func storeBusinesses(businesses: [Business]?, error: Error?) -> Void {
        self.searchButton.isHidden = true
        self.businesses = businesses
        if let businesses = businesses {
            self.displayBusinesses = businesses
            self.businessTableView.reloadData()
        }
    }
}
