//
//  MedicineTableViewCell.h
//  Iris
//
//  Created by apptology on 02/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedicineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarButtonWidthCons;
@end
