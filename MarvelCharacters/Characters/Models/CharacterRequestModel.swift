//
//  CharacterRequestModel.swift
//  MarvelCharacters
//
//  Created by Roberto Jesus Amaral (P) on 22/07/22.
//

import Foundation

struct CharacterRequestModel {
    let limit: Int?
    let offset: Int
    
    init(limit: Int?, offset: Int = 0) {
        self.limit = limit
        self.offset = offset
    }
}
