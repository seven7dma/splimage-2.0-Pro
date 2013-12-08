//
//  SplPlayerView.m
//  Splimage
//
//  Created by Girish Rathod on 01/02/13.
//
//

#import "SplPlayerView.h"

@implementation SplPlayerView
@synthesize thePlayer;
@synthesize viewVideoArea;
- (id)initWithFrame:(CGRect)frame andUrl:(NSURL *)urlVideo andFiltered:(MY_FILTERS)filterApplied
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        urlPlayerVideo = urlVideo;
        
        myFilter=filterApplied;
        
        myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [myScrollView setScrollEnabled:YES];
        [myScrollView setBounces:NO];
        [myScrollView setShowsHorizontalScrollIndicator:NO];
        [myScrollView setShowsVerticalScrollIndicator:NO];
//        [myScrollView setMinimumZoomScale:1.0];
//        [myScrollView setMaximumZoomScale:4.0];
        [self addSubview:myScrollView];
        
        yourScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        [yourScrollView setScrollEnabled:NO];
        [yourScrollView setUserInteractionEnabled: NO];
        [yourScrollView setBounces:NO];
        [yourScrollView setShowsHorizontalScrollIndicator:NO];
        [yourScrollView setShowsVerticalScrollIndicator:NO];
        [yourScrollView setMinimumZoomScale:1.0];
        [yourScrollView setMaximumZoomScale:4.0];
        [yourScrollView setZoomScale:1.0];
        [yourScrollView setDelegate:self];
        [myScrollView addSubview:yourScrollView];

        
        viewVideoArea = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [viewVideoArea setBackgroundColor:[UIColor grayColor]];
        [yourScrollView addSubview:viewVideoArea];
        
        UIImage * imageButton = [UIImage imageNamed:@"play"];
        UIImage * imageButtonSelected = [UIImage imageNamed:@"play_selected"];
        btnPlayVideo = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnPlayVideo setImage:imageButton forState:UIControlStateNormal];
        [btnPlayVideo setImage:imageButtonSelected forState:UIControlStateSelected];
        [btnPlayVideo setFrame:CGRectMake(10, 10, imageButton.size.width, imageButton.size.height)];
        [btnPlayVideo setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
        [btnPlayVideo addTarget:self action:@selector(btnPlayPauseClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnPlayVideo];
        
    }
    return self;
}

-(void)loadUpPlayerThumb{
    
    thePlayer = [[SplimagePlayer alloc] initWithURL:urlPlayerVideo];
    [thePlayer setIndexPlayer:self.tag];
    [thePlayer setDelegate:self];
  //  [thePlayer setPrepareReverseVideo:NO];
    [thePlayer setSelectedFilter:myFilter];
    [thePlayer setGpuImageView:viewVideoArea];
    [thePlayer getOrientationAndFitting];
    [thePlayer setPlayerThumbView];
}

-(void)loadUpPlayer{
    
    thePlayer = [[SplimagePlayer alloc] initWithURL:urlPlayerVideo];
    [thePlayer setIndexPlayer:self.tag];
    [thePlayer setDelegate:self];
   // [thePlayer setPrepareReverseVideo:NO];
    [thePlayer setSelectedFilter:myFilter];
    [thePlayer setGpuImageView:viewVideoArea];
    [thePlayer getOrientationAndFitting];
    [thePlayer setPlayerThumbView];
}

-(void)startPlayer{
    [self loadUpPlayer];
    [thePlayer prepareForProcessing];
    [thePlayer startProcessing];
    [btnPlayVideo setSelected:YES];
}

-(void)stopPlayer{
    if (thePlayer!=nil) {
        [thePlayer endMyProcessing];
        [thePlayer removeAllTargets];
        [thePlayer setDelegate:nil];
        thePlayer = nil;
    }
    if ([_delegate respondsToSelector:@selector(splPlayerDidStopPlaying:)]) {
        [_delegate splPlayerDidStopPlaying:self.tag];
    }
}

