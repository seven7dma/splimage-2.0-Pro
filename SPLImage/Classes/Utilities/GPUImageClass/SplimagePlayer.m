
//
//  SplimagePlayer.m
//  Splimage
//
//  Created by Girish Rathod on 03/01/13.
//
//

#import "SplimagePlayer.h"

@implementation SplimagePlayer
@synthesize delegate =_delegate;
@synthesize indexPlayer = _indexPlayer;
@synthesize assetUrl = _assetUrl;
@synthesize gpuImageView =_gpuImageView;
@synthesize selectedFilter =_selectedFilter;

- (id)initWithURL:(NSURL *)url{
    if (self = [super initWithURL:url]) {
       _selectedFilter = FILTER_NONE;
        _assetUrl = url;
        [self setRunBenchmark:YES];
        splimageInput = [[SplimageInput alloc] initWithInputUrl:url];
    }
    return self;
}

//- (void)readNextVideoFrameFromOutput:(AVAssetReaderTrackOutput *)readerVideoTrackOutput{
//    if (isProcessing) {
//        [super readNextVideoFrameFromOutput:readerVideoTrackOutput];
//    }
//}


//- (void)readNextAudioSampleFromOutput:(AVAssetReaderTrackOutput *)readerAudioTrackOutput{
//    
//}


//- (void)processMovieFrame:(CMSampleBufferRef)movieSampleBuffer{
//    if (isProcessing)
//        [super processMovieFrame:movieSampleBuffer];
//}

-(void)setIndexPlayer:(NSInteger)indexPlayer{
    _indexPlayer = indexPlayer;
}

-(NSInteger)indexPlayer{
    return _indexPlayer;
}
- (void)startProcessing{
    self.playSound = YES;
    [self setPlayAtActualSpeed:YES];
   // [self setPlayAt2XSpeed:!isActualSpeed];
   // super.audioEncodingTarget = [[GPUImageMovieWriter alloc] init];
    [super startProcessing];
}

- (void)endProcessing{
   // [self setEndProcessingForced:YES];
    [self checkAndRemoveAllTargets];
    
    if (_delegate )
        if ([_delegate respondsToSelector:@selector(splimagePlayerDidStopPlaying:)])
            [_delegate splimagePlayerDidStopPlaying:_indexPlayer];
    
}

- (void)endMyProcessing{
    [super endProcessing];
   // [self setEndProcessingForced:YES];
    [self checkAndRemoveAllTargets];

    if (_delegate )
        if ([_delegate respondsToSelector:@selector(splimagePlayerDidStopPlaying:)])
            [_delegate splimagePlayerDidStopPlaying:_indexPlayer];
    
}

-(void)setSelectedFilter:(MY_FILTERS)selectedFilter{
  
    _selectedFilter = selectedFilter;
    
    isActualSpeed = YES;
    switch (selectedFilter) {
            
        case FILTER_NONE:
            myFilter = [GPUImageBrightnessFilter new];
            break;
            
        case FILTER_SKETCH:
            myFilter = [GPUImageSketchFilter new];
            break;
            
        case FILTER_AMATORKA:
            myFilter =  [GPUImageAmatorkaFilter new];
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
            break;
    }
    
}

-(void)setGpuImageView:(GPUImageView *)gpuImageView{
    _gpuImageView = gpuImageView;
}

//_selectedFilter
//_gpuImageView
-(void)setPlayerThumbView{
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:[splimageInput imageProcessedUsingGPUFilter:_selectedFilter] smoothlyScaleOutput:YES];
    [_gpuImageView setFillMode:kGPUImageFillModePreserveAspectRatioAndFill];
    [stillImageSource addTarget:_gpuImageView];
    [stillImageSource processImage];
}
-(void)getOrientationAndFitting{
     [self getForwardFitting ];
}

-(void)getForwardFitting{
    
    switch ([splimageInput orientationForTrack:[AVAsset assetWithURL:_assetUrl]]) {
        case UIInterfaceOrientationPortrait:
            [myFilter setInputRotation:kGPUImageRotateRight atIndex:0];
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            [myFilter setInputRotation:kGPUImageRotateLeft atIndex:0];
            break;
        case UIInterfaceOrientationLandscapeLeft:
            [myFilter setInputRotation:kGPUImageNoRotation atIndex:0];
            break;
        case UIInterfaceOrientationLandscapeRight:
            [myFilter setInputRotation:kGPUImageRotate180 atIndex:0];
            break;
            
        default:
            [myFilter setInputRotation:kGPUImageRotateRight atIndex:0];
            
            break;
    }

}

-(void)prepareForProcessing{
     
    if ([self.targets count]>0){
        [self removeAllTargets];
    }
    if ([myFilter.targets count]>0) {
        [myFilter removeAllTargets];
    }
    
    [myFilter addTarget:_gpuImageView];
    [self addTarget:myFilter];
}

//desperately removing all the possible targets and endProcessing them

-(void)checkAndRemoveAllTargets{
   
//    if([myFilter isKindOfClass:[GPUImageFilterGroup class]])
//    {
//        for (GPUImageFilter * filter in ((GPUImageFilterGroup *)myFilter).initialFilters) {
//            [filter removeAllTargets];
//        }
//    }
    
    if ([self.targets count]>0){
        [self removeAllTargets];
    }
    if ([myFilter.targets count]>0) {
        [myFilter removeAllTargets];
    }
   
    if (_gpuImageView){
        [_gpuImageView endProcessing];
        [myFilter removeTarget:_gpuImageView];
        _gpuImageView =nil;
    }
    if (myFilter) {
        [myFilter endProcessing];
        [self removeTarget:myFilter];
        myFilter = nil;
    }

}

- (void)reverseMovieCompleted:(NSURL *)atPath{
    if (_delegate )
        if ([_delegate respondsToSelector:@selector(reverseMovieCompleted:)])
            [_delegate reverseMovieCompleted:atPath];
}

@end
