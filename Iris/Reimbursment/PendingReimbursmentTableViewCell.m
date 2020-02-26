//
//  PendingReimbursmentTableViewCell.m
//  Iris
//
//  Created by apptology on 12/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "PendingReimbursmentTableViewCell.h"
#import "Localization.h"

#import "MainSideMenuViewController.h"
@implementation PendingReimbursmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.roundedContainerView.layer.cornerRadius = 5.0;
    self.roundedContainerView.layer.borderWidth = 1.0;
    self.roundedContainerView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    self.roundedContainerView.clipsToBounds = YES;
    
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        self.claimLbl.text =  [Localization languageSelectedStringForKey:@"Claim Amount:"];
          self.currencyLbl.text =  [Localization languageSelectedStringForKey:@"Currency:"];
  self.countryLbl.text =  [Localization languageSelectedStringForKey:@"Country:"];
         self.treatLbl.text =  [Localization languageSelectedStringForKey:@"Treatment Date:"];
        self.fileDetLbl.text =  [Localization languageSelectedStringForKey:@"File Details"];
        
        self.accountNameTitle.text =  [Localization languageSelectedStringForKey:@"Account Name:"];
        self.bankNameTitle.text =  [Localization languageSelectedStringForKey:@"Bank Name:"];
        self.branchNameTitle.text =  [Localization languageSelectedStringForKey:@"Branch Name:"];
        self.bankdetailsLbl.text =  [Localization languageSelectedStringForKey:@"Bank Details:"];

        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.accountNameTitle.text =  [Localization languageSelectedStringForKey:@"Account Name:"];
        self.bankNameTitle.text =  [Localization languageSelectedStringForKey:@"Bank Name:"];
        self.branchNameTitle.text =  [Localization languageSelectedStringForKey:@"Branch Name:"];
        self.claimLbl.text =  [Localization languageSelectedStringForKey:@"Claim Amount:"];
        self.currencyLbl.text =  [Localization languageSelectedStringForKey:@"Currency:"];
        self.countryLbl.text =  [Localization languageSelectedStringForKey:@"Country:"];
        self.treatLbl.text =  [Localization languageSelectedStringForKey:@"Treatment Date:"];
        self.fileDetLbl.text =  [Localization languageSelectedStringForKey:@"File Details"];
        self.bankdetailsLbl.text =  [Localization languageSelectedStringForKey:@"Bank Details:"];

    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
