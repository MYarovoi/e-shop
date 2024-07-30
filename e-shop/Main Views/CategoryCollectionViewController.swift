//
//  CategoryCollectionViewController.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 26.07.2024.
//

import UIKit

class CategoryCollectionViewController: UICollectionViewController {
    
    var categoryArray: [Category] = []
    private let sectionsInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    private let itemsPerRows: CGFloat = 3

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadCatigories()
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return categoryArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
        
        cell.generateCell(categoryArray[indexPath.row])
    
        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "categotyToItem", sender: categoryArray[indexPath.row])
    }
    
    //MARK: - Download categories
    
    private func loadCatigories() {
        
        downloadCaregoriesFromFirebase { allCatigories in
            
            self.categoryArray = allCatigories
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "categotyToItem" {
            
            let vc = segue.destination as! ItemsTableViewController
            vc.categoty = sender as! Category
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionsInset.left * (itemsPerRows + 1)
        let availiableWidth = view.frame.width - paddingSpace
        let widthPerItem = availiableWidth / itemsPerRows
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    
        return sectionsInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionsInset.left
    }
}
