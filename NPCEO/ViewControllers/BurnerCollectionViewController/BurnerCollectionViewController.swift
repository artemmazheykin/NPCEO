//
//  BurnerCollectionViewController.swift
//  NPCEO
//
//  Created by  Artem Mazheykin on 06.03.2020.
//  Copyright © 2020 Artem Mazheykin. All rights reserved.
//

import UIKit

class BurnerCollectionViewController: UIViewController {

    @IBOutlet weak var burnerCollectionView: UICollectionView!
    var burnerTypesMas: [BurnerTypeName] = [.gkvd,.nastil,.dut,.inzh,.ggi,.trubcol]
    
    
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
        cell.burnerImageView.image = UIImage(named: burnerTypesMas[indexPath.item].imageName)
        cell.burnerTypeName.text = burnerTypesMas[indexPath.item].typeName
        
        return cell
    }
    
    
    
}