-(void)btnPlayPauseClicked:(UIButton *)sender{
    [sender setSelected:![sender isSelected]];
    
    if (![sender isSelected]) {
        [self stopPlayer];
    }else{
        [self startPlayer];
    }
}
#pragma mark - Splimage Player Delegate
-(void)splimagePlayerDidStopPlaying:(NSInteger)playerIndex{
    if ([btnPlayVideo isSelected]) {
        [self performSelectorOnMainThread:@selector(setUnhidden) withObject:nil waitUntilDone:YES];
    }
}
//-(void)reverseMovieCompleted:(NSURL *)atPath;


#pragma mark - 


-(void)addThumbViewImage{
    
    splimageInput = [[SplimageInput alloc] initWithInputUrl:urlPlayerVideo];
    
    CGFloat sWidth = [SavedData getVisibleRectAtIndex:self.tag].size.width;
    CGFloat sHeight = [SavedData getVisibleRectAtIndex:self.tag].size.height;
    
    CGFloat fWidth = self.frame.size.width;
    CGFloat fHeight =self.frame.size.height;
    
    ratioWidth = fWidth/sWidth;
    ratioHeight = fHeight/sHeight;
    ratioZoom = 1.0f;
    if (fWidth == fHeight){
        if (sWidth>sHeight) {
            fWidth = self.frame.size.width*sWidth/sHeight;
            ratioZoom = ratioHeight;
        }else{
            fHeight= self.frame.size.height*sHeight/sWidth;
            ratioZoom = ratioWidth;
        }
    }else if (fWidth>fHeight){
        fHeight  = sHeight*ratioWidth;
    }else{
        fWidth = sWidth*ratioHeight;
    }
    
    [myScrollView setContentSize:CGSizeMake(fWidth, fHeight)];

    sWidth = [SavedData getWidthAtIndex:self.tag];//thumbImage.size.width;
    sHeight = [SavedData getHeightAtIndex:self.tag];//thumbImage.size.height;
    
    if (fWidth == fHeight){
        if (sWidth>sHeight) {
            fWidth = self.frame.size.width*sWidth/sHeight;
        }else{
            fHeight= self.frame.size.height*sHeight/sWidth;
        }
    }else if (fWidth>fHeight){
        fHeight  = (sHeight*fWidth)/sWidth;
    }else{
        fWidth = sWidth*fHeight/sHeight;
    }

    [yourScrollView setFrame:CGRectMake(0, 0, myScrollView.contentSize.width, myScrollView.contentSize.height)];
    [yourScrollView setContentSize:CGSizeMake(fWidth, fHeight)];
    
    [viewVideoArea setFrame:CGRectMake(0, 0, yourScrollView.contentSize.width, yourScrollView.contentSize.height)];
    [self setZoomAndContentOffset];
    [self loadUpPlayerThumb];

}


-(void)setZoomAndContentOffset{
    CGFloat zScale = [SavedData getZoomScaleAtIndex:self.tag];

    [yourScrollView setZoomScale:zScale];
    
    CGRect visibleRect = [SavedData getVisibleRectAtIndex:self.tag];
    CGFloat xOff = ratioZoom*visibleRect.origin.x;
    CGFloat yOff = ratioZoom*visibleRect.origin.y;
    [yourScrollView setContentOffset:CGPointMake(xOff,yOff)];
     
    [self setScrollViewToCenter];
}

-(void)setScrollViewToCenter{
    float xScroll,yScroll;
    xScroll = (myScrollView.contentSize.width-myScrollView.frame.size.width)/2;
    yScroll = (myScrollView.contentSize.height-myScrollView.frame.size.height)/2;
    CGRect scrollRect = CGRectMake(xScroll, yScroll, myScrollView.frame.size.width, myScrollView.frame.size.height);
    [myScrollView scrollRectToVisible:scrollRect animated:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
        return viewVideoArea;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //    NSLog(@"Scrolling position --- %f",scrollView.frame.origin.x);
    
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //    NSLog(@"Scrolling position === %f",scrollView.frame.origin.x);
    //    [self saveVideoScrollDimensionData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSLog(@"Scrolling position --- %f   %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
   
    
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
  
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    //    NSLog(@"Scrolling position --%f",scrollView.frame.origin.x);
    //    NSLog(@"Scrolling position ---%f",view.frame.origin.x);
}// called before the scroll view begins zooming its content


#pragma mark - User Functions

-(void)setUnhidden{
    [btnPlayVideo setSelected:NO];
}



@end
