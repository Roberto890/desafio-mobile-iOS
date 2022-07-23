//
//  CharacterData.swift
//  MarvelCharacters
//
//  Created by Roberto Jesus Amaral (P) on 23/07/22.
//

import Foundation


struct CharacterData {
    let name: String?
    let description: String
    let imageUrl: String?
    
    init(name: String?, description: String, imageUrl: String?) {
        self.name = name
        self.description = description
        self.imageUrl = imageUrl
    }
}
