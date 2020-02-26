//
//  LipidChartViewController.m
//  Iris
//
//  Created by apptology on 15/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "BloodPressureChartViewController.h"
#import "FSMutipleLineChart.h"
#import "UIColor+FSPalette.h"
#import "UILabel+CustomLabel.h"
#import "YearTableViewCell.h"
#import "MonthTableViewCell.h"
  #import "Localization.h"
#import "Utility.h"
#import "MainSideMenuViewController.h"
@interface BloodPressureChartViewController ()
@property (nonatomic, strong) IBOutlet FSMutipleLineChart *chartWithDates;
@property (strong, nonatomic) NSMutableArray* diaChartData;
@property (strong, nonatomic) NSMutableArray* pulseChartData;
@property (strong, nonatomic) NSMutableArray* sysChartData;
@property (strong, nonatomic) NSDateFormatter *dateTimeFormatter;
@property (strong, nonatomic) NSDateFormatter *previousDateFormatter;

@property (strong, nonatomic) NSDateFormatter *dateMonthFormatter;
@property (strong, nonatomic) NSDateFormatter *dateYearFormatter;

@end

@implementation BloodPressureChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.previousDateFormatter.dateFormat = @"dd MMM yyyy";
    
    monthView.layer.borderWidth = 1.0;
    monthView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    
    yearView.layer.borderWidth = 1.0;
    yearView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
         bloodpreserLbl.text =  [Localization languageSelectedStringForKey:@"Blood Pressure Graph"];
         daysLbl.text =  [Localization languageSelectedStringForKey:@"Days"];
         diastolioLbl.text =  [Localization languageSelectedStringForKey:@"Diastolic"];
         systolicLbl.text =  [Localization languageSelectedStringForKey:@"Systolic"];
         pulseLbl.text =  [Localization languageSelectedStringForKey:@"Pulse"];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        bloodpreserLbl.text =  [Localization languageSelectedStringForKey:@"Blood Pressure Graph"];
        daysLbl.text =  [Localization languageSelectedStringForKey:@"Days"];
        diastolioLbl.text =  [Localization languageSelectedStringForKey:@"Diastolic"];
        systolicLbl.text =  [Localization languageSelectedStringForKey:@"Systolic"];
        pulseLbl.text =  [Localization languageSelectedStringForKey:@"Pulse"];
        topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [self loadChartWithDates];
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}

#pragma mark - Setting up the chart

- (void)loadChartWithDates {
    
    self.previousDateFormatter = [[NSDateFormatter alloc] init];
    self.previousDateFormatter.dateFormat = @"dd MMM yyyy";
    
    self.dateTimeFormatter = [[NSDateFormatter alloc] init];
    self.dateTimeFormatter.dateFormat = @"dd";
    
    _chartWidthCons.constant = 800;
    
    self.diaChartData = [[NSMutableArray alloc] init];
    self.pulseChartData = [[NSMutableArray alloc] init];
    self.sysChartData = [[NSMutableArray alloc] init];
    
    _months = @[[Localization languageSelectedStringForKey:@"Jan"], [Localization languageSelectedStringForKey:@"Feb"],[Localization languageSelectedStringForKey:@"Mar"],  [Localization languageSelectedStringForKey:@"Apr"], [Localization languageSelectedStringForKey:@"May"],  [Localization languageSelectedStringForKey:@"Jun"],[Localization languageSelectedStringForKey:@"Jul"], [Localization languageSelectedStringForKey:@"Aug"], [Localization languageSelectedStringForKey:@"Sep"],[Localization languageSelectedStringForKey:@"Oct"], [Localization languageSelectedStringForKey:@"Nov"], [Localization languageSelectedStringForKey:@"Dec"]];
    
    _yearsArray = [[NSMutableArray alloc] init];
    
    NSDate *currentDate = [NSDate date];
    self.dateMonthFormatter = [[NSDateFormatter alloc] init];
    self.dateMonthFormatter.dateFormat = @"MMM";
    selectedMonth = [self.dateMonthFormatter stringFromDate:currentDate];
    [_monthButton setTitle:selectedMonth forState:UIControlStateNormal];
    
    self.dateYearFormatter = [[NSDateFormatter alloc] init];
    self.dateYearFormatter.dateFormat = @"yyyy";
    
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.dateTimeFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.dateMonthFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.dateYearFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];

        
        
    }else{
        
        [self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.dateTimeFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.dateMonthFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.dateYearFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
    }
    selectedYear = [self.dateYearFormatter stringFromDate:currentDate];
    [_yearButton setTitle:selectedYear forState:UIControlStateNormal];
    
    for(int i = [selectedYear intValue]; i >= [selectedYear intValue] - 10; i--)
    {
        [_yearsArray addObject:[NSNumber numberWithInt:i]];
    }
    
    [self updateChartData];
    _bloodPressureLabel.transform=CGAffineTransformMakeRotation( -( 90 * M_PI ) / 180 );

}

