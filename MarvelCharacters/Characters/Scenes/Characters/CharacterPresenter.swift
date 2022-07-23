//
//  CharacterPresenter.swift
//  MarvelCharacters
//
//  Created by Roberto Jesus Amaral (P) on 22/07/22.
//

import Foundation

protocol CharactersPresenterProtocol{
    
    func presentCharacters(characters: [CharacterData])
    func presentError(error: String)
}

class CharactersPresenter: CharactersPresenterProtocol  {

    weak var viewController: CharactersViewControllerProtocol?
    
    init(viewController: CharactersViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func presentCharacters(characters: [CharacterData]) {
        var charactersModel: [CharacterData] = []
        for character in characters {
            if character.description == "" {
                let newCharacter = CharacterData(name: character.name?.uppercased(), description: "Description not found ".uppercased() + "😱".uppercased(), imageUrl: character.imageUrl)
                charactersModel.append(newCharacter)
            }else {
                let newCharacter = CharacterData(name: character.name?.uppercased(), description: character.description.uppercased(), imageUrl: character.imageUrl)
                charactersModel.append(newCharacter)
            }
            
        }
        viewController?.displayCharacters(characters: charactersModel)
    }
    
    func presentError(error: String) {
        viewController?.displayError(message: error)
    }
}
