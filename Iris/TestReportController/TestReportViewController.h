//
//  TestReportViewController.h
//  Iris
//
//  Created by apptology on 14/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestReportViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UIButton *_previousButton;
    __weak IBOutlet UIButton *_nextButton;
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UIButton *topBtn;
    __weak IBOutlet UIButton *sideMenuBtnOutlet;
    //__weak IBOutlet UITableView *_mainTableView;
    NSMutableArray *_titleArray;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UIButton *_downloadButton;
    __weak IBOutlet UIImageView *notificationIconImageView;

    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    
    
    __weak IBOutlet UILabel *testLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    
    
}
//@property(nonatomic,strong)NSMutableDictionary *reportInfoDictionary;
@property(nonatomic,strong)NSMutableArray *reportsArray;

@end
