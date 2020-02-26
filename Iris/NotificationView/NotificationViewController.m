//
//  NotificationViewController.m
//  Iris
//
//  Created by Deepak on 1/22/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "NotificationViewController.h"
#import "DbManager.h"
#import "Utility.h"
#import "Localization.h"

#import "AppointmentReminderViewController.h"
#import "NotificationTableViewCell.h"
#import "MedicineAlert+CoreDataProperties.h"
#import "AppointmentReminder+CoreDataProperties.h"
#import "RevealViewController.h"
#import "MainSideMenuViewController.h"
@import UserNotifications;

@interface NotificationViewController ()

@property (strong) NSMutableArray *appointmentList;
@property (strong) NSMutableArray *medicineAlertList;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.appointmentList = [[NSMutableArray alloc] init];
    self.medicineAlertList = [[NSMutableArray alloc] init];
    
    self.mainTableView.rowHeight = UITableViewAutomaticDimension;
    self.mainTableView.estimatedRowHeight = 44;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.tableFooterView = [UIView new];
    
    self.personDetailDictionary = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
     
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        notificationLbl.text =  [Localization languageSelectedStringForKey:@"Notification"];

        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        notificationLbl.text =  [Localization languageSelectedStringForKey:@"Notification"]; topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);

        //   [revealController setFrontViewController:frontNavigationController];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:@"Notifications"];
    
    [self updateNotificationsData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotificationsData) name:@"update_alert_notification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - private methods
-(void)updateNotificationsData {
    [self.appointmentList removeAllObjects];
    [self.medicineAlertList removeAllObjects];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    dateFormatter1.dateFormat = @"dd MMMM yyyy - hh:mm a";

  
    
    NSString *dateString = [dateFormatter1 stringFromDate:date];
    NSPredicate *appointmentPredicate =
    [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@",[self.personDetailDictionary valueForKey:@"emiratesid"]];
    
    // fetch notification data
    //NSPredicate *appointmentPredicate = [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@",[self.personDetailDictionary valueForKey:@"emiratesid"]];
    [self.appointmentList addObjectsFromArray:[[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"AppointmentReminder" withPredicate:appointmentPredicate sortKey:@"timings" ascending:YES] mutableCopy]];
    
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.appointmentList.count; i++)
    {
        AppointmentReminder *appointment = [self.appointmentList objectAtIndex:i];
        NSDate *appointmentDate = [dateFormatter1 dateFromString:(NSString*) appointment.appointmentdate];
        if([appointmentDate compare: date] >= 0)
        {
            [filteredArray addObject:appointment];
        }
    }
    [self.appointmentList removeAllObjects];
    [self.appointmentList addObjectsFromArray:filteredArray];
    
    NSArray *arrKeys = [self.appointmentList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd MMMM yyyy - hh:mm a"];

    
        NSDate *d1 = [df dateFromString:(NSString*) [obj1 valueForKey:@"appointmentdate"]];
        NSDate *d2 = [df dateFromString:(NSString*) [obj2 valueForKey:@"appointmentdate"]];
        if (d1 == nil || d2 == nil) {
            return false;
        }
        return [d1 compare: d2];
    }];
    [self.appointmentList removeAllObjects];
    [self.appointmentList addObjectsFromArray:arrKeys];
    
    // fetch medicine alert
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
 
    dateFormatter.dateFormat = @"yyyy/MM/dd";
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];

    dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSPredicate *medicinePredicate = [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@",[self.personDetailDictionary valueForKey:@"emiratesid"],dateString];
    [self.medicineAlertList addObjectsFromArray:[[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"MedicineAlert" withPredicate:medicinePredicate sortKey:@"time" ascending:YES] mutableCopy]];
    
    dateFormatter.dateFormat = @"yyyy/MM/dd hh:mm a";

    NSMutableArray *medicinefilteredArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < self.medicineAlertList.count; i++)
    {
        MedicineAlert *medicineAlert = [self.medicineAlertList objectAtIndex:i];
        NSString *dateTime = [NSString stringWithFormat:@"%@ %@",(NSString*) medicineAlert.date,(NSString*) medicineAlert.time];
        NSDate *medicineDate = [dateFormatter dateFromString:(NSString*) dateTime];
        if([medicineDate compare: date] >= 0 || ![medicineAlert.repeat isEqualToString:@""])
        {
            if([medicineDate compare: date] < 0)
            {
                medicineAlert = [Utility getMedicineAlertForUpcomingDate:medicineAlert];
                [medicinefilteredArray addObject:medicineAlert];
            }
            else
            {
                [medicinefilteredArray addObject:medicineAlert];
            }
        }
    }
    [self.medicineAlertList removeAllObjects];
    [self.medicineAlertList addObjectsFromArray:medicinefilteredArray];
    
    NSArray *arrKeys1 = [self.medicineAlertList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        //NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //[df setDateFormat:@"yyyy/MM/dd"];
        NSString *firstDate = [NSString stringWithFormat:@"%@ %@",[obj1 valueForKey:@"date"],[obj1 valueForKey:@"time"]];
        NSString *secondDate = [NSString stringWithFormat:@"%@ %@",[obj2 valueForKey:@"date"],[obj2 valueForKey:@"time"]];

        NSDate *d1 = [dateFormatter dateFromString:firstDate];
        NSDate *d2 = [dateFormatter dateFromString:secondDate];
        if (d1 == nil || d2 == nil) {
            return false;
        }
        return [d1 compare: d2];
    }];
    [self.medicineAlertList removeAllObjects];
    [self.medicineAlertList addObjectsFromArray:arrKeys1];
    
    [self.mainTableView reloadData];
}

