//
//  CompleteProfileTableViewCell.h
//  Iris
//
//  Created by apptology on 30/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompleteProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
//@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *dropDownButton;
//@property(nonatomic,strong)NSString *textMessage;

@end
