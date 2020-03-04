//
//  ClbIRISCell.h
//  Iris
//
//  Created by Ramniwas Patidar on 03/03/20.
//  Copyright © 2020 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface ClbIRISCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    __weak IBOutlet UICollectionView *collectionView;
    __weak IBOutlet UIPageControl *pageControl;
    
    NSMutableArray *arrayClubList;
}
-(void)getClubData:(NSArray *)arrayData;

@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)previousButtonAction:(id)sender;
- (IBAction)nextButtonAction:(id)sender;
@end

NS_ASSUME_NONNULL_END