#pragma mark - actions
- (IBAction)backButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (section == 0)?[Localization languageSelectedStringForKey:@"Appointments"]:[Localization languageSelectedStringForKey:@"Medicine Alert"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = (section == 0)?self.appointmentList.count:self.medicineAlertList.count;
    if(numberOfRows == 0) {
        numberOfRows = 1;
    } else {
    }
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"NotificationCellIdentifier";
    
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UILabel *appointmentDataLabel = [cell viewWithTag:999];
    if(appointmentDataLabel == nil) {
        appointmentDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 75.0, 60)];
        appointmentDataLabel.numberOfLines = 3;
        appointmentDataLabel.tag = 999;
        appointmentDataLabel.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1.0];
        appointmentDataLabel.textAlignment = NSTextAlignmentCenter;
        appointmentDataLabel.font = [UIFont boldSystemFontOfSize:12];
        cell.accessoryView = appointmentDataLabel;
    }
    
    if(indexPath.section == 0) {
        if(self.appointmentList.count > 0) {
            NSDictionary *appointmentInfo = [self.appointmentList objectAtIndex:indexPath.row];
            NSString *doctorName = [appointmentInfo valueForKey:@"doctorname"];
            NSString *address = [NSString stringWithFormat:@"%@, %@",[appointmentInfo valueForKey:@"facility"], [appointmentInfo valueForKey:@"region"]];
            
            NSArray *dateComponents = [self getFormattedDateFrom:[appointmentInfo valueForKey:@"appointmentdate"] time:nil];
            
            NSMutableAttributedString *attributedStr = [self getAttributedStringFromString:[dateComponents componentsJoinedByString:@"\r\n"] withRange:NSMakeRange(0, [[dateComponents objectAtIndex:0] length])];
            
            cell.textLabel.text = doctorName;
            cell.detailTextLabel.text = address;
            
            appointmentDataLabel.hidden = NO;
            appointmentDataLabel.attributedText = attributedStr;
        } else {
            appointmentDataLabel.hidden = YES;
            cell.textLabel.text = nil;
            if ([MainSideMenuViewController isCurrentLanguageEnglish]){
                
                // [revealController setRightViewController:frontNavigationController];
                //  [revealController setl];
                cell.detailTextLabel.text = [Localization languageSelectedStringForKey:@"No Appointment found."];

            }
            else{
                cell.detailTextLabel.text = [Localization languageSelectedStringForKey:@"No Appointment found."];

                //   [revealController setFrontViewController:frontNavigationController];
            }
        }
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(self.medicineAlertList.count > 0) {
            NSDictionary *medicineAlertInfo = [self.medicineAlertList objectAtIndex:indexPath.row];
            NSLog(@"%@",medicineAlertInfo);
            cell.textLabel.text = [Localization languageSelectedStringForKey:@"Need to take medicine"];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\r\n%@",[medicineAlertInfo valueForKey:@"category"],[medicineAlertInfo valueForKey:@"medicines"]];
            
        
            if (  [medicineAlertInfo valueForKey:@"date"] == nil) {
            }else{
                NSArray *dateComponents = [self getFormattedDateFrom:[medicineAlertInfo valueForKey:@"date"] time:[medicineAlertInfo valueForKey:@"time"]];
                
                NSMutableAttributedString *attributedStr = [self getAttributedStringFromString:[dateComponents componentsJoinedByString:@"\r\n"] withRange:NSMakeRange(0, [[dateComponents objectAtIndex:0] length])];
                appointmentDataLabel.hidden = NO;
                appointmentDataLabel.attributedText = attributedStr;
            }
           
          
        } else {
            appointmentDataLabel.hidden = YES;
            cell.textLabel.text = nil;
            cell.detailTextLabel.text = [Localization languageSelectedStringForKey:@"No Medicine alert found."];
        }
    }
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 1 && self.medicineAlertList.count > 0)
        return YES;
    
    return NO;
    
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSDictionary *medicineAlertInfo = [self.medicineAlertList objectAtIndex:indexPath.row];
        [self deleteAlert:medicineAlertInfo];
        [self updateNotificationsData];
        [self.mainTableView reloadData];
        
        [tableView setEditing:NO];
        
    }];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGSize bgSize = CGSizeMake(100, cell.frame.size.height);
    
    //UIImage *bgImage = [self imageWithBackgroundFromImage:[UIImage imageNamed:@"delete-icon"] size:bgSize];
    UIImage *bgImage = [self fitImage:[UIImage imageNamed:@"delete-icon"] inBox:bgSize withBackground:[UIColor redColor]];
    deleteAction.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
    return @[deleteAction];
}

