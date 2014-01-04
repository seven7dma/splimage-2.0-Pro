//
//  PatternLayoutViewController.m
//  SPLImage
//
//  Created by Girish Rathod on 12/12/12.
//
//

#import "PatternLayoutViewController.h"

@interface PatternLayoutViewController ()
@property (nonatomic, assign) BOOL atleastOneVideo;
@property (nonatomic, strong) NSArray *saveArrayFramesOnRotation;
@end

@implementation PatternLayoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil  andTag:(NSInteger)selectedTag
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:selectedPattern] forKey:@"selectedPattern"];
        selectedPattern = selectedTag;
        self.delegate = self;
        }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    CGRect frame = [super getScreenFrameForCurrentOrientation];
    [self adjustFrameBeforeView:frame];

}

-(void)viewDidAppear:(BOOL)animated{
 
    [super viewDidAppear:animated];
    CGRect frame = [super getScreenFrameForCurrentOrientation];
    [self adjustFrameAfterView:frame];
}

- (void)viewWillDisappear:(BOOL)animated{
//    [canvasView saveVideoScrollDimensionData];
    [super viewWillDisappear:animated];
}

-(void)loadUpCanvasView{
    
    for (NSDictionary * objects in [SavedData getValueForKey:ARRAY_FRAMES]) {
        if ([SavedData isVideoAvalableAtSelectedPosition:[[objects valueForKey:kTag] integerValue]]) {
            [canvasView loadSelectedVideosOnView:[[objects valueForKey:kTag] integerValue]];
        }
    }
    [canvasView shouldAddAllTheGesture:YES];
    [canvasView displayAllSoundButtons:NO];
    [canvasView shouldDisplayAllSequenceViews:NO];
    [canvasView setDelegate:self];
   
    [self checkPlayButtonSatus];
    
}

- (void)viewDidLoad
{
    useSuperButtons = YES;
    [super viewDidLoad];
    CGRect frame = [super getScreenFrameForCurrentOrientation];
    self.atleastOneVideo = NO;
    selectedVideo = 999;
    UIImage *changePattern = [UIImage imageNamed:@"topbar_change"];
    [btnLeftNav setFrame:CGRectMake(9, 8, changePattern.size.width, changePattern.size.height)];
    [btnLeftNav setBackgroundImage:changePattern forState:UIControlStateNormal];
    //[btnLeftNav setImage:changePattern forState:UIControlStateNormal];

    [SavedData setValue:[self getPatternArrayForPattern:selectedPattern] forKey:ARRAY_PATTERN];

    UIImage *imgCanvas = [UIImage imageNamed:@"Canvas"];
    
    canvasView =[[CanvasView alloc] initWithFrame:CGRectMake(5, 80, self.navigationController.navigationBar.frame.size.width-10, frame.size.height - 200) andPattern:[SavedData getValueForKey:ARRAY_PATTERN] andBGImage:imgCanvas];
    canvasView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [canvasView shouldAddAllTheGesture:YES];
    [canvasView setDelegate:self];
    canvasView.autoresizesSubviews = YES;
    
    actionSheetLoadVideos = [[UIActionSheet alloc] initWithTitle:@"Choose Video Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Record Video",@"Choose from Gallery", nil];
    [self setUpToolBarButton];

    imagePickerController=[[UIImagePickerController alloc] init];
    [imagePickerController setDelegate:self];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - User Functions

-(void)setUpToolBarButton{
    NSMutableArray *arrayBtn = [NSMutableArray arrayWithCapacity:0];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    CGRect frame = [super getScreenFrameForCurrentOrientation];
    spacer.width = frame.size.width/3;
    
 //   [arrayBtn addObject:spacer];
    
  //  UIImage *imgCommints = [UIImage imageNamed:@"commint"];
  //  UIImageView *imageViewCommints = [[UIImageView alloc] initWithImage:imgCommints];
  //  [imageViewCommints setFrame:CGRectMake(100, 5, imgCommints.size.width, imgCommints.size.height)];
    
  //  UIBarButtonItem *barBtn1 = [[UIBarButtonItem alloc] initWithCustomView:imageViewCommints];
  //  [arrayBtn addObject:barBtn1];
    
  //  [arrayBtn addObject:spacer];
    
    UIImage *imgBtn = [UIImage imageNamed:@"fx"];
    UIButton * btnFx = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFx setFrame:CGRectMake(25, 5, imgBtn.size.width, imgBtn.size.height)];
    [btnFx setImage:imgBtn forState:UIControlStateNormal];
    [btnFx setTag:INDEX_LEFT];
    [btnFx addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btnFx];
    [arrayBtn addObject:barBtn2];
    
    [arrayBtn addObject:spacer];

    UIImage *imgPlay = [UIImage imageNamed:@"footer_Play"];
    UIImage *imgPlayGreen = [UIImage imageNamed:@"footer_Play_Green"];
    btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPlay setFrame:CGRectMake(CGRectGetMaxX(btnFx.frame), 5, imgPlay.size.width, imgPlay.size.height)];
    [btnPlay setEnabled:NO];
    [btnPlay setImage:imgPlayGreen forState:UIControlStateNormal];
    [btnPlay setImage:imgPlay forState:UIControlStateDisabled];
    [btnPlay setTag:INDEX_LEFT_NEXT];
    [btnPlay addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barBtn3 = [[UIBarButtonItem alloc] initWithCustomView:btnPlay];
    [barBtn3 setEnabled:NO];
    [arrayBtn addObject:barBtn3];
    
    [arrayBtn addObject:spacer];
 
    
    UIImage *imgCut = [UIImage imageNamed:@"Cut"];
    UIButton * btnCut = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCut setFrame:CGRectMake(25, 5, imgCut.size.width, imgCut.size.height)];
    [btnCut setImage:imgCut forState:UIControlStateNormal];
    [btnCut setTag:INDEX_RIGHT_PREVIOUS];
    [btnCut addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn4 = [[UIBarButtonItem alloc] initWithCustomView:btnCut];
    [arrayBtn addObject:barBtn4];
    
    [arrayBtn addObject:spacer];
    
    UIImage *imgShare = [UIImage imageNamed:@"share_icon"];

    UIButton * btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShare setFrame:CGRectMake(280, 5, imgShare.size.width, imgShare.size.height)];
    [btnShare setImage:imgShare forState:UIControlStateNormal];
    [btnShare setTag:INDEX_RIGHT];
    [btnShare setHidden:YES];
    [btnShare addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn5 = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
    [arrayBtn addObject:barBtn5];
    
    [arrayBtn addObject:spacer];
    
    [toolBar setItems:arrayBtn animated:YES];
    
}

