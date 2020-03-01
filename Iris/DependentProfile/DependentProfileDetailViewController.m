//
//  DependentProfileDetailViewController.m
//  Iris
//
//  Created by apptology on 12/02/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import "DependentProfileDetailViewController.h"
#import "Dependent+CoreDataProperties.h"
#import "UILabel+CustomLabel.h"
#import "Utility.h"
#import "Localization.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "RevealViewController.h"
#import "MainSideMenuViewController.h"
#import "Localization.h"
#import "Constant.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ConnectionManager.h"
#import "DbManager.h"

@interface DependentProfileDetailViewController()<coropImageDelegate>

@end

typedef enum _cameraMode
{
    typeCamera = 0,
    typeLibrary = 1
    
} cameraMode;


@implementation DependentProfileDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetupView];

    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
           dependLbl.text =  [Localization languageSelectedStringForKey:@"Dependant"];
        genderLbl.text =  [Localization languageSelectedStringForKey:@"Gender:"];
        
        emiratesLbl.text =  [Localization languageSelectedStringForKey:@"Emirates ID:"];
        
        memberLbl.text =  [Localization languageSelectedStringForKey:@"Member ID:"];
        
        
        passportLbl.text =  [Localization languageSelectedStringForKey:@"Password Number:"];
           emailLbl.text =  [Localization languageSelectedStringForKey:@"Email:"];
         relationLbl.text =  [Localization languageSelectedStringForKey:@"Relation:"];
         nationality.text =  [Localization languageSelectedStringForKey:@"Nationality:"];
        switchToLbl.text =  [Localization languageSelectedStringForKey:@"Switch to Dependant Account"];
         residentLbl.text =  [Localization languageSelectedStringForKey:@"Residence:"];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        
        dependLbl.text =  [Localization languageSelectedStringForKey:@"Dependant"];
        genderLbl.text =  [Localization languageSelectedStringForKey:@"Gender:"];
        
        emiratesLbl.text =  [Localization languageSelectedStringForKey:@"Emirates ID:"];
        
        memberLbl.text =  [Localization languageSelectedStringForKey:@"Member ID:"];
        
        
        passportLbl.text =  [Localization languageSelectedStringForKey:@"Password Number:"];
        emailLbl.text =  [Localization languageSelectedStringForKey:@"Email:"];
        relationLbl.text =  [Localization languageSelectedStringForKey:@"Relation:"];
        nationality.text =  [Localization languageSelectedStringForKey:@"Nationality:"];
        switchToLbl.text =  [Localization languageSelectedStringForKey:@"Switch to Dependant Account"];
        residentLbl.text =  [Localization languageSelectedStringForKey:@"Residence:"];
        _backButton.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [Utility trackGoogleAnalystic:@"Dependant"];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
