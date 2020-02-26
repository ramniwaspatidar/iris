//
//  LipidChartViewController.m
//  Iris
//
//  Created by apptology on 15/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "LipidChartViewController.h"
#import "FSMutipleLineChart.h"
#import "UIColor+FSPalette.h"
#import "UILabel+CustomLabel.h"
#import "YearTableViewCell.h"
#import "Utility.h"
#import "Localization.h"
#import "MainSideMenuViewController.h"
@interface LipidChartViewController ()
@property (nonatomic, strong) IBOutlet FSMutipleLineChart *chartWithDates;
@property (strong, nonatomic) NSMutableArray* hdlChartData;
@property (strong, nonatomic) NSMutableArray* ldlChartData;
@property (strong, nonatomic) NSMutableArray* cholestrolChartData;
@property (strong, nonatomic) NSMutableArray* trigChartData;
@property (strong, nonatomic) NSDateFormatter *previousDateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateYearFormatter;
@property (strong, nonatomic) NSArray* leftArray;

@end


@implementation LipidChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.previousDateFormatter.dateFormat = @"dd MMM yyyy";
    
    mgView.layer.borderWidth = 1.0;
    mgView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    
    yearView.layer.borderWidth = 1.0;
    yearView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    [self loadChartWithDates];
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
         lipidLbl.text =  [Localization languageSelectedStringForKey:@"Lipid Graph"];
          ldlLbl.text =  [Localization languageSelectedStringForKey:@"LDL"];
          hdlLbl.text =  [Localization languageSelectedStringForKey:@"HDL"];
           trigLbl.text =  [Localization languageSelectedStringForKey:@"Triglycerides"];
        monthsLbl.text =  [Localization languageSelectedStringForKey:@"Months"];
          cholestrolLbl.text =  [Localization languageSelectedStringForKey:@"Cholestrol"];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        lipidLbl.text =  [Localization languageSelectedStringForKey:@"Lipid Graph"];
        ldlLbl.text =  [Localization languageSelectedStringForKey:@"LDL"];
        hdlLbl.text =  [Localization languageSelectedStringForKey:@"HDL"];
        trigLbl.text =  [Localization languageSelectedStringForKey:@"Triglycerides"];
        monthsLbl.text =  [Localization languageSelectedStringForKey:@"Months"];
        cholestrolLbl.text =  [Localization languageSelectedStringForKey:@"Cholestrol"];
        topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:@"Lipid Graph"];
}

#pragma mark - Setting up the chart

- (void)loadChartWithDates {
    // Generating some dummy data
    
    selectedUnit = @"mg/dL";
    _lipidUnitLabel.text = selectedUnit;
//[Localization languageSelectedStringForKey:@"Dec"]
    self.leftArray = @[@"50", @"100", @"150", @"200",@"250",@"300",@"350",@"400"];
    _months = @[ [Localization languageSelectedStringForKey:@"Jan"], [Localization languageSelectedStringForKey:@"Feb"],[Localization languageSelectedStringForKey:@"Mar"],  [Localization languageSelectedStringForKey:@"Apr"], [Localization languageSelectedStringForKey:@"May"],  [Localization languageSelectedStringForKey:@"Jun"],[Localization languageSelectedStringForKey:@"Jul"], [Localization languageSelectedStringForKey:@"Aug"], [Localization languageSelectedStringForKey:@"Sep"],[Localization languageSelectedStringForKey:@"Oct"], [Localization languageSelectedStringForKey:@"Nov"], [Localization languageSelectedStringForKey:@"Dec"]];
    
    _yearsArray = [[NSMutableArray alloc] init];
    
    
    self.previousDateFormatter = [[NSDateFormatter alloc] init];
    self.previousDateFormatter.dateFormat = @"dd MMM yyyy";
    
    NSDate *currentDate = [NSDate date];
    self.dateYearFormatter = [[NSDateFormatter alloc] init];
    self.dateYearFormatter.dateFormat = @"yyyy";
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.dateYearFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
       
        
    }else{
        
        [self.dateYearFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
      
    }
    selectedYear = [self.dateYearFormatter stringFromDate:currentDate];
    
    for(int i = [selectedYear intValue]; i >= [selectedYear intValue] - 10; i--)
    {
        [_yearsArray addObject:[NSNumber numberWithInt:i]];
    }
    
    _chartWidthCons.constant = 450;
    self.hdlChartData = [[NSMutableArray alloc] init];
    self.ldlChartData = [[NSMutableArray alloc] init];
    self.cholestrolChartData = [[NSMutableArray alloc] init];
    self.trigChartData = [[NSMutableArray alloc] init];
    
    self.leftArray = @[@"50", @"100", @"150", @"200",@"250",@"300",@"350",@"400"];

    [self updateChartData];
    _lipidUnitLabel.transform=CGAffineTransformMakeRotation( -( 90 * M_PI ) / 180 );

    //NSMutableArray* datesArray = [[NSMutableArray alloc] init];
   
    
//    [self performSelector:@selector(showLDLLine:) withObject:nil afterDelay:0.0];
//    [self performSelector:@selector(showHDLLine:) withObject:nil afterDelay:2.0];
//    [self performSelector:@selector(showCholestrolLine:) withObject:nil afterDelay:4.0];
//    [self performSelector:@selector(showTrigLine:) withObject:nil afterDelay:6.0];
}

