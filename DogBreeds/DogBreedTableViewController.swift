//
//  DogBreedListTableViewController.swift
//  DogBreeds
//
//  Created by Rammel on 2022-01-25.
//

import UIKit

class DogBreedTableViewController: UITableViewController {
    
    var dogBreedList = [DogBreed]()
    var firstLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //fetch dog breed list
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //reload data after image randomly generated in detail view
        if !firstLoad {
            self.tableView.reloadData()
        } else {
            firstLoad = false
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
        
        // only retrieve random image once
        if let image = dogBreed.image {
            // store previously retrieved image to avoid fetching again when scrolling
            cell.dogBreedImage.image = image
        } else {
            cell.spinner.isHidden = false
            fetchDogImage(dogBreed: dogBreed.name) { response in
                switch response {
                case .success(let data):
                    DispatchQueue.main.async {
                        cell.spinner.isHidden = true
                        cell.dogBreedImage.image = data
                        self.dogBreedList[indexPath.row].image = data
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // pass the selected dog breed
        if let dst = segue.destination as? DogBreedDetailViewController {
            dst.dogBreed = dogBreedList[tableView.indexPathForSelectedRow!.row]
            dst.title = dst.dogBreed.name
        }
    }
    
}
