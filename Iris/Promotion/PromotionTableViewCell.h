//
//  PromotionTableViewCell.h
//  Iris
//
//  Created by apptology on 04/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIView *roundedContainerView;
@property (weak, nonatomic) IBOutlet UILabel *promotionName;
@property (weak, nonatomic) IBOutlet UILabel *partnerName;
@property (weak, nonatomic) IBOutlet UILabel *promotionDescription;
@property (weak, nonatomic) IBOutlet UIImageView *promotionImageView;
@property (weak, nonatomic) IBOutlet UILabel *valideuptoLbl;
@end