-(void)updateChartData
{
    [_pulseChartData removeAllObjects];
    [_diaChartData removeAllObjects];
    [_sysChartData removeAllObjects];

    [_chartWithDates clearChartData];
    
    NSMutableArray* days = [[NSMutableArray alloc] init];
    for(int i = 1; i <= 31; i++)
    {
        if(i < 10)
        {
            [days addObject:[NSString stringWithFormat:@"0%d",i]];
        }
        else
        {
            [days addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    NSArray* leftArray = @[@"50", @"100", @"150", @"200",@"250",@"300",@"350",@"400"];
    
    for(int i = 0; i < days.count; i++)
    {
        float diaValue = 0.0;
        float pulseValue = 0.0;
        float sysValue = 0.0;
        int totalItems = 0;
        
        NSString *dayString = [days objectAtIndex:i];

        for(int j = 0; j < self.bloodptrssureArray.count; j++)
        {
            NSString *dateString = [[self.bloodptrssureArray objectAtIndex:j] valueForKey:@"date"];
            
            NSString *selectedDateString = [NSString stringWithFormat:@"%@ %@ %@",dayString,selectedMonth,selectedYear];
            
            if([selectedDateString isEqualToString:dateString])
            {
                totalItems ++;
                
                diaValue = diaValue + [[self.bloodptrssureArray[j] valueForKey:@"diastolic"] floatValue];
                pulseValue = pulseValue + [[self.bloodptrssureArray[j] valueForKey:@"pulse"] floatValue];
                sysValue = sysValue + [[self.bloodptrssureArray[j] valueForKey:@"systolic"] floatValue];
            }
        }
        if(totalItems > 0)
        {
            float avgDiaVal = diaValue/totalItems;
            float avgPulseVal = pulseValue/totalItems;
            float avgSysVal = sysValue/totalItems;
            
            _diaChartData[i] = [NSNumber numberWithFloat:avgDiaVal];
            _pulseChartData[i] = [NSNumber numberWithFloat:avgPulseVal];
            _sysChartData[i] = [NSNumber numberWithFloat:avgSysVal];
        }
        else
        {
            _diaChartData[i] = [NSNumber numberWithInt:0];
            _pulseChartData[i] = [NSNumber numberWithInt:0];
            _sysChartData[i] = [NSNumber numberWithInt:0];
        }
    }
    
    // Setting up the line chart
    _chartWithDates.verticalGridStep = 6;//(int)leftArray.count;
    _chartWithDates.horizontalGridStep = (int)days.count;
    _chartWithDates.fillColor = nil;
    _chartWithDates.lineWidth = 1.0;
    _chartWithDates.displayDataPoint = YES;
    _chartWithDates.dataPointColor = [UIColor fsOrange];
    _chartWithDates.dataPointBackgroundColor = [UIColor fsOrange];
    _chartWithDates.dataPointRadius = 2;
    _chartWithDates.color = [_chartWithDates.dataPointColor colorWithAlphaComponent:0.3];
    _chartWithDates.valueLabelPosition = ValueLabelLeft;
    _chartWithDates.leftArray = [leftArray copy];
    _chartWithDates.labelForIndex = ^(NSUInteger item) {
        return days[item];
    };
    
    _chartWithDates.labelForValue = ^(CGFloat value) {
        
        return [NSString stringWithFormat:@"%.02f   ", value];
    };
    
    /*_chartWithDates.dataPointColor = [UIColor fsRed];
    _chartWithDates.dataPointBackgroundColor = [UIColor fsRed];
    _chartWithDates.color = [UIColor fsRed];
    [_chartWithDates setChartData:self.diaChartData withTag:1];
    */
    
    [self performSelector:@selector(showLDLLine:) withObject:nil afterDelay:0.0];
    
    [self performSelector:@selector(showHDLLine:) withObject:nil afterDelay:2.0];
    [self performSelector:@selector(showCholestrolLine:) withObject:nil afterDelay:4.0];
}

-(void)showLDLLine:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _chartWithDates.dataPointColor = [UIColor fsRed];
        _chartWithDates.dataPointBackgroundColor = [UIColor fsRed];
        _chartWithDates.color = [UIColor fsRed];
        [_chartWithDates setChartData:self.diaChartData withTag:1];
    });
}

-(void)showHDLLine:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _chartWithDates.dataPointColor = [UIColor fsGreen];
        _chartWithDates.dataPointBackgroundColor = [UIColor fsGreen];
        _chartWithDates.color = [UIColor fsGreen];
        [_chartWithDates setChartData:self.pulseChartData withTag:2];
    });
}

-(void)showCholestrolLine:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _chartWithDates.dataPointColor = [UIColor fsDarkGray];
        _chartWithDates.dataPointBackgroundColor = [UIColor fsDarkGray];
        _chartWithDates.color = [UIColor fsDarkGray];
        [_chartWithDates setChartData:self.sysChartData withTag:3];
    });
}

#pragma mark- Table View methods -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(_monthTableView == tableView)
        return _months.count;
    else
        return _yearsArray.count;
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _monthTableView)
    {
        static NSString *cellIdentifier  =@"MonthCellIdentifier";
        MonthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"MonthTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.monthLabel.text = [_months objectAtIndex:indexPath.row];
        
        //cell.backgroundColor = [UIColor clearColor];
        //cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
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
    
    if(tableView == _monthTableView)
    {
        selectedMonth = [NSString stringWithFormat:@"%@",[_months objectAtIndex:indexPath.row]];
        [_monthButton setTitle:selectedMonth forState:UIControlStateNormal];
        _monthTableView.hidden = YES;
    }
    else
    {
        selectedYear = [NSString stringWithFormat:@"%d",[[_yearsArray objectAtIndex:indexPath.row] intValue]];
        [_yearButton setTitle:selectedYear forState:UIControlStateNormal];
        _yearTableView.hidden = YES;
    }

    
    [self updateChartData];
    
}

#pragma mark- Button Action Methods-

- (IBAction)changeMonthButtonAction:(id)sender {
    _monthTableView.hidden = !_monthTableView.hidden;
}
- (IBAction)changeYearButtonAction:(id)sender {
    _yearTableView.hidden = !_yearTableView.hidden;
}



#pragma mark- Button Action Methods-

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
