//
//  SideMenuTableViewCell.h
//  Iris
//
//  Created by apptology on 01/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *_titleLbl;
@property (strong, nonatomic) IBOutlet UIImageView *_iconImgView;

-(void)setImage:(NSString *)imageName forMode:(BOOL)isPrincipleMode;

@end
