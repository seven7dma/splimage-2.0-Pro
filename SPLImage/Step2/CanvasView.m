//
//  CanvasView.m
//  SPLImage
//
//  Created by Girish Rathod on 12/12/12.
//
//

#import "CanvasView.h"

@implementation CanvasView
#define PADDING 0.0
@synthesize arrayCanvasView,delegate;
- (id)initWithFrame:(CGRect)frame andPattern:(NSArray *)patternArray andBGImage:(UIImage *)bgImage
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        arrayButtonsAdd = [NSMutableArray array];
        arrayCanvasView = [NSMutableArray array];
        arrayButtonSound = [NSMutableArray array];
        arrayPlayButtons = [NSMutableArray array];
        arrayCenterPoints = [NSMutableArray array];
        arraySequences = [NSMutableArray array];
        
        UIImageView *imageCanvasBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [imageCanvasBG setImage:bgImage];
        [self addSubview:imageCanvasBG];
        self.backgroundColor = [UIColor clearColor];
        int tag = 0;
        [self initFramesSavedData];
        
        for (NSDictionary *items in patternArray) {
            
            NSMutableDictionary *dictViews = [NSMutableDictionary dictionaryWithCapacity:0];
            
            CGRect frameCanvas = CGRectMake(frame.size.width * [[items valueForKey:COORDINATE_X] floatValue] +PADDING, frame.size.height * [[items valueForKey:COORDINATE_Y] floatValue] +PADDING, frame.size.width * [[items valueForKey:WIDTH] floatValue] - 2*PADDING, frame.size.height * [[items valueForKey:HEIGHT] floatValue] - 2*PADDING);
            
            myScrollView =[[SPLImageGpuClass alloc] initWithFrame:frameCanvas andTag:tag];
            [self addSubview:myScrollView];
                       
            UIImage *imgSoundUnSelected = [UIImage imageNamed:@"volume_icon_red"];
            UIImage *imgSoundSelected = [UIImage imageNamed:@"volume_icon_green"];
            
            UIButton * btnSounds = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnSounds setTag:tag];
            [btnSounds setImage:imgSoundUnSelected forState:UIControlStateNormal];
            [btnSounds setImage:imgSoundSelected forState:UIControlStateSelected];
            [btnSounds setFrame:CGRectMake(frameCanvas.origin.x+frameCanvas.size.width-imgSoundSelected.size.width-8, frameCanvas.origin.y+8, imgSoundSelected.size.width, imgSoundSelected.size.height)];
            [btnSounds setHidden:YES];
            [btnSounds setUserInteractionEnabled:YES];
            
            [self addSubview:btnSounds];
            
            NSString *imgName =[NSString stringWithFormat:@"%d.png",tag+1];
            UIImage *imgSequence = [UIImage imageNamed:imgName];
            UIImageView *imageViewSeq=[[UIImageView alloc] initWithImage:imgSequence];
            
            [imageViewSeq setTag:tag];
            [imageViewSeq setFrame:CGRectMake(frameCanvas.origin.x+frameCanvas.size.width-imgSoundSelected.size.width-8, frameCanvas.origin.y+8, imgSoundSelected.size.width, imgSoundSelected.size.height)];
            [imageViewSeq setUserInteractionEnabled:YES];
            [imageViewSeq setHidden:YES];
            [self addSubview:imageViewSeq];
            [arraySequences addObject:imageViewSeq];
            
            
            NSDictionary *dictCenters = [NSDictionary dictionaryWithObjectsAndKeys:[NSValue valueWithCGPoint:imageViewSeq.center],kSequenceCenter, [NSValue valueWithCGPoint:myScrollView.center],kFrameCenter, nil];
            
            
            [arrayCenterPoints addObject:dictCenters];//save center point co-ords
            
            
            UIImage *imgPlay = [UIImage imageNamed:@"over_img_play.png"];
            UIImage *imgStop = [UIImage imageNamed:@"square.png"];
            
            UIButton * btnPlayStop = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnPlayStop setTag:tag];
            [btnPlayStop setImage:imgPlay forState:UIControlStateNormal];
            [btnPlayStop setImage:imgStop forState:UIControlStateSelected];
            [btnPlayStop setFrame:CGRectMake(frameCanvas.origin.x+ 8, frameCanvas.origin.y+8, imgStop.size.width, imgStop.size.height)];
            [btnPlayStop setHidden:YES];
            [self addSubview:btnPlayStop];
            [btnPlayStop addTarget:self action:@selector(btnPlayStopClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [arrayPlayButtons addObject:btnPlayStop];
            
                   
            [myScrollView.btnAddVideo addTarget:self action:@selector(addVideoAction:) forControlEvents:UIControlEventTouchUpInside];
            [arrayButtonsAdd addObject:myScrollView.btnAddVideo];

            [btnSounds addTarget:self action:@selector(setTheSelectedSounds:) forControlEvents:UIControlEventTouchUpInside];
            [arrayButtonSound addObject:btnSounds];
            
              
            [dictViews setObject:myScrollView forKey:CANVAS_VIEW_GREEN_BG];
            [dictViews setObject:myScrollView.viewGpuImage forKey:CANVAS_VIEW_GRAY];
            [dictViews setObject:myScrollView.btnAddVideo forKey:CANVAS_VIEW_BTN];
            
            [arrayCanvasView addObject:dictViews];
            
            tag++;
        }

         
        //for sequence options

    }
    return self;
}


