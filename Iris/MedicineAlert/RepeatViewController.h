//
//  RepeatViewController.h
//  Iris
//
//  Created by apptology on 1/31/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendRepeatedData <NSObject>
- (void)getDaysData:(NSArray*)data;
- (void)getDatesFromDays:(NSArray*)data;



@end

@interface RepeatViewController : UIViewController
{
    
    __weak IBOutlet UILabel *repeatLbl;
    __weak IBOutlet UIButton *topBtn;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
}
@property (nonatomic, weak) id <sendRepeatedData> delegate;
@property (nonatomic,strong)NSMutableArray *selectedDays;
@property (nonatomic,strong)NSMutableArray *selectedDaysValues;

@end
