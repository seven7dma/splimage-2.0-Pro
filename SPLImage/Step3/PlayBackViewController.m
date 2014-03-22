//
//  PlayBackViewController.m
//  SPLImage
//
//  Created by Girish Rathod on 18/12/12.
//
//

#import "PlayBackViewController.h"

@interface PlayBackViewController () {
    
    BOOL videoMergeCompleted;
}
@end

#define VIDEO_TITLE @"My Latest Video prepared by Splimage"
#define VIDEO_DESCRIPTION @"Description : My Latest Video prepared by Splimage"

@implementation PlayBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTag:(NSInteger)selectedTag andView:(CanvasView *)_canvasView
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delegate = self;
        canvasView = _canvasView;
        [canvasView setDelegate:self];
        indexSelected = selectedTag;
        [self.view addSubview:canvasView];
        if (indexSelected==8) {
            NSNumber *temp = [arraySequence objectAtIndex:0];
            [arraySequence replaceObjectAtIndex:0 withObject:[arraySequence objectAtIndex:1]];
            [arraySequence replaceObjectAtIndex:1 withObject:temp];
        }
        if (indexSelected==9) {
            NSNumber *temp = [arraySequence objectAtIndex:0];
            [arraySequence replaceObjectAtIndex:0 withObject:[arraySequence objectAtIndex:1]];
            [arraySequence replaceObjectAtIndex:1 withObject:temp];
        }
        if (indexSelected==10) {
            NSNumber *temp = [arraySequence objectAtIndex:0];
            [arraySequence replaceObjectAtIndex:0 withObject:[arraySequence objectAtIndex:1]];
            [arraySequence replaceObjectAtIndex:1 withObject:temp];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    useSuperButtons = YES;
    [super viewDidLoad];
    //UIImage *backImage = [UIImage imageNamed:@"btn_back"];
    //[btnLeftNav setImage:backImage forState:UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *back = [UIImage imageNamed:@"btn_back"];
    [btnLeftNav setFrame:CGRectMake(9, 5, back.size.width, back.size.height)];
    [btnLeftNav setBackgroundImage:back forState:UIControlStateNormal];
    
    UIImage *goPro = [UIImage imageNamed:@"tabbar_pro"];
    [btnRightNav setFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width - goPro.size.width - 5, 5, goPro.size.width, goPro.size.height)];
    [btnRightNav setBackgroundImage:goPro forState:UIControlStateNormal];
    
    [self loadUpCanvasView];
    [self setUpToolBarButton];
    [canvasView disableTheGreenBorders];
    
    arraySequence = [NSMutableArray array];
    for (int i =0; i<4; i++)
        [arraySequence addObject:[NSNumber numberWithInt:i]];
    videoMergeCompleted = NO;
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
//    [FlurryAds fetchAndDisplayAdForSpace:@"BANNER_MAIN_VIEW" view:self.adView size:BANNER_BOTTOM];
}

#pragma mark-

-(void)loadUpCanvasView{
    
    for (NSDictionary * objects in [SavedData getValueForKey:ARRAY_FRAMES]) {
        [canvasView loadSelectedVideosOnView:[[objects valueForKey:kTag] integerValue]];
    }
    [canvasView shouldAddAllTheGesture:NO];
    [canvasView displayAllSoundButtons:YES];
    [canvasView hideVideoAddBtns];
   // [self setUpAudioButton];
}

#pragma mark- canvasViewDelegate

-(void)sequenceChangedFrom:(NSInteger)seq1 to:(NSInteger)seq2{
    NSNumber *temp = [arraySequence objectAtIndex:seq1];
    [arraySequence replaceObjectAtIndex:seq1 withObject:[arraySequence objectAtIndex:seq2]];
    [arraySequence replaceObjectAtIndex:seq2 withObject:temp];
//    NSLog([arraySequence description]);
}


#pragma mark- SplPlayerViewDelegate
-(void)splPlayerDidStopPlaying:(NSInteger)playerIndex{
  //  [self showAlertWithMessage:@"Save Video" andTitle:@"" cancelButtonTitle:@"Save" otherButtonTitles:@"Delete" andTag:SAVE_DELETE];
}

#pragma mark-
-(void)loadUpAndPlayVideo{
    
    CGRect screenFrame = [super getScreenFrameForCurrentOrientation];
    
    splPlayerView = [[SplPlayerView alloc] initWithFrame:CGRectMake(5, 64, screenFrame.size.width - 10 , screenFrame.size.height - 150) andUrl:combinedVideoUrl andFiltered:FILTER_NONE];
    
    [splPlayerView setTag:indexSelected];
    [splPlayerView setDelegate:self];
    [splPlayerView loadUpPlayer];
    [self.view addSubview:splPlayerView];
    
}