-(void)initFramesSavedData{
    
    NSMutableArray * arrayFrames = [NSMutableArray array];
    int tag = 0;
    for (NSDictionary *items in [SavedData getValueForKey:ARRAY_PATTERN]) {
        CGRect frameCanvas = CGRectMake(self.frame.size.width * [[items valueForKey:COORDINATE_X] floatValue] ,
                                        self.frame.size.height * [[items valueForKey:COORDINATE_Y] floatValue],
                                        self.frame.size.width * [[items valueForKey:WIDTH] floatValue],
                                        self.frame.size.height * [[items valueForKey:HEIGHT] floatValue]);
    
        NSMutableDictionary *dictFrames = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          [NSValue valueWithCGRect:frameCanvas], kFrames,
                                          [NSNumber numberWithInt:tag], kTag,
                                          [NSURL URLWithString:@""], kVideoURL,
                                          [NSURL URLWithString:@""], kReverseVideoURL,
                                          [NSNumber numberWithInt:FILTER_NONE], kFilter,
                                          [NSNumber numberWithFloat:0.0], kLength,
                                          [NSNumber numberWithBool:NO], kIsReverse,
                                          [NSNumber numberWithInt:tag], kSequence,
                                          [NSNumber numberWithBool:NO], kIsMute,
                                          [NSNumber numberWithFloat:0.0], kWidth,
                                          [NSNumber numberWithFloat:0.0], kHeight,
                                          [NSNumber numberWithFloat:1.0], kZoomScale,
                                          [NSValue valueWithCGPoint:CGPointMake(0, 0)], kContentOffset,
                                           [NSNumber numberWithBool:NO], kShouldRevert,
                                           nil];
    
    [arrayFrames addObject:dictFrames];
        tag ++;
    }

    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:arrayFrames copyItems:NO];
    [SavedData setValue:temp forKey:ARRAY_FRAMES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code

}


#pragma mark - SplimagePlayer Methods


-(void)loadUpThePlayerAtPosition:(NSInteger)_position{

    MY_FILTERS assignedFilter;
    NSURL *videoPath;
    GPUImageView * viewVideoArea;
    
    if ([SavedData getIsReverseTrackAtIndex:_position]) {
        videoPath = [SavedData getReverseVideoURLAtIndex:_position];
    }else{
        videoPath = [SavedData getVideoURLAtIndex:_position];
    }
    assignedFilter = [SavedData getFilterAtIndex:_position];
      
    for (NSDictionary *items in arrayCanvasView) {
        if ([[items valueForKey:CANVAS_VIEW_GRAY] tag]==_position) {
            viewVideoArea = [items valueForKey:CANVAS_VIEW_GRAY];
        }
    }

    theGpuPlayer = [[SplimagePlayer alloc] initWithURL:videoPath];
    [theGpuPlayer setIndexPlayer:_position];

    [theGpuPlayer setDelegate:self];
    [theGpuPlayer setSelectedFilter:assignedFilter];
    [theGpuPlayer setGpuImageView:viewVideoArea];
    //[theGpuPlayer setPrepareReverseVideo:NO];
    [theGpuPlayer getOrientationAndFitting];
    [theGpuPlayer prepareForProcessing];
    [theGpuPlayer startProcessing];

    //    [btnPlayVideo setSelected:YES];
//    [self.view bringSubviewToFront:btnPlayVideo];
}

