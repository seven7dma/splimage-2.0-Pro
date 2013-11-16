//
//  PlayBackViewController.h
//  SPLImage
//
//  Created by Girish Rathod on 18/12/12.
//
//

#import <UIKit/UIKit.h>
#import "SPLViewController.h"
#import "CanvasView.h"
#import "EVSwitch.h"
#import "UICustomSwitch.h"
#import "VideoPlaybackView.h"
#import "SplPlayerView.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "GData.h"
#import "GDataEntryYouTubeUpload.h"
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
@interface PlayBackViewController : SPLViewController
                                    <SPLViewControllerDelegate,
                                    SplPlayerViewDelegate,
                                    CanvasViewDelegate,
                                    VideoPlaybackViewProtocol,
                                    UIAlertViewDelegate,
                                    UIActionSheetDelegate,
                                    MFMailComposeViewControllerDelegate,
                                    UINavigationControllerDelegate>
{
    CanvasView *canvasView;
    UICustomSwitch *mySwitch;
    SplPlayerView *splPlayerView;
    UIButton * btnPlay;
    NSURL *combinedVideoUrl;
    int counter;
    int indexSelected;
    UIActionSheet *actionSheetShareVideo;
    NSMutableArray *arraySequence;
    float finalVideoWidth;
    float finalVideoHeight;
    NSArray *patternArray;
    NSString *finalVideoName;
    NSTimer *timer;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTag:(NSInteger)selectedTag andView:(CanvasView *)canvasView;

@end
