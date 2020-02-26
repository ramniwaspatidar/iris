//
//  TestReportViewController.m
//  Iris
//
//  Created by apptology on 14/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "TestReportViewController.h"
#import "TestReportTableViewCell.h"
#import "UILabel+CustomLabel.h"
#import "UIButton+CustomButton.h"
#import "NotificationViewController.h"
#import "Utility.h"
#import "Localization.h"
#import "MainSideMenuViewController.h"
@interface TestReportViewController ()

@end

@implementation TestReportViewController
static NSInteger previousPage = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _previousButton.hidden = YES;
    _scrollView.scrollEnabled = NO;
    if([[[self.reportsArray firstObject] valueForKey:@"isfilepresent"] intValue] == 0)
    {
        _downloadButton.hidden = YES;
    }
    else
    {
        _downloadButton.hidden = NO;
    }
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        [_downloadButton setTitle:[Localization languageSelectedStringForKey:@"Download Report"] forState:UIControlStateNormal];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        testLbl.text =  [Localization languageSelectedStringForKey:@"Test Report"];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
         helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        [_downloadButton setTitle:[Localization languageSelectedStringForKey:@"Download Report"] forState:UIControlStateNormal];
        
        testLbl.text =  [Localization languageSelectedStringForKey:@"Test Report"];
        topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    [_downloadButton setButtonCornerRadious];
    _titleArray = [[NSMutableArray alloc] initWithObjects:[Localization languageSelectedStringForKey:@"Lab Name"],[Localization languageSelectedStringForKey:@"Service Name"],[Localization languageSelectedStringForKey:@"Test Value"],[Localization languageSelectedStringForKey:@"Test Observation"], nil];
    //_inputDataArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"", nil];
    
    [self setScrollViewContent];
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(notificationIconTapped:)];
    tapGesture.numberOfTapsRequired = 1;
    notificationIconImageView.userInteractionEnabled = YES;
    [notificationIconImageView addGestureRecognizer:tapGesture];
    
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    //[self setPreviousNextButtonCornerRadious];
    //_mainTableView.backgroundColor = [UIColor clearColor];
    //_mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:[Localization languageSelectedStringForKey:@"Test Report"]];
}

-(void)setPreviousNextButtonCornerRadious
{
    _previousButton.layer.cornerRadius = _previousButton.frame.size.width/2;
    _previousButton.clipsToBounds = YES;
    _nextButton.layer.cornerRadius = _nextButton.frame.size.width/2;
    _nextButton.clipsToBounds = YES;
}

-(void)setScrollViewContent
{
    CGFloat x = 0;
    CGFloat y = 0;
    
    for(int i = 0; i < self.reportsArray.count; i++)
    {
        CGFloat width = self.view.frame.size.width;
        CGFloat height = _scrollView.frame.size.height;
        CGRect tableFrame = CGRectMake(x, y, width, height);
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = YES;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.userInteractionEnabled = YES;
        tableView.bounces = NO;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 65;
        tableView.tag = i;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        [_scrollView addSubview:tableView];
        x = x + width;
        _scrollView.contentSize = CGSizeMake(x, _scrollView.frame.size.height-50);
    }
}