-(void)stopPlayer{
    if (theGpuPlayer!=nil) {
//    [theGpuPlayer endProcessing];
    [theGpuPlayer endMyProcessing];
    [theGpuPlayer removeAllTargets];
    [theGpuPlayer setDelegate:nil];
    theGpuPlayer = nil;
    }
}

//set the thumb image here
-(void)loadSelectedVideosOnView:(NSInteger)viewTag {
    
    for (NSDictionary *items in arrayCanvasView) {
        
        if ([[items valueForKey:CANVAS_VIEW_GRAY] tag]==viewTag) {
            [self addThumbViewImageFor:viewTag];
            [[items valueForKey:CANVAS_VIEW_BTN] setHidden:YES];
            [[arrayPlayButtons objectAtIndex:viewTag] setSelected:NO];
            
        }
    }
    
    [UIView animateWithDuration:0.50 animations:^{
        [self displayPlayButtons];
    }];
    
}


#pragma mark - SplimagePlayer Delegate

-(void)splimagePlayerDidStopPlaying:(NSInteger)playerIndex{
    if ([[arrayPlayButtons objectAtIndex:playerIndex] isSelected]) {
        [self performSelectorOnMainThread:@selector(setUnselected:) withObject:[arrayPlayButtons objectAtIndex:playerIndex] waitUntilDone:NO];
    }
}

-(void)setUnselected:(UIButton *)btnPlay{
    NSLog(@"setUnselected:btnPlay");
    [btnPlay setSelected:NO];
}

#pragma mark - Button Actions

-(void)btnPlayStopClicked:(UIButton *)sender{
    
    [self stopPlayer];
    
    for (NSDictionary *items in arrayCanvasView) {
        if ([[items valueForKey:CANVAS_VIEW_GRAY] tag]==[sender tag]) {
            
            if ([sender isSelected]) {
                //do nothing
            }
            else{
                [self loadUpThePlayerAtPosition:[sender tag]];
                [self setThumbViewImage:0.0 forView:[items valueForKey:CANVAS_VIEW_GREEN_BG]];
            }
            break;
        }
    }
    
    [sender setSelected:![sender isSelected]];
    [self setTheSelectedView:[sender tag]];
}

-(void)addVideoAction:(UIButton *)sender{

    [self stopPlayer];
//    [self stopPlayingAllPlayers];

    [self setTheSelectedView:sender.tag];
    
    if (delegate)
        if ([delegate respondsToSelector:@selector(addVideoButtondClicked:)])
            [delegate addVideoButtondClicked:sender];
       
}

-(void)setTheSelectedSounds:(id)sender{
    
    for (UIButton *B in arrayButtonSound) {
        if ([B tag]==[sender tag])
            [B setSelected:YES];
        else
            [B setSelected:NO];
    }
    for (NSDictionary *items in [SavedData getValueForKey:ARRAY_FRAMES]) {
        if ([[items valueForKey:kTag] integerValue]==[sender tag]) {
            [items setValue:[NSNumber numberWithBool:NO] forKey:kIsMute];
        }else
            [items setValue:[NSNumber numberWithBool:YES] forKey:kIsMute];
    }
    
}

#pragma mark -

-(void)shouldAddAllTheGesture:(BOOL)_shouldAdd{
    
    [self shouldAddSingleTapGestureRecognizer:_shouldAdd];
    [self shouldAddDoubleTapGestureRecognizer:_shouldAdd];
    [self shouldAddLongPressGestureRecognizer:_shouldAdd];
    [self shouldAddZoomToVideos:_shouldAdd];
    [self shouldRemoveAllTheGesture:!_shouldAdd];
}
-(void)shouldRemoveAllTheGesture:(BOOL)_shouldRemove{
        for (NSDictionary *items in arrayCanvasView) {
            [[items valueForKey:CANVAS_VIEW_GREEN_BG]  setUserInteractionEnabled:!_shouldRemove];
//            for (UIGestureRecognizer *gesture in [[items valueForKey:CANVAS_VIEW_GREEN_BG] gestureRecognizers]) {
//                NSLog(@"------%@",[gesture description]);
//                if ([gesture isKindOfClass:[UIGestureRecognizer class]]){
//                    if(_shouldRemove){
//                        [[items valueForKey:CANVAS_VIEW_GREEN_BG] removeGestureRecognizer:gesture];
//                    }else{
//                        [[items valueForKey:CANVAS_VIEW_GREEN_BG] addGestureRecognizer:gesture];
//                    }
//                }
//            }
        }
}
-(void)shouldAddSingleTapGestureRecognizer:(BOOL)_shouldAdd{
   
    if (_shouldAdd) {
        for (NSDictionary *item in arrayCanvasView) {
            singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [singleTapGesture setNumberOfTapsRequired:1];
            [[item valueForKey:CANVAS_VIEW_GREEN_BG] addGestureRecognizer:singleTapGesture];
        }

    }
}

