//
//  MovieInfoController.swift
//  ifkadyrovPW8
//
//  Created by user211270 on 3/20/22.
//

import UIKit

class MovieInfoController : UIViewController {
    let apiService = ApiService()
    var movie: Movie!
    var poster = UIImageView()
    var overviewText = UITextView()
    var isAdultLabel = UILabel()
    var isAdultValueLabel = UILabel()
    var budgetLabel = UILabel()
    var budgetValueLabel = UILabel()
    var voteLabel = UILabel()
    var voteValueLabel = UILabel()
    var movieId: Int!
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        configUI()
        DispatchQueue.global(qos: .background).async { [weak self] in
            self!.apiService.getMovie(id: self!.movieId) { movie in
                self?.movie = movie
                DispatchQueue.main.async {
                    self?.overviewText.textAlignment = .center
                    self?.overviewText.text = movie.overview
                    self?.overviewText.sizeToFit()
                    self?.isAdultValueLabel.text = movie.isAdult ? "Да" : "Нет"
                    self?.budgetValueLabel.text = String(movie.budget) + "$"
                    
                }
            }
        }
    }
    
    func configUI() {
        poster.translatesAutoresizingMaskIntoConstraints = false
        overviewText.translatesAutoresizingMaskIntoConstraints = false
        isAdultLabel.translatesAutoresizingMaskIntoConstraints = false
        isAdultValueLabel.translatesAutoresizingMaskIntoConstraints = false
        budgetLabel.translatesAutoresizingMaskIntoConstraints = false
        budgetValueLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewText.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(poster)
        view.addSubview(isAdultLabel)
        view.addSubview(isAdultValueLabel)
        view.addSubview(budgetLabel)
        view.addSubview(budgetValueLabel)
        view.addSubview(overviewText)
        
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: view.topAnchor),
            poster.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            poster.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            poster.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.frame.height * 0.4),
            
            isAdultLabel.topAnchor.constraint(equalTo: poster.bottomAnchor),
            isAdultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            isAdultLabel.widthAnchor.constraint(equalToConstant: view.frame.width * 0.4),
            isAdultLabel.heightAnchor.constraint(equalToConstant: 50),
            
            isAdultValueLabel.topAnchor.constraint(equalTo: poster.bottomAnchor),
            isAdultValueLabel.leadingAnchor.constraint(equalTo: isAdultLabel.trailingAnchor, constant: 10),
            isAdultValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            isAdultValueLabel.heightAnchor.constraint(equalToConstant: 50),
            
            budgetLabel.topAnchor.constraint(equalTo: isAdultLabel.bottomAnchor),
            budgetLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            budgetLabel.widthAnchor.constraint(equalToConstant: view.frame.width * 0.4),
            budgetLabel.heightAnchor.constraint(equalToConstant: 50),
            
            budgetValueLabel.topAnchor.constraint(equalTo: isAdultLabel.bottomAnchor),
            budgetValueLabel.leadingAnchor.constraint(equalTo: budgetLabel.trailingAnchor, constant: 10),
            budgetValueLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            budgetValueLabel.heightAnchor.constraint(equalToConstant: 50),
            
            overviewText.topAnchor.constraint(equalTo: budgetLabel.bottomAnchor, constant: 10),
            overviewText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            overviewText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            overviewText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        ])
        isAdultLabel.text = "Для взрослых"
        budgetLabel.text = "Бюджет"
        isAdultLabel.textAlignment = .left
        isAdultValueLabel.textAlignment = .right
        budgetLabel.textAlignment = .left
        budgetValueLabel.textAlignment = .right
        overviewText.isEditable = false
        overviewText.sizeToFit()
    }
}
