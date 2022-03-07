//
//  DogBreedListTableViewController.swift
//  DogBreeds
//
//  Created by Rammel on 2022-01-25.
//

import UIKit

class DogBreedTableViewController: UITableViewController {
    
    var dogBreedList = [DogBreed]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchDogBreed { response in
            switch response {
            case .success(let data):
                self.dogBreedList = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogBreedList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "dogbreed", for: indexPath) as? DogBreedCell
        else {
            fatalError("Unable to dequeue dogbreed")
        }
        let dogBreed = dogBreedList[indexPath.row]
        
        if dogBreed.subBreed.isEmpty {
            cell.breedLabel.text = dogBreed.name
            cell.subBreedLabel.text = ""
        } else {
            cell.breedLabel.text = "\(dogBreed.name):"
            var subbreedText = ""
            for (index, subbreed) in dogBreed.subBreed.enumerated() {
                if index == 0 || index == dogBreed.subBreed.count - 1 {
                    subbreedText += subbreed
                } else {
                    subbreedText += "\(subbreed), "
                }
            }
            cell.subBreedLabel.text = subbreedText
        }
        return cell
    }
    
}
