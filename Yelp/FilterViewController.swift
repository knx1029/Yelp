//
//  FilterViewController.swift
//  Yelp
//
//  Created by Nanxi Kang on 9/22/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import DropDown
import UIKit

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OptionTableViewCellDelegate {
    
    @IBOutlet weak var filterTable: UITableView!
    
    var filter: Filter = Filter()
    
    var distanceExpand: Bool = false
    var sortByExpand: Bool = false
    var categoryExpand: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("am here!")
        
        filterTable.delegate = self
        filterTable.dataSource = self
        
        distanceExpand = false
        sortByExpand = false
        categoryExpand = false
        filter.refreshCategory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // OFFER DEAL
    // DISTANCE
    // SORT BY
    // CATEGORY
    
    let NUM_OPTIONS: Int = 4
    let NUM_CATEGORIES_DISPLAY: Int = 4
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return NUM_OPTIONS
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0: return 1
        case 1: if (distanceExpand) {
            return filter.DISTANCE_OPTIONS.count + 1
        } else {
            return 1
        }
        case 2: if (sortByExpand) {
            return filter.SORT_OPTIONS.count + 1
        } else {
            return 1
        }
        default: return self.lastCategoryRow() + 1
        }
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String?  {
        switch (section) {
        case 0: return ""
        case 1: return "Distance"
        case 2: return "Sort By"
        case 3: return "Category"
        default:
            print("Invalid section \(section)")
            return "ERROR"
            //throw FilterError.InvalidSectionError(section: section)
        }
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        print("Get cell for \(section), \(row)")
        switch (section) {
        case 0:
            let cell = filterTable.dequeueReusableCell(withIdentifier: "OptionCell") as! OptionTableViewCell
            cell.optionType = .OfferDeal
            cell.delegate = self
            cell.optionLabel.text = "Offer a deal"
            cell.optionSwitch.setOn(filter.offerDeal, animated: true)
            return cell
        case 1:
            if (distanceExpand && row != 0) {
                let cell = filterTable.dequeueReusableCell(withIdentifier: "ExpandCell") as! ExpandTableViewCell
                cell.expandLabel.text = filter.DISTANCE_OPTIONS[row - 1].0
                return cell
            } else {
                let cell = filterTable.dequeueReusableCell(withIdentifier: "DropdownCell") as! DropdownTableViewCell
                cell.menuLabel.text = filter.getDistance()
                if (distanceExpand) {
                    cell.arrowImage.image = UIImage(named: "arrow")
                } else {
                    cell.arrowImage.image = UIImage(named: "right-arrow")
                }
                return cell
            }
        case 2:
            if (sortByExpand && row != 0) {
                let cell = filterTable.dequeueReusableCell(withIdentifier: "ExpandCell") as! ExpandTableViewCell
                cell.expandLabel.text = filter.SORT_OPTIONS[row - 1].0
                return cell
            } else {
                let cell = filterTable.dequeueReusableCell(withIdentifier: "DropdownCell") as! DropdownTableViewCell
                cell.menuLabel.text = filter.getSort()
                if (sortByExpand) {
                    cell.arrowImage.image = UIImage(named: "arrow")
                } else {
                    cell.arrowImage.image = UIImage(named: "right-arrow")
                }
                return cell
            }
        case 3:
            if (row < self.lastCategoryRow()) {
                let cell = filterTable.dequeueReusableCell(withIdentifier: "OptionCell") as! OptionTableViewCell
                cell.optionType = .Category(index: row)
                cell.delegate = self
                cell.optionLabel.text = filter.getCategoryName(row)
                cell.optionSwitch.setOn(filter.getCategorySelected(row), animated: true)
                return cell
            } else {
                let cell = filterTable.dequeueReusableCell(withIdentifier: "ExpandCell") as! ExpandTableViewCell
                if (categoryExpand) {
                    cell.expandLabel.text = "Show less"
                } else {
                    cell.expandLabel.text = "See all"
                }
                return cell
            }
        default:
            print("Invalid IndexPath \(indexPath)")
            let cell = filterTable.dequeueReusableCell(withIdentifier: "DropdownCell") as! DropdownTableViewCell
            return cell
            //throw FilterError.InvalidaIndexPathError(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        print("Select \(section), \(row)")
        
        switch (section) {
        // case 0: doing nothing
        case 1:
            distanceExpand = !distanceExpand
            if (row != 0) {
                self.filter.distanceIndex = row - 1
            }
            self.filterTable.reloadData()
        case 2:
            sortByExpand = !sortByExpand
            if (row != 0) {
                self.filter.sortIndex = row - 1
            }
            self.filterTable.reloadData()
        case 3:
            if ((categoryExpand && row == self.filter.CATEGORY_OPTIONS.count) || (!categoryExpand && row == NUM_CATEGORIES_DISPLAY)) {
                categoryExpand = !categoryExpand
                filter.refreshCategory()
                self.filterTable.reloadData()
            }
        default:
            print("no change!")
        }
    }
    
    private func lastCategoryRow() -> Int {
        if (categoryExpand) {
            return self.filter.CATEGORY_OPTIONS.count
        } else {
            return self.NUM_CATEGORIES_DISPLAY
        }
    }
    
    func switchTapped(_ cell: OptionTableViewCell) {
        switch (cell.optionType) {
        case .OfferDeal:
            print("OfferDeal tapped")
            self.filter.offerDeal = cell.optionSwitch.isOn
        case .Category(let index):
            print("Category \(index) tapped")
            self.filter.category[index].0 = cell.optionSwitch.isOn
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let button = sender as! UIBarButtonItem
        if (button == navigationItem.leftBarButtonItem) {
            // is cancel
            print("CANCEL")
        } else {
            // is search
            print("SEARCH")
            let controller = segue.destination as! UINavigationController
            let vc = controller.topViewController as! BusinessesViewController
            vc.filter.setFilter(filter)
        }
    }
}