-(void)shouldAddDoubleTapGestureRecognizer:(BOOL)_shouldAdd{
   
    if (_shouldAdd) {
        for (NSDictionary *item in arrayCanvasView) {
            doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
            [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
            [[item valueForKey:CANVAS_VIEW_GREEN_BG] addGestureRecognizer:doubleTapGestureRecognizer];
        }
     }
}
 
-(void)shouldAddLongPressGestureRecognizer:(BOOL)_shouldAdd{
    
    if (_shouldAdd) {
        for (NSDictionary *item in arrayCanvasView) {
            longPressGestureRecognizer = [[UILongPressGestureRecognizer  alloc] initWithTarget:self action:@selector(handleLongPress:)];
            [longPressGestureRecognizer setMinimumPressDuration:1.0];
            [[item valueForKey:CANVAS_VIEW_GREEN_BG] addGestureRecognizer:longPressGestureRecognizer];
        }
    }
}

-(void)shouldAddZoomToVideos:(BOOL)_shouldAdd{
        for (NSDictionary *item in arrayCanvasView) {
            [(SPLImageGpuClass *)[item valueForKey:CANVAS_VIEW_GREEN_BG] setShouldZoom:_shouldAdd];
        }
}

-(void)shouldAddSwipeGestureRecognizers:(BOOL)_shouldAdd{
    if (_shouldAdd) {
        for (UIImageView *item in arraySequences) {
            UILongPressGestureRecognizer *longPressGestureRecognizerSequence = [[UILongPressGestureRecognizer  alloc] initWithTarget:self action:@selector(handleLongPressForSequence:)];
            [longPressGestureRecognizerSequence setMinimumPressDuration:0.1];
            [item addGestureRecognizer:longPressGestureRecognizerSequence];
        }
    }
}
#pragma mark - Gesture Recognizers

-(void)panningSelectedCanvas:(UIPanGestureRecognizer *)panGesture{
    SPLImageGpuClass *view1 = (SPLImageGpuClass *)panGesture.view;
    
	CGPoint translation = [panGesture translationInView:view1];
    
	view1.center = CGPointMake(view1.center.x + translation.x,
                               view1.center.y + translation.y);
    
	[panGesture setTranslation:CGPointZero inView:view1];
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"UIGestureRecognizerStateBegan");
            break;
        case UIGestureRecognizerStateEnded:
            NSLog(@"UIGestureRecognizerStateEnded");
            
            [self swapMoveTheView:view1 toLocationWithTag:[self findClosestFrameTo:panGesture.view.center]];
            
             for (NSDictionary *items in arrayCanvasView) {
                for (UIGestureRecognizer *gesture in [[items valueForKey:CANVAS_VIEW_GREEN_BG] gestureRecognizers]) {
                    if ([gesture isKindOfClass:[UIPanGestureRecognizer class]] && gesture!= [[items valueForKey:CANVAS_VIEW_GREEN_BG] panGestureRecognizer] && gesture!= [[items valueForKey:CANVAS_VIEW_GREEN_BG] pinchGestureRecognizer]) {
                        [[items valueForKey:CANVAS_VIEW_GREEN_BG] removeGestureRecognizer:gesture];
                        NSLog(@"removeGestureRecognizer: PAN");
                    }
                }
            }
            break;
            
        default:
            break;
    }

}
-(void)swapMoveTheView:(SPLImageGpuClass *)thisView toLocationWithTag:(int)locationTag{
    [self swapSavedDataUrlsBetweenTag:thisView.tag and:locationTag];
    if (thisView.tag==locationTag) {
        NSLog(@"Move Back");
        [self transitionTheView:thisView toLocationWithTag:locationTag];
    }else{
        //            for (NSDictionary *items in arrayCanvasView) {
        //            if ([[items valueForKey:CANVAS_VIEW_BTN] isSelected] && [[items valueForKey:CANVAS_VIEW_GREEN_BG] tag] == [self findClosestFrameTo:panGesture.view.center]) {
        //                NSLog(@"selected");
        //                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Replace existing video?" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Yes",@"No", nil];
        //                [alert show];
        //            }else
        //                NSLog(@"Not selected");
        //            }

        for (NSDictionary *items in [SavedData getValueForKey:ARRAY_FRAMES]) {
            if ([[items valueForKey:kTag] integerValue]==locationTag) {
                [self transitionTheView:thisView toLocationWithTag:locationTag];
                
                for (NSDictionary *item in arrayCanvasView) {
                    if ([[item valueForKey:CANVAS_VIEW_GREEN_BG] tag]==locationTag) {
                        [self transitionTheView:[item valueForKey:CANVAS_VIEW_GREEN_BG] toLocationWithTag:thisView.tag];
                        [[item valueForKey:CANVAS_VIEW_GREEN_BG] setTag:thisView.tag];
                        [[item valueForKey:CANVAS_VIEW_GREEN_BG] revertVideoScrollDimensionDataAt:thisView.tag];

                    }
                }
                [thisView setTag:locationTag];
                [thisView revertVideoScrollDimensionDataAt:locationTag];

                break;
            }
         }
    }
    [self resetAllTheTags];
    [UIView animateWithDuration:0.50 animations:^{
        [self displayPlayButtons];

    }];

    [self setTheSelectedView:thisView.tag];
    if([delegate respondsToSelector:@selector(videoPositionsChanged)])
        [delegate videoPositionsChanged];

}


