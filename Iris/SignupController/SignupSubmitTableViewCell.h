//
//  SignupSubmitTableViewCell.h
//  Iris
//
//  Created by apptology on 16/02/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupSubmitTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *termConditionButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *agreeLbl;

@end
