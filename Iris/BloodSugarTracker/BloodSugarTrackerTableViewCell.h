//
//  BloodSugarTrackerTableViewCell.h
//  Iris
//
//  Created by apptology on 23/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodSugarTrackerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bottomLineLabel;
@property (weak, nonatomic) IBOutlet UIButton *calendarButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarButtonWidthCons;
@end
