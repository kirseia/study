//
//  DragCollectionViewController.swift
//  ReorderedCollectionView
//
//  Created by Hanyoung on 02/07/2019.
//  Copyright © 2019 Hanyoung. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class DragCollectionViewController: UICollectionViewController {

    var alphabet = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        for i in str {
            alphabet.append(String(i))
        }
        
        self.collectionView.dragDelegate = self
        self.collectionView.dropDelegate = self
        self.collectionView.dragInteractionEnabled = true
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        // 1
        // return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // 2
        // return the number of items
        return alphabet.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 3
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AlphabetCell
        
        // Configure the cell
        cell.alphabetLabel.text = alphabet[indexPath.row]
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = alphabet.remove(at: sourceIndexPath.item)
        alphabet.insert(temp, at: destinationIndexPath.item)
    }
    

}

extension DragCollectionViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let beginAlphabet = alphabet[indexPath.item]
        
        let item = NSItemProvider(object: beginAlphabet as NSString )
        let dragItem = UIDragItem(itemProvider: item)
        return [dragItem]
        
    }
}

extension DragCollectionViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else {
            return
        }
        
        coordinator.items.forEach { (dropItem ) in
            guard let sourceIndexPath = dropItem.sourceIndexPath else {
                return
            }
            
            collectionView.performBatchUpdates({
                let str = alphabet[sourceIndexPath.item]
                
                removeAlphabet(at: sourceIndexPath)
                insertAlphabet(newAlphabet: str, at: destinationIndexPath)
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
                
            }, completion: { (_) in
                coordinator.drop(dropItem.dragItem, toItemAt: destinationIndexPath)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
        private func removeAlphabet(at indexPath: IndexPath) {
            alphabet.remove(at: indexPath.item)
        }
    
        private func insertAlphabet(newAlphabet: String,  at indexPath: IndexPath) {
            alphabet.insert(newAlphabet, at: indexPath.item)
        }
    
        func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession,
            withDestinationIndexPath destinationIndexPath: IndexPath?)
            -> UICollectionViewDropProposal {
                return UICollectionViewDropProposal(
                    operation: .move,
                    intent: .insertAtDestinationIndexPath)
        }
}
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//        <#code#>
//    }
//
//

//
//    func collectionView(_ collectionView: UICollectionView,
//                        canHandle session: UIDropSession) -> Bool {
//        return true
//    }
//
//

//}