-(void)initialSetupView
{
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
    if(self.showMenuIcon)
    {
        [self.backButton setImage:[UIImage imageNamed:@"revealmenu"] forState:UIControlStateNormal];
        
        RevealViewController *revealController = [self revealViewController];
        [revealController tapGestureRecognizer];
        
        
        if ([MainSideMenuViewController isCurrentLanguageEnglish]){
         [self.backButton addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            // [revealController setRightViewController:frontNavigationController];
            //  [revealController setl];
            
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
        else{
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            
            [self.backButton addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
            
            //   [revealController setFrontViewController:frontNavigationController];
        }
    }
    else
    {
        [self.backButton addTarget:self
    action:@selector(backButtonAction:)
    forControlEvents:UIControlEventTouchUpInside];
    }
    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    _userImageView.layer.cornerRadius = _userImageView.frame.size.width/2;
    _userImageView.clipsToBounds = YES;
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    NSString *activeDependent = [userInfoDic valueForKey:@"dependentmemberid"];
    if(activeDependent && ![activeDependent isEqualToString:@""])
    {
        if([self.dependentUser.memberid isEqualToString:activeDependent])
            switchToDependentButton.selected = YES;
    }
    
    /*_inputDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.dependentUser.fullname,@"fullname",self.dependentUser.email,@"email",self.dependentUser.nationality,@"nationality",self.dependentUser.gender,@"gender",self.dependentUser.memberid,@"memberid",self.dependentUser.residence,@"residence",self.dependentUser.profileimage,@"profileimage",self.dependentUser.passport,@"passport",self.dependentUser.emiratesid,@"emiratesid",self.dependentUser.relation,@"relation", nil];
    */
    
       [_userImageView setImage:[UIImage imageNamed:@"userplaceholde"]];

        if(self.dependentUser.profileimage)
        {
            NSString *imageString = self.dependentUser.profileimage;
            
            dispatch_async(dispatch_get_global_queue(0,0), ^{
                NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imageString]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_userImageView.image = [UIImage imageWithData: data];
                });
            });
            
        }
    
        if(self.dependentUser.passport)
        {
            _passportNoLabel.text = self.dependentUser.passport;
        }
        if(self.dependentUser.fullname)
        {
            _nameLabel.text = self.dependentUser.fullname;
        }
        if(self.dependentUser.email && ![self.dependentUser.email isEqualToString:@""])
        {
            _emailLabel.text = self.dependentUser.email;
        }
        else
        {
            _emailLabel.text =  [Localization languageSelectedStringForKey:@"N/A"];
        }
        if(self.dependentUser.gender)
        {
            _genderLabel.text = ([self.dependentUser.gender isEqualToString:@"M"])? [Localization languageSelectedStringForKey:@"Male"]:[Localization languageSelectedStringForKey:@"Female"];
        }
        if(self.dependentUser.nationality)
        {
            _nationalityLabel.text = self.dependentUser.nationality;
        }
        if(self.dependentUser.residence && ![self.dependentUser.residence isEqualToString:@""])
        {
            _resigenceLabel.text = self.dependentUser.residence;
        }
        else
        {
            _resigenceLabel.text = [Localization languageSelectedStringForKey:@"N/A"];
        }
        if(self.dependentUser.emiratesid)
        {
            _emritidLabel.text = self.dependentUser.emiratesid;
        }
        if(self.dependentUser.memberid)
        {
            _memberidLabel.text = self.dependentUser.memberid;
        }
        if(self.dependentUser.relation)
        {
            _relationLabel.text = self.dependentUser.relation;
        }
    
    
        UIGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnImage:)];
        [_userImageView addGestureRecognizer:tapGuesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tapOnImage:(UIGestureRecognizer *)guesture{
    [self openCamera];
    
}

#pragma mark- Button Actions-

- (IBAction)switchToDependentButtonAction:(id)sender {
    
    NSMutableDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    if(!switchToDependentButton.selected)
    {
        switchToDependentButton.selected = YES;
        [userInfoDic setValue:self.dependentUser.memberid forKey:@"dependentmemberid"];
        [[NSUserDefaults standardUserDefaults] setValue:[Utility archiveData:userInfoDic] forKey:@"login"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
        switchToDependentButton.selected = false;
        [userInfoDic removeObjectForKey:@"dependentmemberid"];
        [[NSUserDefaults standardUserDefaults] setValue:[Utility archiveData:userInfoDic] forKey:@"login"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"update_profile_notification"                                                                object:nil userInfo:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kImageCropViewIdentifier])
    {
        HIPRootViewController *hipRootViewController = segue.destinationViewController;
        
        hipRootViewController.customDelegate = self;
        CGSize size = CGSizeZero;
        size.width = self.view.frame.size.width - 50;
        size.height = size.width;
        UIImage *capturedImage = sender;
        [hipRootViewController setImageToCrop:capturedImage withSize:size];
    }
}

-(void)openCamera
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[Localization languageSelectedStringForKey:@"Please select"] message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *addPhotoAction = [UIAlertAction actionWithTitle:[Localization languageSelectedStringForKey:@"Library"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                     {
                                         capturedMode = typeLibrary;
                                         if(self.imagePicker == nil)
                                             self.imagePicker = [[UIImagePickerController alloc] init];
                                         [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
                                         [self.imagePicker setDelegate:self];
                                         [self.imagePicker setMediaTypes:@[(NSString *)kUTTypeImage]];
                                         [self presentViewController:self.imagePicker animated:YES completion:nil];
                                     }];
    
    UIAlertAction *addVideoAction = [UIAlertAction actionWithTitle:[Localization languageSelectedStringForKey:@"Camera"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                     {
                                         if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
                                         {
                                             capturedMode = typeCamera;
                                             if(self.imagePicker == nil)
                                                 self.imagePicker = [[UIImagePickerController alloc] init];
                                             
                                             [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
                                             self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                                             self.imagePicker.showsCameraControls = YES;
                                             self.imagePicker.delegate = self;
                                             [self presentViewController:self.imagePicker animated:YES completion:nil];
                                         }
                                     }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:[Localization languageSelectedStringForKey:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        NSLog(@"Dismiss");
    }];
    
    [alertController addAction:addPhotoAction];
    [alertController addAction:addVideoAction];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:NO completion:nil];
    UIImage *capturedImage= [info objectForKey:UIImagePickerControllerOriginalImage];
    capturedImage = [self compressImage:capturedImage];
    
    //UIImage *newImage = [self imageWithImage:capturedImage scaledToFillSize:CGSizeMake(self.view.frame.size.width,self.view.frame.size.height)];
    [self performSelector:@selector(moveToCroperScreen:) withObject:capturedImage afterDelay:0];
}

-(void)moveToCroperScreen:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *capturedImage = sender;
        [self performSegueWithIdentifier:kImageCropViewIdentifier sender:capturedImage];
    });
}

-(UIImage *)compressImage:(UIImage *)image{
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0); //1 it represents the quality of the image.
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imgData length]);
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = self.view.frame.size.height;
    float maxWidth = self.view.frame.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.5;//50 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth){
        if(imgRatio < maxRatio){
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio){
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else{
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
    
    NSLog(@"Size of Image(bytes):%ld",(unsigned long)[imageData length]);
    
    return [UIImage imageWithData:imageData];
}

-(void)updateCropedCaptureImage:(UIImage *)capturedImage
{
    _userImageView.image = capturedImage;
    [self callupdateProfileAPI];

    
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f, (size.height - height)/2.0f, width,height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *) scaleAndRotateImage: (UIImage *)image
{
    int kMaxResolution = 600; // Or whatever
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef),CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:[Localization languageSelectedStringForKey:@"Invalid image orientation"]];
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
    {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}





