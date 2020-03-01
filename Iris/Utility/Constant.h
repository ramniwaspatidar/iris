//
//  Constant.h
//  Iris
//
//  Created by apptology on 28/11/17.
//  Copyright © 2017 apptology. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define kMediumFont16 [UIFont fontWithName:@"SanFranciscoText-Medium" size:16]

#define kSignupIdentifier @"SignupIdentifier"
#define kVerificationIdentifier @"VerificationIdentifier"
#define kCompleteProfileIdentifier @"CompleteProfileIdentifier"
#define kFilterIdentifier @"FilterIdentifier"
#define kTabbarControllerIdentifier @"TabbarControllerIdentifier"
#define kMainSideMenuStoryBoardName @"sideMenuScreenStoryBoardIdentifier"
#define kImageCropViewIdentifier @"ImageCropViewIdentifier"
#define kAppointmentReminderIdentifier @"appointmentReminderIdentifier"
#define kAboutUsIdentifier @"AboutUsIdentifier"
#define kMyHistoryIdentifier @"myHistoryIdentifier"
#define kReimbursementIdentifier @"ReimbursementIdentifier"
#define kTestReportIdentifier @"TestReportIdentifier"
#define kPolicyIdentifier @"PolicyIdentifier"
#define kPolicyDetailIdentifier @"PolicyDetailIdentifier"
#define kBMIDetailIdentifier @"BMIDetailIdentifier"

#define kAboutUsStoryBoardIdentifier  @"AboutUsStoryBoardIdentifier"
#define kWebViewsViewController  @"WebViewsViewController"
#define kRepeatViewController  @"RepeatViewController"



#define kLoginScreenStoryBoardName @"loginScreenStoryBoardIdentifier"
#define kMyHistoryStoryBoardName @"MyHistoryStoryBoardIdentifier"
#define kReimbursementStoryBoardName @"ReimbursementStoryBoardIdentifier"
#define kPolicyViewStoryboardName @"PolicyViewStoryboardIdentifier"
#define kViewYourECardViewStoryboardName @"ViewYourECardViewController"

#define kBMICalculatorIdentifier @"BMICalculatorIdentifier"
#define kBMICalculatorStoryboardName @"BMICalculatorStoryboardIdentifier"

#define kBloodPressureTrackerIdentifier @"BloodPressureTrackerIdentifier"
#define kBloodPressureTrackerStoryboardName @"BloodPressureTrackerStoryboardIdentifier"

#define kBloodSugarTrackerIdentifier @"BloodSugarTrackerIdentifier"
#define kBloodSugarTrackerStoryboardName @"BloodSugarTrackerStoryboardIdentifier"

#define kBloodPressureStatesIdentifier @"BloodPressureStatesIdentifier"
#define kBloodSugarStatesIdentifier @"BloodSugarStatesIdentifier"

#define kLipidStatesIdentifier @"LipidStatesIdentifier"
#define kLipidTrackerStoryboardName @"LipidTrackerStoryboardIdentifier"

#define kMedicineAlertIdentifier @"MedicineAlertIdentifier"
#define kMedicineAlertStoryboardName @"MedicineAlertStoryboardIdentifier"

#define kLipidTrackerIdentifier @"LipidTrackerIdentifier"

#define kSugarDeleteIdentifier @"SugarDeleteIdentifier"

#define kPromotionIdentifier @"PromotionIdentifier"
#define kPromotionStoryboardName @"PromotionStoryboardIdentifier"

#define kPromotionDetailIdentifier @"PromotionDetailIdentifier"

#define kProfileViewIdentifier @"ProfileViewIdentifier"
#define kProfileViewStoryboardName @"ProfileViewStoryboardIdentifier"
#define kDependentProfileViewStoryboardName @"DependentProfileViewStoryboardIdentifier"

#define kProfileDetailIdentifier @"ProfileDetailIdentifier"

#define kProviderNetworkViewIdentifier @"ProviderNetworkViewIdentifier"
#define kProviderNetworkViewStoryboardName @"ProviderNetworkViewStoryboardIdentifier"

#define kBMIChartIdentifier @"BMIChartIdentifier"
#define kLipidChartIdentifier @"LipidChartIdentifier"
#define kBloodPressureChartIdentifier @"BloodPressureChartIdentifier"
#define kBloodSugarChartIdentifier @"BloodSugarChartIdentifier"

#define kHBAChartIdentifier @"HBAChartIdentifier"
#define kAddReimbursementIdentifier @"AddReimbursementIdentifier"
#define kAddReimbursementStoryboardName @"AddReimbursementStoryboardIdentifier"

#define kDependentViewIdentifier @"DependentViewIdentifier"
#define kFileViewIdentifier @"FileViewIdentifier"
#define kForgotPasswordViewIdentifier @"ForgotPasswordViewIdentifier"

#define kForgotPasswordOTPViewIdentifier @"ForgotPasswordOTPViewIdentifier"

#define kdownloadEcardSegue @"downloadEcardSegue"

#define kDependentProfileDetailIdentifier @"DependentProfileDetailIdentifier"
//#define kAPIBaseURL @"http://ezyclaim.com/MobileAPIBeta/EzyclaimService.svc/"
#define kAPIBaseURL @"http://demoiris.ezyclaim.com:8080/Mobileapp/EzyclaimService.svc/"

//#define kAPIBaseURL @"http://demoiris.ezyclaim.com:8080/Mobileapp/EzyclaimService.svc/"

#define kFacebookUrl @"https://www.facebook.com/irishealth030/"
#define kInstagramUrl @"https://www.linkedin.com/in/irishealthservices/"
#define kWebsiteUrl @"http://iris.healthcare/"

#define kServerMessage @"message"
#define kLatitude @"userlatitude"
#define kLongitude @"userlongitude"

#define kErrorTitle NSLocalizedString(@"Oops!!", @"Some description")
#define kErrorMsgJsonParse [Localization languageSelectedStringForKey:@"It seems like we have encountered a temporary glitch. Please try again later."]
#define kErrorMsgSlowInternet [Localization languageSelectedStringForKey:@"It appears you are on slow connection or your internet is unavailable. Please check and try again !!."]

#define kTimeoutDuration 30.0
#define IS_IPHONEX ([[UIScreen mainScreen] bounds].size.height == 812)

#endif /* Constant_h */
