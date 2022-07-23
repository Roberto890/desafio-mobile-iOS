//
//  CharacterResult.swift
//  MarvelCharacters
//
//  Created by Roberto Jesus Amaral (P) on 22/07/22.
//

import Foundation

struct ApiResult: Codable {
    let data: CharactersData
}

struct CharactersData: Codable {
    let results: [Character]

}

struct Character: Codable {
    let name: String?
    let description: String
    let thumbnail: Thumbnail
}

struct Thumbnail: Codable {
    let path:String?
    let `extension`:String?
}
