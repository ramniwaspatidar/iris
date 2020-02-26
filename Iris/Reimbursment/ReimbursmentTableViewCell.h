//
//  ReimbursmentTableViewCell.h
//  Iris
//
//  Created by apptology on 17/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReimbursmentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *claimId;
@property (weak, nonatomic) IBOutlet UILabel *providerName;
@property (weak, nonatomic) IBOutlet UILabel *claimType;
@property (weak, nonatomic) IBOutlet UILabel *diagnosisDetail;
@property (weak, nonatomic) IBOutlet UILabel *treatmentDetail;
@property (weak, nonatomic) IBOutlet UILabel *treatmentDate;
@property (weak, nonatomic) IBOutlet UILabel *labTest;
@property (weak, nonatomic) IBOutlet UILabel *claimedCurrency;
@property (weak, nonatomic) IBOutlet UILabel *approvedAmount;
@property (weak, nonatomic) IBOutlet UILabel *claimedPaymentDate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labTestHeightCons;
@property (weak, nonatomic) IBOutlet UIView *roundedContainerView;

@property (weak, nonatomic) IBOutlet UILabel *provideLbl;
@property (weak, nonatomic) IBOutlet UILabel *claimLbl;
@property (weak, nonatomic) IBOutlet UILabel *treatLbl;
@property (weak, nonatomic) IBOutlet UILabel *diagnosisLbl;
@property (weak, nonatomic) IBOutlet UILabel *treatdetailsLbl;
@property (weak, nonatomic) IBOutlet UILabel *claimcurrLbl;
@property (weak, nonatomic) IBOutlet UILabel *approvLbl;
@property (weak, nonatomic) IBOutlet UILabel *claimpaymnetLbl;

@property (weak, nonatomic) IBOutlet UIButton *viewReLbl;









@end
