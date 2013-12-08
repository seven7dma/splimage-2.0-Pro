//
//  TemplateViewController.h
//  SPLImage
//
//  Created by Girish Rathod on 07/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SPLViewController.h"
#import "PatternLayoutViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import "FaceBookLikeViewController.h"
#import <MessageUI/MessageUI.h>

@interface TemplateViewController : SPLViewController<SPLViewControllerDelegate, FBLoginViewDelegate,UIAlertViewDelegate, UIScrollViewDelegate,MFMessageComposeViewControllerDelegate>{
    UIScrollView *scrollTemplateView;
    UIPageControl *pageControl;
    UIButton *btnSettings;
    UIButton *btnShare;
    PatternLayoutViewController *patternLayoutView;
    __block NSString *twitterAlerMsg;
}
- (void)changePage;
- (void)tabBarButtonClicked:(UIButton *)sender;
- (void)showTwitterAlertMessage:(NSNotification *)notification;
@end
