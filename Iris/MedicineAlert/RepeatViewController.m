//
//  RepeatViewController.m
//  Iris
//
//  Created by apptology on 1/31/18.
//  Copyright © 2018 apptology. All rights reserved.
//
#import "Localization.h"

#import "RepeatViewController.h"
#import "Utility.h"
#import "MainSideMenuViewController.h"
@interface RepeatViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UITableView *repeatTableView;
    NSArray *weekdayArray;
    NSArray *weekdayArrayShort;
    NSArray *weekdayArrayValue;


}
//   [Localization languageSelectedStringForKey:@"Sat"]

@end

@implementation RepeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    weekdayArray = [[NSArray alloc]initWithObjects:[Localization languageSelectedStringForKey:@"Every Sunday"], [Localization languageSelectedStringForKey:@"Every Monday"], [Localization languageSelectedStringForKey:@"Every Tuesday"], [Localization languageSelectedStringForKey:@"Every Wednesday"], [Localization languageSelectedStringForKey:@"Every Thursday"], [Localization languageSelectedStringForKey:@"Every Friday"], [Localization languageSelectedStringForKey:@"Every Saturday"], nil];
    
    weekdayArrayValue = [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7", nil];
    
    weekdayArrayShort = [[NSArray alloc]initWithObjects:[Localization languageSelectedStringForKey:@"Sun"], [Localization languageSelectedStringForKey:@"Mon"], [Localization languageSelectedStringForKey:@"Tue"], [Localization languageSelectedStringForKey:@"Wed"], [Localization languageSelectedStringForKey:@"Thur"], [Localization languageSelectedStringForKey:@"Fri"], [Localization languageSelectedStringForKey:@"Sat"], nil];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        repeatLbl.text =  [Localization languageSelectedStringForKey:@"Repeat"];

        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        repeatLbl.text =  [Localization languageSelectedStringForKey:@"Repeat"];
 topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
  //  repeatTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    if(self.selectedDays == nil)
        self.selectedDays = [[NSMutableArray alloc] init];
    if(self.selectedDaysValues == nil)
        self.selectedDaysValues = [NSMutableArray array];
    // Do any additional setup after loading the view.
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return weekdayArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    cell.textLabel.text =  [weekdayArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.selectedDays containsObject:[weekdayArrayShort objectAtIndex:indexPath.row]])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    return cell;
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ([self.selectedDays containsObject:[weekdayArrayShort objectAtIndex:indexPath.row]])
    {
        [self.selectedDays removeObject:[weekdayArrayShort objectAtIndex:indexPath.row]];
        [self.selectedDaysValues removeObject:[weekdayArrayValue objectAtIndex:indexPath.row]];
    }
    else
    {
        [self.selectedDays addObject:[weekdayArrayShort objectAtIndex:indexPath.row]];
        [self.selectedDaysValues addObject:[weekdayArrayValue objectAtIndex:indexPath.row]];

    }
    [tableView reloadData];
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *footerView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    [footerView setBackgroundColor:[UIColor clearColor]];
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(40, 20, self.view.frame.size.width - 80, 30)];
    [saveButton setTitle:[Localization languageSelectedStringForKey:@"SUBMIT"] forState:UIControlStateNormal];
    saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
   // saveButton.titleLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightSemibold];
    [saveButton addTarget:self action:@selector(saveRepeatData) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:96.0/255.0 blue:175.0/255.0 alpha:1.0]];
    saveButton.layer.cornerRadius = 5.0;
    saveButton.clipsToBounds =   true;
    
    [footerView addSubview:saveButton];
    
    return  footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return  100;
}

-(void)saveRepeatData{
    [_delegate getDaysData:self.selectedDays.mutableCopy];
    [_delegate getDatesFromDays:self.selectedDaysValues.mutableCopy];
    [self.navigationController popViewControllerAnimated:true];
}



- (IBAction)backButton_Clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
