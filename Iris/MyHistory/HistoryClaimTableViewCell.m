//
//  HistoryClaimTableViewCell.m
//  Iris
//
//  Created by apptology on 12/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "HistoryClaimTableViewCell.h"
#import "Localization.h"

#import "MainSideMenuViewController.h"


@implementation HistoryClaimTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.roundedContainerView.layer.cornerRadius = 5.0;
    self.roundedContainerView.layer.borderWidth = 1.0;
    self.roundedContainerView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    self.roundedContainerView.clipsToBounds = YES;
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        self.providenameLbl.text =  [Localization languageSelectedStringForKey:@"Provider Name:"];
          self.claimLbl.text =  [Localization languageSelectedStringForKey:@"Claim Type:"];
  self.diagnosisLbl.text =  [Localization languageSelectedStringForKey:@"Diagnosis Details:"];
         self.treatmentLbl.text =  [Localization languageSelectedStringForKey:@"Treatment Details:"];
           self.approvedLbl.text =  [Localization languageSelectedStringForKey:@"Approved Amount:"];
        
        [self.viewBtn setTitle:[Localization languageSelectedStringForKey:@"VIEW REPORT"] forState:UIControlStateNormal];
        

        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.providenameLbl.text =  [Localization languageSelectedStringForKey:@"Provider Name:"];
        self.claimLbl.text =  [Localization languageSelectedStringForKey:@"Claim Type:"];
        self.diagnosisLbl.text =  [Localization languageSelectedStringForKey:@"Diagnosis Details:"];
        self.treatmentLbl.text =  [Localization languageSelectedStringForKey:@"Treatment Details:"];
        self.approvedLbl.text =  [Localization languageSelectedStringForKey:@"Approved Amount:"];
        
        [self.viewBtn setTitle:[Localization languageSelectedStringForKey:@"VIEW REPORT"] forState:UIControlStateNormal];
        
    }
    

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
