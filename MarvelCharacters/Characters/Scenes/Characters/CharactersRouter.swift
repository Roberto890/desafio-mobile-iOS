//
//  CharactersRouter.swift
//  MarvelCharacters
//
//  Created by Roberto Jesus Amaral (P) on 22/07/22.
//
import Foundation
import UIKit

protocol CharactersRouterProtocol {
    func setup() -> CharactersViewController
    func start()
//    func setup(repository: CharactersRepositoryProtocol) -> CharactersViewController
}

class CharactersRouter: CharactersRouterProtocol {
    
    weak var viewController: CharactersViewController?
    
    private var navigation: UINavigationController
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    public func start() {
        navigation.pushViewController(setup(), animated: true)
        
    }
    
    func setup() -> CharactersViewController {
        let repository = CharactersRepository()
        let charactersViewController = navigation.storyboard?.instantiateViewController(withIdentifier: "CharactersViewController") as! CharactersViewController
        let presenter = CharactersPresenter.init(viewController: charactersViewController)
        let interactor = CharactersInteractor.init(presenter: presenter, repository: repository)
        charactersViewController.interactor = interactor
        charactersViewController.router = self
        self.viewController = charactersViewController
        
        return charactersViewController
    }

}
