//
//  CategoryCollectionViewController.swift
//  e-shop
//
//  Created by Mykyta Yarovoi on 26.07.2024.
//

import UIKit

class CategoryCollectionViewController: UICollectionViewController {
    
    var categoryArray: [Category] = []

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
    
    //MARK: - Download categories
    
    private func loadCatigories() {
        
        downloadCaregoriesFromFirebase { allCatigories in
            
            self.categoryArray = allCatigories
            self.collectionView.reloadData()
        }
    }
}