-(void)setUpToolBarButton{
    
    NSMutableArray *arrayBtn = [NSMutableArray arrayWithCapacity:0];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 10;
    
    [arrayBtn addObject:spacer];
    
    mySwitch = [UICustomSwitch switchWithLeftText:@"Play all at once" andRight:@"Choose Playback Order"];
    [mySwitch setFrame:CGRectMake(5, 5, 225, 25)];
    [mySwitch.rightLabel setText:@"Playback Order"];
    [mySwitch setTag:INDEX_LEFT];
    [mySwitch addTarget:self action:@selector(checkOnOffState:) forControlEvents:UIControlEventValueChanged];
    [mySwitch setOn:NO animated:YES];
    [mySwitch setEnabled:YES];
    UIBarButtonItem *barBtn1 = [[UIBarButtonItem alloc] initWithCustomView:mySwitch];
    [arrayBtn addObject:barBtn1];

    
    [arrayBtn addObject:spacer];

    UIImage *imgPlay = [UIImage imageNamed:@"footer_Play"];
    UIImage *imgPlayGreen = [UIImage imageNamed:@"footer_Play_Green"];

    btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPlay setFrame:CGRectMake(CGRectGetMaxX(mySwitch.frame), 5, imgPlay.size.width + 10, imgPlay.size.height + 5)];
    [btnPlay setImage:imgPlay forState:UIControlStateNormal];
    [btnPlay setImage:imgPlayGreen forState:UIControlStateSelected];
    [btnPlay setTag:INDEX_RIGHT];
    [btnPlay setEnabled:YES];
    [btnPlay addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btnPlay];
    [arrayBtn addObject:barBtn2];
    
    [arrayBtn addObject:spacer];
    
    [toolBar setItems:arrayBtn animated:YES];
    
}

-(void)reSetUpToolBarButton{
    
    UIImage *done = [UIImage imageNamed:@"btn_done"];
    [btnLeftNav setFrame:CGRectMake(9, 5, done.size.width, done.size.height)];
    [btnLeftNav setBackgroundImage:done forState:UIControlStateNormal];
    
    UIImage *goPro = [UIImage imageNamed:@"tabbar_pro"];
    [btnRightNav setFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width - goPro.size.width - 5, 5, goPro.size.width, goPro.size.height)];
    [btnRightNav setImage:goPro forState:UIControlStateNormal];
    
    CGRect screenFrame = [super getScreenFrameForCurrentOrientation];

    NSMutableArray *arrayBtn = [NSMutableArray arrayWithCapacity:0];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];// UIBarButtonSystemItemFixedSpace
    spacer.width = 300;
    
//    [arrayBtn addObject:spacer];
   
//    UIImage *homeImage = [UIImage imageNamed:@"home_icon"];
//    UIButton *btnHome = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnHome setFrame:CGRectMake(5,5,homeImage.size.width,homeImage.size.height)];
//    [btnHome setImage:homeImage forState:UIControlStateNormal];
//    [btnHome setTag:INDEX_LEFT_NEXT];
 //   [btnHome setEnabled:YES];
 //   [btnHome addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

//    UIBarButtonItem *barBtn1 = [[UIBarButtonItem alloc] initWithCustomView:btnHome];
//    [arrayBtn addObject:barBtn1];
    
    [arrayBtn addObject:spacer];
    
    UIImage *shareImage = [UIImage imageNamed:@"icon_share"];
    
    UIButton *btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShare setFrame:CGRectMake(screenFrame.size.width - (shareImage.size.width+9), 10, shareImage.size.width, shareImage.size.height)];
    [btnShare setImage:shareImage forState:UIControlStateNormal];
    [btnShare setTag:INDEX_RIGHT_PREVIOUS];
    [btnShare setEnabled:YES];
    [btnShare addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btnShare];
    [arrayBtn addObject:barBtn2];
    
//    [arrayBtn addObject:spacer];
    
    [toolBar setItems:arrayBtn animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBarButtonClicked:(UIButton *)sender{
    [canvasView stopPlayer];
    switch ([sender tag]) {
        case INDEX_LEFT:
            NSLog(@"switch");
            break;
        case INDEX_RIGHT:{
            if ([sender isSelected]){
                NSLog(@"Play selected");
            }
            else{
                NSLog(@"Play");
                [self showFullScreenAd];  // display interstatial add
            }
            break;
        }
        case INDEX_LEFT_NEXT:
        //home button
            [self homeButtonPressed];
            break;
            
        case INDEX_RIGHT_PREVIOUS:
            //share button
            [self shareVideoOptions];
            break;
            
        default:
            break;
    }
}

-(void)navBarButtonClicked:(UIButton *)sender{
    [canvasView stopPlayer];
    switch ([sender tag]) {
        case INDEX_LEFT:
            NSLog(@"done");
            if (splPlayerView) {
                [splPlayerView stopPlayer];
            }
            
            if (splPlayerView) {
                [splPlayerView removeFromSuperview];
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
            break;
            
        case INDEX_RIGHT:
            NSLog(@"goPro");
            
//            [self shareVideoOptions];
            goProViewController = [[GoProViewController alloc] initWithNibName:@"GoProViewController" bundle:nil];
            self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:goProViewController animated:YES completion:nil];
            break;

        default:
            break;
    }
}

-(void)checkOnOffState:(id)sender{
    [canvasView disableAllSoundButtons:mySwitch.on];
    [canvasView shouldAddSwipeGestureRecognizers:mySwitch.on];
    switch (mySwitch.on) {
        case TRUE:
            NSLog(@"switchOn");
            break;
            
        case FALSE:
            NSLog(@"switchOFF");
          //  [self setUpAudioButton];
            break;
            

        default:
            break;
    }
}

-(void)setUpAudioButton{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTag:0];
    btn.selected = YES;
    [canvasView setTheSelectedSounds:btn];
}

#pragma mark -UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch ([alertView tag]) {
        case SAVE_DELETE:
            //save ok cancel
            [self saveDeleteAlert:buttonIndex];
            break;
            
        case OK_CANCEL:
            //home
            [self homeButtonAlert:buttonIndex];
            break;

        case SUCCESS_FAIL:
            //
            break;

        case START_STOP:
            [self startStopAlert:buttonIndex];
            break;

        case LOGIN_ALERT:
             [self uploadToYoutube:[[alertView textFieldAtIndex:0] text]
                       andPassword:[[alertView textFieldAtIndex:1] text]
                         withVideo:[NSData dataWithContentsOfURL:combinedVideoUrl]];
            break;
        default:
            break;
    }
    
}


