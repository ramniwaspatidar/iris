//
//  ClubIRISViewController.h
//  Iris
//
//  Created by Ramniwas Patidar on 03/03/20.
//  Copyright © 2020 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClbIRISCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClubIRISViewController : UIViewController{
    
    __weak IBOutlet UIButton *menuButton;
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UITableView *_mainTableView;

    
       NSIndexPath *activeCellIndexPath;
       BOOL keyboardShown;
       CGFloat keyboardOverlap;
       float keybaordHeight;
    
}

@end

NS_ASSUME_NONNULL_END