- (UIImage*) fitImage:(UIImage*)image inBox:(CGSize)size withBackground:(UIColor*)color {
    
    float widthFactor = size.width / image.size.width;
    float heightFactor = size.height / image.size.height;
    
    CGSize scaledSize = size;
    if (widthFactor<heightFactor) {
        scaledSize.width = size.width;
        scaledSize.height = image.size.height * widthFactor;
    } else {
        scaledSize.width = image.size.width * heightFactor;
        scaledSize.height = size.height;
    }
    
    UIGraphicsBeginImageContextWithOptions( size, NO, 0.0 );
    
    float marginX = (size.width-scaledSize.width)/2;
    float marginY = (size.height-scaledSize.height)/2;
    CGRect scaledImageRect = CGRectMake(marginX, marginY, scaledSize.width, scaledSize.height );
    
    UIImage* temp = UIGraphicsGetImageFromCurrentImageContext();
    [color set];
    UIRectFill(CGRectMake(0.0, 0.0, temp.size.width, temp.size.height));
    [image drawInRect:scaledImageRect];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

-(void)deleteAlert:(NSDictionary *)alertData {
    NSPredicate *medicinePredicate = [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@ AND SELF.date == %@ AND SELF.time == %@",[alertData valueForKey:@"emiratesid"],[alertData valueForKey:@"date"],[alertData valueForKey:@"time"]];
    MedicineAlert *medicineAlert = [[[DbManager getSharedInstance] fatchAllObjectsForEntity:@"MedicineAlert" withPredicate:medicinePredicate sortKey:nil ascending:NO] firstObject];


    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];


        NSString *requestIdentifier = [NSString stringWithFormat:@"UYLLocalNotification_%@",[NSString stringWithFormat:@"%@ %@", medicineAlert.date, medicineAlert.time]];

        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier
                                                                              content:nil trigger:nil];

        [center removePendingNotificationRequestsWithIdentifiers:@[requestIdentifier]];

    } else {
        // Fallback on earlier versions
    }

    [[DbManager getSharedInstance] deleteObject:medicineAlert];
    [[DbManager getSharedInstance] saveContext];
}

#pragma mark - table data source helpers

-(NSArray *)getFormattedDateFrom:(NSString *)rawDate time:(NSString *)rawTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if(!rawTime) {
        dateFormatter.dateFormat = @"dd MMMM yyyy - hh:mm a";
    } else {
        dateFormatter.dateFormat = @"yyyy/MM/dd";
    }
   
    //dateFormatter.dateFormat = @"dd MMMM yyyy - hh:mm a";
    
   
    NSDate *date = [dateFormatter dateFromString:rawDate];
    if (date ==nil) {
        [dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        date = [dateFormatter dateFromString:rawDate];
    }
    // week day
//    dateFormattertest.dateFormat = @"EEEE";
//    NSString *stringDay = [dateFormattertest stringFromDate:date];
    
    // date and month
    dateFormatter.dateFormat = @"dd MMM";
    NSString *stringMonth = [dateFormatter stringFromDate:date];
    
    // year
    dateFormatter.dateFormat = @"yyyy";
    NSString *stringYear = [dateFormatter stringFromDate:date];
    
    // time
    NSString *stringTime;
    if(rawTime) {
        stringTime = rawTime;
    } else {
        dateFormatter.dateFormat = @"hh:mm a";
        stringTime = [dateFormatter stringFromDate:date];
    }
    
    if (stringMonth == nil) {
        stringMonth = @"";
    }
    if (stringYear == nil) {
        stringYear = @"";
    }
    if (stringTime == nil) {
        stringTime = @"";
    }
    return @[stringMonth,stringYear,stringTime];
}

-(NSMutableAttributedString *)getAttributedStringFromString:(NSString *)rawString withRange:(NSRange)range {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:rawString];
    UIFont *regularFont = [UIFont systemFontOfSize:11];
    UIFont *boldFont = [UIFont boldSystemFontOfSize:11];
    [attributedStr setAttributes:@{ NSFontAttributeName: regularFont } range:NSMakeRange(0, attributedStr.length)];
    [attributedStr setAttributes:@{ NSFontAttributeName: boldFont } range:range];
    return attributedStr;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0 && self.appointmentList.count > 0) {
        AppointmentReminderViewController *appointReminderViewController = (AppointmentReminderViewController *)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AppointmentReminderViewController"];
        appointReminderViewController.canDeleteAppointment = YES;
        appointReminderViewController.appointmentInfoDictionary = [self.appointmentList objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:appointReminderViewController animated:YES];
    }
}


@end
