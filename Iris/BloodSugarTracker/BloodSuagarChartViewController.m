//
//  BloodSuagarChartViewController.m
//  Iris
//
//  Created by apptology on 16/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "BloodSuagarChartViewController.h"
#import "FSMutipleLineChart.h"
#import "UIColor+FSPalette.h"
#import "UILabel+CustomLabel.h"
#import "MonthTableViewCell.h"
#import "YearTableViewCell.h"
#import "Utility.h"
#import "Localization.h"
#import "MainSideMenuViewController.h"
@interface BloodSuagarChartViewController ()
@property (nonatomic, strong) IBOutlet FSMutipleLineChart *chartWithDates;
@property (strong, nonatomic) NSMutableArray* firstChartData;
@property (strong, nonatomic) NSMutableArray* secondChartData;
@property (strong, nonatomic) NSMutableArray* thirdChartData;
@property (strong, nonatomic) NSMutableArray* fourthChartData;
@property (strong, nonatomic) NSMutableArray* fifthChartData;
@property (strong, nonatomic) NSMutableArray* sixthChartData;
//@property (strong, nonatomic) NSMutableArray* days;
@property (strong, nonatomic) NSArray* leftArray;
//@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDateFormatter *dateMonthFormatter;
@property (strong, nonatomic) NSDateFormatter *dateYearFormatter;
@property(strong,nonatomic) NSArray *slotArray;



@property (strong, nonatomic) NSDateFormatter *previousDateFormatter;

@end

