//
//  TrimVideoViewController.h
//  Splimage
//
//  Created by Girish Rathod on 12/02/13.
//
//

#import <UIKit/UIKit.h>
#import "SplPlayerView.h"
#import "SPLViewController.h"
@interface TrimVideoViewController : SPLViewController<SplPlayerViewDelegate,UIVideoEditorControllerDelegate,UINavigationControllerDelegate>
{
    UIToolbar *toolBarTrimmer;
    SplPlayerView *splPlayerView;
    NSURL *videoPath;
    NSURL *edittedVideoPath;
    NSInteger selectedIndex;
    BOOL isReplacable;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTag:(NSInteger)selectedTag;
@end
