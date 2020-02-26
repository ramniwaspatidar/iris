//
//  DependentViewController.h
//  Iris
//
//  Created by apptology on 12/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DependentViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
{
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UICollectionView *_collectionView;
    __weak IBOutlet UIButton *topBtn;
    __weak IBOutlet UILabel *dependLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
}

@property(nonatomic,strong)NSMutableArray *dependentsArray;
@end
