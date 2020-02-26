//
//  SearchTableViewCell.h
//  Iris
//
//  Created by apptology on 05/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *hospitalName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *specialty;
@property (weak, nonatomic) IBOutlet UIView *roundContainerView;
@property (weak, nonatomic) IBOutlet UIButton *directionButton;
@property (weak, nonatomic) IBOutlet UIButton *reminderButton;

@end
