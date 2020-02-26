//
//  TestReportTableViewCell.h
//  Iris
//
//  Created by apptology on 14/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestReportTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textHeightCons;
@property (weak, nonatomic) IBOutlet UILabel *title;
//@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UILabel *inputTextLabel;

@end
