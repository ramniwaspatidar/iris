//
//  IRISClubDetailViewController.m
//  Iris
//
//  Created by Ramniwas Patidar on 05/03/20.
//  Copyright © 2020 apptology. All rights reserved.
//

#import "IRISClubDetailViewController.h"
#import "ClubCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Localization.h"
@interface IRISClubDetailViewController ()

@end

@implementation IRISClubDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [collectionView registerNib:[UINib nibWithNibName:@"ClubCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ClubCollectionCell"];
    // Do any additional setup after loading the view.
}

-(void)setInitislData{
    [downloadButton setTitle:[Localization languageSelectedStringForKey:@"DOWNLOAD"] forState:UIControlStateNormal];
     [partnerButton setTitle:[Localization languageSelectedStringForKey:@"PARTNER DESCRIPTION"] forState:UIControlStateNormal];
     [redeemptionButton setTitle:[Localization languageSelectedStringForKey:@"REDEEMTION T&C's"] forState:UIControlStateNormal];
     [locationButton setTitle:[Localization languageSelectedStringForKey:@"LOCATIONS"] forState:UIControlStateNormal];
}

-(void)addShadow{
       downloadButton.layer.masksToBounds = true;
       downloadButton.layer.cornerRadius = 0;
       downloadButton.layer.borderWidth = 1;
       downloadButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
       downloadButton.layer.shadowColor = [[UIColor blackColor] CGColor];
       downloadButton.layer.shadowOffset = CGSizeMake(0.0, 0.3);
       downloadButton.layer.shadowOpacity = 0.5;
       downloadButton.layer.shadowRadius = 1.0;
    
       partnerButton.layer.masksToBounds = true;
       partnerButton.layer.cornerRadius = 0;
       partnerButton.layer.borderWidth = 1;
          partnerButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
          partnerButton.layer.shadowColor = [[UIColor blackColor] CGColor];
          partnerButton.layer.shadowOffset = CGSizeMake(0.0, 0.3);
          partnerButton.layer.shadowOpacity = 0.5;
          partnerButton.layer.shadowRadius = 1.0;
    
    redeemptionButton.layer.masksToBounds = true;
          redeemptionButton.layer.cornerRadius = 0;
          redeemptionButton.layer.borderWidth = 1;
          redeemptionButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
          redeemptionButton.layer.shadowColor = [[UIColor blackColor] CGColor];
          redeemptionButton.layer.shadowOffset = CGSizeMake(0.0, 0.3);
          redeemptionButton.layer.shadowOpacity = 0.5;
          redeemptionButton.layer.shadowRadius = 1.0;
    
    locationButton.layer.masksToBounds = true;
    locationButton.layer.cornerRadius = 0;
    locationButton.layer.borderWidth = 1;
    locationButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    locationButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    locationButton.layer.shadowOffset = CGSizeMake(0.0, 0.3);
    locationButton.layer.shadowOpacity = 0.5;
    locationButton.layer.shadowRadius = 1.0;
}

- (IBAction)locationButtonAction:(id)sender {
}

- (IBAction)previousButtonAction:(id)sender {
    for (UICollectionViewCell *cell in [collectionView visibleCells]) {
        NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
     if (indexPath.row > 0){
         
         NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
         [collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:0 animated:true];

     }
    }
}

- (IBAction)downloadButtonAction:(id)sender {
}

- (IBAction)partnerButtonAction:(id)sender {
}

- (IBAction)redeemptionButtonAction:(id)sender {
}

- (IBAction)nextButtonAction:(id)sender {
    
    for (UICollectionViewCell *cell in [collectionView visibleCells]) {
        NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
        if (indexPath.row < arrayClubList.count){
            
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:0 animated:true];
        }
        
    }
    
}


#pragma mark- CollectionView datasouce methods -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrayClubList.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClubCollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"ClubCollectionCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor clearColor];
    
    NSString *immageString = [[arrayClubList objectAtIndex:indexPath.row] valueForKey:@"URL"];
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:immageString] placeholderImage:[UIImage imageNamed:@"userplaceholde.png"]];
    
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(collectionView.frame.size.width,153)
    ;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}




@end
