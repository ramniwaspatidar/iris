//
//  AppointmentReminderTableViewCell.h
//  Iris
//
//  Created by apptology on 08/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppointmentReminderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarButtonWidthCons;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
