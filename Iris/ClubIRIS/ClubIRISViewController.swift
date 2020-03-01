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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = Localization.languageSelectedString(forKey: "Club IRIS")
    }
    
    func revelMenuAction(){
    }
    
    
//    -(void)initialSetupView
//    {
//    RevealViewController *revealController = [self revealViewController];
//    [revealController tapGestureRecognizer];
//
//    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
//    _clubirisLbl.text =  [Localization languageSelectedStringForKey:@"Club IRIS"];
//
//    [backbtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
//    // [revealController setRightViewController:frontNavigationController];
//    //  [revealController setl];
//
//    [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
//    }
//    else{
//    [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
//
//    _clubirisLbl.text =  [Localization languageSelectedStringForKey:@"Club IRIS"];
//
//    [backbtn addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
//
//    //   [revealController setFrontViewController:frontNavigationController];
//    }
//
//    //[_phoneLabel setGestureOnLabel];
//
//    }


}
