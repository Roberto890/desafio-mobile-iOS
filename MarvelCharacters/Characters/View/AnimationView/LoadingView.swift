//
//  LoadingView.swift
//  MarvelCharacters
//
//  Created by Roberto Jesus Amaral (P) on 23/07/22.
//

import Foundation
import Lottie
import UIKit

class LoadingView: UIViewController{
    
    var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func startAnimation(){
        animationView = .init(name: "loading-circle")
        animationView?.frame
    }
    
}
