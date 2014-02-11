//
//  SPLSettingViewController.h
//  SplImage
//
//  Created by Nikhil Lele on 8/9/13.
//  Copyright (c) 2013 Nikhil Lele. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RKCropImageController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>


@interface SPLSettingViewController : UIViewController<UIActionSheetDelegate, UIDocumentInteractionControllerDelegate, MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    UIActionSheet *actionWatermark;
    
    UIImagePickerController *_backPickerContoller;
}


+(id)sharedSettingViewController;

-(IBAction)actionBack:(id)sender;

-(IBAction)actionRateus:(id)sender;

-(IBAction)actionShareApplication:(id)sender;

-(IBAction)actionRestorePurchase:(id)sender;

-(IBAction)actionCustomWaterMark:(id)sender;


@end
