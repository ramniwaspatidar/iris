//
//  SignupTableViewCell.h
//  Iris
//
//  Created by apptology on 16/02/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoBoxLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infoBoxBgImageView;


@property(nonatomic,assign)BOOL isInfoOpen;
@end