-(void)homeButtonAlert:(NSInteger)btnIndex{
    switch (btnIndex) {
        case 0:
            NSLog(@"Cancel");
            break;
            
        case 1:{
            NSLog(@"Eject");
            [canvasView setDelegate:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

-(void)saveDeleteAlert:(NSInteger)btnIndex{
    switch (btnIndex) {
        case 0:
            NSLog(@"Save");
//            [self shareVideoOptions];
            break;
            
        case 1:{
            NSLog(@"Delete");
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
    
}


-(void)startStopAlert:(NSInteger)btnIndex{
    switch (btnIndex) {
        case 0:
            NSLog(@"Cancel");
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case 1:{
            //call out OutPutMovie
            [self startProcessingOutput];
        }
            break;
            
        default:
            break;
    }

}

#pragma mark -
-(void)showAlertWithMessage:(NSString *)aMessage andTitle:(NSString *)title cancelButtonTitle:(NSString *)cTitle otherButtonTitles:(NSString *)oTitle andTag:(MY_ALERT_TYPES)alertTag{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:aMessage
                                                   delegate:self cancelButtonTitle:cTitle otherButtonTitles:oTitle, nil];
    [alert setTag:alertTag];
    [alert show];
    
}


#pragma mark -
-(void)homeButtonPressed{
    [self showAlertWithMessage:@"Clear all videos and close?" andTitle:@"Warning!" cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, close" andTag:OK_CANCEL];
}
#pragma mark -

-(void)shareVideoOptions{
    actionSheetShareVideo = [[UIActionSheet alloc] initWithTitle:@"Choose Video Shareing Option" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook",@"YouTube",@"Email", nil];
    [actionSheetShareVideo setBackgroundColor:[UIColor lightGrayColor]];
    [actionSheetShareVideo showInView:self.view];
}
#pragma mark -

-(void)startProcessingOutput{
    counter=0;
    [canvasView removeFromSuperview];
    [self showActivity];
    [self getTheOutPutFrameSize];

    if (mySwitch.on) {
        //sequential
        [self prepareSequentialVideo];
    }else{
        //parallel : all at once
        [self prepareParallelVideo];
    }
    
}

-(void)prepareSequentialVideo{
    //saveddata
    [self getSetReloadWriter];
 }

-(void)prepareParallelVideo{
    [self getSetReloadWriter];
}

-(void)getSetReloadWriter{
    NSLog(@"saved data array frames count: %d",[[SavedData getValueForKey:ARRAY_FRAMES] count]);
    if (counter<[[SavedData getValueForKey:ARRAY_FRAMES] count]) {
        [self performSelectorInBackground:@selector(myMixedTask) withObject:Nil];
        CGRect frame = [SavedData getFramesAtIndex:counter];
        VideoPlaybackView * playbackView = [[VideoPlaybackView alloc] initWithFrame:frame];
        playbackView.delegate = self;
        playbackView.tag = counter;
        
        CGSize videoFrameSize = CGSizeMake(finalVideoWidth * [[[patternArray objectAtIndex:counter] valueForKey:WIDTH] floatValue], finalVideoHeight*[[[patternArray objectAtIndex:counter] valueForKey:HEIGHT] floatValue]);
        
        MY_FILTERS selectedFilter =[[[[SavedData getValueForKey:ARRAY_FRAMES] objectAtIndex:counter] objectForKey:kFilter] intValue];
        
        NSURL * fileUrl = [[[SavedData getValueForKey:ARRAY_FRAMES] objectAtIndex:counter] objectForKey:kVideoURL];
        
        CGRect myContent =[self getMyContentRectFromUrl:counter]; // [SavedData getCropContentAtIndex:counter]; //
        
        NSLog(@"videoFrameSize --- %@",NSStringFromCGSize(videoFrameSize));
        NSLog(@"myContent --- %@",NSStringFromCGRect(myContent));
       
        [playbackView loadVideoWithName:fileUrl
                              andFilter:selectedFilter
                                andSize:videoFrameSize
                             andContent:myContent];
        
        playbackView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        
        [playbackView startRecording];
        
        
    }else{
        //movie completed
        [self performSelectorInBackground:@selector(progressTimer) withObject:Nil];
        [self mergeVideos:[self prepareVideoCompositionArray]];
    }

}

-(NSMutableArray *)prepareVideoCompositionArray{
    NSMutableArray * arrayVideoComposition = [NSMutableArray array];

    for (int i = 0; i <counter; i++) {
        NSMutableDictionary* dictionaryVideoCompostion = [[NSMutableDictionary alloc] init];
        
        NSURL * url = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Movie%d.m4v",i]]];
        
        [dictionaryVideoCompostion setObject:url forKey:kVideoURL];
        [dictionaryVideoCompostion setObject:[NSNumber numberWithBool:[SavedData getIsTrackMuteAtIndex:i]] forKey:kIsMute];
        
       // if ([SavedData getFilterAtIndex:i]==FILTER_2X) {
       //     [dictionaryVideoCompostion setObject:[NSNumber numberWithBool:YES] forKey:kIsFast];
       // }else
        [dictionaryVideoCompostion setObject:[NSNumber numberWithBool:NO] forKey:kIsFast];

        if (mySwitch.on) {
            [dictionaryVideoCompostion setObject:[NSNumber numberWithBool:NO] forKey:kIsMute];
            
        }
        [arrayVideoComposition addObject:dictionaryVideoCompostion];
    }
    return arrayVideoComposition;
}

-(void)mergeVideos:(NSArray *)videoCompositonArray

{
    AVMutableComposition * mixComposition = [[AVMutableComposition alloc] init];
    
    AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    
    NSMutableArray * instructionsArray = [NSMutableArray array];
    
    CMTime calculateTime = kCMTimeZero;
    CMTime tinyTime =CMTimeMake(1, 100);
    
//    CGFloat finalVideoWidthExact = 0.0 , finalVideoHeightExact = 0.0;
    
    for (int i = 0; i < [videoCompositonArray count]; i++) {
        
        
        NSInteger index = 0;
        for (NSNumber *N in arraySequence) {
            if (i == [N intValue]) {
                index = [arraySequence indexOfObject:N];
            }
        }
        
        NSURL *url = [[videoCompositonArray objectAtIndex:index] valueForKey:kVideoURL];
        
        AVURLAsset * videoAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
        
        AVMutableCompositionTrack * videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        //        NSLog(NSStringFromCGSize([videoTrack naturalSize]));
        
        //        AVAsset *vAsset = [AVAsset assetWithURL:url];
        //        AVAssetTrack *vTrack =  [[vAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        //        finalVideoWidthExact = finalVideoWidthExact+[vTrack naturalSize].width;
        //        finalVideoHeightExact = finalVideoHeightExact+[vTrack naturalSize].height;
        //
        //
        
        BOOL isNotMute = ![[[videoCompositonArray objectAtIndex:index] valueForKey:kIsMute] boolValue];
        
        CMTime startTime ;
        if (mySwitch.on) {
            startTime = calculateTime;
        }else{
            startTime = kCMTimeZero;
        }
        
        
        CMTime videoAssetDuration = videoAsset.duration;
        
        BOOL isFast = [[[videoCompositonArray objectAtIndex:index] valueForKey:kIsFast] boolValue];
        
        
        if(isFast)
            videoAssetDuration = CMTimeMultiplyByFloat64(videoAsset.duration, 0.5);
        
        
        
        calculateTime = CMTimeAdd(calculateTime, videoAssetDuration);
        
        //        if (indexSelected==9) {
        //            if (i==1) {
        //               CMTime videoAssetDuration1 = CMTimeMultiplyByFloat64(videoAsset.duration, 0.5);
        //                [videoTrack insertTimeRange:CMTimeRangeMake(videoAssetDuration1, videoAssetDuration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:startTime error:nil];
        //
        //            }
        //            else
        //            {
        //                [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetDuration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:startTime error:nil];
        //            }
        //        }
        //        else
        //        {
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAssetDuration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:startTime error:nil];
        //       }
        
        if (isNotMute) {
            //If Audiotrack not available then it might crash here ***
            //  AVMutableCompositionTrack *AudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            //  BOOL success=  [AudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:&error];
            
            AVMutableCompositionTrack * audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            NSLog(@"audio track : %@",audioTrack);
            //NSError *abc = [[NSError alloc] init];
            // sandeep- there is need to check is audio track is availble or not
            if ([[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]) {
                BOOL abc = [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:startTime error:nil];
                NSLog(@"return: %d",abc);
            }
            
        }
        
        AVMutableVideoCompositionLayerInstruction *videoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        if (mySwitch.on) {
            MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, calculateTime);
        }else{
            if(i == 0)
            {
                MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
            }else
                if ( CMTimeRangeContainsTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), MainInstruction.timeRange) ) {
                    MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
                }
            
        }
        
        CGAffineTransform transform = [self getTransformationForTag:index];
        
        [videoLayerInstruction setTransform:transform atTime:kCMTimeZero];
        
        NSLog(@"Transform : %@",NSStringFromCGAffineTransform(transform));
        
        [instructionsArray addObject:videoLayerInstruction];
        //        [instructionsArray addObject:audioLayerInstruction];
        
        //        CGAffineTransform transform = CGAffineTransformMakeTranslation(100 * -i, 100 * -i);
        
    }
    
    if (mySwitch.on)
        for (int i = 0; i < [videoCompositonArray count]; i++) {
            
            NSInteger index = 0;
            for (NSNumber *N in arraySequence) {
                if (i == [N intValue]) {
                    index = [arraySequence indexOfObject:N];
                }
            }
            
            NSURL * url = [[videoCompositonArray objectAtIndex:index] valueForKey:kVideoURL];
            AVURLAsset * videoAsset = [[AVURLAsset alloc] initWithURL:url options:nil];
            AVMutableCompositionTrack * videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            
            calculateTime = CMTimeAdd(calculateTime, tinyTime);
            
            
            [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, tinyTime) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
            
            AVMutableVideoCompositionLayerInstruction *videoLayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
            
            CGAffineTransform transform = [self getTransformationForTag:index];
            
            [videoLayerInstruction setTransform:transform atTime:kCMTimeZero];
            
            NSLog(@"Transform : %@",NSStringFromCGAffineTransform(transform));
            
            [instructionsArray addObject:videoLayerInstruction];
            
        }
    
    patternArray =nil;
    MainInstruction.layerInstructions = instructionsArray;
    
    AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
    MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
    MainCompositionInst.frameDuration = CMTimeMake(1, 30);
    
    
    MainCompositionInst.renderSize = CGSizeMake((int)finalVideoWidth,(int)finalVideoHeight);//final width and height
    
    NSArray *docpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tempPath = [docpaths objectAtIndex:0];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat: @"yyyy_MM_dd_HH_mm"];
    NSString *stringFromDate = [formatter stringFromDate:[NSDate date]];
    finalVideoName = [NSString stringWithFormat:@"Splimage_%@",stringFromDate];
    NSString *exportPath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",finalVideoName]];
    combinedVideoUrl = [NSURL fileURLWithPath:exportPath];
    
    unlink([exportPath UTF8String]);
    if([[NSFileManager defaultManager] fileExistsAtPath:exportPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:exportPath error:nil];
    }
    //change the quality for various file size*********
    //sandeep there is change exported video qualty
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPreset1280x720]; // AVAssetExportPresetHighestQuality // AVAssetExportPresetMediumQuality
    
    _assetExport.outputFileType = AVFileTypeQuickTimeMovie;//AVFileTypeAppleM4V;//AVFileTypeMPEG4;//
    _assetExport.outputURL = combinedVideoUrl;
    NSLog(@"file type %@",_assetExport.outputURL);
    _assetExport.shouldOptimizeForNetworkUse = YES;
    _assetExport.videoComposition=MainCompositionInst;
    [_assetExport exportAsynchronouslyWithCompletionHandler:^{
        switch (_assetExport.status)
        {
                
            case AVAssetExportSessionStatusFailed:
            {
                NSLog (@"FAIL \n%@",[_assetExport.error description]);
                [self showAlertWithMessage:@"Combine Video Failed"
                                  andTitle:@"Error"
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil
                                    andTag:SUCCESS_FAIL];
                [self removeActivity];
                break;
            }
            case AVAssetExportSessionStatusCompleted:
            {
                NSLog (@"SUCCESS");
                //save to device library
                
                [self videoPrepCompleted];
                
                break;
            }
        };
    }];
}



#pragma mark -
-(CGAffineTransform)getTransformationForTag:(NSInteger)_tag{
    
    float xCord =[[[patternArray objectAtIndex:_tag] valueForKey:COORDINATE_X] floatValue];//   /[SavedData getZoomScaleAtIndex:_tag];
    float yCord = [[[patternArray objectAtIndex:_tag] valueForKey:COORDINATE_Y] floatValue];//   /[SavedData getZoomScaleAtIndex:_tag];
    
    CGAffineTransform transform =  CGAffineTransformMakeScale(1.0,1.0);//CGAffineTransformMakeScale([SavedData getZoomScaleAtIndex:_tag],[SavedData getZoomScaleAtIndex:_tag]);//
    
    transform = CGAffineTransformTranslate(transform, finalVideoWidth*xCord, finalVideoHeight*yCord);
    return transform;
}

#pragma mark -

-(void)videoPrepCompleted{

    //[btnPlay setHidden:YES];
    //[mySwitch setHidden:YES];
    //[btnRightNav setEnabled:YES];
    //[self reSetUpToolBarButton];

    NSArray *docpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tempPath = [docpaths objectAtIndex:0];
    NSString *exportPath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",finalVideoName]];
    
    [self removeActivity];
    [self performSelectorOnMainThread:@selector(loadUpAndPlayVideo) withObject:nil waitUntilDone:YES];

    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(exportPath)) {
        UISaveVideoAtPathToSavedPhotosAlbum(exportPath,
                                            self,
                                            @selector(video:didFinishSavingWithError:contextInfo:), nil);
        
    }
    
    for (int i = 0; i <counter; i++) {
        [SavedData removeFileAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Movie%d.m4v",i]]];
    }
    
    videoMergeCompleted = YES;
    
     //  [self loadUpAndPlayVideo];
}

-(void)video:(NSString*)videoPath didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error) {
        [self showAlertWithMessage:@"Video Saving Failed" andTitle:@"Alert" cancelButtonTitle:@"OK" otherButtonTitles:nil andTag:SUCCESS_FAIL];
    } else {
        [self showAlertWithMessage:@"Your Splimage was saved to your gallery" andTitle:@"Please Note:" cancelButtonTitle:@"OK" otherButtonTitles:nil andTag:SUCCESS_FAIL];
    }
    NSLog (@"error: %@", error);
}


