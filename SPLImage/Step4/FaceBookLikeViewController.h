//
//  FaceBookLikeViewController.h
//  SPLImage
//
//  Created by Girish Rathod on 20/12/12.
//
//

#import <UIKit/UIKit.h>
#import "SPLViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
@interface FaceBookLikeViewController : SPLViewController<SPLViewControllerDelegate, UIWebViewDelegate, FBLoginViewDelegate>{
    UIWebView *webView;

}

@end
