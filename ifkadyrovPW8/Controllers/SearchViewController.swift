//
//  ViewController.swift
//  ifkadyrovPW8
//
//  Created by user211270 on 3/19/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let apiService = ApiService()
    private let tableView = UITableView()
    private var movies = [Movie]()
    private let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configUI()
    }

    private func configUI(){
        view.addSubview(tableView)
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.register(MovieView.self, forCellReuseIdentifier: MovieView.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo:view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo:view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo:view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor)
        ])
        tableView.rowHeight = 540
        tableView.reloadData()
    }
}

extension SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieView.identifier, for: indexPath) as! MovieView
        cell.configure(movie: movies[indexPath.row])
        return cell
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.apiService.loadMovies(name: searchText) { movies in
                self?.movies = movies
                DispatchQueue.main.async {
                    self!.tableView.reloadData()
                }
                DispatchQueue.global(qos: .background).async { [weak self] in
                    self!.apiService.loadImagesForMovies(self!.movies) { movies in
                        self?.movies = movies
                        DispatchQueue.main.async {
                            self!.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

