//
//  CharactersRepository.swift
//  MarvelCharacters
//
//  Created by Roberto Jesus Amaral (P) on 22/07/22.
//

import Foundation

protocol CharactersRepositoryProtocol {
    func listCharacters(offSet: Int?, completion: @escaping(Result<[CharacterData], Error>) -> Void  )
}

enum APIErrors: String, Error {
    case invalidApiCall = "Houve um erro ao tentar pegar os dados do servidor, Por favor tente novamente mais tarde"
}

class CharactersRepository: CharactersRepositoryProtocol {
    
    let baseUrl = "https://gateway.marvel.com:443/v1/public/characters"
    
    func listCharacters(offSet: Int?, completion: @escaping (Result<[CharacterData], Error>) -> Void) {
        let charactersRequest = CharactersRequest()
        var url: URL? = URL(string: baseUrl)
        url?.appendQueryItem(name: "limit", value: charactersRequest.limit)
        url?.appendQueryItem(name: "ts", value: String(charactersRequest.ts))
        url?.appendQueryItem(name: "apikey", value: charactersRequest.apiKey)
        url?.appendQueryItem(name: "hash", value: charactersRequest.hash)
        url?.appendQueryItem(name: "offset", value: String(offSet ?? 0))
        
        guard let resourceUrl = url else {fatalError()}
        
        var urlRequest = URLRequest(url: resourceUrl)
        urlRequest.httpMethod = charactersRequest.httpMethod
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if error != nil {
                completion(.failure(APIErrors.invalidApiCall))
            }
            
            do {
                if let result = data {
                    let jsonResponse = try JSONDecoder().decode(ApiResult.self, from: result)
                    
                    var characterList:[CharacterData] = []
                    
                    for value in jsonResponse.data.results {
                        
                        let urlPath = ((value.thumbnail.path ?? "") + "." + (value.thumbnail.extension ?? ""))
                        let character = CharacterData(name: value.name, description: value.description, imageUrl: urlPath)
                        characterList.append(character)
                    }
                    
                    completion(.success(characterList))
                }
            } catch {
                print(String(describing: error))
                completion(.failure(APIErrors.invalidApiCall))
            }
        }
        
        dataTask.resume()
        
    }
    
}