-(void)navBarButtonClicked:(UIButton *)sender{
    [canvasView stopPlayer];//    [canvasView stopPlayingAllPlayers];
    NSLog (@"selected video: %ld", (long)selectedVideo);
    if (self.atleastOneVideo) {
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Warning!" message:@"Clear all videos and close?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, close", nil];
        [alertView show];
    }else {
        [canvasView setDelegate:Nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)tabBarButtonClicked:(UIButton *)sender{
    
    [canvasView stopPlayer];
    pushThisController = nil;
    switch ([sender tag]) {
        case INDEX_LEFT:{
            NSLog(@"Fx") ;
            if (selectedVideo==999) break;
            if ([SavedData isVideoAvalableAtSelectedPosition:selectedVideo]){
                effectsViewController  = [[EffectsViewController alloc] initWithNibName:@"FiltersViewController" bundle:nil andTag:selectedVideo];
                [self.navigationController pushViewController:effectsViewController animated:YES];
            }
            break;
        }
        case INDEX_LEFT_NEXT:
            NSLog(@"Play") ;
            pushThisController = [[PlayBackViewController alloc] initWithNibName:@"PlayBackViewController" bundle:nil andTag:selectedPattern andView:canvasView];
            break;

        case INDEX_RIGHT_PREVIOUS:
            NSLog(@"Cut") ;
            if (selectedVideo==999) break;
            if ([SavedData isVideoAvalableAtSelectedPosition:selectedVideo]){
                [self trimVideoMethod];
            }
            break;

        case INDEX_RIGHT:
            NSLog(@"Share") ;
            break;

        default:
            break;
    }
    
    if(pushThisController != nil)
        [self.navigationController pushViewController:pushThisController animated:YES];

}


#pragma mark -UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            NSLog(@"Cancel");
            break;
            
        case 1:
            [canvasView setDelegate:Nil];
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}


#pragma mark - CanvasViewDelegate

-(void)addVideoButtondClicked:(UIButton *)selectedBtn{
    NSLog(@"addVideoButtondClicked --- %d",[selectedBtn tag]);
    selectedVideo = [selectedBtn tag];
    [actionSheetLoadVideos showInView:self.view];
  }

-(void)viewSelected:(NSInteger)selectedView{
    selectedVideo = selectedView;
}

-(void)videoPositionsChanged{
    [self loadUpCanvasView];
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    switch (buttonIndex) {
        case 0:
            NSLog(@"Record Video");
            [self loadMediaByRecordingFromCamera];
            break;
            
        case 1:
        {
            NSLog(@"Choose from Gallery");
            [self loadMediaFromLibrary];
            break;
        }
        default:
            break;
    }
}


#pragma Mark - Load Media Methods
-(void)loadMediaByRecordingFromCamera{

    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
        
        imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeMovie, nil];
        [imagePickerController setVideoQuality:UIImagePickerControllerQualityType640x480];//UIImagePickerControllerQualityType640x480 //UIImagePickerControllerQualityTypeLow
        [imagePickerController setVideoMaximumDuration:VIDEO_MAX_DURATION];
        [imagePickerController setShowsCameraControls:YES];
        imagePickerController.allowsEditing = NO;
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }else
       NSLog(@"Device Not available");
}
-(void)loadMediaFromLibrary{
    
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary & UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    imagePickerController.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeMovie, nil];
    [imagePickerController setVideoQuality:UIImagePickerControllerQualityType640x480
     ]; //UIImagePickerControllerQualityType640x480 //UIImagePickerControllerQualityTypeLow
    [imagePickerController setVideoMaximumDuration:VIDEO_MAX_DURATION];
    imagePickerController.allowsEditing = YES;

    [self presentViewController:imagePickerController animated:YES completion:nil];
}

