//
//  ViewYourECardViewController.h
//  Iris
//
//  Created by appt on 15/02/19.
//  Copyright © 2019 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewYourECardViewController : UIViewController {
    
    __weak IBOutlet UIButton *sideMenuBtnOutlet;
    __weak IBOutlet UIImageView *notificationIconImageView;

    __weak IBOutlet UILabel *ecartLbl;
    __weak IBOutlet UILabel *footerLbl;
    
    
    
}
@property(nonatomic,strong)NSMutableDictionary *personDetailDictionary;
@property(nonatomic,strong)NSMutableDictionary *eCardInfoDetailDictionary;

@end