#pragma mark Table View methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"TestReportCellIdentifier";
    TestReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TestReportTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    if(cell.inputTextLabel)
    {
        cell.inputTextLabel.tag =  indexPath.row;
        cell.inputTextLabel.userInteractionEnabled = NO;
    }
    int tableTag = (int)tableView.tag;
    NSDictionary *reportInfoDictionary = [self.reportsArray objectAtIndex:tableTag];
    cell.title.text = [_titleArray objectAtIndex:indexPath.row];
    if(indexPath.row == 0)
    {
        if(![[reportInfoDictionary  valueForKey:@"labname"] isKindOfClass:[NSNull class]])
            cell.inputTextLabel.text = [reportInfoDictionary valueForKey:@"labname"];
    }
    else if(indexPath.row ==1)
    {
        if(![[reportInfoDictionary  valueForKey:@"servicename"] isKindOfClass:[NSNull class]])
            cell.inputTextLabel.text = [reportInfoDictionary valueForKey:@"servicename"];
    }
    else if(indexPath.row ==2)
    {
        if(![[reportInfoDictionary  valueForKey:@"testvalue"] isKindOfClass:[NSNull class]])
            cell.inputTextLabel.text = [reportInfoDictionary valueForKey:@"testvalue"];
    }
    else if(indexPath.row ==3)
    {
        if(![[reportInfoDictionary  valueForKey:@"testobservations"] isKindOfClass:[NSNull class]] && ![[reportInfoDictionary  valueForKey:@"testobservations"] isEqualToString:@""])
            cell.inputTextLabel.text = [reportInfoDictionary valueForKey:@"testobservations"];
        else
            cell.inputTextLabel.text = [Localization languageSelectedStringForKey:@"N/A"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}

/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier  =@"TestReportCellIdentifier";
    TestReportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TestReportTableViewCell" owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    CGSize maximumLabelSize = CGSizeMake(cell.frame.size.width - 30, 100);

    int tableTag = (int)tableView.tag;
    NSDictionary *reportInfoDictionary = [self.reportsArray objectAtIndex:tableTag];
    
    NSString *inputText = nil;
    if(indexPath.row == 0)
    {
        if(![[reportInfoDictionary  valueForKey:@"labname"] isKindOfClass:[NSNull class]])
            inputText = [reportInfoDictionary valueForKey:@"labname"];
    }
    else if(indexPath.row ==1)
    {
        if(![[reportInfoDictionary  valueForKey:@"servicename"] isKindOfClass:[NSNull class]])
            inputText = [reportInfoDictionary valueForKey:@"servicename"];
    }
    else if(indexPath.row ==2)
    {
        if(![[reportInfoDictionary  valueForKey:@"testvalue"] isKindOfClass:[NSNull class]])
            inputText = [reportInfoDictionary valueForKey:@"testvalue"];
    }
    else if(indexPath.row ==3)
    {
        if(![[reportInfoDictionary  valueForKey:@"testobservations"] isKindOfClass:[NSNull class]])
            inputText = [reportInfoDictionary valueForKey:@"testobservations"];
    }
    
    CGSize expectedLabelSize = [inputText sizeWithFont:cell.textLabel.font
                                      constrainedToSize:maximumLabelSize
                                          lineBreakMode:cell.textLabel.lineBreakMode];
    
    if(expectedLabelSize.height > 0)
        cell.textHeightCons.constant = expectedLabelSize.height;
    else
        cell.textHeightCons.constant = 20;
    return cell.textHeightCons.constant + 35;
}
*/
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 15;
    cell.separatorInset = insets;
    cell.contentView.backgroundColor = [UIColor clearColor];
}

#pragma mark- Button Actions -

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)downloadReportButtonAction:(id)sender {
    NSDictionary *dictionary = [_reportsArray objectAtIndex:previousPage];
    // make the file name first
    
    if([[dictionary valueForKey:@"isfilepresent"] intValue] == 0)
        return;
    NSString *fileUrl = [dictionary valueForKey:@"fileurl"];
    NSString *extention = [[fileUrl componentsSeparatedByString:@"."] lastObject];
#if 1
    // the URL to save
    NSURL *yourURL = [NSURL URLWithString:fileUrl];
    // turn it into a request and use NSData to load its content
    NSURLRequest *request = [NSURLRequest requestWithURL:yourURL];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *path;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"TestReport"];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])    //Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            NSLog(@"Create directory error: %@", error);
        }
    }
    int pageNumber = _scrollView.contentOffset.x/_scrollView.frame.size.width;
    NSString *fileName = [NSString stringWithFormat:@"%@_%d.%@",[dictionary valueForKey:@"claimno"],pageNumber,extention];
    path = [path stringByAppendingPathComponent:fileName];

    if ([[NSFileManager defaultManager] fileExistsAtPath:path])        //Does file exist?
    {
        if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error])    //Delete it
        {
            NSLog(@"Delete file error: %@", error);
        }
    }
    NSURL *filePathUrl = [NSURL fileURLWithPath:path];
    // and finally save the file
    NSError *error1;
    [data writeToURL:filePathUrl options:NSDataWritingAtomic error:&error1];
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)previousButtonAction:(id)sender {
    if(_scrollView.contentOffset.x > 0)
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x - _scrollView.frame.size.width, 0) animated:NO];
}

- (IBAction)nextButtonAction:(id)sender {
    if(_scrollView.contentOffset.x + _scrollView.frame.size.width < _scrollView.contentSize.width)
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x + _scrollView.frame.size.width, 0) animated:NO];

}


#pragma mark - private methods
-(void)notificationIconTapped:(UITapGestureRecognizer *)sender {
    NotificationViewController *notificationVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NotificationViewController"];
    [self.navigationController pushViewController:notificationVC animated:YES];
}

#pragma mark- Scroll View Delegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (previousPage != page) {
        // Page has changed, do your thing!
        // ...
        // Finally, update previous page
        
        NSDictionary *dictionary = [_reportsArray objectAtIndex:page];
        // make the file name first
        
        if([[dictionary valueForKey:@"isfilepresent"] intValue] == 0)
        {
            _downloadButton.hidden = YES;
        }
        else
        {
            _downloadButton.hidden = NO;
        }
            
        
        
        
        if(page == 0)
        {
            _previousButton.hidden = YES;
        }
        else
        {
            _previousButton.hidden = NO;
        }
        if(page == self.reportsArray.count-1)
        {
            _nextButton.hidden = YES;
        }
        else
        {
            _nextButton.hidden = NO;
        }
        previousPage = page;
    }
    
}

@end
