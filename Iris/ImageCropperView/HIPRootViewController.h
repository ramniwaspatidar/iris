//
//  HIPRootViewController.h
//  Iris
//
//  Created by apptology on 06/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol coropImageDelegate<NSObject>
-(void)updateCropedCaptureImage:(UIImage *)image;
@end


@interface HIPRootViewController : UIViewController
@property(nonatomic,strong)UIImage *cropImage;
@property(nonatomic,assign)CGSize imageSize;
@property(nonatomic,weak)id<coropImageDelegate>customDelegate;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;

-(void)setImageToCrop:(UIImage *)image withSize:(CGSize )size;
-(IBAction)capturedButton_Cliked:(id)sender;

@end