-(void)swapSavedDataUrlsBetweenTag:(NSInteger)tag1 and:(NSInteger)tag2{

    NSURL *tempUrl1;
    NSURL *tempUrl2;
    NSURL *tempRevUrl1;
    NSURL *tempRevUrl2;
    NSNumber *filter1;
    NSNumber *filter2;
    NSNumber *isRev1;
    NSNumber *isRev2;

//    
//    for (NSMutableDictionary *dict in (NSArray*)[SavedData getValueForKey:ARRAY_FRAMES]) {
//        if ([dict valueForKey:kTag] == [NSNumber numberWithInteger:tag1]) {
//            tempUrl1    = [dict valueForKey:kVideoURL];
//            filter1     = [dict valueForKey:kFilter];
//            tempRevUrl1 = [dict valueForKey:kReverseVideoURL];
//            isRev1      = [dict valueForKey:kIsReverse];
//        }
//        if ([dict valueForKey:kTag] == [NSNumber numberWithInteger:tag2]) {
//            tempUrl2    = [dict valueForKey:kVideoURL];
//            filter2     = [dict valueForKey:kFilter];
//            tempRevUrl2 = [dict valueForKey:kReverseVideoURL];
//            isRev2      = [dict valueForKey:kIsReverse];
//        }
//    }
    
    tempUrl1    = [SavedData getVideoURLAtIndex:tag1];
    filter1     = [NSNumber numberWithInt:[SavedData getFilterAtIndex:tag1]];
    tempRevUrl1 = [SavedData getReverseVideoURLAtIndex:tag1];
    isRev1      = [NSNumber numberWithBool:[SavedData getIsReverseTrackAtIndex:tag1]];
    
    tempUrl2    = [SavedData getVideoURLAtIndex:tag2];
    filter2     = [NSNumber numberWithInt:[SavedData getFilterAtIndex:tag2]];
    tempRevUrl2 = [SavedData getReverseVideoURLAtIndex:tag2];
    isRev2      = [NSNumber numberWithBool:[SavedData getIsReverseTrackAtIndex:tag2]];
    
    
    for (NSMutableDictionary *dict in (NSArray*)[SavedData getValueForKey:ARRAY_FRAMES]) {
        if ([dict valueForKey:kTag] == [NSNumber numberWithInteger:tag1]) {
            [dict setObject:tempUrl2 forKey:kVideoURL];
            [dict setObject:filter2 forKey:kFilter];
            [dict setObject:tempRevUrl2 forKey:kReverseVideoURL];
            [dict setObject:isRev2 forKey:kIsReverse];
        }
        if ([dict valueForKey:kTag] == [NSNumber numberWithInteger:tag2]) {
            [dict setObject:tempUrl1 forKey:kVideoURL];
            [dict setObject:filter1 forKey:kFilter];
            [dict setObject:tempRevUrl1 forKey:kReverseVideoURL];
            [dict setObject:isRev1 forKey:kIsReverse];
        }
    }
    
}
-(void)resetAllTheTags{
    for (NSMutableDictionary *views in arrayCanvasView) {
        [[views valueForKey:CANVAS_VIEW_BTN] setTag:[[views valueForKey:CANVAS_VIEW_GREEN_BG] tag]];
        [[views valueForKey:CANVAS_VIEW_GRAY] setTag:[[views valueForKey:CANVAS_VIEW_GREEN_BG] tag]];

    }
}

