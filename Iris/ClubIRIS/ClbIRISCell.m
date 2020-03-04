//
//  ClbIRISCell.m
//  Iris
//
//  Created by Ramniwas Patidar on 03/03/20.
//  Copyright © 2020 apptology. All rights reserved.
//

#import "ClbIRISCell.h"
#import "ClubCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ClbIRISCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
     [collectionView registerNib:[UINib nibWithNibName:@"ClubCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ClubCollectionCell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)getClubData:(NSArray *)arrayData{
    
    NSLog(@"%@",arrayData);
    arrayClubList = [[NSMutableArray alloc]initWithArray:arrayData];
    [collectionView reloadData];
    
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

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (UICollectionViewCell *cell in [collectionView visibleCells]) {
        NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
        pageControl.currentPage = indexPath.row;
    }
}



@end