-(void)updateChartData
{
    [_chartWithDates clearChartData];
    
    NSArray* months = @[[Localization languageSelectedStringForKey:@"Jan"], [Localization languageSelectedStringForKey:@"Feb"],[Localization languageSelectedStringForKey:@"Mar"],  [Localization languageSelectedStringForKey:@"Apr"], [Localization languageSelectedStringForKey:@"May"],  [Localization languageSelectedStringForKey:@"Jun"],[Localization languageSelectedStringForKey:@"Jul"], [Localization languageSelectedStringForKey:@"Aug"], [Localization languageSelectedStringForKey:@"Sep"],[Localization languageSelectedStringForKey:@"Oct"], [Localization languageSelectedStringForKey:@"Nov"], [Localization languageSelectedStringForKey:@"Dec"]];
    
    
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.lipidunit == mg/dL"];
    
    NSString* filter = @"(lipidunit contains[c] %@)";
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:filter, selectedUnit];
    
    NSArray *filteredLipidArray = [self.lipidArray filteredArrayUsingPredicate:predicate];
    
    
    for(int i = 0; i < months.count; i++)
    {
        float ldlValue = 0.0;
        float hdlValue = 0.0;
        float cholestrolValue = 0.0;
        float trigValue = 0.0;
        
        int totalItems = 0;
        
        NSString *monthString = [months objectAtIndex:i];
        for(int j = 0; j < filteredLipidArray.count; j++)
        {
            NSString *dateString = [[filteredLipidArray objectAtIndex:j] valueForKey:@"date"];
            
            NSDate *dataDate = [self.previousDateFormatter dateFromString:dateString];
            
            NSString *yearString = [self.dateYearFormatter stringFromDate:dataDate];
            
            if([dateString containsString:monthString] && [yearString isEqualToString:selectedYear])
            {
                totalItems ++;
                
                ldlValue = ldlValue + [[filteredLipidArray[j] valueForKey:@"ldl"] floatValue];
                hdlValue = hdlValue + [[filteredLipidArray[j] valueForKey:@"hdl"] floatValue];
                cholestrolValue = cholestrolValue + [[filteredLipidArray[j] valueForKey:@"cholestrol"] floatValue];
                trigValue = trigValue + [[filteredLipidArray[j] valueForKey:@"triglycerides"] floatValue];
            }
        }
        if(totalItems > 0)
        {
            float avgLdlVal = ldlValue/totalItems;
            float avgHdlVal = hdlValue/totalItems;
            float avgChlestrolVal = cholestrolValue/totalItems;
            float avgTrigVal = trigValue/totalItems;
            
            _ldlChartData[i] = [NSNumber numberWithFloat:avgLdlVal];
            _hdlChartData[i] = [NSNumber numberWithFloat:avgHdlVal];
            _cholestrolChartData[i] = [NSNumber numberWithFloat:avgChlestrolVal];
            _trigChartData[i] = [NSNumber numberWithFloat:avgTrigVal];
        }
        else
        {
            _ldlChartData[i] = [NSNumber numberWithInt:0];
            _hdlChartData[i] = [NSNumber numberWithInt:0];
            _cholestrolChartData[i] = [NSNumber numberWithInt:0];
            _trigChartData[i] = [NSNumber numberWithInt:0];
        }
    }
    
    // Setting up the line chart
    _chartWithDates.verticalGridStep = 6;//(int)self.leftArray.count;
    _chartWithDates.horizontalGridStep = (int)months.count;
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
    
    _chartWithDates.dataPointColor = [UIColor fsRed];
    _chartWithDates.dataPointBackgroundColor = [UIColor fsRed];
    //_chartWithDates.fillColor = [UIColor fsRed];
    _chartWithDates.color = [UIColor fsRed];
    [_chartWithDates setChartData:self.ldlChartData withTag:1];
    
    _chartWithDates.dataPointColor = [UIColor fsGreen];
    _chartWithDates.dataPointBackgroundColor = [UIColor fsGreen];
    //_chartWithDates.fillColor = [UIColor fsGreen];
    _chartWithDates.color = [UIColor fsGreen];
    [_chartWithDates setChartData:self.hdlChartData withTag:2];
    
    _chartWithDates.dataPointColor = [UIColor orangeColor];
    _chartWithDates.dataPointBackgroundColor = [UIColor orangeColor];
    //_chartWithDates.fillColor = [UIColor fsDarkBlue];
    _chartWithDates.color = [UIColor orangeColor];
    [_chartWithDates setChartData:self.cholestrolChartData withTag:3];
    
    _chartWithDates.dataPointColor = [UIColor fsPurple];
    _chartWithDates.dataPointBackgroundColor = [UIColor fsPurple];
    //_chartWithDates.fillColor = [UIColor fsPurple];
    _chartWithDates.color = [UIColor fsPurple];
    [_chartWithDates setChartData:self.trigChartData withTag:4];
}