-(void)transitionTheView:(SPLImageGpuClass *)thisView toLocationWithTag:(int)locationTag{
    
    [thisView scrollViewShouldRevertZoom:thisView];

    for (NSDictionary *items in [SavedData getValueForKey:ARRAY_FRAMES]) {
        if ([[items valueForKey:kTag] integerValue]==locationTag) {
            CGRect rect = [[items valueForKey:kFrames] CGRectValue];
            CGPoint centerPoint1 = CGPointMake(rect.origin.x + (rect.size.width/2), rect.origin.y + (rect.size.height/2));
            // animate
            [UIView animateWithDuration:0.75 animations:^{
                thisView.center = centerPoint1;
                [thisView setFrame:rect];
                [thisView rearrangeSubviews];
            }];
            break;
        }

    }

}
-(int)findClosestFrameTo:(CGPoint)centerPoint{
    CGFloat closest = 1000.0f;
    int tag = 0;
    for (NSDictionary *items in [SavedData getValueForKey:ARRAY_FRAMES]) {
        CGRect rect = [[items valueForKey:kFrames] CGRectValue];
        CGPoint centerPoint1 = CGPointMake(rect.origin.x + (rect.size.width/2), rect.origin.y + (rect.size.height/2));

        CGFloat xDist = (centerPoint1.x - centerPoint.x);
        CGFloat yDist = (centerPoint1.y - centerPoint.y); 
        CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
        if (distance<=closest){
            closest = distance;
            tag = [[items valueForKey:kTag] integerValue];
        }
    }
    return tag;
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer {

    [self stopPlayer];//    [self stopPlayingAllPlayers];
    
    if (delegate)
        if ([delegate respondsToSelector:@selector(addVideoButtondClicked:)]) {
            for (NSDictionary *items in arrayCanvasView) {
                if ([[items valueForKey:CANVAS_VIEW_BTN] tag]==recognizer.view.tag) {
                    [delegate addVideoButtondClicked:[items valueForKey:CANVAS_VIEW_BTN]];
                    break;
                }
            }
        }

}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {

    [self setTheSelectedView:recognizer.view.tag];
}


-(void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer{
    
    NSLog(@"Pinching %d",recognizer.view.tag);
    NSLog(@"latscale = %f",mLastScale);
    
    mCurrentScale += [recognizer scale] - mLastScale;
    mLastScale = [recognizer scale];

    if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        mLastScale = 1.0;
    }
    
    CGAffineTransform currentTransform = CGAffineTransformIdentity;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, mCurrentScale, mCurrentScale);
    recognizer.view.transform = newTransform;
    
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)recognizer{
    [self stopPlayer]; //[self stopPlayingAllPlayers];

    for (NSDictionary *items in arrayCanvasView) {
        if ([[items valueForKey:CANVAS_VIEW_GREEN_BG] tag]==recognizer.view.tag) {
            [self bringSubviewToFront:[items valueForKey:CANVAS_VIEW_GREEN_BG]];
            [self setTheSubViewSequences];
            [self setTheHighlightedView:recognizer.view.tag];
        }
    }
    
    SPLImageGpuClass *view = (SPLImageGpuClass *)recognizer.view;
    
    [view scrollViewShouldRevertZoom:view];
    
    CGPoint point = [recognizer locationInView:view.superview];
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint center = view.center;
        center.x += point.x - _priorPoint.x;
        center.y += point.y - _priorPoint.y;
        view.center = center;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        NSLog(@"UIGestureRecognizerStateEnded");
        
        [self swapMoveTheView:view toLocationWithTag:[self findClosestFrameTo:recognizer.view.center]];
        _priorPoint = CGPointZero;
    }
    _priorPoint = point;
