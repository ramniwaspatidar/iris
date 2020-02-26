//
//  BloodSugarButtonTableViewCell.h
//  Iris
//
//  Created by apptology on 29/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodSugarButtonTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *viewStatesButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewStatesWidthConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewStateLeadingConstant;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@end