#pragma mark - VideoPlaybackView Delegate Methods -
-(void)videoCreatedSuccessfully:(VideoPlaybackView *)videoView
{
    NSLog(@"Created Successfully");
    counter++;
    [self getSetReloadWriter];
    
}


#pragma mark -
-(void)showActivity{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.center = CGPointMake(canvasView.center.x, canvasView.center.y);
    [HUD setMode:MBProgressHUDModeIndeterminate];
    HUD.labelText = @"";
    [self.view setUserInteractionEnabled:NO];
    [self.view bringSubviewToFront:HUD];
}
- (void)myMixedTask {
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"Encoding Video";
    float totalDuration =12.0f;
    //    int counterIndx = [[SavedData getValueForKey:ARRAY_FRAMES] count];
    //    for (int i = 0; i <counterIndx; i++) {
    //        totalDuration  = totalDuration  + [SavedData getTrackLengthAtIndex:i];
    //    }
    totalDuration = totalDuration/200000.0;
    HUD.progress=0.0;
    while (HUD.progress < 1.0f) {
        HUD.progress += totalDuration;
    }
}

-(void)progressTimer{
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Generating Video";
}
-(void)myUploadingTask{
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"Uploading Video";
    HUD.progress=0.01;
}
-(void)myUploadTask{
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Uploading Video";
}

