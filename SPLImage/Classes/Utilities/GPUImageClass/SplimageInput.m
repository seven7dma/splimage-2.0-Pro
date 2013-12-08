//
//  SplimageInput.m
//  Splimage
//
//  Created by Girish Rathod on 14/01/13.
//
//

#import "SplimageInput.h"
@implementation SplimageInput

- (id)initWithInputUrl:(NSURL *)assetUrl
{
    self = [super init];
    if (self) {
        // Initialization code
        myUrl = assetUrl;
    }
    return self;
}

-(UIImage *)getImageForSelectedFilter:(GPUImageOutput <GPUImageInput> *)_filter{
    return [_filter imageByFilteringImage:[self getAssetThumbnail]];
}

-(UIImage *)getImageForFilter:(MY_FILTERS)selectedFilter{

    GPUImageOutput <GPUImageInput> * myFilter;// = [[SavedData getValueForKey:ARRAY_FILTERS] objectAtIndex:selectedFilter];
//    [myFilter removeAllTargets];
//    [myFilter endProcessing];
    switch (selectedFilter) {
        case FILTER_LOWPASS:
        case FILTER_2X:
        case FILTER_NONE:
            myFilter = [GPUImageBrightnessFilter new];
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
        case FILTER_MOSAIC:
            myFilter = [GPUImageBrightnessFilter new];
            //myFilter = [GPUImageBrightnessFilter new];
            break;
        case FILTER_ADDNOISE:
            myFilter = [GPUImageBrightnessFilter new];
            //myFilter = [GPUImageBrightnessFilter new];
            break;
        case FILTER_EMBOSS:
            myFilter = [GPUImageEmbossFilter new];
            //myFilter = [GPUImageBrightnessFilter new];
            break;
        case FILTER_TILTSHIFT:
            myFilter = [GPUImageTiltShiftFilter new];
            break;
        case FILTER_SEPIA:
            //myFilter = [GPUImageBrightnessFilter new];
            myFilter = [GPUImageSepiaFilter new]; 
            break;
        default:
            break;
    }
   
    return [myFilter imageByFilteringImage:[self getAssetThumbnail]];

}

- (UIImage *)imageProcessedUsingGPUFilter:(MY_FILTERS)selectedFilter
{
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:[self getAssetThumbnail]];
    
    GPUImageOutput <GPUImageInput> * stillImageFilter;//  = [[SavedData getValueForKey:ARRAY_FILTERS] objectAtIndex:selectedFilter];
    
    switch (selectedFilter) {
        case FILTER_LOWPASS:
        case FILTER_2X:
        case FILTER_NONE:
            stillImageFilter = [GPUImageBrightnessFilter new];
            break;
            
        case FILTER_BLACK_WHITE:
            stillImageFilter = [GPUImageGrayscaleFilter new];
            break;
            
        case FILTER_POSTERIZE:
            stillImageFilter = [GPUImagePosterizeFilter new];
            break;
            
        case FILTER_CARTOON:
            stillImageFilter = [GPUImageToonFilter new];
            break;
           
        case FILTER_SOBELEDGE:
            stillImageFilter = [GPUImageSobelEdgeDetectionFilter new];
            break;
            
        case FILTER_ETIKATE:
            stillImageFilter = [GPUImageMissEtikateFilter new];
            break;
            
        case FILTER_XRAY:
            stillImageFilter = [GPUImageColorInvertFilter new];
            break;
        case FILTER_MOSAIC:
            //stillImageFilter = [GPUImageMosaicFilter new];
            stillImageFilter = [GPUImageBrightnessFilter new];

            break;
            
        case FILTER_ADDNOISE:
            stillImageFilter =  [GPUImagePerlinNoiseFilter new];
            //stillImageFilter = [GPUImageBrightnessFilter new];

            break;
            
        case FILTER_EMBOSS:
            stillImageFilter =  [GPUImageEmbossFilter new];
            //stillImageFilter = [GPUImageBrightnessFilter new];

            break;
            
        case FILTER_TILTSHIFT:
            stillImageFilter = [GPUImageTiltShiftFilter new];
            //stillImageFilter = [GPUImageBrightnessFilter new];

            break;
            
        case FILTER_SEPIA:
            stillImageFilter = [GPUImageSepiaFilter new];
            //stillImageFilter = [GPUImageBrightnessFilter new];

            break;

        default:
            break;
    }
    
    [stillImageFilter prepareForImageCapture];
    [stillImageSource addTarget:stillImageFilter];
    [stillImageSource processImage];
    
    UIImage *currentFilteredVideoFrame = [stillImageFilter imageFromCurrentlyProcessedOutput];
    
    [stillImageFilter endProcessing];
    [stillImageFilter removeAllTargets];
    stillImageFilter = nil;
    [stillImageSource removeAllTargets];
    stillImageSource = nil;
    
    return currentFilteredVideoFrame;
}


-(UIImage *)getAssetThumbnail{
   
    UIImage *theImage = nil;
    
    BOOL isReverse = NO;//[[myUrl absoluteString] rangeOfString:@"Documents"].location!=NSNotFound;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:myUrl options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    NSError *err = NULL;
    
    CMTime time;
    if (!isReverse) {
        time = kCMTimeZero;
    }else{
        time = asset.duration;

    }
    
    CGImageRef imgRef = [generator copyCGImageAtTime:time actualTime:NULL error:&err];
    
    theImage = [[UIImage alloc] initWithCGImage:imgRef] ;
    
    CGImageRelease(imgRef);

    return theImage; //newImage;//
}
static inline double radians (double degrees) {return degrees * M_PI/180;}
-(UIInterfaceOrientation)orientationForTrack:(AVAsset *)asset
{
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize size = [videoTrack naturalSize];
    CGAffineTransform txf = [videoTrack preferredTransform];
    
    if (size.width == txf.tx && size.height == txf.ty)
        return UIInterfaceOrientationLandscapeRight;
    else if (txf.tx == 0 && txf.ty == 0)
        return UIInterfaceOrientationLandscapeLeft;
    else if (txf.tx == 0 && txf.ty == size.width)
        return UIInterfaceOrientationPortraitUpsideDown;
    else
        return UIInterfaceOrientationPortrait;
}


@end
