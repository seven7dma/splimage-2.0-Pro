//
//  SplimageInput.h
//  Splimage
//
//  Created by Girish Rathod on 14/01/13.
//
//

#import "GPUImageView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SplimageInput : GPUImageView{
    NSURL *myUrl;
}
//- (id)initWithInputUrl:(NSURL *)assetUrl andFilter:(GPUImageOutput <GPUImageInput> *)_filter;

- (id)initWithInputUrl:(NSURL *)assetUrl;
- (UIImage *)getImageForSelectedFilter:(GPUImageOutput <GPUImageInput> *)_filter;

- (UIImage *)imageProcessedUsingGPUFilter:(MY_FILTERS)selectedFilter;
//- (UIImage *)getImageForFilter:(MY_FILTERS)selectedFilter;

- (UIImage *)getAssetThumbnail;

-(UIInterfaceOrientation)orientationForTrack:(AVAsset *)asset;
@end
