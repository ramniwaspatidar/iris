//
//  AddReimbusmentTableViewCell.h
//  Iris
//
//  Created by apptology on 20/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddReimbusmentTableViewCell1 : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarButtonWidthCons;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;

@end
