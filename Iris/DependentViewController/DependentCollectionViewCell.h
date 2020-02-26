//
//  DependentCollectionViewCell.h
//  Iris
//
//  Created by apptology on 12/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DependentCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *dependentImageView;
@property (weak, nonatomic) IBOutlet UIButton *dependentButton;
@property (weak, nonatomic) IBOutlet UILabel *dependentNameLabel;

@end