-(void)removeActivity{
    
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"Completed";
    [HUD hide:YES];
    [HUD removeFromSuperview];
	HUD = nil;
    [self.view setUserInteractionEnabled:YES];
}

#pragma mark -
-(void)getTheOutPutFrameSize{
    //check % of each side of the frame and get a ratio and add it to an array of dictionary
    NSMutableArray *arrayAllArea =[[NSMutableArray alloc] init];
    NSMutableArray *arrayAllValues =[[NSMutableArray alloc] init];
    
    patternArray =  [SavedData getValueForKey:ARRAY_PATTERN];
    int counterIndx = [[SavedData getValueForKey:ARRAY_FRAMES] count];
    for (int i=0; i<counterIndx; i++) {
        
        
        CGRect myContent = [SavedData getCropContentAtIndex:i];
        
        float percentWidth = myContent.size.height;//dimension.x; //
        float percentHeight = myContent.size.width; //dimension.y; //
        
        float width = [SavedData getWidthAtIndex:i];
        float height = [SavedData getHeightAtIndex:i];
        
        float finalWidth = percentWidth*width/[[[patternArray objectAtIndex:i] valueForKey:WIDTH] floatValue];//(1.0/percentWidth)*width;
        float finalHeight = percentHeight*height/[[[patternArray objectAtIndex:i] valueForKey:HEIGHT] floatValue];
        float finalArea = finalWidth*finalHeight;
        
        NSLog(@"%d Final width   %f",i, finalWidth);
        NSLog(@"%d Final Height   %f",i, finalHeight);
        NSLog(@"%d Final Area   %f",i, finalArea);
        
        [arrayAllArea addObject:[NSNumber numberWithFloat:finalArea]];
        
        [arrayAllValues addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:finalWidth],@"finalWidth",[NSNumber numberWithFloat:finalHeight],@"finalHeight",[NSNumber numberWithFloat:finalArea],@"finalArea", nil]];
    }
    
    double lowest = DBL_MAX ;
    int indexOptimum = 0;
    for (NSNumber * N in arrayAllArea) {
        if ([N floatValue]<=lowest) {
            lowest = [N floatValue];
            indexOptimum = [arrayAllArea indexOfObject:N];
        }
    }
    
    //new width and height
    
    finalVideoWidth = [[[arrayAllValues objectAtIndex:indexOptimum] valueForKey:@"finalWidth"] floatValue];
    finalVideoHeight = [[[arrayAllValues objectAtIndex:indexOptimum] valueForKey:@"finalHeight"] floatValue];
    
    //    when rounding to the nearest n,
    //    x_rounded = ((x + n/2)/n)*n;
    finalVideoWidth = (((int)finalVideoWidth+4)/8)*8;
    finalVideoHeight = (((int)finalVideoHeight+4)/8)*8;
    
    
    NSLog(@"Final width  = %f ",finalVideoWidth);
    NSLog(@"Final height  = %f ",finalVideoHeight);
    
    arrayAllArea = nil;
    arrayAllValues = nil;
    //    [SavedData getAllTheValues];
    
}
#pragma mark -

