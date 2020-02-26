//
//  HIPRootViewController.m
//  Iris
//
//  Created by apptology on 06/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "HIPImageCropperView.h"
#import "HIPRootViewController.h"
#import "Localization.h"

#import "MainSideMenuViewController.h"

@interface HIPRootViewController ()

@property (nonatomic, strong) HIPImageCropperView *cropperView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSArray *photoButtons;

- (void)didTapPhotoButton:(id)sender;
- (void)didTapCaptureButton:(id)sender;

- (void)gestureRecognizerDidTap:(UIGestureRecognizer *)tapRecognizer;

@end


@implementation HIPRootViewController


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        [self.captureButton setTitle:[Localization languageSelectedStringForKey:@"crop & save"] forState:UIControlStateNormal];
        

        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        [self.captureButton setTitle:[Localization languageSelectedStringForKey:@"crop & save"] forState:UIControlStateNormal];

        
    }
}

-(void)setImageToCrop:(UIImage *)image withSize:(CGSize)size
{
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    
    _cropperView = [[HIPImageCropperView alloc]
                    initWithFrame:screenSize
                    cropAreaSize:CGSizeMake(size.width, size.height)
                    position:HIPImageCropperViewPositionCenter];
    
    [self.view addSubview:_cropperView];
    
    [_cropperView setOriginalImage:image];
    
    [self.view bringSubviewToFront:self.captureButton];
    self.captureButton.userInteractionEnabled = YES;
}

#pragma mark - Button actions

- (void)didTapPhotoButton:(id)sender {
    NSUInteger buttonIndex = [_photoButtons indexOfObject:sender];
    NSString *resourceName = nil;
    
    switch (buttonIndex) {
        case 0:
            resourceName = @"portrait.jpg";
            break;
        case 1:
            resourceName = @"landscape.jpg";
            break;
        case 2:
            resourceName = @"landscape-wide.jpg";
            break;
        default:
            break;
    }
    
    if (resourceName == nil) {
        return;
    }
    
    [self.cropperView setOriginalImage:[UIImage imageNamed:resourceName]];
}

-(IBAction)capturedButton_Cliked:(id)sender
{
    if (self.imageView != nil) {
        [self.imageView removeFromSuperview];
        self.imageView = nil;
        
    }
    UIImage *corpImage = [self.cropperView processedImage];
    [self.customDelegate updateCropedCaptureImage:corpImage];
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)didTapCaptureButton:(id)sender {
    if (self.imageView != nil) {
        [self.imageView removeFromSuperview];
        
        self.imageView = nil;
    }
    
    UIImage *corpImage = [self.cropperView processedImage];
    [self.customDelegate updateCropedCaptureImage:corpImage];
    [self.view removeFromSuperview];
}

- (void)gestureRecognizerDidTap:(UIGestureRecognizer *)tapRecognizer {
    [self.imageView removeFromSuperview];
    
    self.imageView = nil;
}

@end

