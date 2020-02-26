//
//  LipidOptionalCell.h
//  Iris
//
//  Created by apptology on 30/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LipidOptionalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *mgOptionalButton;
@property (weak, nonatomic) IBOutlet UIButton *mmOptionalButton;
@property (weak, nonatomic) IBOutlet UIImageView *mgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *mmImageView;
@property (weak, nonatomic) IBOutlet UILabel *lipidLbl;

@end
