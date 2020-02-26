//
//  BMIChartViewController.m
//  Iris
//
//  Created by apptology on 10/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "BMIChartViewController.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "UILabel+CustomLabel.h"
#import "YearTableViewCell.h"
#import "Utility.h"
#import "Localization.h"
#import "MainSideMenuViewController.h"
@interface BMIChartViewController ()
@property (nonatomic, strong) IBOutlet FSLineChart *chartWithDates;
@property (strong, nonatomic) NSArray* leftArray;
@property (strong, nonatomic) NSDateFormatter *dateYearFormatter;
@property (strong, nonatomic) NSDateFormatter *dateMonthFormatter;
@property (strong, nonatomic) NSDateFormatter *previousDateFormatter;
@end

@implementation BMIChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.previousDateFormatter.dateFormat = @"dd MMM yyyy";

    [self loadChartWithDates];
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        bmiNLbl.text =  [Localization languageSelectedStringForKey:@"BMI"];
        avgLbl.text =  [Localization languageSelectedStringForKey:@"Avg. BMI per month"];
          bmiLbl.text =  [Localization languageSelectedStringForKey:@"BMI Graph"];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        bmiNLbl.text =  [Localization languageSelectedStringForKey:@"BMI"];
        avgLbl.text =  [Localization languageSelectedStringForKey:@"Avg. BMI per month"];
        bmiLbl.text =  [Localization languageSelectedStringForKey:@"BMI Graph"];
        topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Utility trackGoogleAnalystic:@"BMI Graph"];
}

#pragma mark - Setting up the chart

- (void)loadChartWithDates {
    // Generating some dummy data
    
    _chartWidthCons.constant = 450;
    _bmiLabel.transform=CGAffineTransformMakeRotation( -( 90 * M_PI ) / 180 );

    yearView.layer.borderWidth = 1.0;
    yearView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    //[Localization languageSelectedStringForKey:@"Obesity"]
    self.leftArray = @[@"Under Weight",  [Localization languageSelectedStringForKey:@"Normal"], @"Over Weight",  [Localization languageSelectedStringForKey:@"Obesity"]];
    
    _months = @[ [Localization languageSelectedStringForKey:@"Jan"], [Localization languageSelectedStringForKey:@"Feb"],[Localization languageSelectedStringForKey:@"Mar"],  [Localization languageSelectedStringForKey:@"Apr"], [Localization languageSelectedStringForKey:@"May"],  [Localization languageSelectedStringForKey:@"Jun"],[Localization languageSelectedStringForKey:@"Jul"], [Localization languageSelectedStringForKey:@"Aug"], [Localization languageSelectedStringForKey:@"Sep"],[Localization languageSelectedStringForKey:@"Oct"], [Localization languageSelectedStringForKey:@"Nov"], [Localization languageSelectedStringForKey:@"Dec"]];
    
    _yearsArray = [[NSMutableArray alloc] init];
    
    
    
    NSDate *currentDate = [NSDate date];
    self.dateYearFormatter = [[NSDateFormatter alloc] init];
    self.dateYearFormatter.dateFormat = @"yyyy";
    selectedYear = [self.dateYearFormatter stringFromDate:currentDate];
    [_yearButton setTitle:selectedYear forState:UIControlStateNormal];
    
    
    for(int i = [selectedYear intValue]; i >= [selectedYear intValue] - 10; i--)
    {
        [_yearsArray addObject:[NSNumber numberWithInt:i]];
    }
    
    self.previousDateFormatter = [[NSDateFormatter alloc] init];
    self.previousDateFormatter.dateFormat = @"dd MMM yyyy";
    
    self.dateMonthFormatter = [[NSDateFormatter alloc] init];
    self.dateMonthFormatter.dateFormat = @"MMM";
    
    
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [self.dateYearFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.dateMonthFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];

        
        
    }else{
        
        [self.dateYearFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.dateMonthFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
    }
    [self updateChartData];
}

