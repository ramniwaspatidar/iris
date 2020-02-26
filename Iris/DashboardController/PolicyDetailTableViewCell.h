//
//  PolicyDetailTableViewCell.h
//  Iris
//
//  Created by apptology on 07/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PolicyDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *policyNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *policyPeriodLabel;
@property (weak, nonatomic) IBOutlet UILabel *policyStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *roundedContainerView;
@property (weak, nonatomic) IBOutlet UILabel *policyNumberLbl;
@property (weak, nonatomic) IBOutlet UILabel *policyPeriodLbl;
@property (weak, nonatomic) IBOutlet UILabel *stausLbl;

@end
