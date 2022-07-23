//
//  CharactersRequest.swift
//  MarvelCharacters
//
//  Created by Roberto Jesus Amaral (P) on 22/07/22.
//

import Foundation
import CryptoSwift

class CharactersRequest {
    let baseUrl = "https://gateway.marvel.com:443/v1/public/characters"
    let httpMethod = "GET"
    
    let apiKey = "76a6961afd017c90e7a4824b1afef107"
    let privateKey = "862ee22223be3dda4cca60b32ad39a39832e7243"
    let ts = "5"
    let limit = "30"
    let hash: String
    init() {
        self.hash = (ts+privateKey+apiKey).md5()
    }
}
