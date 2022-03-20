//
//  Movie.swift
//  ifkadyrovPW8
//
//  Created by user211270 on 3/19/22.
//

import Foundation
import UIKit

class Movie {
    let title: String
    let posterPath: String?
    var poster: UIImage? = nil
    let id: Int
    let overview: String
    let isAdult: Bool
    let budget: Int
    
    init(title: String, posterPath: String?, id: Int, overview: String = "", isAdult: Bool = true, budget: Int = 0) {
        self.title = title
        self.posterPath = posterPath
        self.id = id
        self.overview = overview
        self.isAdult = isAdult
        self.budget = budget
    }
    
    // TODO: relocate to apiservice
    func loadPoster(completion: @escaping (UIImage?) -> Void){
        guard
            let posterPath = posterPath,
            let url = URL(string:"https://image.tmdb.org/t/p/original/\(posterPath)")
        else { return completion(nil) }
        let request = URLSession.shared.dataTask(with: URLRequest (url: url)) { [weak self] data, _, _ in
            guard
                let data = data,
                let image = UIImage (data: data) else {
                return completion(nil)
            }
            self?.poster = image
            completion(image)

        }
        request.resume()
    }
}
