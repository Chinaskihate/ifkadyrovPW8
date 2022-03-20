//
//  MovieView.swift
//  ifkadyrovPW8
//
//  Created by user211270 on 3/19/22.
//

import Foundation
import UIKit

class MovieView: UITableViewCell {
    static let identifier = "MovieCell"
    var movieId: Int!
    let poster = UIImageView()
    let titleLabel = UILabel()
    let button = UIButton()
    
    init() {
        super.init(style: .default, reuseIdentifier: Self.identifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: Self.identifier)
        configureUI()
    }
    
    private func configureUI() {
        poster.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(poster)
        addSubview(titleLabel)
        addSubview(button)
        
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: topAnchor),
            poster.leadingAnchor.constraint(equalTo: leadingAnchor),
            poster.trailingAnchor.constraint(equalTo: trailingAnchor),
            poster.heightAnchor.constraint(equalToConstant: 500),
            
            button.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 5),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            button.widthAnchor.constraint(equalToConstant: 80),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            titleLabel.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -5),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            
        ])
        titleLabel.textAlignment = .center
        button.setTitle("Info", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    func configure(movie: Movie) {
        titleLabel.text = movie.title
        poster.image = movie.poster
        movieId = movie.id
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        let rootVC = MovieInfoController()
        rootVC.title = titleLabel.text
        rootVC.poster.image = poster.image
        rootVC.movieId = movieId
        let navVC = UINavigationController(rootViewController: rootVC)
        
        getCurrentVC()!.present(navVC, animated: true)
    }
    
    private func getCurrentVC() -> UIViewController? {
            if let rootController = UIApplication.shared.keyWindow?.rootViewController {
                var currentController: UIViewController! = rootController
                while( currentController.presentedViewController != nil ) {
                    currentController = currentController.presentedViewController
                }
                return currentController
            }
            return nil
        }
}