-(void)updateChartData
{
    [_chartWithDates clearChartData];
    _chartWithDates.chartType = @"BMI";
    NSMutableArray* chartData = [[NSMutableArray alloc] init];
    
    NSArray *months = @[[Localization languageSelectedStringForKey:@"Jan"], [Localization languageSelectedStringForKey:@"Feb"],[Localization languageSelectedStringForKey:@"Mar"],  [Localization languageSelectedStringForKey:@"Apr"], [Localization languageSelectedStringForKey:@"May"],  [Localization languageSelectedStringForKey:@"Jun"],[Localization languageSelectedStringForKey:@"Jul"], [Localization languageSelectedStringForKey:@"Aug"], [Localization languageSelectedStringForKey:@"Sep"],[Localization languageSelectedStringForKey:@"Oct"], [Localization languageSelectedStringForKey:@"Nov"], [Localization languageSelectedStringForKey:@"Dec"]];
    for(int i = 0; i < months.count; i++)
    {
        float hbaValue = 0.0;
        int totalItems = 0;
        NSString *currentMonthString = [months objectAtIndex:i];
        for(int j = 0; j < self.statesArray.count; j++)
        {
            NSString *dateString = [[self.statesArray objectAtIndex:j] valueForKey:@"date"];
            
            NSDate *dataDate = [self.previousDateFormatter dateFromString:dateString];
            
            NSString *monthString = [self.dateMonthFormatter stringFromDate:dataDate];
            
            NSString *yearString = [self.dateYearFormatter stringFromDate:dataDate];
            
            if([currentMonthString isEqualToString:monthString] && [yearString isEqualToString:selectedYear])
            {
                totalItems ++;
                hbaValue = hbaValue + [[self.statesArray[j] valueForKey:@"bmivalue"] floatValue];
            }
        }
        if(totalItems > 0)
        {
            float avgHbaVal = hbaValue/totalItems;
            float finalValue = (avgHbaVal*10);
            if(finalValue > 500.0)
                finalValue = 508.0;
            chartData[i] = [NSNumber numberWithFloat:finalValue];
        }
        else
        {
            [chartData addObject:[NSNumber numberWithInt:0]];
        }
    }
    
    // Setting up the line chart
    _chartWithDates.verticalGridStep = (int)self.leftArray.count;
    _chartWithDates.horizontalGridStep = 12;
    _chartWithDates.fillColor = nil;
    _chartWithDates.displayDataPoint = YES;
    _chartWithDates.dataPointColor = [UIColor fsOrange];
    _chartWithDates.dataPointBackgroundColor = [UIColor fsOrange];
    _chartWithDates.dataPointRadius = 2;
    _chartWithDates.color = [_chartWithDates.dataPointColor colorWithAlphaComponent:0.3];
    _chartWithDates.valueLabelPosition = ValueLabelLeft;
    _chartWithDates.leftArray = [self.leftArray copy];
    _chartWithDates.labelForIndex = ^(NSUInteger item) {
        return months[item];
    };
    
    _chartWithDates.labelForValue = ^(CGFloat value) {
        
        return [NSString stringWithFormat:@"%.02f   ", value];
    };
    
    [_chartWithDates setChartData:chartData withTag:1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark- Table View methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _yearsArray.count;
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"YearCellIdentifier";
    YearTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"YearTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    cell.yearLabel.text = [NSString stringWithFormat:@"%d",[[_yearsArray objectAtIndex:indexPath.row] intValue]];
    //cell.backgroundColor = [UIColor clearColor];
    //cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 0;
    insets.left = 0;
    cell.separatorInset = insets;
    //cell.contentView.backgroundColor = [UIColor clearColor];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 10)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.frame.size.width, 30)];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    
    [view setBackgroundColor:[UIColor clearColor]]; //your background color...
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedYear = [NSString stringWithFormat:@"%d",[[_yearsArray objectAtIndex:indexPath.row] intValue]];
    [_yearButton setTitle:selectedYear forState:UIControlStateNormal];
    _yearTableView.hidden = YES;
    
    [self updateChartData];
}

#pragma mark- Button Action Methods-


- (IBAction)changeYearButtonAction:(id)sender {
    _yearTableView.hidden = !_yearTableView.hidden;
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
