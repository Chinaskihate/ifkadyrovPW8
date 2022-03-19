//
//  MoviesViewController.swift
//  ifkadyrovPW8
//
//  Created by user211270 on 3/19/22.
//

import Foundation
import UIKit

class MoviesViewController: UIViewController {
    private let apiService = ApiService()
    private var movies: [Movie] = []
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            self!.apiService.loadMovies() { movies in
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
        
        
        // tableView.reloadData()
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.register(MovieView.self, forCellReuseIdentifier: MovieView.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.rowHeight = 540
        tableView.reloadData()
    }
}

extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieView.identifier, for: indexPath) as! MovieView
        //let cell = MovieView()
        cell.configure(movie: movies[indexPath.row])
        print(cell.title.text)
        return cell
    }
}