//    NSLog(NSStringFromCGPoint(point));
    
}
-(void)handleLongPressForSequence:(UILongPressGestureRecognizer *)recognizer{
    [self stopPlayer]; //[self stopPlayingAllPlayers];
    [self setTheSubViewSequences];

    UIImageView *view = (UIImageView *)recognizer.view;
    
    
    CGPoint point = [recognizer locationInView:view.superview];
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint center = view.center;
        center.x += point.x - _priorPoint.x;
        center.y += point.y - _priorPoint.y;
        view.center = center;
    }
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        NSLog(@"UIGestureRecognizerStateEnded");
        
        [self swapMoveTheSequenceView:view toLocation:[self findClosestSequenceIndexTo:recognizer.view.center]];
        _priorPoint = CGPointZero;

    }
    _priorPoint = point;
//    NSLog(NSStringFromCGPoint(point));
    
}

-(NSInteger)findClosestSequenceIndexTo:(CGPoint)seqViewCenter{
    CGFloat closest = 1000.0f;
    NSInteger closestIndex=0;
    for (NSDictionary *items in arrayCenterPoints) {
        CGPoint centerPoint1 = [[items valueForKey:kFrameCenter] CGPointValue];
        CGFloat xDist = (centerPoint1.x - seqViewCenter.x);
        CGFloat yDist = (centerPoint1.y - seqViewCenter.y);
        CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));
        if (distance<=closest){
            closest = distance;
            closestIndex = [arrayCenterPoints indexOfObject:items];
        }
    }
    return closestIndex;
    
}

-(void)swapMoveTheSequenceView:(UIImageView *)seqView toLocation:(NSInteger)_index{
    
    NSInteger newIndex = seqView.tag;

    UIImageView *imageView1 = seqView;
    UIImageView *imageView2 = [arraySequences objectAtIndex:_index];
    CGPoint toPoint1 = [[[arrayCenterPoints objectAtIndex:_index] valueForKey:kSequenceCenter] CGPointValue];
    CGPoint toPoint2 = [[[arrayCenterPoints objectAtIndex:newIndex] valueForKey:kSequenceCenter] CGPointValue];
    
    [arraySequences replaceObjectAtIndex:_index withObject:imageView1];
    [arraySequences replaceObjectAtIndex:newIndex withObject:imageView2];
    
    [UIView animateWithDuration:0.75 animations:^{
        imageView1.center = toPoint1;
    } completion:^(BOOL finished) {
        if (finished) {
            NSLog(@"animationcompleted 1");
            [UIView animateWithDuration:0.75 animations:^{
                imageView2.center = toPoint2;
            } completion:^(BOOL finished) {
                if (finished) {
                    NSLog(@"animationcompleted 2");
                    NSLog(@"%d-->%d",_index,newIndex);
                    imageView1.tag = _index;
                    imageView2.tag = newIndex;
                    if([delegate respondsToSelector:@selector(sequenceChangedFrom:to:)])
                        [delegate sequenceChangedFrom:_index to:newIndex];
                }
            }];
        }
    }];
  
}

#pragma mark -
#pragma mark -

-(void)setTheHighlightedView:(NSInteger)viewTag{
    for (NSDictionary *items in arrayCanvasView) {
        if ([[items valueForKey:CANVAS_VIEW_GREEN_BG] tag]==viewTag) {
            [[[items valueForKey:CANVAS_VIEW_GREEN_BG] layer] setBorderColor:[COLOR_RGB(151, 203, 255, 1.0) CGColor]];
        }else
            [[[items valueForKey:CANVAS_VIEW_GREEN_BG] layer] setBorderColor:[[UIColor clearColor] CGColor]];
    }
}

-(void)setTheSelectedView:(NSInteger)viewTag{
        
    for (NSDictionary *items in arrayCanvasView) {
        if ([[items valueForKey:CANVAS_VIEW_GREEN_BG] tag]==viewTag) {
            [[[items valueForKey:CANVAS_VIEW_GREEN_BG] layer] setBorderColor:[[UIColor greenColor] CGColor]];
        }else
            [[[items valueForKey:CANVAS_VIEW_GREEN_BG] layer] setBorderColor:[[UIColor clearColor] CGColor]];
    }
    if (delegate)
        if ([delegate respondsToSelector:@selector(viewSelected:)])
            [delegate viewSelected:viewTag];
   
}

