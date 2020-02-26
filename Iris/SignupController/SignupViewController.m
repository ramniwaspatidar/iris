//
//  SignupViewController.m
//  Iris
//
//  Created by apptology on 29/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import "SignupViewController.h"
#import "Utility.h"
#import "Constant.h"
#import "ConnectionManager.h"
#import "VerifyViewController.h"
#import "UILabel+CustomLabel.h"
#import "UIButton+CustomButton.h"
#import "ProfileImageTableViewCell.h"
#import "SignupTableViewCell.h"
#import "SignupSubmitTableViewCell.h"
#import "MainSideMenuViewController.h"
#import "Localization.h"

#define MAX_LENGTH 15

@interface SignupViewController ()

@end
typedef enum _cameraMode
{
    typeCamera = 0,
    typeLibrary = 1
    
} cameraMode;
@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _placeholderArray = [[NSMutableArray alloc] initWithObjects:@"",@"NATIONAL ID / CERTIFICATE NUMBER",[Localization languageSelectedStringForKey:@"Phone Number"],@"", nil];
    
    _inputDataArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"uncheck", nil];

    [uaeCall setGestureOnLabel];
    [omanCall setGestureOnLabelOMAN];
    
    [self callRemoveRegistrationAPI];
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        signupLbl.text =  [Localization languageSelectedStringForKey:@"Sign Up"];
        
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        helplineLbl.text =  [Localization languageSelectedStringForKey:@"Helpline"];
        uaeLbl.text =  [Localization languageSelectedStringForKey:@"UAE"];
        omanLbl.text =  [Localization languageSelectedStringForKey:@"OMAN"];
        signupLbl.text =  [Localization languageSelectedStringForKey:@"Sign Up"];
        topBtn.transform=CGAffineTransformMakeRotation(M_PI * 0.999);
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
    _mainTableView.backgroundColor = [UIColor clearColor];
    _mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    customAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 38)];
    customAccessoryView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self
               action:@selector(keyboardDownMethod:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:[Localization languageSelectedStringForKey:@"Done"] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(customAccessoryView.frame.size.width - 65, 0, 60, 38.0);
    [customAccessoryView addSubview:button];    // Do any additional setup after loading the view.
    if ([Utility IsiPhoneX])
    {
        topViewTopCons.constant = 0;
    }
}

