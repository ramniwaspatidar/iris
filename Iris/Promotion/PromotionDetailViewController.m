//
//  PromotionDetailViewController.m
//  Iris
//
//  Created by apptology on 05/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "PromotionDetailViewController.h"
#import "NSData+Base64.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utility.h"
#import "UILabel+CustomLabel.h"
#import "MainSideMenuViewController.h"
#import "Localization.h"
@interface PromotionDetailViewController ()<UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation PromotionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];

    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"MM/dd/yyyy hh:mm:ss a";
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [ self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
        
        
    }else{
        
        [ self.dateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
        
        
        
    }
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
           promotionLbl.text =  [Localization languageSelectedStringForKey:@"Promotion Details"];
         descriptionLbl.text =  [Localization languageSelectedStringForKey:@"Description"];
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        promotionLbl.text =  [Localization languageSelectedStringForKey:@"Promotion Details"];
        descriptionLbl.text =  [Localization languageSelectedStringForKey:@"Description"]; topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    [self setCornerView];
    [self setPromotionDetailOnView];
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:[Localization languageSelectedStringForKey:@"Promotions Details"]];
}

-(void)setPromotionDetailOnView
{
    _promotionName.text = [self.promotionDetail valueForKey:@"promoname"];
    _promotionBy.text = [NSString stringWithFormat:@"%@: %@",[Localization languageSelectedStringForKey:@"Promoted by"],[self.promotionDetail valueForKey:@"promopartner"]];
    _couponCode.text = [NSString stringWithFormat:@"%@: %@",[Localization languageSelectedStringForKey:@"Coupon Code"],[self.promotionDetail valueForKey:@"promocode"]];

    NSString *promotionStartDate = [self.promotionDetail valueForKey:@"promostartdate"];
    NSString *promotionEndDate = [self.promotionDetail valueForKey:@"promoenddate"];
    NSDate *startDate = [self.dateFormatter dateFromString:promotionStartDate];
    NSDate *endDate = [self.dateFormatter dateFromString:promotionEndDate];
    
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
    newDateFormatter.dateFormat = @"EEEE dd MMMM, yyyy";
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        [ newDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"en"]];
        
        
        
        
    }else{
        
        [ newDateFormatter  setLocale:[NSLocale localeWithLocaleIdentifier:@"ar"]];
        
        
        
        
        
        
    }
    _validFromToDate.text = [NSString stringWithFormat:@"%@ to %@",[newDateFormatter stringFromDate:startDate],[newDateFormatter stringFromDate:endDate]];
    
    
    if([self.promotionDetail valueForKey:@"promopic"])
    {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[self.promotionDetail valueForKey:@"promopic"]] placeholderImage:[UIImage imageNamed:@"no_image.png"] options:SDWebImageHighPriority];
    }
    
    if([self.promotionDetail valueForKey:@"promodescription"])
    {
        _descriptionTextView.text = [self.promotionDetail valueForKey:@"promodescription"];
    }
    /*
    NSData *imageData = [NSData dataFromBase64String:[self.promotionDetail valueForKey:@"promopic"]];
    UIImage *promoImage = [UIImage imageWithData:imageData];
    if(promoImage)
    {
        _imageView.image = promoImage;
        //imageHeightCons.constant = promoImage.size.height;
        //imageWidthCons.constant = promoImage.size.width;
    }*/
    

}
-(void)setCornerView
{
    _roundCornerView.layer.cornerRadius = 5.0;
    _roundCornerView.layer.borderWidth = 1.0;
    _roundCornerView.layer.borderColor =  [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1] CGColor];
    _roundCornerView.clipsToBounds = YES;
}


#pragma mark- Button Action -

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)shareButtonAction:(id)sender {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      @"image.ig" ];
    UIImage *myImage = [UIImage imageNamed:@"icon-App-76x76"];
    NSData* data = UIImagePNGRepresentation(myImage);
    [data writeToFile:path atomically:YES];
    
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:
                           @"image.ig" ];
    
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIGraphicsEndImageContext();
    
    self.docController.UTI = @"com.instagram.photo";
    self.docController = [self setupControllerWithURL:[NSURL fileURLWithPath:imagePath] usingDelegate:self];
    self.docController=[UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:imagePath]];
    NSString * msgBody = [NSString stringWithFormat:@"%@",_couponCode.text];
    self.docController.annotation = [NSDictionary dictionaryWithObject:msgBody forKey:@"InstagramCaption"];
    [self.docController presentOpenInMenuFromRect: rect inView: self.view animated: YES ];
}


- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    return interactionController;
}

- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller {
    
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
