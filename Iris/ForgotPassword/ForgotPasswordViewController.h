//
//  ForgotPasswordViewController.h
//  Iris
//
//  Created by apptology on 19/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgotPasswordViewController : UIViewController
{
    NSMutableArray *_placeholderArray;
    NSMutableArray *_inputDataArray;
    
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UILabel *omanLbl;
    
   
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *forgotpawdLbl;
    __weak IBOutlet UILabel *uaeLbl;
    
    __weak IBOutlet UIButton *submitBtn;
    
    __weak IBOutlet UIButton *topBtn;
    NSIndexPath *activeCellIndexPath;
    BOOL keyboardShown;
    CGFloat keyboardOverlap;
    float keybaordHeight;
    __weak IBOutlet UITableView *_mainTableView;
    NSString *tokenString;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
}
@end