-(CGRect)getMyContentRectFromUrl:(NSInteger)theIndex{
    
    CGRect myContent = [SavedData getCropContentAtIndex:theIndex];
    
    CGFloat xPos = myContent.origin.x ;
    CGFloat yPos = myContent.origin.y ;
    
    CGFloat ratioWidth = myContent.size.width ;
    CGFloat ratioHeight = myContent.size.height ;
    
    CGRect myNewContent;
    
    switch ([SavedData getRotationAtIndex:theIndex]) {
        case UIInterfaceOrientationPortrait:
        {
            CGFloat newY = 1.0-ratioHeight-yPos;
            newY>1.0?newY=1.0:newY<0?newY=0:newY;
            myNewContent = CGRectMake( xPos, newY, ratioWidth,  ratioHeight);//myContent;//
        }   break;
            
        case UIInterfaceOrientationPortraitUpsideDown:{
            CGFloat newX = 1.0-ratioWidth-xPos;
            CGFloat newY = 1.0-ratioHeight-yPos;
            
            newX>1.0?newX=1.0:newX<0?newX=0:newX;
            newY>1.0?newY=1.0:newY<0?newY=0:newY;
            
            myNewContent = CGRectMake(newX, newY, ratioWidth,  ratioHeight);//myContent;//
        } break;
            
        case UIInterfaceOrientationLandscapeLeft:
            myNewContent = CGRectMake(yPos, xPos,  ratioHeight,ratioWidth);//myContent;//
            break;
            
        case UIInterfaceOrientationLandscapeRight:{
            
            CGFloat newX = 1.0-ratioWidth-xPos;
            CGFloat newY = 1.0-ratioHeight-yPos;
            
            newX>1.0?newX=1.0:newX<0?newX=0:newX;
            newY>1.0?newY=1.0:newY<0?newY=0:newY;
            
            myNewContent = CGRectMake(newY, newX,  ratioHeight,ratioWidth);//myContent;//
            //            myNewContent = CGRectMake(yPos, xPos,  ratioHeight,ratioWidth);//myContent;//
            
            break;
        }
        default:
            break;
    }
    return myNewContent;
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
    switch (buttonIndex) {
        case 0:{
            NSLog(@"Facebook");
            [self faceBookOperation];
            break;
        }
        case 1:
            NSLog(@"YouTube");
            [self uploadToYouTube];
            break;
        case 2:
            NSLog(@"Email");
            [self setUpTheMail];
            break;
            
        default:
            //   [self dismissThisView];
            break;
    }
}


#pragma mark -