@implementation BloodSuagarChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    
    monthView.layer.borderWidth = 1.0;
    monthView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    
    yearView.layer.borderWidth = 1.0;
    yearView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    
    //self.previousDateFormatter.dateFormat = @"dd MMM yyyy";
    self.previousDateFormatter = [[NSDateFormatter alloc] init];
    self.previousDateFormatter.dateFormat = @"dd MMM yyyy";
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        

        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
         bloodLbl.text =  [Localization languageSelectedStringForKey:@"Blood Sugar Graph"];
        
         daysLbl.text =  [Localization languageSelectedStringForKey:@"Days"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        [self.previousDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];

        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
        bloodLbl.text =  [Localization languageSelectedStringForKey:@"Blood Sugar Graph"];
        
        daysLbl.text =  [Localization languageSelectedStringForKey:@"Days"]; topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    //self.dateFormatter = [[NSDateFormatter alloc] init];
    _months = @[[Localization languageSelectedStringForKey:@"Jan"], [Localization languageSelectedStringForKey:@"Feb"],[Localization languageSelectedStringForKey:@"Mar"],  [Localization languageSelectedStringForKey:@"Apr"], [Localization languageSelectedStringForKey:@"May"],  [Localization languageSelectedStringForKey:@"Jun"],[Localization languageSelectedStringForKey:@"Jul"], [Localization languageSelectedStringForKey:@"Aug"], [Localization languageSelectedStringForKey:@"Sep"],[Localization languageSelectedStringForKey:@"Oct"], [Localization languageSelectedStringForKey:@"Nov"], [Localization languageSelectedStringForKey:@"Dec"]];
    
    _yearsArray = [[NSMutableArray alloc] init];
    
    NSDate *currentDate = [NSDate date];
    self.dateMonthFormatter = [[NSDateFormatter alloc] init];
    self.dateMonthFormatter.dateFormat = @"MMM";
    selectedMonth = [self.dateMonthFormatter stringFromDate:currentDate];
    [_monthButton setTitle:selectedMonth forState:UIControlStateNormal];
    
    self.dateYearFormatter = [[NSDateFormatter alloc] init];
    self.dateYearFormatter.dateFormat = @"yyyy";
    selectedYear = [self.dateYearFormatter stringFromDate:currentDate];
    [_yearButton setTitle:selectedYear forState:UIControlStateNormal];
    
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [self.dateMonthFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        [self.dateYearFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];

        
    }else{
        
        [self.dateMonthFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        [self.dateYearFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];

    }
    for(int i = [selectedYear intValue]; i >= [selectedYear intValue] - 10; i--)
    {
        [_yearsArray addObject:[NSNumber numberWithInt:i]];
    }
    


    [self loadChartDates];
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    _bloodSugarLabel.transform=CGAffineTransformMakeRotation( -( 90 * M_PI ) / 180 );

    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}

#pragma mark - Setting up the chart

- (void)loadChartDates {
    
    //self.dateFormatter.dateFormat = @"dd";
    
    _chartWidthCons.constant = 800;
    
    self.firstChartData = [[NSMutableArray alloc] init];
    self.secondChartData = [[NSMutableArray alloc] init];
    self.thirdChartData = [[NSMutableArray alloc] init];
    self.fourthChartData = [[NSMutableArray alloc] init];
    self.fifthChartData = [[NSMutableArray alloc] init];
    self.sixthChartData = [[NSMutableArray alloc] init];

    

    
    self.slotArray = [[NSArray alloc] initWithObjects:@"6am-10am",@"10am-2pm",@"2pm-6pm",@"6pm-10pm",@"10pm-2am",@"2am-6am",nil];
    
    self.leftArray = @[@"50", @"100", @"150", @"200",@"250",@"300",@"350",@"400"];
    
    [self updateChartData];
}


-(void)updateChartData
{
    [_chartWithDates clearChartData];
    
    NSMutableArray *days = [[NSMutableArray alloc] init];

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
    for(int i = 0; i < days.count; i++)
    {
        NSString *dayString = [days objectAtIndex:i];
        NSString *dateString = [NSString stringWithFormat:@"%@ %@ %@",dayString,selectedMonth,selectedYear];
        
        NSMutableArray *allValueArray = [[NSMutableArray alloc] init];
        
        for(int j = 0; j < self.slotArray.count; j++)
        {
            float valueForSlot = [self getvalueForSlot:[self.slotArray objectAtIndex:j] withDate:dateString];

            [allValueArray addObject:[NSNumber numberWithFloat:valueForSlot]];
        }
        
        _firstChartData[i] = [allValueArray objectAtIndex:0];
        _secondChartData[i] = [allValueArray objectAtIndex:1];
        _thirdChartData[i] = [allValueArray objectAtIndex:2];
        _fourthChartData[i] = [allValueArray objectAtIndex:3];
        _fifthChartData[i] = [allValueArray objectAtIndex:4];
        _sixthChartData[i] = [allValueArray objectAtIndex:5];
    }
    
    // Setting up the line chart
    _chartWithDates.verticalGridStep = 6; //(int)self.leftArray.count;
    _chartWithDates.horizontalGridStep = (int)days.count;
    _chartWithDates.fillColor = nil;
    _chartWithDates.lineWidth = 1.0;
    _chartWithDates.displayDataPoint = YES;
    _chartWithDates.dataPointColor = [UIColor fsOrange];
    _chartWithDates.dataPointBackgroundColor = [UIColor fsOrange];
    _chartWithDates.dataPointRadius = 2;
    _chartWithDates.color = [_chartWithDates.dataPointColor colorWithAlphaComponent:0.3];
    _chartWithDates.valueLabelPosition = ValueLabelLeft;
    _chartWithDates.leftArray = [self.leftArray copy];
    _chartWithDates.labelForIndex = ^(NSUInteger item) {
        return days[item];
    };
    
    _chartWithDates.labelForValue = ^(CGFloat value) {
        
        return [NSString stringWithFormat:@"%.02f   ", value];
    };
    
    _chartWithDates.dataPointColor = [UIColor fsRed];
    _chartWithDates.dataPointBackgroundColor = [UIColor fsRed];
    _chartWithDates.color = [UIColor fsRed];
    [_chartWithDates setChartData:self.firstChartData withTag:1];
    
    /*
    _chartWithDates.dataPointColor = [UIColor fsGreen];
    _chartWithDates.dataPointBackgroundColor = [UIColor fsGreen];
    _chartWithDates.color = [UIColor fsGreen];
    [_chartWithDates setChartData:self.secondChartData withTag:2];
    
    _chartWithDates.dataPointColor = [UIColor fsDarkGray];
    _chartWithDates.dataPointBackgroundColor = [UIColor fsDarkGray];
    _chartWithDates.color = [UIColor fsDarkGray];
    [_chartWithDates setChartData:self.thirdChartData withTag:3];
    
    _chartWithDates.dataPointColor = [UIColor fsYellow];
    _chartWithDates.dataPointBackgroundColor = [UIColor fsYellow];
    _chartWithDates.color = [UIColor fsYellow];
    [_chartWithDates setChartData:self.fourthChartData withTag:4];
    
    _chartWithDates.dataPointColor = [UIColor fsDarkBlue];
    _chartWithDates.dataPointBackgroundColor = [UIColor fsDarkBlue];
    _chartWithDates.color = [UIColor fsDarkBlue];
    [_chartWithDates setChartData:self.fifthChartData withTag:5];
    
    _chartWithDates.dataPointColor = [UIColor fsOrange];
    _chartWithDates.dataPointBackgroundColor = [UIColor fsOrange];
    _chartWithDates.color = [UIColor fsOrange];
    [_chartWithDates setChartData:self.sixthChartData withTag:6];
     */
    
    [self performSelector:@selector(showSecondLine:) withObject:nil afterDelay:2.0];
    [self performSelector:@selector(showThirdLine:) withObject:nil afterDelay:4.0];
    [self performSelector:@selector(showFourthLine:) withObject:nil afterDelay:6.0];
    [self performSelector:@selector(showFifthLine:) withObject:nil afterDelay:8.0];
    [self performSelector:@selector(showSixthLine:) withObject:nil afterDelay:10.0];
    
}

-(void)showSecondLine:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _chartWithDates.dataPointColor = [UIColor fsGreen];
        _chartWithDates.dataPointBackgroundColor = [UIColor fsGreen];
        _chartWithDates.color = [UIColor fsGreen];
        [_chartWithDates setChartData:self.secondChartData withTag:2];
    });
}

