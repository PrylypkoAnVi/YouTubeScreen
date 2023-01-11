//
//  NetworkManager.swift
//  YouTubeScreen
//
//  Created by Anastasia on 10.01.2023.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private init() { }
    
    let jsonURL = "https://api.unsplash.com/photos/random/?client_id=vds0dxJ6TfFVFwLQu0EFnaxdMfl4J2AbFd9O6Dewd4s&count=4&orientation=landscape"
    
    func getImageData(completion: @escaping ([ImageData]?) -> Void, onFailure: @escaping (CustomError) -> ()) {
        
        let request = AF.request(jsonURL, method: HTTPMethod.get, parameters: nil, encoding: URLEncoding.default, headers: HTTPHeaders.default)
        
        request.validate().responseDecodable(of: Unsplash.self) { response in
            switch response.result {
            case .success(let data):
                completion(data.compactMap{
//                    let url = URL(string: $0.links.html)
                    return ImageData(user: $0.user.name, createdAt: $0.createdAt, altDescription: $0.altDescription, likes: $0.likes, link: $0.links.html)
                })
                print(data)
            case .failure(let error):
                if response.data == nil {
                    onFailure(CustomError.noInternetConnection)
                    print(error)
                } else {
                    onFailure(CustomError.unexpected)
                    print(error)
                }
            }
        }
    }
}