-(void)keyboardDownMethod:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark Keyboard notification

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [Utility trackGoogleAnalystic:[Localization languageSelectedStringForKey:@"Sign Up"]];

    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _placeholderArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        static NSString *cellIdentifier  =@"ProfileImageCellIdentifier";
        ProfileImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileImageTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        [cell.profileImageView setImage:[UIImage imageNamed:@"userplaceholde"]];
        cell.profileEditImageView.hidden = NO;

        if(cell.profileImageButton)
        {
            cell.profileImageButton.layer.cornerRadius = cell.profileImageButton.frame.size.height/2;
            cell.profileImageButton.clipsToBounds = YES;
            
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.height/2;
            cell.profileImageView.clipsToBounds = YES;
            
            [cell.profileImageButton addTarget:self
                                        action:@selector(changePictureButtonAction:)
                              forControlEvents:UIControlEventTouchUpInside];
        }
        
        if([_inputDataArray objectAtIndex:indexPath.row])
        {
            if(self.capturedImage)
            {
                [cell.profileImageView setImage:self.capturedImage];
            }
        }
        else
        {
            [cell.profileImageView setImage:[UIImage imageNamed:@"userplaceholde"]];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath.row == 3)
    {
        static NSString *cellIdentifier  =@"SignupSubmitCellIdentifier";
        SignupSubmitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignupSubmitTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        if(cell.agreeButton)
        {
            [cell.agreeButton addTarget:self
                                        action:@selector(agreeButtonAction:)
                              forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        if(cell.termConditionButton)
        {
            [cell.termConditionButton addTarget:self
                                 action:@selector(conditionButtonAction:)
                       forControlEvents:UIControlEventTouchUpInside];
        }
        
        if(cell.submitButton)
        {
            [cell.submitButton addTarget:self
                                         action:@selector(submitButtonAction:)
                               forControlEvents:UIControlEventTouchUpInside];
        }
        
        if([[_inputDataArray objectAtIndex:indexPath.row]isEqualToString:@"check"])
            [cell.agreeButton setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        else
            [cell.agreeButton setImage:[UIImage imageNamed:@"uncheck.png"] forState:UIControlStateNormal];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if(indexPath > 0 && indexPath.row < 3)
    {
        static NSString *cellIdentifier  =@"SignupCellIdentifier";
        SignupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
        {
            // Load the top-level objects from the custom cell XIB.
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SignupTableViewCell" owner:self options:nil];
            // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
            cell = [topLevelObjects objectAtIndex:0];
        }
        cell.tag = indexPath.row;
        //cell.inputTextField.inputAccessoryView = nil;
        if(cell.inputTextField)
        {
            cell.inputTextField.tag = 61 + indexPath.row;
            cell.inputTextField.delegate = self;
            [cell.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        }
        
        if(indexPath.row == 1)
        {
            //cell.infoButton.hidden = NO;
            if(cell.infoButton)
            {
                [cell.infoButton addTarget:self
                                            action:@selector(infoButtonAction:)
                                  forControlEvents:UIControlEventTouchUpInside];
            }
            if(isInfoBoxOpen)
            {
                cell.infoBoxLabel.hidden = NO;
                cell.infoBoxBgImageView.hidden = NO;
            }
            else
            {
                cell.infoBoxLabel.hidden = YES;
                cell.infoBoxBgImageView.hidden = YES;
            }
        }
        else
        {
            if(indexPath.row == 2)
            {
                cell.inputTextField.keyboardType = UIKeyboardTypePhonePad;
                cell.inputTextField.inputAccessoryView = customAccessoryView;
            }
            
           // cell.infoButton.hidden = YES;
        }
        
        cell.titleLabel.text = [_placeholderArray objectAtIndex:indexPath.row];
        
        //cell.inputTextField.placeholder = [_placeholderArray objectAtIndex:indexPath.row];
        
        if(![[_inputDataArray objectAtIndex:indexPath.row] isEqualToString:@""])
        {
            cell.inputTextField.text = [_inputDataArray objectAtIndex:indexPath.row];
            cell.titleLabel.hidden = NO;
        }
        else
        {
            cell.inputTextField.text = @"";
            cell.titleLabel.hidden = NO;
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets  = cell.separatorInset;
    insets.right = 27;
    cell.separatorInset = insets;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
        return 110;
    else if(indexPath.row == 3)
    {
        return 120;
    }
    else
        return 65;
}

#pragma mark- UITextField Delegate methods


-(void)textFieldDidChange:(UITextField *)textField
{
    SignupTableViewCell *cell = (SignupTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    if(textField.text)
    {
        [_inputDataArray replaceObjectAtIndex:indexPath.row withObject:textField.text];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    SignupTableViewCell *cell = (SignupTableViewCell*)textField.superview.superview;
    activeCellIndexPath = [_mainTableView indexPathForCell:cell];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    SignupTableViewCell *cell = (SignupTableViewCell*)textField.superview.superview;
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    //cell.titleLabel.hidden = YES;
    if(indexPath.row == 2)
    {
        [textField resignFirstResponder];
        return YES;
    }
    
    if (textField.returnKeyType == UIReturnKeyNext) {
        // tab forward logic here
        return YES;
    }
    else if (textField.returnKeyType == UIReturnKeyGo)
    {
        
    }
    
    activeCellIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
    [_mainTableView scrollToRowAtIndexPath:activeCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [_mainTableView selectRowAtIndexPath:activeCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    
    cell = [_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]];
    if(cell)
    {
        activeCellIndexPath = indexPath;
        for(id view in cell.contentView.subviews)
            if([view isKindOfClass:[UITextField class]])
            {
                UITextField *textField1 = view;
                [textField1 becomeFirstResponder];
            }
    }
    else
    {
        [textField resignFirstResponder];
    }
    
    
    return YES;
}

#pragma mark - move view when keyboard comes into play
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    if(keyboardShown)
        return;
    
    keyboardShown = YES;
    
    // Get the keyboard size
    UIScrollView *tableView;
    if([_mainTableView.superview isKindOfClass:[UIScrollView class]])
        tableView = (UIScrollView *)_mainTableView.superview;
    else
        tableView = _mainTableView;
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [tableView.superview convertRect:[aValue CGRectValue] fromView:nil];
    
    // Get the keyboard's animation details
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    // Determine how much overlap exists between tableView and the keyboard
    CGRect tableFrame = tableView.frame;
    CGFloat tableLowerYCoord = tableFrame.origin.y + tableFrame.size.height;
    keyboardOverlap = tableLowerYCoord - keyboardRect.origin.y;
    if(self.inputAccessoryView && keyboardOverlap>0)
    {
        CGFloat accessoryHeight = self.inputAccessoryView.frame.size.height;
        keyboardOverlap -= accessoryHeight;
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, accessoryHeight, 0);
        tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, accessoryHeight, 0);
    }
    
    if(keyboardOverlap < 0)
        keyboardOverlap = 0;
    
    if(keyboardOverlap != 0)
    {
        tableFrame.size.height -= keyboardOverlap;
        
        NSTimeInterval delay = 0;
        if(keyboardRect.size.height)
        {
            delay = (1 - keyboardOverlap/keyboardRect.size.height)*animationDuration;
            animationDuration = animationDuration * keyboardOverlap/keyboardRect.size.height;
        }
        
        [UIView animateWithDuration:animationDuration delay:delay options:UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             tableView.frame = tableFrame;
         }
                         completion:^(BOOL finished){ [self tableAnimationEnded:nil finished:nil contextInfo:nil]; }];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    if(!keyboardShown)
        return;
    
    keyboardShown = NO;
    
    UIScrollView *tableView;
    if([_mainTableView.superview isKindOfClass:[UIScrollView class]])
        tableView = (UIScrollView *)_mainTableView.superview;
    else
        tableView = _mainTableView;
    //if(self.inputAccessoryView)
    {
        tableView.contentInset = UIEdgeInsetsZero;
        tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }
    
    if(keyboardOverlap == 0)
        return;
    
    // Get the size & animation details of the keyboard
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [tableView.superview convertRect:[aValue CGRectValue] fromView:nil];
    
    NSTimeInterval animationDuration;
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    UIViewAnimationCurve animationCurve;
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    
    CGRect tableFrame = tableView.frame;
    tableFrame.size.height += keyboardOverlap;
    
    if(keyboardRect.size.height)
        animationDuration = animationDuration * keyboardOverlap/keyboardRect.size.height;
    
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{ tableView.frame = tableFrame; }
                     completion:nil];
}

- (void) tableAnimationEnded:(NSString*)animationID finished:(NSNumber *)finished contextInfo:(void *)context
{
    // Scroll to the active cell
    if(activeCellIndexPath)
    {
        [_mainTableView scrollToRowAtIndexPath:activeCellIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [_mainTableView selectRowAtIndexPath:activeCellIndexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)agreeButtonAction:(id)sender {
    if([[_inputDataArray objectAtIndex:3] isEqualToString:@"check"])
        [_inputDataArray replaceObjectAtIndex:3 withObject:@"uncheck"];
    else
        [_inputDataArray replaceObjectAtIndex:3 withObject:@"check"];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
- (IBAction)infoButtonAction:(id)sender {
   
    isInfoBoxOpen = !isInfoBoxOpen;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
- (IBAction)conditionButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"goToTermsNCondition" sender:nil];
    
}

- (IBAction)submitButtonAction:(id)sender {
    if([self validateForm])
    {
        if(![[_inputDataArray objectAtIndex:3] isEqualToString:@"check"])
        {
            [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Please check agree button."] block:^(int index) {
            }];
            return;
        }
        /*else if(!self.encodedImageString)
        {
            [Utility showAlertViewControllerIn:self title:nil message:@"Please capture profile image." block:^(int index) {
            }];
            return;
        }*/
        [self callSignupAPI];
    }
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)changePictureButtonAction:(id)sender
{
   /* if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        if(self.imagePicker == nil)
            self.imagePicker = [[UIImagePickerController alloc] init];
        
        [self.imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        self.imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        self.imagePicker.showsCameraControls = YES;
        self.imagePicker.delegate = self;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }*/
    [self openCamera];
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
    float compressionQuality = 0.7;//50 percent compression
    
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
    UIImage *thumbnailImage = [self imageWithImage:capturedImage scaledToFillSize:CGSizeMake(150,150)];
    
    self.capturedImage = [capturedImage copy];
    //[self.profileImageButton setImage:thumbnailImage forState:UIControlStateNormal];
    self.encodedImageString = [self encodeToBase64String: thumbnailImage];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [_mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    //[_userCapturedImageArray addObject:capturedImage];
    //[_userCapturedThumbnailArray addObject:thumbnailImage];
    //[self doneButton_clicked:@"photo"];
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

-(void)callRemoveRegistrationAPI
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@"784-1987-4839394-3" forKey:@"emiratesid"];
    [dictionary setValue:@"ADNIN1D302" forKey:@"memberid"];
    [dictionary setValue:@"N1111111" forKey:@"passportno"];
    //[dictionary setValue:@"0552210365" forKey:@"mobileno"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"RemoveUserRegister"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:@"86148f78-15d1-4dc4-bad1-0d84f9e99da0" json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     _tokenString = [responseDictionary valueForKey:@"token"];
                     NSMutableDictionary *responseUpdatedDictionary = [[NSMutableDictionary alloc] init];
                     [responseUpdatedDictionary addEntriesFromDictionary:responseDictionary];
                     [responseUpdatedDictionary setValue:[_inputDataArray objectAtIndex:1] forKey:@"emiratesid"];
                     [responseUpdatedDictionary setValue:[_inputDataArray objectAtIndex:2] forKey:@"passportno"];
                     [responseUpdatedDictionary setValue:_tokenString forKey:@"token"];
                     [responseUpdatedDictionary setValue:[_inputDataArray objectAtIndex:3] forKey:@"mobileno"];
                     if(self.encodedImageString)
                     {
                         [responseUpdatedDictionary setValue:self.encodedImageString forKey:@"profileimage"];
                     }
                     
                 }
                 else if ([serverMsg containsString:[Localization languageSelectedStringForKey:@"Email not verified"]])
                 {
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Email is not varified."] block:^(int index) {
                     }];                  }
                 else if ([serverMsg containsString:[Localization languageSelectedStringForKey:@"Email not found"]] || [serverMsg containsString:[Localization languageSelectedStringForKey:@"User is inactive"]])
                 {
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"We were not able to find any details for the entered email address"] block:^(int index) {
                         
                     }];
                 }
                 else if ([serverMsg containsString:[Localization languageSelectedStringForKey:@"Email or Recovery key is incorrect"]])
                 {
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Please enter the correct login details"] block:^(int index) {
                     }];
                 }
                 else if ([serverMsg containsString:[Localization languageSelectedStringForKey:@"Email already exist"]])
                 {
                     [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"The email already exist on our server, Try Active New Device"] block:^(int index) {
                         
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
-(void)callSignupAPI
{
    NSString *emriteTextField = [Utility trimString:[_inputDataArray objectAtIndex:1]];
    
    emriteTextField = [emriteTextField stringByReplacingOccurrencesOfString:@"\\U2013" withString:@"-"];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:emriteTextField forKey:@"emiratesid"];
    [dictionary setValue:@"" forKey:@"passportno"];
    [dictionary setValue:[Utility trimString:[_inputDataArray objectAtIndex:2]] forKey:@"mobileno"];
    [dictionary setValue:@"m.ali@iris.healthcare" forKey:@"otpemail"];//m.ali@iris.healthcare
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"RegisterUser"];
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJson:url json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     _tokenString = [responseDictionary valueForKey:@"token"];
                     NSMutableDictionary *responseUpdatedDictionary = [[NSMutableDictionary alloc] init];
                     [responseUpdatedDictionary addEntriesFromDictionary:responseDictionary];
                     [responseUpdatedDictionary setValue:[Utility trimString:emriteTextField]  forKey:@"emiratesid"];
                     [responseUpdatedDictionary setValue:@"" forKey:@"passportno"];
                     [responseUpdatedDictionary setValue:_tokenString forKey:@"token"];
                     [responseUpdatedDictionary setValue:[Utility trimString:[_inputDataArray objectAtIndex:2]] forKey:@"mobileno"];
                     if(self.encodedImageString)
                     {
                         [responseUpdatedDictionary setValue:self.encodedImageString forKey:@"profileimage"];
                     }
                     [self performSegueWithIdentifier:kVerificationIdentifier sender:responseUpdatedDictionary];
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kVerificationIdentifier])
    {
        VerifyViewController *verifyViewController = segue.destinationViewController;
        verifyViewController.requestDictionary = sender;
        
        verifyViewController.verifyMessage = [NSString stringWithFormat:@"We have sent a 6-digit verification\n code via SMS to ****%@,\n enter the code below.",[[_inputDataArray objectAtIndex:2] substringFromIndex:4]];
    }
    else if ([segue.identifier isEqualToString:kImageCropViewIdentifier])
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


- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (!string.length)
        return YES;
//    if(textField.tag == 61){
//        if(textField.text.length == 3){
//            textField.text  = [textField.text  stringByAppendingString:@"-"];
//            if([string isEqualToString:@"-"])
//            {
//                return NO;
//            }
//        }
//        if(textField.text.length == 8){
//
//            textField.text  = [textField.text  stringByAppendingString:@"-"];
//            if([string isEqualToString:@"-"])
//            {
//                return NO;
//            }
//        }
//        if(textField.text.length == 16){
//
//            textField.text  = [textField.text  stringByAppendingString:@"-"];
//            if([string isEqualToString:@"-"])
//            {
//                return NO;
//            }
//        }
//
//        if(range.length + range.location > textField.text.length)
//        {
//            return NO;
//        }
//
//        NSUInteger newLength = [textField.text length] + [string length] - range.length;
//        if(newLength > 18)
//            [self textFieldShouldReturn:textField];
//        return newLength <= 18;
//    }else
//     if(textField.tag == 62)
//    {
//        NSUInteger newLength = [textField.text length] + [string length];
//
//        if(newLength > 40){
//            return NO;
//        }
//    }else
     if(textField.tag == 63)
    {
        NSUInteger newLength = [textField.text length] + [string length];
        
        if(newLength > MAX_LENGTH){
            return NO;
        }
        
        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSString *expression = @"^([0-9]+)?(\\.([0-9]{1,2})?)?$";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:nil];
        NSUInteger numberOfMatches = [regex numberOfMatchesInString:newString
                                                            options:0
                                                              range:NSMakeRange(0, [newString length])];
        if (numberOfMatches == 0)
            return NO;
    }
    return YES;
}
/*
-(void)moveViewUp:(UITextField *)textField
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int keyboardOverlap = 0;
        if (textField == _emiratesIdTextField) {
            keyboardOverlap = self.view.frame.size.height - CGRectGetMaxY(_emiratesIdTextField.frame) - keyboardHeight;
        }
        else if (textField == _passportNumberTextField)
        {
            keyboardOverlap = self.view.frame.size.height - CGRectGetMaxY(_passportNumberTextField.frame) - keyboardHeight;
        }
        else if (textField == _phoneNumberTextField)
        {
            keyboardOverlap = self.view.frame.size.height - CGRectGetMaxY(_phoneNumberTextField.frame) - keyboardHeight;
        }
        if(keyboardOverlap < 0)
        {
            CGRect selfRect = self.view.frame;
            selfRect.origin.y = keyboardOverlap - 5.0;
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^
             {
                 self.view.frame = selfRect;
             }completion:^(BOOL finished){  }];
        }
    });
}
*/




