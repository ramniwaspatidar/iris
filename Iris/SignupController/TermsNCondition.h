//
//  TermsNCondition.h
//  Iris
//
//  Created by apptology on 1/30/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsNCondition : UIViewController{
    
    
    
    __weak IBOutlet UILabel *termLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    
    __weak IBOutlet UIButton *topBtn;
    IBOutlet UIWebView *contentWebView;
    __weak IBOutlet UIImageView *notificationIconImageView;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;

}

@end
