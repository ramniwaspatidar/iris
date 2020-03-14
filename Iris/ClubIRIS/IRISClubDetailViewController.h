//
//  IRISClubDetailViewController.h
//  Iris
//
//  Created by Ramniwas Patidar on 05/03/20.
//  Copyright © 2020 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Iris-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface IRISClubDetailViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,delegateDownloadFinished,UIDocumentInteractionControllerDelegate>{
    __weak IBOutlet UICollectionView *collectionView;
    NSMutableArray *arrayClubList;

    __weak IBOutlet UIImageView *qrCodeImageView;
    
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *promotionLabel;
    __weak IBOutlet UILabel *discountLabel;
    __weak IBOutlet UILabel *qrCodeLabel;
    __weak IBOutlet UILabel *descriptionLabel;
    __weak IBOutlet UIView *qrCodeView;
    __weak IBOutlet UIButton *downloadButton;
    __weak IBOutlet UIButton *partnerButton;
    __weak IBOutlet UIButton *redeemptionButton;
    __weak IBOutlet UIButton *locationButton;
    __weak IBOutlet UITableView *tblView;
    __weak IBOutlet UILabel *codeLabel;
    
   NSDictionary  *dictDetail;

}

@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong) NSDictionary  *dictDetailInfo;


- (IBAction)backButtonAction:(id)sender;
- (IBAction)locationButtonAction:(id)sender;
- (IBAction)previousButtonAction:(id)sender;
- (IBAction)downloadButtonAction:(id)sender;
- (IBAction)partnerButtonAction:(id)sender;
- (IBAction)redeemptionButtonAction:(id)sender;
- (IBAction)nextButtonAction:(id)sender;
@end

NS_ASSUME_NONNULL_END
