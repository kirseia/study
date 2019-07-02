import UIKit

private let reuseIdentifier = "Cell"

class ReorderCollectionView: UICollectionViewController {
    var alphabet = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let str: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        
        for i in str {
            alphabet.append(String(i))
        }
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
