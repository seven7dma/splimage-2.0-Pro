//
//  TrimVideoViewController.m
//  Splimage
//
//  Created by Girish Rathod on 12/02/13.
//
//

#import "TrimVideoViewController.h"

@interface TrimVideoViewController ()

@end

@implementation TrimVideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTag:(NSInteger)selectedTag
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        videoPath = [SavedData getVideoURLAtIndex:selectedTag];
        selectedIndex = selectedTag;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isReplacable = NO;
    UIScreen *screen = [UIScreen mainScreen];
    CGRect screenFrame = [screen applicationFrame];

    UIImage *imgToolBar = [UIImage imageNamed:@"grayToolBar"];
    toolBarTrimmer = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screenFrame.size.height-imgToolBar.size.height, 320 , imgToolBar.size.height)];
    [toolBarTrimmer setBackgroundImage:imgToolBar forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    [self.view addSubview:toolBarTrimmer];
    
    [self setUpToolBarButton];
    
    UIVideoEditorController *videoEditorControl = [[UIVideoEditorController alloc] init];
    videoEditorControl.delegate = self;
    videoEditorControl.videoMaximumDuration = 30.0;
    videoEditorControl.videoQuality = UIImagePickerControllerQualityTypeHigh;
    videoEditorControl.videoPath = [[videoPath absoluteURL] path];
    [videoEditorControl.navigationController setTitle:@"Hello"];
    [self presentViewController:videoEditorControl animated:YES completion:Nil];
//    [self loadUpPlayer];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpToolBarButton{
    NSMutableArray *arrayBtn = [NSMutableArray arrayWithCapacity:0];
    
    UIBarButtonItem * spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 80;
    
    [arrayBtn addObject:spacer];
    
    
    UIImage * imgCross = [UIImage imageNamed:@"cancel_icon"];
    UIButton * btnCross = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCross setFrame:CGRectMake(150, 8, imgCross.size.width, imgCross.size.height)];
    [btnCross setImage:imgCross forState:UIControlStateNormal];
    [btnCross setTag:INDEX_LEFT];
    [btnCross addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn3 = [[UIBarButtonItem alloc] initWithCustomView:btnCross];
    [arrayBtn addObject:barBtn3];
    
    [arrayBtn addObject:spacer];
    
    UIImage * imgBtnOk = [UIImage imageNamed:@"accept_icon"];
    UIButton * btnBtnOk = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBtnOk setFrame:CGRectMake(CGRectGetMaxX(btnCross.frame), 8, imgBtnOk.size.width, imgBtnOk.size.height)];
    [btnBtnOk setImage:imgBtnOk forState:UIControlStateNormal];
    [btnBtnOk setTag:INDEX_RIGHT];
    [btnBtnOk addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * barBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btnBtnOk];
    [arrayBtn addObject:barBtn2];
    
    [arrayBtn addObject:spacer];
    
    [toolBarTrimmer setItems:arrayBtn animated:YES];
    
}


-(void)tabBarButtonClicked:(UIButton *)sender{
    
//    [self stopPlayer];
    
    switch ([sender tag]) {
        case INDEX_LEFT:
            NSLog(@"Cancel") ;
            if(isReplacable)
                [SavedData removeFileAtPath:[[edittedVideoPath absoluteURL] path]];
            break;
            
        case INDEX_RIGHT:
            NSLog(@"OK") ;
            if(isReplacable)
                [self replaceVideoWithTrimmedVideo];
            break;
            
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - SplimagePlayer methods

-(void)loadUpPlayer{
    
    if (splPlayerView) {
        [splPlayerView stopPlayer];
        [splPlayerView removeFromSuperview];
        splPlayerView=nil;
    }
    splPlayerView = [[SplPlayerView alloc] initWithFrame:CGRectMake(0, 0, VIDEO_VIEW_HEIGHT , VIDEO_VIEW_HEIGHT) andUrl:videoPath andFiltered:FILTER_NONE];
    [splPlayerView setTag:selectedIndex];
    [splPlayerView setDelegate:self];
    [splPlayerView addThumbViewImage];
    [self.view addSubview:splPlayerView];
    
}
-(void)stopPlayer{
    [splPlayerView stopPlayer];
}

-(void)prepareAndPlayThePlayer{
    [self loadUpPlayer];
    [splPlayerView startPlayer];
}
-(void)replaceVideoWithTrimmedVideo{
    
    AVAsset *movie = [AVAsset assetWithURL:videoPath];
    CMTime movieLength = movie.duration;
    
    [SavedData removeFileAtPath:[[[SavedData getVideoURLAtIndex:selectedIndex] absoluteURL] path]];
    for (NSDictionary *items in [SavedData getValueForKey:ARRAY_FRAMES]) {
        if ([[items valueForKey:kTag] integerValue]==selectedIndex) {
            [items setValue:videoPath forKey:kVideoURL];
            [items setValue:[NSNumber numberWithFloat:CMTimeGetSeconds(movieLength)] forKey:kLength];
            break;
        }
    }

}
#pragma mark - UIVideoEditorController Delegate
- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath{
    isReplacable =YES;
    videoPath = [NSURL fileURLWithPath: editedVideoPath];
    edittedVideoPath = [NSURL fileURLWithPath: editedVideoPath];
    [editor dismissViewControllerAnimated:YES completion:nil];
    [self loadUpPlayer];

}//- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error;
- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor{
    isReplacable = NO;
    [editor dismissViewControllerAnimated:YES completion:nil];
    [self loadUpPlayer];
}

-(void) splPlayerDidStopPlaying:(NSInteger)playerIndex {

}

@end
