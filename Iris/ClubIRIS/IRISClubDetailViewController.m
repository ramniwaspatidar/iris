//
//  IRISClubDetailViewController.m
//  Iris
//
//  Created by Ramniwas Patidar on 05/03/20.
//  Copyright © 2020 apptology. All rights reserved.
//

#import "IRISClubDetailViewController.h"
#import "ClubCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Localization.h"
#import "Constant.h"
#import "ConnectionManager.h"
#import "Utility.h"

@interface IRISClubDetailViewController ()

@end

@implementation IRISClubDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addShadow];
    
    dictDetail = [[NSMutableDictionary alloc]init];
  
    NSString *accesscountrylist = [self.dictDetailInfo valueForKey:@"clubvouchermemberassignid"];
    [self getDetails:accesscountrylist];


     [collectionView registerNib:[UINib nibWithNibName:@"ClubCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ClubCollectionCell"];
}

-(void)setData{
    
     titleLabel.text = [dictDetail valueForKey:@"partnername"];
      promotionLabel.text = [NSString stringWithFormat:@"Promotion valid from %@ to %@",[dictDetail valueForKey:@"entrydate"],[dictDetail valueForKey:@"enddate"]];
      discountLabel.text = [dictDetail valueForKey:@"title"];
      descriptionLabel.text = [dictDetail valueForKey:@"description"];
      qrCodeLabel.text = [dictDetail valueForKey:@"vouchercode"];
    codeLabel.text = [dictDetail valueForKey:@"promovouchercode"];
    
    [qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:[dictDetail valueForKey:@"barcodeimageurl"]] placeholderImage:[UIImage imageNamed:@"userplaceholde.png"]];

      
}
-(void)setInitislData{
    [downloadButton setTitle:[Localization languageSelectedStringForKey:@"DOWNLOAD"] forState:UIControlStateNormal];
     [partnerButton setTitle:[Localization languageSelectedStringForKey:@"PARTNER DESCRIPTION"] forState:UIControlStateNormal];
     [redeemptionButton setTitle:[Localization languageSelectedStringForKey:@"REDEEMTION T&C's"] forState:UIControlStateNormal];
     [locationButton setTitle:[Localization languageSelectedStringForKey:@"LOCATIONS"] forState:UIControlStateNormal];
}

-(void)addShadow{
       downloadButton.layer.masksToBounds = true;
       downloadButton.layer.cornerRadius = 0;
       downloadButton.layer.borderWidth = 2;
       downloadButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
       downloadButton.layer.shadowColor = [[UIColor blackColor] CGColor];
       downloadButton.layer.shadowOffset = CGSizeMake(0.0, 0.3);
       downloadButton.layer.shadowOpacity = 0.5;
       downloadButton.layer.shadowRadius = 1.0;
    
       partnerButton.layer.masksToBounds = true;
       partnerButton.layer.cornerRadius = 0;
       partnerButton.layer.borderWidth = 2;
          partnerButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
          partnerButton.layer.shadowColor = [[UIColor blackColor] CGColor];
          partnerButton.layer.shadowOffset = CGSizeMake(0.0, 0.3);
          partnerButton.layer.shadowOpacity = 0.5;
          partnerButton.layer.shadowRadius = 1.0;
    
    redeemptionButton.layer.masksToBounds = true;
          redeemptionButton.layer.cornerRadius = 0;
          redeemptionButton.layer.borderWidth = 2;
          redeemptionButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
          redeemptionButton.layer.shadowColor = [[UIColor blackColor] CGColor];
          redeemptionButton.layer.shadowOffset = CGSizeMake(0.0, 0.3);
          redeemptionButton.layer.shadowOpacity = 0.5;
          redeemptionButton.layer.shadowRadius = 1.0;
    
    locationButton.layer.masksToBounds = true;
    locationButton.layer.cornerRadius = 0;
    locationButton.layer.borderWidth = 2;
    locationButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    locationButton.layer.shadowColor = [[UIColor blackColor] CGColor];
    locationButton.layer.shadowOffset = CGSizeMake(0.0, 0.3);
    locationButton.layer.shadowOpacity = 0.5;
    locationButton.layer.shadowRadius = 1.0;
}

- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)locationButtonAction:(id)sender {
    descriptionLabel.text = [dictDetail valueForKey:@"address"];
}

- (IBAction)previousButtonAction:(id)sender {
    for (UICollectionViewCell *cell in [collectionView visibleCells]) {
        NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
     if (indexPath.row > 0){
         
         NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
         [collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:0 animated:true];

     }
    }
}

- (IBAction)downloadButtonAction:(id)sender {
    [self getEcardPDFUrl];
}

- (IBAction)partnerButtonAction:(id)sender {
    descriptionLabel.text = [dictDetail valueForKey:@"description"];

}

