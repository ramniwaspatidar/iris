//
//  PdfWebViewController.m
//  Iris
//
//  Created by VINAY on 07/02/19.
//  Copyright © 2019 apptology. All rights reserved.
//

#import "PdfWebViewController.h"
#import "RevealViewController.h"
#import "UILabel+CustomLabel.h"
#import "NotificationViewController.h"
#import "Utility.h"
#import "Localization.h"
#import "MainSideMenuViewController.h"

@interface PdfWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *viewOfWebView;
@property (weak, nonatomic) IBOutlet UIButton *backbtn;


@end

@implementation PdfWebViewController
@synthesize viewOfWebView;
@synthesize backbtn;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetupView];
        NSString *urlAddress = @"http://www.iris.healthcare/club-iris-web/";
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [viewOfWebView loadRequest:requestObj];
        //[viewOfWebView release];
        viewOfWebView.delegate=self;
    
    
}

-(void)initialSetupView
{
    RevealViewController *revealController = [self revealViewController];
    [revealController tapGestureRecognizer];
    
    if ([MainSideMenuViewController isCurrentLanguageEnglish]){
        _clubirisLbl.text =  [Localization languageSelectedStringForKey:@"Club IRIS"];

        [backbtn addTarget:revealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        // [revealController setRightViewController:frontNavigationController];
        //  [revealController setl];
        
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    else{
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        _clubirisLbl.text =  [Localization languageSelectedStringForKey:@"Club IRIS"];

        [backbtn addTarget:revealController action:@selector(rightRevealToggle:) forControlEvents:UIControlEventTouchUpInside];
        
        //   [revealController setFrontViewController:frontNavigationController];
    }
   
    //[_phoneLabel setGestureOnLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
