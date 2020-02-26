//
//  ProviderNetworkTableViewCell.h
//  Iris
//
//  Created by apptology on 08/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProviderNetworkTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *facilityName;
@property (weak, nonatomic) IBOutlet UILabel *facilityType;
@property (weak, nonatomic) IBOutlet UILabel *location;
@property (weak, nonatomic) IBOutlet UIButton *directionButton;
@property (weak, nonatomic) IBOutlet UIView *roundCornerView;

@end