#pragma mark- Validation Methods -
-(BOOL)validateForm
{
    BOOL isValid = true;
    //Nishant
//    if([Utility trimString:[_inputDataArray objectAtIndex:1]].length == 0)
//    {
//        isValid = false;
//        [Utility showAlertViewControllerIn:self title:nil message:@"NATIONAL ID / CERTIFICATE NUMBER" block:^(int index) {
//        }];
//    }
//    else if([Utility trimString:[_inputDataArray objectAtIndex:1]].length != 18)
//    {
//        isValid = false;
//        [Utility showAlertViewControllerIn:self title:nil message:@"NATIONAL ID / CERTIFICATE NUMBER" block:^(int index) {
//        }];
//    }else

//    }else
    if([Utility trimString:[_inputDataArray objectAtIndex:2]].length == 0)
    {
        isValid = false;
        [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Please enter mobile number."] block:^(int index) {
        }];
    }
    else if([Utility trimString:[_inputDataArray objectAtIndex:2]].length <= 7)
    {
        isValid = false;
        [Utility showAlertViewControllerIn:self title:nil message:[Localization languageSelectedStringForKey:@"Please enter valid mobile number."] block:^(int index) {
        }];
    }
    
    
    return isValid;
}

/*
 #pragma mark - Navigation
 else if(([[Utility trimString:[_inputDataArray objectAtIndex:2]] hasPrefix:@"055"] || [[Utility trimString:[_inputDataArray objectAtIndex:2]] hasPrefix:@"056"] || [[Utility trimString:[_inputDataArray objectAtIndex:2]] hasPrefix:@"052"]) && ([[Utility trimString:[_inputDataArray objectAtIndex:2]] hasPrefix:@"0"] && !([Utility trimString:[_inputDataArray objectAtIndex:2]].length == 10)) || (![[Utility trimString:[_inputDataArray objectAtIndex:2]] hasPrefix:@"0"] && !([Utility trimString:[_inputDataArray objectAtIndex:2]].length == 9)))
 {
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