-(void)uploadToYouTube{
    
    UIAlertView *yAlert = [[UIAlertView alloc] initWithTitle:@"Upload to YouTube" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [yAlert setTag:LOGIN_ALERT];
    [yAlert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [yAlert show];
    
}
#pragma mark -

-(void)faceBookOperation{
    
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    [self showActivity];
    
    if (version >= 6) {
        __block ACAccount *facebookAccount = nil;
        
        ACAccountStore *accountStore =[[ACAccountStore alloc] init];
        ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        
        NSDictionary *options = @{
                                  @"ACFacebookAppIdKey" : FACEBOOK_APP_ID,
                                  @"ACFacebookPermissionsKey" : @[@"publish_stream", @"publish_actions",@"user_videos"],
                                  @"ACFacebookAudienceKey" : ACFacebookAudienceEveryone}; // Needed only when write permissions are requested
        
        [accountStore requestAccessToAccountsWithType:facebookAccountType
                                              options:options
                                           completion:^(BOOL granted, NSError *error) {
                                               if (granted)
                                               {
                                                   NSArray *accounts = [accountStore accountsWithAccountType:facebookAccountType];
                                                   facebookAccount = [accounts lastObject];
                                                   [self loadUpTheFaceBookRequest:facebookAccount];
                                               } else {
                                                   NSLog(@"%@",error);
                                                   [self removeActivity];
                                                   [[[UIAlertView alloc] initWithTitle:@"Failed!"
                                                                               message:@"Log in to the Facebook App First and Try again."
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK!"
                                                                     otherButtonTitles:nil]
                                                    show];
                                               }
                                           }];
        
        
        
        
    }else{
        if (![FBSession.activeSession isOpen]) {
            [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                if ([session isOpen]) {
                    [self uploadFaceBook];
                }
            }];
            
        }
        else
            [self uploadFaceBook];
    }
}

-(void)loadUpTheFaceBookRequest:(ACAccount *)fBAccount{
    NSURL *videourl = [NSURL URLWithString:@"https://graph.facebook.com/me/videos"];
    NSData *videoData = [NSData dataWithContentsOfURL:combinedVideoUrl];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   finalVideoName, @"title",
                                   VIDEO_DESCRIPTION, @"description",
                                   finalVideoName, @"file",
                                   nil];
    
    SLRequest *uploadRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                                  requestMethod:SLRequestMethodPOST
                                                            URL:videourl
                                                     parameters:params];
    [uploadRequest addMultipartData:videoData
                           withName:VIDEO_TITLE
                               type:@"video/mp4"
                           filename:[combinedVideoUrl absoluteString]];
    
    uploadRequest.account = fBAccount;
    
    [uploadRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        [self removeActivity];
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if(error){
            NSLog(@"Error %@", error.localizedDescription);
            [[[UIAlertView alloc] initWithTitle:@"Facebook"
                                        message:error.localizedDescription
                                       delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil]
             show];
            
        }else{
            NSLog(@"%@", responseString);
            [[[UIAlertView alloc] initWithTitle:@"Facebook"
                                        message:@"Video Uploaded"
                                       delegate:nil
                              cancelButtonTitle:@"OK!"
                              otherButtonTitles:nil]
             show];
            
        }
    }];
    [self myUploadTask];
}
-(void)uploadFaceBook{
    [self myUploadTask];
    NSData *videoData = [NSData dataWithContentsOfURL:combinedVideoUrl];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   finalVideoName, @"title",
                                   VIDEO_DESCRIPTION, @"description",
                                   finalVideoName, @"file",
                                   videoData, @"clip.mov",
                                   nil];
    
    [FBRequestConnection
     startWithGraphPath:@"me/videos"
     parameters:params
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         [self removeActivity];
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:nil
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
    
    
    [FBRequest requestWithGraphPath:@"me/videos" parameters:params HTTPMethod:@"POST"];
    //   [self dismissThisView];
}
#pragma mark -
#pragma mark - Youtube

- (GDataServiceGoogleYouTube *)youTubeService:(NSString *)username andPassword:(NSString *)password  {
    
    static GDataServiceGoogleYouTube* service = nil;
    
    if (!service) {
        service = [[GDataServiceGoogleYouTube alloc] init];
        
        [service setShouldCacheResponseData:YES];//[service setShouldCacheDatedData:YES]
        [service setServiceShouldFollowNextLinks:YES];
        [service setIsServiceRetryEnabled:YES];
    }
    
    // update the username/password each time the service is requested
    [service setUserCredentialsWithUsername:username
                                   password:password];
    
    
    return service;
}

