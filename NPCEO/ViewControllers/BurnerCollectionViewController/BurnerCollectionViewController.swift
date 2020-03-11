//
//  BurnerCollectionViewController.swift
//  NPCEO
//
//  Created by  Artem Mazheykin on 06.03.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import UIKit
import Firebase

class BurnerCollectionViewController: UIViewController {

    @IBOutlet weak var burnerCollectionView: UICollectionView!
    var burnerTypesMas: [BurnerTypeName] = [.gkvd,.nastil,.dut,.inzh,.ggi,.trubcol]
    let storage = Storage.storage()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        burnerCollectionView.delegate = self
        burnerCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension BurnerCollectionViewController: UICollectionViewDelegate{
    
}

extension BurnerCollectionViewController: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return burnerTypesMas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BurnerCollectionViewCell", for: indexPath) as! BurnerCollectionViewCell
        
        let storageRef = storage.reference()
        let spaceRef = storageRef.child("images/typesOfBurner/\(indexPath.item+1).png")
        Spinners.spinnerStart(spinner: cell.spinner)
        spaceRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let err = error {
            print("Can't load image \(spaceRef.fullPath), error = \(err.localizedDescription)")
            Spinners.spinnerStop(spinner: cell.spinner)
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            Spinners.spinnerStop(spinner: cell.spinner)
            cell.burnerImageView.image = image
          }
        }
        cell.burnerTypeName.text = burnerTypesMas[indexPath.item].typeName
        
        return cell
    }
    
    
    
}
