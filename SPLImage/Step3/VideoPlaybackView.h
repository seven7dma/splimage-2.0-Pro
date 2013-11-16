//
//  VideoPlaybackView.h
//  GPUVideoDemo
//
//  Created by Shwet on 06/11/12.
//  Copyright (c) 2012 Shwet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplimageInput.h"

@protocol VideoPlaybackViewProtocol;
@interface VideoPlaybackView : GPUImageView
{
    GPUImageMovie *movieFile;
    GPUImageMovieWriter *movieWriter;
    GPUImageOutput<GPUImageInput> *myFilter;
    GPUImageCropFilter *cropFilter;
    CGSize originalSize;
    BOOL runActualSpeed;
}
@property (nonatomic, assign) id <VideoPlaybackViewProtocol> delegate;
-(void)loadVideoWithName:(NSURL *)sampleURL andFilter:(MY_FILTERS)_filter andSize:(CGSize)_originalSize andContent:(CGRect)contentRect;
-(void)startRecording;
@end

@protocol VideoPlaybackViewProtocol <NSObject>

-(void)videoCreatedSuccessfully:(VideoPlaybackView *)videoView;

@end
