//
//  HistoryClaimTableViewCell.h
//  Iris
//
//  Created by apptology on 12/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryClaimTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *claimId;
@property (weak, nonatomic) IBOutlet UILabel *providerName;
@property (weak, nonatomic) IBOutlet UILabel *claimType;
@property (weak, nonatomic) IBOutlet UILabel *diagnosisDetail;
@property (weak, nonatomic) IBOutlet UILabel *treatmentDetail;
@property (weak, nonatomic) IBOutlet UILabel *labTest;
@property (weak, nonatomic) IBOutlet UILabel *approvedAmount;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *month;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labTestHeightCons;
@property (weak, nonatomic) IBOutlet UIView *roundedContainerView;
@property (weak, nonatomic) IBOutlet UILabel *providenameLbl;
@property (weak, nonatomic) IBOutlet UILabel *claimLbl;
@property (weak, nonatomic) IBOutlet UILabel *diagnosisLbl;
@property (weak, nonatomic) IBOutlet UILabel *treatmentLbl;
@property (weak, nonatomic) IBOutlet UIButton *viewBtn;
@property (weak, nonatomic) IBOutlet UILabel *approvedLbl;







@end
