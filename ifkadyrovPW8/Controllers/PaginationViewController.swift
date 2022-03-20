//
//  PaginationViewController.swift
//  ifkadyrovPW8
//
//  Created by user211270 on 3/20/22.
//
import UIKit

class PaginationViewController: UIViewController, UITableViewDelegate {
    
    private let apiService = ApiService()
    private let tableView = UITableView()
    private var movies = [Movie]()
    private var currentPage = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configUI()
        
//        DispatchQueue.global(qos: .background).async { [weak self] in
//            self!.apiService.loadMovies(page: self!.currentPage) { movies in
//                self?.movies.append(contentsOf: movies)
//                DispatchQueue.main.async {
//                    self!.tableView.reloadData()
//                }
//                DispatchQueue.global(qos: .background).async { [weak self] in
//                    self!.apiService.loadImagesForMovies(self!.movies) { movies in
//                        self?.movies = movies
//                        DispatchQueue.main.async {
//                            self!.tableView.reloadData()
//                        }
//                    }
//                }
//            }
//        }
    }

    private func configUI(){
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
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
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}

extension PaginationViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieView.identifier, for: indexPath) as! MovieView
        cell.contentView.isUserInteractionEnabled = false
        cell.configure(movie: movies[indexPath.row])
        return cell
    }
} 

extension PaginationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if (position > tableView.contentSize.height - 100 - scrollView.frame.size.height) {
            self.tableView.tableFooterView = createSpinnerFooter()
            DispatchQueue.global(qos: .background).async { [weak self] in
                self!.apiService.loadMovies(page: self!.currentPage) { movies in
                    self?.movies.append(contentsOf: movies)
                    DispatchQueue.main.async {
                        self!.tableView.reloadData()
                    }
                    DispatchQueue.global(qos: .background).async { [weak self] in
                        self!.apiService.loadImagesForMovies(self!.movies) { movies in
                            self?.movies = movies
                            DispatchQueue.main.async {
                                self!.tableView.reloadData()
                                self!.currentPage = self!.currentPage + 1
                                print(self!.currentPage)
                                self!.tableView.tableFooterView = nil
                            }
                        }
                    }
                }
            }
        }
    }
}