-(void)disableTheGreenBorders{
    for (NSDictionary *items in arrayCanvasView)
        [[[items valueForKey:CANVAS_VIEW_GREEN_BG] layer] setBorderColor:[[UIColor clearColor] CGColor]];
}

#pragma mark -

-(void)shouldDisplayAllSequenceViews:(BOOL)_display{
    for (UIImageView *imgViews in arraySequences) {
        [imgViews setHidden:!_display];
        [imgViews setUserInteractionEnabled:_display];
    }

}

-(void)disableAllSoundButtons:(BOOL)_disable{
    [self displayAllSoundButtons:!_disable];
    [self shouldDisplayAllSequenceViews:_disable];
}
-(void)displayAllSoundButtons:(BOOL)_display{
    for (UIButton *B in arrayButtonSound) {
        [B setHidden:!_display];
    }
}
-(void)hideVideoAddBtns{
    for (UIButton *B in arrayButtonsAdd)
        [B setHidden:YES];

}
-(void)disableVideoAddBtnsWithTag:(NSInteger)btnTag{
    for (NSDictionary *items in arrayCanvasView) {
        if ([[items valueForKey:CANVAS_VIEW_BTN] tag]==btnTag)
            [[arrayPlayButtons objectAtIndex:btnTag] setHidden:NO];
    }
}
-(BOOL)checkAllButtons{
    for (NSDictionary *items in arrayCanvasView) {
        if (![[items valueForKey:CANVAS_VIEW_BTN] isHidden]) {
            return NO;
        }
    }
    return YES;
}

-(void)displayPlayButtons{
    for (NSDictionary *items in [SavedData getValueForKey:ARRAY_FRAMES]) {
        NSString *strUrl =[NSString stringWithFormat:@"%@",[items objectForKey:kVideoURL]];
        if ([strUrl length]>5) {
            [[arrayPlayButtons objectAtIndex:[[items valueForKey:kTag] intValue]] setHidden:NO];
        }else{
            [[arrayPlayButtons objectAtIndex:[[items valueForKey:kTag] intValue]] setHidden:YES];
        }
    }
}

-(void)removeVideoAtTheCanvasWithTag:(int)tagCanvas{
    
}

-(void)setTheSubViewSequences{
    for (id object in arrayButtonSound) {
        [self bringSubviewToFront:object];
    }
    for (id object in arrayPlayButtons) {
        [self bringSubviewToFront:object];
    }
    for (id object in arraySequences) {
        [self bringSubviewToFront:object];
    }
}


#pragma mark - Thums

-(void)addThumbViewImageFor:(NSInteger)_index {
    
    NSURL * videoPath;
    MY_FILTERS selectedFilter;
    
    selectedFilter = [SavedData getFilterAtIndex:_index];
    if ([SavedData getIsReverseTrackAtIndex:_index]) {
        videoPath = [SavedData getReverseVideoURLAtIndex:_index];
    }else{
        videoPath = [SavedData getVideoURLAtIndex:_index];
    }
    
    SPLImageGpuClass * gpuClass;
    for (NSDictionary *items in arrayCanvasView) {
        if ([[items valueForKey:CANVAS_VIEW_GREEN_BG] tag]==_index) {
            gpuClass = [items valueForKey:CANVAS_VIEW_GREEN_BG];
            break;
        }
    }

    [gpuClass.viewThumb setBackgroundColor:[UIColor blackColor]];
    [gpuClass.viewThumb setAlpha:1.0];
    
    SplimageInput *splimageInput = [[SplimageInput alloc] initWithInputUrl:videoPath];
    
    for (NSDictionary *items in [SavedData getValueForKey:ARRAY_FRAMES]) {
        if ([[items valueForKey:kTag] integerValue]==_index) {
            [items setValue:[NSNumber numberWithInteger:[splimageInput orientationForTrack:[AVAsset assetWithURL:videoPath]]] forKey:kRotation];
            break;
        }
    }
    
    [gpuClass setThumbView:[splimageInput imageProcessedUsingGPUFilter: selectedFilter]];
    return;
    
}


-(void)setThumbViewImage:(CGFloat)_alpha forView:(SPLImageGpuClass *)_splImageView{
    [UIView animateWithDuration:1.0 animations:^{
        [_splImageView.viewThumb setAlpha:_alpha];
    }];
}

#pragma mark - Scroll Data


@end
