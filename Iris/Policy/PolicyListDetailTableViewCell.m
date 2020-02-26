//
//  PolicyDetailTableViewCell.m
//  Iris
//
//  Created by apptology on 20/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "PolicyListDetailTableViewCell.h"
#import "Localization.h"

#import "MainSideMenuViewController.h"


@implementation PolicyListDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        self.policyLbl.text =  [Localization languageSelectedStringForKey:@"Policy Number:"];
        self.insurencLbl.text =  [Localization languageSelectedStringForKey:@"Insurance Company:"];
        self.masterLbl.text =  [Localization languageSelectedStringForKey:@"Master Contract:"];
          self.companyNLbl.text =  [Localization languageSelectedStringForKey:@"Company Name:"];
        self.startdateLbl.text =  [Localization languageSelectedStringForKey:@"Start Date:"];
         self.endDateLbl.text =  [Localization languageSelectedStringForKey:@"End Date:"];
          self.dependLbl.text =  [Localization languageSelectedStringForKey:@"Dependants:"];
        self.planNameLbl.text =  [Localization languageSelectedStringForKey:@"Plan Name:"];
         self.statusLbl.text =  [Localization languageSelectedStringForKey:@"Status:"];
        self.policyDeaiLbl.text = [Localization languageSelectedStringForKey:@"Policy Benefits:"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            self.policyDeaiLbl.text = [Localization languageSelectedStringForKey:@"Policy Benefits:"];
        self.policyLbl.text =  [Localization languageSelectedStringForKey:@"Policy Number:"];
        self.insurencLbl.text =  [Localization languageSelectedStringForKey:@"Insurance Company:"];
        self.masterLbl.text =  [Localization languageSelectedStringForKey:@"Master Contract:"];
        self.companyNLbl.text =  [Localization languageSelectedStringForKey:@"Company Name:"];
        self.startdateLbl.text =  [Localization languageSelectedStringForKey:@"Start Date:"];
        self.endDateLbl.text =  [Localization languageSelectedStringForKey:@"End Date:"];
        self.dependLbl.text =  [Localization languageSelectedStringForKey:@"Dependants:"];
        self.planNameLbl.text =  [Localization languageSelectedStringForKey:@"Plan Name:"];
        self.statusLbl.text =  [Localization languageSelectedStringForKey:@"Status:"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