#pragma mark- Table View methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == _yearTableView)
        return _yearsArray.count;
    else
        return 1;
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
    if(tableView == _yearTableView)
        cell.yearLabel.text = [NSString stringWithFormat:@"%d",[[_yearsArray objectAtIndex:indexPath.row] intValue]];
    else
    {
        if([selectedUnit isEqualToString:@"mmol/L"])
            cell.yearLabel.text = @"mg/dL";
        else
            cell.yearLabel.text = @"mmol/L";
    }
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

    if(tableView == _yearTableView)
    {
        selectedYear = [NSString stringWithFormat:@"%d",[[_yearsArray objectAtIndex:indexPath.row] intValue]];
        [_yearButton setTitle:selectedYear forState:UIControlStateNormal];
        _yearTableView.hidden = YES;
    }
    if(tableView == _mgTableView)
    {
        if([selectedUnit isEqualToString:@"mmol/L"])
            selectedUnit = @"mg/dL";
        else
           selectedUnit = @"mmol/L";
        
        _lipidUnitLabel.text = selectedUnit;

        [_mgButton setTitle:selectedUnit forState:UIControlStateNormal];
        _mgTableView.hidden = YES;
    }
    [self updateChartData];
}

#pragma mark- Button Action Methods-


- (IBAction)changeYearButtonAction:(id)sender {
    _yearTableView.hidden = !_yearTableView.hidden;
}

- (IBAction)changeUnitAction:(id)sender {
    _mgTableView.hidden = !_mgTableView.hidden;
    [_mgTableView reloadData];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