-(void)addMediaTotheView:(NSURL *)videoUrl{
    
//    [canvasView loadSelectedVideosOnView:selectedVideo];

    [self checkPlayButtonSatus];
}

-(void)checkPlayButtonSatus{
    [btnPlay setEnabled:[canvasView checkAllButtons]];
    
 
}

#pragma Mark - Image Picker Controller Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [SavedData removePreviousDataAtIndex:selectedVideo];
    
    [[[SavedData getValueForKey:ARRAY_FRAMES] objectAtIndex:selectedVideo] setValue:[info objectForKey:UIImagePickerControllerMediaURL] forKey:kVideoURL];
   
    AVAsset *movie = [AVAsset assetWithURL:[info objectForKey:UIImagePickerControllerMediaURL]];
    CMTime movieLength = movie.duration;
    
    [[[SavedData getValueForKey:ARRAY_FRAMES] objectAtIndex:selectedVideo] setValue:[NSNumber numberWithFloat:CMTimeGetSeconds(movieLength)] forKey:kLength];

    //save the video in library

    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
        if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
            NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self,
                                                    @selector(video:didFinishSavingWithError:contextInfo:), nil);
            } 
        }
    }
    [self addMediaTotheView:[[[SavedData getValueForKey:ARRAY_FRAMES] objectAtIndex:selectedVideo] valueForKey:kVideoURL]];
    self.atleastOneVideo = YES;
}

