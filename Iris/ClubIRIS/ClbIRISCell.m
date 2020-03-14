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
#import "IRISClubDetailViewController.h"

@implementation ClbIRISCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.userInteractionEnabled = true;

    
    [collectionView registerNib:[UINib nibWithNibName:@"ClubCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ClubCollectionCell"];
  
    bgView.layer.masksToBounds = true;
    bgView.layer.cornerRadius = 5;
    bgView.layer.borderWidth = 1;
    bgView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    bgView.layer.shadowColor = [[UIColor blackColor] CGColor];
    bgView.layer.shadowOffset = CGSizeMake(0.0, 0.3);
    bgView.layer.shadowOpacity = 0.5;
    bgView.layer.shadowRadius = 1.0;
}

- (IBAction)previousButtonAction:(id)sender {
    for (UICollectionViewCell *cell in [collectionView visibleCells]) {
        NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
     if (indexPath.row > 0){
         
         NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
         [collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:0 animated:true];
         pageControl.currentPage = indexPath.row - 1;

     }
    }
}

- (IBAction)nextButtonAction:(id)sender {
    
    for (UICollectionViewCell *cell in [collectionView visibleCells]) {
        NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
        if (indexPath.row < arrayClubList.count){
            
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:0 animated:true];
            pageControl.currentPage = indexPath.row + 1;
            
            if (indexPath.row + 1 == arrayClubList.count){
                pageControl.currentPage = 0;
            }
        }
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)getClubData:(NSMutableDictionary *)dict title:(NSString *)title{
    
    dictDetail = dict;
    _titleLabel.text = title;
    arrayClubList = [[NSMutableArray alloc]initWithArray:[dict valueForKey:@"voucherimageslist"]];
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
      IRISClubDetailViewController *detailView = [storyboard instantiateViewControllerWithIdentifier:@"IRISClubDetailViewController"];
      detailView.dictDetailInfo = dictDetail;
      [self.nav.navigationController pushViewController:detailView animated:true];
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
