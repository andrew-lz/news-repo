//
//  NetworkDataFetcher.swift
//  News-View
//
//  Created by BMF on 1.09.21.
//

import Foundation

class NetworkDataFetcher {
    
    private let networkService = NetworkService()
    private let apiKey = "19aca4fda67d47f3b866f0ee8028f6fd"
    //           "220fba25b6d14383908e89872d1136da"
    //           "f1aa354959d04f21b021d83392ce310a"
    
    private func fetchNews(urlString: String, response: @escaping (NewsResponse?) -> Void) {
        networkService.request(urlString: urlString) { (result) in
            switch result {
            case .success(let data):
                do {
                    let news = try JSONDecoder().decode(NewsResponse.self, from: data)
                    response(news)
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                }
            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
        }
    }
    
    private func formUrl(before daysQuantity: Int) -> String {
        let language = "en"
        let q = "bitcoin"
        let from = Date().getDate(before: daysQuantity)
        let to =  Date().getDate(before: daysQuantity - 1)
        let scheme = "https"
        let host = "newsapi.org"
        let path = "/v2/everything"
        
        let queryParams: [String: String] = [
            "apiKey": apiKey,
            "language": language,
            "q": q,
            "from": from,
            "to": to
        ]
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        
        urlComponents.setQueryItems(with: queryParams)
        return urlComponents.url!.absoluteString
    }
    
    func loadNewsPage(before daysQuantity: Int, then handler: @escaping (NewsResponse) -> Void) {
        let url: String = formUrl(before: daysQuantity)
        fetchNews(urlString: url) { news in
            guard let news = news else { return }
            handler(news)
        }
    }
}

private class NetworkService {
    
    func request(urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                completion(.success(data))
            }
        }.resume()
    }
}

extension URLComponents {
    
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

extension Date {
    func getDate(before daysQuantity: Int) -> String{
        return ISO8601DateFormatter().string(from: Calendar.current.date(byAdding: .day, value: -daysQuantity, to: self)!)
    }
}


