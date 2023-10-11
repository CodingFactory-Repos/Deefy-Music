//
//  SearchViewController.swift
//  Deefy Music
//
//  Created by Ilan Petiot on 11/10/2023.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var SearchTableView: UITableView!

    var search: [Search] = [Search(image: "Haikyuuu", artist: "Haruichi", title: "Haikyuuu"), Search(image: "Darius", artist: "Riot", title: "Darius"), Search(image: "Haikyuuu", artist: "Haruichi", title: "Haikyuuu"), Search(image: "Haikyuuu", artist: "Haruichi", title: "Haikyuuu"), Search(image: "Haikyuuu", artist: "Haruichi", title: "Haikyuuu"), Search(image: "Haikyuuu", artist: "Haruichi", title: "Haikyuuu"), Search(image: "Haikyuuu", artist: "Haruichi", title: "Haikyuuu")]
    var filteredData: [Search]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"

        filteredData = search
        SearchTableView.dataSource = self
        SearchTableView.delegate = self
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchTableViewCell
        cell.Title.text = filteredData[indexPath.row].title
        cell.Artist.text = filteredData[indexPath.row].artist
        cell.MusicImage.image = UIImage(named: filteredData[indexPath.row].image)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Music") as? MusicViewController {
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//      }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        filteredData = []
        if searchText == "" {
            filteredData = search
        } else {
            for search in search {
                if search.title.lowercased().contains(searchText.lowercased()) {
                    filteredData.append(search)
                }
            }
        }
        self.SearchTableView.reloadData()
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