- (void)uploadToYoutube: (NSString *)login andPassword:(NSString *)password withVideo:(NSData *)videoData //forSighting:(SightingDB *)sighting
{
    [self showActivity];
    GDataServiceGoogleYouTube *service = [self youTubeService:login andPassword:password];
    
    [service setYouTubeDeveloperKey:GOOGLE_DEVELOPER_KEY];
    
    NSURL *url = [GDataServiceGoogleYouTube youTubeUploadURLForUserID:kGDataServiceDefaultUser];
    
    // gather all the metadata needed for the mediaGroup
    
    GDataMediaTitle *title = [GDataMediaTitle textConstructWithString:VIDEO_TITLE];
    
    NSString *categoryStr = @"Entertainment";
    GDataMediaCategory *category = [GDataMediaCategory mediaCategoryWithString:categoryStr];
    [category setScheme:kGDataSchemeYouTubeCategory];
    
    GDataMediaDescription *desc = [GDataMediaDescription textConstructWithString:VIDEO_DESCRIPTION];
    
    NSArray *kwords = [[NSArray alloc] initWithObjects:@"Splimage",nil];
    GDataMediaKeywords *keywords = [GDataMediaKeywords keywordsWithStrings:kwords];
    
    BOOL isPrivate = NO;
    
    GDataYouTubeMediaGroup *mediaGroup = [GDataYouTubeMediaGroup mediaGroup];
    [mediaGroup setMediaTitle:title];
    [mediaGroup setMediaDescription:desc];
    [mediaGroup addMediaCategory:category];
    [mediaGroup setMediaKeywords:keywords];
    [mediaGroup setIsPrivate:isPrivate];
    
    NSString *mimeType = [GDataUtilities MIMETypeForFileAtPath:@""
                                               defaultMIMEType:@"video/mp4"];
    
    // create the upload entry with the mediaGroup and the file data
    GDataEntryYouTubeUpload *entry;
    
    entry = [GDataEntryYouTubeUpload uploadEntryWithMediaGroup:mediaGroup
                                                          data:videoData
                                                      MIMEType:mimeType
                                                          slug:@"movie.mov"];
    
    
    
    SEL progressSel = @selector(ticket:hasDeliveredByteCount:ofTotalByteCount:);
    [service setServiceUploadProgressSelector:progressSel];
    
    GDataServiceTicket *ticket;
    ticket = [service fetchEntryByInsertingEntry:entry
                                      forFeedURL:url
                                        delegate:self
                               didFinishSelector:@selector(uploadTicket:finishedWithEntry:error:)];
    
    [self myUploadingTask];
}
// progress callback
- (void)ticket:(GDataServiceTicket *)ticket
hasDeliveredByteCount:(unsigned long long)numberOfBytesRead
ofTotalByteCount:(unsigned long long)dataLength {
    
    NSLog(@"-->%lld", numberOfBytesRead);
    NSLog(@"->%lld", dataLength);
    float progress = numberOfBytesRead/dataLength;
    NSLog(@"---->%f", progress);
    HUD.progress=progress;
}

- (void)uploadTicket:(GDataServiceTicket *)ticket
   finishedWithEntry:(GDataEntryYouTubeVideo *)videoEntry
               error:(NSError *)error {
    [self removeActivity];
    NSString *alertMsg;
    if (error == nil) {
        // tell the user that the add worked
        alertMsg =[NSString stringWithFormat:@"%@ succesfully uploaded",
                   [[videoEntry title] stringValue]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Uploaded!"
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    } else {
        alertMsg = @"Upload Failed. Try Again Later.";//[NSString stringWithFormat:@"Error: %@", [error description]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}
#pragma mark -
#pragma mark Mail

-(void)setUpTheMail{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Check out this video collage I made with Splimage!"];
    
    // Fill out the email body text
    [picker setMessageBody:@"Download Splimage for FREE on your iPhone/iPodTouch today!!!\n\n\nDiscover exclusive Splimage updates on www.splimage.com" isHTML:NO];
    
    NSString *mimeType = @"video/quicktime";
    
    [picker addAttachmentData:[NSData dataWithContentsOfURL:combinedVideoUrl]  mimeType:mimeType fileName:[NSString stringWithFormat:@"%@.mov",finalVideoName]];
    picker.navigationBar.barStyle = UIBarStyleBlack; // choose your style, unfortunately, Translucent colors behave quirky.
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (result == MFMailComposeResultSent) {
        [[[UIAlertView alloc] initWithTitle:@"Email Sent"
                                    message:@""
                                   delegate:nil
                          cancelButtonTitle:@"OK!"
                          otherButtonTitles:nil]
         show];
    }
    [controller dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma handle autorotation

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    CGRect frame = [super getScreenFrameForOrientation:toInterfaceOrientation];
    [self adjustFrameBeforeView:frame];
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
    [self adjustFrameAfterView];
    
}

-(void)adjustFrameBeforeView:(CGRect) frame{
    
    [self layoutTopViewForInterfaceFrame:frame];
    if (videoMergeCompleted) {
        
        if (splPlayerView) {
            [splPlayerView stopPlayer];
            [splPlayerView removeFromSuperview];
            splPlayerView=nil;
        }
    }
}

-(void)adjustFrameAfterView{
    
    if (videoMergeCompleted) {
        [self loadUpAndPlayVideo];
      // [self reSetUpToolBarButton];
    } else {
        [self reSetUpToolBarButton];
    }
}

#pragma Flurry Ad delegates

-(void) showFullScreenAd {
    
    [FlurryAds setAdDelegate:self];
    [FlurryAds fetchAdForSpace:@"INTERSTITIAL_MAIN_VIEW" frame:self.view.frame size:FULLSCREEN];
    // Check if ad is ready. If so, display the ad
    
    if ([FlurryAds adReadyForSpace:@"INTERSTITIAL_MAIN_VIEW"]) {
        [FlurryAds displayAdForSpace:@"INTERSTITIAL_MAIN_VIEW" onView:self.view];
        //    } else {
        // Fetch an ad
        //        [FlurryAds fetchAdForSpace:@"INTERSTITIAL_MAIN_VIEW" frame:self.view.frame size:FULLSCREEN];
    }
}

/*
 *  It is recommended to pause app activities when an interstitial is shown.
 *  Listen to should display delegate.
 */
//- (BOOL) spaceShouldDisplay:(NSString*)adSpace interstitial:(BOOL)
//interstitial {
//    if (interstitial) {
// Pause app state here
//    }

// Continue ad display
//    return YES;
//}

/*
 *  Resume app state when the interstitial is dismissed.
 */
- (void)spaceDidDismiss:(NSString *)adSpace interstitial:(BOOL)interstitial {
    if (interstitial) {
        // Resume app state here
        [self reSetUpToolBarButton];
        [self startProcessingOutput];
    }
}

@end
