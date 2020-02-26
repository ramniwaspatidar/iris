//
//  BloodSugarDeleteViewController.h
//  Iris
//
//  Created by apptology on 02/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodSugarDeleteViewController :UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    __weak IBOutlet UILabel *_slotLabel;
    __weak IBOutlet UILabel *_dateLabel;
    __weak IBOutlet UICollectionView *_collectionView;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UIButton *topBtn;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    NSMutableArray *_titleArray;
    __weak IBOutlet UILabel *bloodsugerLbl;
    
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *omanLbl;
    
    __weak IBOutlet UILabel *uaeLbl;
    
    
    //NSMutableArray *_bloodSugarStatsArray;
}
@property(nonatomic,strong) NSMutableArray *bloodSugarStatsArray;
@property(nonatomic,strong)NSString *displaySlot;

@end
