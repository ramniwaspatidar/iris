//
//  ClubIRISViewController.swift
//  Iris
//
//  Created by Ramniwas Patidar on 01/03/20.
//  Copyright © 2020 apptology. All rights reserved.
//

import UIKit

class ClubIRISViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var revealMenu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = Localization.languageSelectedString(forKey: "Club IRIS")
        
        let revel : RevealViewController = RevealViewController()
        
        if MainSideMenuViewController.isCurrentLanguageEnglish(){
            revealMenu.addTarget(revel, action: #selector(revel.revealToggle(_:)), for: .touchUpInside)
        }
        else {
            revealMenu.addTarget(revel, action: #selector(revel.rightRevealToggle(_:)), for: .touchUpInside)
        }
    }
  
}