- (IBAction)redeemptionButtonAction:(id)sender {
    descriptionLabel.text = [dictDetail valueForKey:@"termsandconditions"];

}

- (IBAction)nextButtonAction:(id)sender {
    
    for (UICollectionViewCell *cell in [collectionView visibleCells]) {
        NSIndexPath *indexPath = [collectionView indexPathForCell:cell];
        if (indexPath.row < arrayClubList.count){
            
            NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:0 animated:true];
        }
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:kdownloadEcardSegue])
    {        ECardViewController *eCardViewController = segue.destinationViewController;
        eCardViewController.pdfUrl = [NSString stringWithFormat:@"%@",sender];
        eCardViewController.downloadDelegate = self;
    }
}


-(void)saveDownloadFile:(NSURL*) url{
    NSLog(@"test");
    [self pdfSucessAlert:[NSString stringWithFormat:@"%@",url]];
    
}


-(void)pdfSucessAlert:(NSString *)path
{
    NSString *location = [NSString stringWithFormat:@"%@: %@",[Localization languageSelectedStringForKey:@"Location"],path];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[Localization languageSelectedStringForKey:@"Download"] message:location preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *openFile = [UIAlertAction actionWithTitle:[Localization languageSelectedStringForKey:@"OPEN FILE"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                               {
        
        UIDocumentInteractionController *documentInteractionController =[UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:path]];
        documentInteractionController.delegate = self;
        [documentInteractionController presentPreviewAnimated:YES];
    }];
    
    [alertController addAction:openFile];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
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


-(void)getDetails:(NSString *)voucherAssignId{
    

   NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    
    NSString *activeDependent = [userInfoDic valueForKey:@"dependentmemberid"];
    if(activeDependent && ![activeDependent isEqualToString:@""])
    {
        [dictionary setValue:activeDependent forKey:@"memberid"];
    }
    else
    {
        [dictionary setValue:[userInfoDic valueForKey:@"memberid"]
                       forKey:@"memberid"];
    }
    
    [dictionary setValue:voucherAssignId forKey:@"clubvouchermemberassignid"];

   NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"ViewClubIrisVoucherDetails"];
   NSError *jsonError;
   NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
   NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
   
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[userInfoDic valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
         if (!error)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                 if([[serverMsg lowercaseString] isEqualToString:@"success"])
                 {
                     self->dictDetail = [[responseDictionary valueForKey:@"viewvouchers"] objectAtIndex:0];
                     self->arrayClubList = [[NSMutableArray alloc]initWithArray:[self->dictDetail valueForKey:@"voucherimageslist"]];
                     [self->collectionView reloadData];
                     [self setData];
                     [self->tblView setHidden:false];
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

-(void)getEcardPDFUrl
{
    
    NSDictionary *userInfoDic = [Utility unarchiveData:[[NSUserDefaults standardUserDefaults] valueForKey:@"login"]];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"GetEcardPdfUrl"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
//    NSString *memberId = [userInfoDic valueForKey:@"memberid"];
//    [dictionary1 setValue:memberId forKey:@"memberid"];
//
//
      
      NSString *voucherAssignId = [self.dictDetailInfo valueForKey:@"clubvouchermemberassignid"];

      NSString *activeDependent = [userInfoDic valueForKey:@"dependentmemberid"];
      if(activeDependent && ![activeDependent isEqualToString:@""])
      {
          [dictionary setValue:activeDependent forKey:@"memberid"];
      }
      else
      {
          [dictionary setValue:[userInfoDic valueForKey:@"memberid"]
                         forKey:@"memberid"];
      }
      
      [dictionary setValue:voucherAssignId forKey:@"clubvouchermemberassignid"];

    
    NSError *jsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&jsonError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURLWithRawJsonAndHeader:url withHeader:[userInfoDic valueForKey:@"token"] json:jsonString timeoutInterval:kTimeoutDuration showHUD:YES showSystemError:NO completion:^(NSDictionary *responseDictionary, NSError *error)
     {
        if (!error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *serverMsg = [NSString stringWithFormat:@"%@",[responseDictionary valueForKey:kServerMessage]];
                if([[serverMsg lowercaseString] isEqualToString:@"success"])
                {
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"ecard.pdf"];
                
                    [self checkFileExistAtPath:path];
                    NSDictionary *dict = [responseDictionary valueForKey:@"pdfUrl"];
                                                                                 NSString *pdfUrl = [dict valueForKey:@"pdfUrl"];
                [self performSegueWithIdentifier:kdownloadEcardSegue sender:pdfUrl];
                   
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

- (void)checkFileExistAtPath:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath: path])
    {
        [fileManager removeItemAtPath:path error:NULL];
    }
}

@end