-(void)showThirdLine:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _chartWithDates.dataPointColor = [UIColor fsDarkGray];
        _chartWithDates.dataPointBackgroundColor = [UIColor fsDarkGray];
        _chartWithDates.color = [UIColor fsDarkGray];
        [_chartWithDates setChartData:self.thirdChartData withTag:3];
    });
}

-(void)showFourthLine:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _chartWithDates.dataPointColor = [UIColor fsYellow];
        _chartWithDates.dataPointBackgroundColor = [UIColor fsYellow];
        _chartWithDates.color = [UIColor fsYellow];
        [_chartWithDates setChartData:self.fourthChartData withTag:4];
    });
}

-(void)showFifthLine:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _chartWithDates.dataPointColor = [UIColor fsLightBlue];
        _chartWithDates.dataPointBackgroundColor = [UIColor fsLightBlue];
        _chartWithDates.color = [UIColor fsLightBlue];
        [_chartWithDates setChartData:self.fifthChartData withTag:5];
    });
}

-(void)showSixthLine:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _chartWithDates.dataPointColor = [UIColor fsOrange];
        _chartWithDates.dataPointBackgroundColor = [UIColor fsOrange];
        _chartWithDates.color = [UIColor fsOrange];
        [_chartWithDates setChartData:self.sixthChartData withTag:6];
    });
}

-(float)getvalueForSlot:(NSString *)slotString withDate:(NSString *)dateString
{
    float finalValue = 0.0;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.date == %@ AND SELF.slot == %@",dateString,slotString];
    
    NSArray *filteredSlotOneArray = [self.bloodsugarArray filteredArrayUsingPredicate:predicate];
    
    for(int i = 0; i < filteredSlotOneArray.count; i++)
    {
        finalValue = finalValue + [[filteredSlotOneArray[i] valueForKey:@"bloodsugar"] floatValue];
    }
    if(filteredSlotOneArray.count > 0)
    {
        finalValue = finalValue/filteredSlotOneArray.count;
    }
    return finalValue;
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

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

