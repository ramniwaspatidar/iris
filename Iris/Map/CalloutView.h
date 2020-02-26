//
//  CalloutView.h
//  Iris
//
//  Created by apptology on 18/12/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@protocol calloutDelegateProtocol
-(void)calloutClicked:(id)sender;
-(void)reminderButtonClicked:(id)sender;
-(void)nextButtonClicked:(id)sender;

@end

@interface CalloutView : MKAnnotationView
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *moveMapButton;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *hospitalName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *specialty;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *setReminderButton;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic)id customDelegate;
@end
