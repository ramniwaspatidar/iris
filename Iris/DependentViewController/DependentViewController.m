//
//  DependentViewController.m
//  Iris
//
//  Created by apptology on 12/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "DependentViewController.h"
#import "DependentCollectionViewCell.h"
#import "Dependent+CoreDataProperties.h"
#import "Constant.h"
#import "NSData+Base64.h"
#import "ProfileDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DependentProfileDetailViewController.h"
#import "Utility.h"
#import "UILabel+CustomLabel.h"
#import "MainSideMenuViewController.h"
#import "Localization.h"
@interface DependentViewController ()

@end

@implementation DependentViewController

#define itemSize CGSizeMake(95,145)

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    // Do any additional setup after loading the view.
    [_collectionView registerNib:[UINib nibWithNibName:@"DependentCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DependentCollectionCellIdentifier"];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        dependLbl.text =  [Localization languageSelectedStringForKey:@"Dependants"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        dependLbl.text =  [Localization languageSelectedStringForKey:@"Dependants"];
        topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [_collectionView setCollectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}


#pragma mark- CollectionView datasouce methods -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dependentsArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DependentCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"DependentCollectionCellIdentifier" forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor clearColor];
    
    if(cell.dependentButton)
    {
        NSString *imageString = [[_dependentsArray objectAtIndex:indexPath.row]valueForKey:@"profileimage"];
        //NSData *imageData = [NSData dataFromBase64String:imageString];
        //UIImage *dependentImage = [UIImage imageWithData:imageData];
        
        [cell.dependentImageView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"userplaceholde.png"]];
        
        cell.dependentNameLabel.text = [[_dependentsArray objectAtIndex:indexPath.row]valueForKey:@"fullname"];
        
        cell.dependentButton.tag = indexPath.row;
        [cell.dependentButton addTarget:self
                              action:@selector(dependentButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  itemSize;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0,(self.view.frame.size.width - (itemSize.width * 3))/4,0,0);  // top, left, bottom, right
}

-(void)dependentButtonAction:(id)sender
{
    UIButton *button = sender;
    Dependent *dependent = [self.dependentsArray objectAtIndex:(int)button.tag];
    [self performSegueWithIdentifier:kDependentProfileDetailIdentifier sender:dependent];
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kDependentProfileDetailIdentifier])
    {
        DependentProfileDetailViewController *profileDetailViewController = segue.destinationViewController;
        profileDetailViewController.dependentUser = sender;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
