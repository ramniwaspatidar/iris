//
//  PromotionDetailViewController.h
//  Iris
//
//  Created by apptology on 05/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromotionDetailViewController : UIViewController
{
    __weak IBOutlet NSLayoutConstraint *topViewTopCons;
    __weak IBOutlet NSLayoutConstraint *imageWidthCons;
    __weak IBOutlet NSLayoutConstraint *imageHeightCons;
    __weak IBOutlet UILabel *uaeCall;
    __weak IBOutlet UILabel *omanCall;
    __weak IBOutlet UIImageView *_imageView;
    __weak IBOutlet UILabel *_promotionName;
    __weak IBOutlet UILabel *_promotionBy;
    __weak IBOutlet UIButton *topBtn;
    __weak IBOutlet UILabel *_validFromToDate;
    __weak IBOutlet UILabel *_couponCode;
    __weak IBOutlet UIView *_roundCornerView;
    __weak IBOutlet UITextView *_descriptionTextView;
    
    __weak IBOutlet UILabel *promotionLbl;
    __weak IBOutlet UILabel *helplineLbl;
    __weak IBOutlet UILabel *uaeLbl;
    __weak IBOutlet UILabel *omanLbl;
    __weak IBOutlet UILabel *descriptionLbl;
    __weak IBOutlet UILabel *couponCodLbl;
    
    
    
    
}

@property(nonatomic,strong)NSDictionary *promotionDetail;
@property (strong,nonatomic) UIDocumentInteractionController *docController;
@end
