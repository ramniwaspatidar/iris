//
//  FileNameTableViewCell.h
//  Iris
//
//  Created by apptology on 19/01/18.
//  Copyright © 2018 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileNameTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *filename;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end
