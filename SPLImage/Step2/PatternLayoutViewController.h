//
//  PatternLayoutViewController.h
//  SPLImage
//
//  Created by Girish Rathod on 12/12/12.
//
//

#import "SPLViewController.h"
#import "CanvasView.h"
#import "PlayBackViewController.h"
#import "TrimVideoViewController.h"
#import "FiltersViewController.h"

@interface PatternLayoutViewController : SPLViewController<SPLViewControllerDelegate, CanvasViewDelegate,UIActionSheetDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate, UIVideoEditorControllerDelegate>{
    NSInteger selectedPattern;
    CanvasView *canvasView;
    UIActionSheet *actionSheetLoadVideos;
    NSInteger selectedVideo;
    NSMutableArray *arrayVideoUrls;
    UIImagePickerController *imagePickerController;
    UIButton * btnPlay;
    FiltersViewController *filtersViewController;
    TrimVideoViewController *trimVideoViewController;
    UIViewController *pushThisController;
    NSURL * videoPath;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTag:(NSInteger)selectedTag;

@end