-(void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Trim Video Operations

-(void)trimVideoMethod{
    videoPath = [SavedData getVideoURLAtIndex:selectedVideo];
    UIVideoEditorController *videoEditorControl = [[UIVideoEditorController alloc] init];
    videoEditorControl.delegate = self;
    videoEditorControl.videoMaximumDuration = VIDEO_MAX_DURATION;
    videoEditorControl.videoQuality = UIImagePickerControllerQualityTypeHigh;
    videoEditorControl.videoPath = [[videoPath absoluteURL] path];
    //    [videoEditorControl.navigationController setTitle:@"Hello"];
    [self presentViewController:videoEditorControl animated:YES completion:nil];
}

-(void)replaceVideoWithTrimmedVideo{
    
    AVAsset *movie = [AVAsset assetWithURL:videoPath];
    CMTime movieLength = movie.duration;
    
    [SavedData removeFileAtPath:[[[SavedData getVideoURLAtIndex:selectedVideo] absoluteURL] path]];
    for (NSDictionary *items in [SavedData getValueForKey:ARRAY_FRAMES]) {
        if ([[items valueForKey:kTag] integerValue]==selectedVideo) {
            [items setValue:videoPath forKey:kVideoURL];
            [items setValue:[NSNumber numberWithFloat:CMTimeGetSeconds(movieLength)] forKey:kLength];
            break;
        }
    }
}


#pragma mark - UIVideoEditorController Delegate
- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath{
    videoPath = [NSURL fileURLWithPath: editedVideoPath];
    [editor dismissViewControllerAnimated:YES completion:nil];
    [self replaceVideoWithTrimmedVideo];
    
}//- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error;

- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor{
    [editor dismissViewControllerAnimated:YES completion:nil];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    CGRect frame = [super getScreenFrameForOrientation:toInterfaceOrientation];
    [self adjustFrameBeforeView:frame];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{

    UIInterfaceOrientation orientation;
    if ( (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) )
        orientation = UIInterfaceOrientationPortrait;
    else
        orientation = UIInterfaceOrientationLandscapeLeft;
    
    CGRect frame = [super getScreenFrameForOrientation:orientation];
    [self adjustFrameAfterView:frame];
    
}

-(void)adjustFrameBeforeView:(CGRect) frame{
    
    [self layoutTopViewForInterfaceFrame:frame];
    
    [canvasView removeFromSuperview];
    canvasView = nil;
    toolBar.items = [NSArray new];
    
}

-(void)adjustFrameAfterView:(CGRect) frame{
    
    [self  saveSelectedVideoInfo];
    UIImage *imgCanvas = [UIImage imageNamed:@"Canvas"];

    canvasView =[[CanvasView alloc] initWithFrame:CGRectMake(5, 80, self.navigationController.navigationBar.frame.size.width-10, frame.size.height - 200) andPattern:[SavedData getValueForKey:ARRAY_PATTERN] andBGImage:imgCanvas];

    [self loadBackSavedVideoInfoAfterRotation];

    [canvasView shouldAddAllTheGesture:YES];
    [canvasView setDelegate:self];
    [self loadUpCanvasView];
    [self.view addSubview:canvasView];
    BOOL isPlayButtonEnabled = btnPlay.isEnabled;
    [self setUpToolBarButton];
    [btnPlay setEnabled:isPlayButtonEnabled];

}

// saving video content info on rotation so it can be restored back.
-(void) saveSelectedVideoInfo {

    self.saveArrayFramesOnRotation = [NSArray arrayWithArray:[SavedData getValueForKey:ARRAY_FRAMES]];
}


// load back video content info on rotation as canvas view has been initialized.
-(void) loadBackSavedVideoInfoAfterRotation {
    
    for (NSDictionary * objects in [SavedData getValueForKey:ARRAY_FRAMES]) {
        
        for (NSDictionary *savedObjects in self.saveArrayFramesOnRotation) {
        
            if ([[objects valueForKey:kTag] integerValue]  == [[savedObjects valueForKey:kTag] integerValue])
            {
                [objects setValue:savedObjects[kVideoURL] forKey:kVideoURL];
                [objects setValue:savedObjects[kReverseVideoURL] forKey:kReverseVideoURL];
                [objects setValue:savedObjects[kFilter] forKey:kFilter];
                [objects setValue:savedObjects[kLength] forKey:kLength];
                [objects setValue:savedObjects[kIsReverse] forKey:kIsReverse];
                [objects setValue:savedObjects[kIsMute] forKey:kIsMute];
                [objects setValue:savedObjects[kWidth] forKey:kWidth];
                [objects setValue:savedObjects[kHeight] forKey:kHeight];
                [objects setValue:savedObjects[kZoomScale] forKey:kZoomScale];
                [objects setValue:savedObjects[kShouldRevert] forKey:kShouldRevert];
                [objects setValue:savedObjects[kContentOffset] forKey:kContentOffset];
                [objects setValue:savedObjects[kShouldRevert] forKey:kShouldRevert];
                [objects setValue:savedObjects[kVideoURL] forKey:kVideoURL];
            
            }
        }
    }
    //[SavedData setValue:self.saveArrayFramesOnRotation forKey:ARRAY_FRAMES];

}

@end
