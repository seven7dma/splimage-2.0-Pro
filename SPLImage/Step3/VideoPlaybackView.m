
//  VideoPlaybackView.m
//  GPUVideoDemo
//
//  Created by Shwet on 06/11/12.
//  Copyright (c) 2012 Shwet. All rights reserved.
//

#import "VideoPlaybackView.h"
@implementation VideoPlaybackView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)

-(void)getForwardFitting:(NSURL *)sampleURL{
    
    SplimageInput *splimageInput=[[SplimageInput alloc] initWithInputUrl:sampleURL];
    switch ([splimageInput orientationForTrack:[AVAsset assetWithURL:sampleURL]]) {
        case UIInterfaceOrientationPortrait:
            [self setFillMode:kGPUImageFillModePreserveAspectRatio];
            [myFilter setInputRotation:kGPUImageRotateRight atIndex:0];
//            [cropFilter setInputRotation:kGPUImageRotateRight atIndex:0];//kGPUImageRotateLeft//kGPUImageNoRotation//kGPUImageRotate180//kGPUImageRotateRight

            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            [self setFillMode:kGPUImageFillModePreserveAspectRatio];
            [myFilter setInputRotation:kGPUImageRotateLeft atIndex:0];
//            [cropFilter setInputRotation:kGPUImageRotateLeft atIndex:0];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [self setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
            [myFilter setInputRotation:kGPUImageNoRotation atIndex:0];
//            [cropFilter setInputRotation:kGPUImageNoRotation atIndex:0];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [self setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
            [myFilter setInputRotation:kGPUImageRotate180 atIndex:0];
//            [cropFilter setInputRotation:kGPUImageRotate180 atIndex:0];
            break;
        default:
            [self setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
            [myFilter setInputRotation:kGPUImageRotateRight atIndex:0];
//            [cropFilter setInputRotation:kGPUImageNoRotation atIndex:0];
            break;
    }
}

-(void)setSelectedFilter:(MY_FILTERS)selectedFilter{
    runActualSpeed = YES;
    switch (selectedFilter) {
            
        case FILTER_NONE:
            myFilter = [GPUImageBrightnessFilter new];
            break;
        case FILTER_SKETCH:
            myFilter = [GPUImageSketchFilter new];
            break;
            
        case FILTER_ADDNOISE:
            myFilter =  [GPUImagePerlinNoiseFilter new];
            break;
            
        case FILTER_EMBOSS:
            myFilter =  [GPUImageEmbossFilter new];
            break;
            
        case FILTER_TILTSHIFT:
            myFilter = [GPUImageTiltShiftFilter new];
            break;
            
        case FILTER_SEPIA:
            myFilter = [GPUImageSepiaFilter new];
            break;
            
        case FILTER_BLACK_WHITE:
            myFilter = [GPUImageGrayscaleFilter new];
            break;
            
        case FILTER_POSTERIZE:
            myFilter = [GPUImagePosterizeFilter new];
            break;
            
        case FILTER_CARTOON:
            myFilter = [GPUImageToonFilter new];
            break;
            
        case FILTER_SOBELEDGE:
            myFilter = [GPUImageSobelEdgeDetectionFilter new];
            break;
            
        case FILTER_ETIKATE:
            myFilter = [GPUImageMissEtikateFilter new];
            break;
            
        case FILTER_XRAY:
            myFilter = [GPUImageColorInvertFilter new];
            break;
            
        default:
            myFilter = [GPUImageBrightnessFilter new];
            break;
    }
}

-(void)loadVideoWithName:(NSURL *)sampleURL andFilter:(MY_FILTERS)_filter andSize:(CGSize)_originalSize andContent:(CGRect)contentRect
{
    [self setSelectedFilter:_filter];

    originalSize =_originalSize;
    
    movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL ];
    movieFile.runBenchmark = YES;
    movieFile.playAtActualSpeed = YES;
 //   movieFile.playAt2XSpeed = !runActualSpeed;
    //fix crash when contentsize grows > 1.0
    contentRect = CGRectMake(0, 0, 1, 1);
    cropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:contentRect];

    [self getForwardFitting:sampleURL];
  
    [myFilter addTarget:self atTextureLocation:0]; //atTextureLocation:1
    [cropFilter addTarget:myFilter atTextureLocation:0];
    [movieFile addTarget:cropFilter atTextureLocation:0];
    

//    GPUImageView *filterView = (GPUImageView *)self;
    
    // In addition to displaying to the screen, write out a processed version of the movie to disk
}

-(void)startRecording
{
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/Movie%d.m4v",self.tag]];
    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:originalSize ];
   // movieWriter.playAt2XSpeed = !runActualSpeed;

    [myFilter addTarget:movieWriter];
    
    // Configure this for video from the movie file, where we want to preserve all video frames and audio samples
    movieFile.playSound = NO;
    [movieFile setPlayAtActualSpeed:YES];
    movieWriter.shouldPassthroughAudio = YES;
    movieFile.audioEncodingTarget = movieWriter;
    [movieFile enableSynchronizedEncodingUsingMovieWriter:movieWriter];

    [movieWriter startRecording];
    [movieFile startProcessing];

    __weak VideoPlaybackView *self_ = self;
    [movieWriter setCompletionBlock:^{
        [self_ finishedWritingVideo];
    }];
}

-(void)finishedWritingVideo{
    
    if([myFilter isKindOfClass:[GPUImageFilterGroup class]])
    {
        for (GPUImageFilter * filter in ((GPUImageFilterGroup *)myFilter).initialFilters) {
            [filter removeAllTargets];
        }
    }

    
    if ([movieFile.targets count]>0){
        [movieFile removeAllTargets];
    }
    if ([myFilter.targets count]>0) {
        [myFilter removeAllTargets];
    }
//    myFilter=nil;
    
    [movieWriter finishRecording];
    
    [_delegate videoCreatedSuccessfully:self];
    _delegate = nil;
    movieWriter.completionBlock = nil;
    movieWriter = nil;

}

@end
