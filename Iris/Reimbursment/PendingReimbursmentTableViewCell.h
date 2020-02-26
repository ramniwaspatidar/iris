//
//  PendingReimbursmentTableViewCell.h
//  Iris
//
//  Created by apptology on 12/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingReimbursmentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *fileView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filedetailViewHeightCons;
@property (weak, nonatomic) IBOutlet UILabel *swiftcode;
@property (weak, nonatomic) IBOutlet UILabel *iban;
@property (weak, nonatomic) IBOutlet UILabel *branchNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *bankNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *accountNameTitle;
@property (weak, nonatomic) IBOutlet UILabel *bankdetailsLbl;
@property (weak, nonatomic) IBOutlet UILabel *memberId;
@property (weak, nonatomic) IBOutlet UILabel *toward;
@property (weak, nonatomic) IBOutlet UILabel *treatmentDate;
@property (weak, nonatomic) IBOutlet UILabel *countryOfTreatment;
@property (weak, nonatomic) IBOutlet UILabel *claimedAmount;
@property (weak, nonatomic) IBOutlet UILabel *claimCurrency;
@property (weak, nonatomic) IBOutlet UILabel *accountName;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *branchName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labTestHeightCons;
@property (weak, nonatomic) IBOutlet UIView *roundedContainerView;
@property (weak, nonatomic) IBOutlet UILabel *claimLbl;
@property (weak, nonatomic) IBOutlet UILabel *currencyLbl;
@property (weak, nonatomic) IBOutlet UILabel *countryLbl;
@property (weak, nonatomic) IBOutlet UILabel *treatLbl;
@property (weak, nonatomic) IBOutlet UILabel *fileDetLbl;


@end
