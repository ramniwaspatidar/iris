//
//  NotificationViewController.h
//  Iris
//
//  Created by Deepak on 1/22/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UIButton *topBtn;
    __weak IBOutlet UILabel *notificationLbl;
    
}

@property (strong) NSDictionary *personDetailDictionary;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (IBAction)backButtonClicked:(UIButton *)sender;

@end
