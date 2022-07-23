//
//  CharacterInteractor.swift
//  MarvelCharacters
//
//  Created by Roberto Jesus Amaral (P) on 22/07/22.
//

import Foundation


protocol CharactersInteractorProtocol{
    func callListCharacter(offset: Int?)
//    func callNextListCharacter()
    
}

class CharactersInteractor: CharactersInteractorProtocol {
    
    private let presenter: CharactersPresenterProtocol
    private let repository: CharactersRepositoryProtocol
    
    init(presenter: CharactersPresenterProtocol, repository: CharactersRepositoryProtocol) {
        self.presenter = presenter
        self.repository = repository
    }
    
    func callListCharacter(offset: Int? = nil) {
        repository.listCharacters(offSet: offset) { result in
            switch result {
            case .success(let characterList):
                self.presenter.presentCharacters(characters: characterList)
            case.failure(let error):
                self.presenter.presentError(error: error.localizedDescription)
            }
        }
    }
    
//    func callNextListCharacter(offset: Int?){
//        let characterRequestModel = CharacterRequestModel(limit: 10, ts: 5,offset: 10 , apikey: "76a6961afd017c90e7a4824b1afef107", hash: "9a814f09f75a201c9ab410a9817e7ca7")
//        repository.listCharacters(offSet: offset) { result in
//            switch result {
//            case .success(let characterList):
//                self.presenter.presentCharacters(characters: characterList)
//            case.failure(let error):
//                print(error)
//            }
//        }
//    }
    
    
}
