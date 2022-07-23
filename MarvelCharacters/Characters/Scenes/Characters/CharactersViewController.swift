//
//  CharactersViewController.swift
//  MarvelCharacters
//
//  Created by Roberto Jesus Amaral (P) on 22/07/22.
//

import UIKit
import SDWebImage
import Lottie

protocol CharactersViewControllerProtocol: AnyObject {
    
    func showCharacters()
    func displayCharacters(characters: [CharacterData])
    func displayError(message: String)
    
}

class CharactersViewController: UIViewController, CharactersViewControllerProtocol {
    
    var interactor: CharactersInteractorProtocol?
    var router: CharactersRouterProtocol?
    var currentIndexTableView: Int = 0
    var characterList: [CharacterData] = []
    var fetchingMore: Bool = false
    var isFirstCall: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAnimationView()
        characterCarousel.delegate = self
        characterCarousel.dataSource = self
        characterTableView.delegate = self
        characterTableView.dataSource = self
        showCharacters()
        self.navigationItem.title = "MARVEL CHARACTERS"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Marvel Regular", size: 50)]
        
    }
    
    @IBOutlet weak var animationContainer: AnimationView!
    @IBOutlet weak var characterCarousel: UICollectionView!
    
    @IBOutlet weak var characterTableView: UITableView!
    
    func showCharacters() {
        startAnimation()
        interactor?.callListCharacter(offset: nil)
    }
    
    func callNextCharacters() {
        fetchingMore = true
        interactor?.callListCharacter(offset: characterList.count)
    }
    
    func displayCharacters(characters: [CharacterData]) {
        DispatchQueue.main.async {[self] in
            self.stopAnimation()
            self.characterList.append(contentsOf:characters)
            if isFirstCall {
                characterCarousel.reloadData()
                characterCarousel.collectionViewLayout.invalidateLayout()
            }
            characterCarousel.layoutSubviews()
            characterTableView.reloadData()
            characterTableView.layoutSubviews()
            self.isFirstCall = false
            self.fetchingMore = false
        }
    }
    
    func displayError(message: String) {
        stopAnimation()
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Falha de conexão", message: message, preferredStyle: UIAlertController.Style.alert)
            let button = UIAlertAction(title: "Sair do App", style: .destructive) { alertAction in
                exit(0)
            }
            alert.addAction(button)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func loadAnimationView(){
        animationContainer.backgroundColor = .clear
        animationContainer.loopMode = .loop
        animationContainer.animationSpeed = 0.5
        
    }
    
    func startAnimation() {
        
        animationContainer.isHidden = false
        animationContainer.play()
        characterTableView.isUserInteractionEnabled = false
        characterCarousel.isUserInteractionEnabled = false
        
    }
    
    func stopAnimation(){
        animationContainer.isHidden = true
        animationContainer.stop()
        characterTableView.isUserInteractionEnabled = true
        characterCarousel.isUserInteractionEnabled = true
    }
}

extension CharactersViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if characterList.count < 5 || isFirstCall == false {
            return 0
        } else {
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(UINib(nibName: "CharacterCollectionCell", bundle: nil), forCellWithReuseIdentifier: "collectionViewCell")
        let cell = characterCarousel.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CharacterCollectionCell
        let character = characterList[indexPath.row]
        cell.characterName.text = character.name
        if let url = character.imageUrl {
            guard let unwapedUrl = URL(string: url) else {fatalError()}
            var urlHttpsChange = URLComponents(url: unwapedUrl, resolvingAgainstBaseURL: false)
            urlHttpsChange?.scheme = "https"
            let httpsUrl = urlHttpsChange!.url!
            cell.characterImage.sd_setImage(with: httpsUrl) { image, error, cacheImage, url in
                if let error = error {
                    print("erro ao baixar imagem: " + error.localizedDescription)
                }
            }
        }
        
        
        return cell
    }
    
    
}

extension CharactersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if characterList.count == 30 && isFirstCall == true {
            currentIndexTableView = 5
            return currentIndexTableView
        } else {
            currentIndexTableView = characterList.count - 5
            return currentIndexTableView
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "CharacterTableViewCell", bundle: nil), forCellReuseIdentifier: "tableViewCell")
        let cell = characterTableView.dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath) as! CharacterTableViewCell
        let index = indexPath.row
        let character = characterList[index + 5]
        
        cell.characterName.text = character.name
        cell.characterDescription.text = character.description
        if let url = character.imageUrl {
            guard let unwapedUrl = URL(string: url) else {fatalError()}
            var urlHttpsChange = URLComponents(url: unwapedUrl, resolvingAgainstBaseURL: false)
            urlHttpsChange?.scheme = "https"
            let httpsUrl = urlHttpsChange!.url!
            cell.characterImage.sd_setImage(with: httpsUrl) { image, error, cacheImage, url in
                if let error = error {
                    print("erro ao baixar imagem: " + error.localizedDescription)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == currentIndexTableView - 1  {
            self.startAnimation()
            interactor?.callListCharacter(offset: characterList.count)
        }
    }
    
    
}

extension CharactersViewController {
    func downloadImage(url: URL, uiImage: UIImageView) {
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
            if let e = error {
                print("Erro baixando imagem: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        DispatchQueue.main.async {
                            let image = UIImage(data: imageData)
                            uiImage.image = image
                            uiImage.sizeToFit()
                        }
                        
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadPicTask.resume()
    }
}
