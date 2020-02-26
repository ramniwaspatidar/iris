//
//  FilterTableViewCell.h
//  Iris
//
//  Created by apptology on 05/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dropdownButtonWidthCons;

@end
