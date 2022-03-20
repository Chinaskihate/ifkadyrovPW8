//
//  ListViewController.swift
//  ifkadyrovPW8
//
//  Created by user211270 on 3/20/22.
//

import Foundation
import UIKit

class ListViewController: UIViewController {
    private let apiService = ApiService()
    private var movies: [Movie] = []
    private var currentPage: Int = 1
    private let numberOfPages = 500
    private let tableView = UITableView()
    private var prevButton: UIBarButtonItem!
    private var nextButton: UIBarButtonItem!
    private let currentLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray
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
    }
    
    private func configureUI() {
        configureTableView()
        configureNavItem()
    }
    
    private func configureTableView() {
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
    
    private func configureNavItem() {
        prevButton = UIBarButtonItem(title: "Previous page", style: .plain, target: self, action: #selector(didTapPrevButton))
        nextButton = UIBarButtonItem(title: "Next page", style: .plain, target: self, action: #selector(didTapNextButton))
        currentLabel.text = String(currentPage)
        currentLabel.font = UIFont(name: currentLabel.font.fontName, size: 25)
        navigationItem.leftBarButtonItem = nil
        navigationItem.titleView = currentLabel
        navigationItem.rightBarButtonItem = nextButton
    }
    
    @objc private func didTapPrevButton(_ sender: UIButton) {
        navigationItem.rightBarButtonItem = nextButton
        if (currentPage == 2) {
            navigationItem.leftBarButtonItem = nil
        }
        currentPage = currentPage - 1
        didTapButton()
    }
    
    @objc private func didTapNextButton(_ sender: UIButton) {
        navigationItem.leftBarButtonItem = prevButton
        if (currentPage == numberOfPages - 1) {
            navigationItem.rightBarButtonItem = nil
        }
        currentPage = currentPage + 1
        didTapButton()
    }
    
    private func didTapButton() {
        currentLabel.text = String(currentPage)
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.apiService.loadMovies(page: self!.currentPage) { movies in
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

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieView.identifier, for: indexPath) as! MovieView
        cell.configure(movie: movies[indexPath.row])
        print(cell.title.text)
        return cell
    }
}