-(void)callupdateProfileAPI
{
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSMutableDictionary *dictionary1 = [[NSMutableDictionary alloc] init];
    [dictionary1 setValue:self.dependentUser.memberid forKey:@"memberid"];
    [dictionary1 setValue:self.dependentUser.principalmemberid forKey:@"principalmemberid"];
    [dictionary1 setValue:[self encodeToBase64String: _userImageView.image] forKey:@"profileimage"];
    

    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"UpdateDependentProfileImage"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary1 options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[userInfoDic valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     [self callShowProfileAPI];

                 }
                
                 else
                 {
                     [Utility showAlertViewControllerIn:self title:nil message:serverMsg block:^(int index) {
                     }];
                 }
                 
             });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
             });
         }
     }];
}

-(void)callShowProfileAPI
{
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSMutableDictionary *dictionary1 = [[NSMutableDictionary alloc] init];
    
    NSString *activeDependent = [userInfoDic valueForKey:@"dependentmemberid"];
    if(activeDependent && ![activeDependent isEqualToString:@""])
    {
        [dictionary1 setValue:activeDependent forKey:@"memberid"];
    }
    else
    {
        [dictionary1 setValue:[userInfoDic valueForKey:@"memberid"]
                       forKey:@"memberid"];
    }
    
    [dictionary1 setValue:[userInfoDic valueForKey:@"memberid"] forKey:@"principalmemberid"];
    
    [dictionary1 setValue:self.dependentUser.memberid forKey:@"memberid"];
    [dictionary1 setValue:self.dependentUser.principalmemberid forKey:@"principalmemberid"];
    
        
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"ShowProfile"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary1 options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[userInfoDic valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[dictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     
                   
                     [[DbManager getSharedInstance] deleteObjectsForEntity:@"Dependent" withPredicate:nil];
                    
                    
                     NSArray *policyHolderArray = [dictionary valueForKey:@"policyholder"];
                     for(int i = 0; i< policyHolderArray.count; i++)
                     {
                         
                          NSMutableDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
                          
                          NSString *emiratesId = [userInfoDic valueForKey:@"emiratesid"];
                          NSString *defaultPolicy = @"True";
                          NSPredicate *predicate =
                          [NSPredicate predicateWithFormat:@"SELF.emiratesid == %@ AND SELF.defaultpolicyholder == %@",emiratesId,defaultPolicy];
                          
                          NSArray *userArray = [[DbManager getSharedInstance] fatchAllObjectsForEntity:@"User" withPredicate:predicate sortKey:nil ascending:NO];
                          User *user = [userArray firstObject];
                        
                         NSArray *dependentArray = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"dependents"];
                         
                
                         [userInfoDic setValue:dependentArray forKey:@"dependents"];
                         
                             [[NSUserDefaults standardUserDefaults] setValue:[Utility archiveData:userInfoDic] forKey:@"login"];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                         
                         
                         
                         if(dependentArray.count > 0)
                         {
                             NSMutableSet * dependentSet = [[NSMutableSet alloc]init];
                             for(NSDictionary *dependentDic in dependentArray)
                             {
                                 Dependent *dependent = [NSEntityDescription insertNewObjectForEntityForName:@"Dependent"
                                                                                      inManagedObjectContext:[DbManager getSharedInstance].managedObjectContext];
                                 if(![[dependentDic valueForKey:@"email"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.email = [dependentDic valueForKey:@"email"];
                                 }
                                 if(![[dependentDic valueForKey:@"emiratesid"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.emiratesid = [dependentDic valueForKey:@"emiratesid"];
                                 }
                                 if(![[dependentDic valueForKey:@"fullname"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.fullname = [dependentDic valueForKey:@"fullname"];
                                 }
                                 
                                 if(![[dependentDic valueForKey:@"gender"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.gender = [dependentDic valueForKey:@"gender"];
                                 }
                                 if(![[dependentDic valueForKey:@"memberid"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.memberid = [dependentDic valueForKey:@"memberid"];
                                 }
                                 if(![[dependentDic valueForKey:@"nationality"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.nationality = [dependentDic valueForKey:@"nationality"];
                                 }
                                 if(![[dependentDic valueForKey:@"passport"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.passport = [dependentDic valueForKey:@"passport"];
                                 }
                                 if(![[dependentDic valueForKey:@"principalmemberid"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.principalmemberid = [dependentDic valueForKey:@"principalmemberid"];
                                 }
                                 if(![[dependentDic valueForKey:@"relation"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.relation = [dependentDic valueForKey:@"relation"];
                                 }
                                 if(![[dependentDic valueForKey:@"residence"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.residence = [dependentDic valueForKey:@"residence"];
                                 }
                                 if(![[dependentDic valueForKey:@"profileimage"] isKindOfClass:[NSNull class]])
                                 {
                                     dependent.profileimage = [dependentDic valueForKey:@"profileimage"];
                                 }
                                 if([[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"]){
                                     dependent.parentemiratesid = [[[dictionary valueForKey:@"policyholder"]objectAtIndex:i] valueForKey:@"emiratesid"];
                                 }
                                 
                                 [dependentSet addObject:dependent];
                                 [[DbManager getSharedInstance] saveContext];
                             }
                             user.depend = dependentSet;
                         }
                         [[DbManager getSharedInstance] saveContext];
                     }
                     
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Profile updated successfully."] block:^(int index) {
                     }];
                    
                 }
                
                 else
                 {
                     [Utility showAlertViewControllerIn:self title:nil message:serverMsg block:^(int index) {
                     }];
                 }
                 
             });
         }
         else
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
             });
         }
     }];
}

@end
