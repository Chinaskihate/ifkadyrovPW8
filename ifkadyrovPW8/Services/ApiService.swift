//
//  ApiService.swift
//  ifkadyrovPW8
//
//  Created by user211270 on 3/19/22.
//

import Foundation
import UIKit

class ApiService {
    private let apiKey = "2cba74690481f329d0ee8f1aff8a7b1e"
    private var searchSession: URLSessionDataTask!
    private var pageSession: URLSessionDataTask!

    public func loadMovies(completion: @escaping ([Movie]) -> Void) {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=ru-RU") else {
            return assertionFailure()
        }
        let session = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: { data, _, _ in
            guard
                let data = data,
                let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                let results = dict["results"] as? [[String: Any]]
            else {return}
            let movies: [Movie] = results.map { params in
                let title = params["title"] as! String
                let imagePath = params["poster_path"] as? String
                let id = params["id"] as! Int
                return Movie(
                    title: title,
                    posterPath: imagePath,
                    id: id
                )
            }
            print(movies)
            DispatchQueue.main.async {
                completion(movies)
            }
        })
        
        session.resume()
    }
    
    public func loadImagesForMovies(_ movies: [Movie], completion: @escaping ([Movie]) -> Void) {
        let group = DispatchGroup()
        for movie in movies {
            group.enter()
            DispatchQueue.global(qos: .background).async {
                movie.loadPoster { _ in
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            completion(movies)
        }
    }
    
    public func loadMovies(name: String, completion: @escaping ([Movie]) -> Void){
        if(searchSession != nil){
            searchSession!.cancel()
        }
        guard let url = URL(string:"https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&language=ru-RU&query=\(name)&page=1".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        else {return assertionFailure()}
        searchSession = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: {data, _, _ in
            guard
                let data = data,
                let dict = try? JSONSerialization.jsonObject (with: data, options: []) as? [String: Any],
                let results = dict["results"] as? [[String: Any]]
            else { return }
            let movies: [Movie] = results.map { params in
                let title = params["title"] as! String
                let imagePath = params["poster_path"] as? String
                let id = params["id"] as! Int
                return Movie(
                    title: title,
                    posterPath: imagePath,
                    id: id
                )
            }
            print(movies)
            DispatchQueue.main.async {
                completion(movies)
            }
        })
        searchSession.resume()
    }
    
    public func loadMovies(page: Int, completion: @escaping ([Movie]) -> Void){
        if(searchSession != nil){
            searchSession!.cancel()
        }
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)&language=ru-RU&page=\(page)") else{
            return assertionFailure()
        }
        searchSession = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: {data, _, _ in
            guard
                let data = data,
                let dict = try? JSONSerialization.jsonObject (with: data, options: []) as? [String: Any],
                let results = dict["results"] as? [[String: Any]]
            else { return }
            let movies: [Movie] = results.map { params in
                let title = params["title"] as! String
                let imagePath = params["poster_path"] as? String
                let id = params["id"] as! Int
                return Movie(
                    title: title,
                    posterPath: imagePath,
                    id: id
                )
            }
            DispatchQueue.main.async {
                completion(movies)
            }
        })
        searchSession.resume()
    }
    
    public func getMovie(id: Int, completion: @escaping (Movie) -> Void){
        if(searchSession != nil){
            searchSession!.cancel()
        }
        guard let url = URL(string:"https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)&language=ru-RU".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
        else {return assertionFailure()}
        searchSession = URLSession.shared.dataTask(with: URLRequest(url: url), completionHandler: {data, _, _ in
            guard
                let data = data,
                let params = try? JSONSerialization.jsonObject (with: data, options: []) as? [String: Any]
            else { return }
            let title = params["title"] as! String
            let imagePath = params["poster_path"] as? String
            let id = params["id"] as! Int
            let overview = params["overview"] as! String
            let isAdult = params["adult"] as! Bool
            let budget = params["budget"] as! Int
            let movie = Movie(
                title: title,
                posterPath: imagePath,
                id: id,
                overview: overview,
                isAdult: isAdult,
                budget: budget
            )
            print(movie)
            DispatchQueue.main.async {
                completion(movie)
            }
        })
        searchSession.resume()
    }
}
