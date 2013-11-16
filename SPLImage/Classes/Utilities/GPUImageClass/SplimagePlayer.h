//
//  SplimagePlayer.h
//  Splimage
//
//  Created by Girish Rathod on 03/01/13.
//
//

#import "GPUImageMovie.h"
#import "GPUImageView.h"
#import "SplimageInput.h"

@protocol SplimagePlayerDelegate <NSObject>
@optional
-(void)splimagePlayerDidStopPlaying:(NSInteger)playerIndex;
-(void)reverseMovieCompleted:(NSURL *)atPath;
@end

@interface SplimagePlayer : GPUImageMovie{
//   GPUImageFilter * myFilter;
    GPUImageOutput <GPUImageInput> * myFilter;
    SplimageInput *splimageInput;
    GPUImageMovieWriter * movieWriter;
    UIImageView *thumbView;
    BOOL isActualSpeed;
}

@property(nonatomic, assign)id <SplimagePlayerDelegate> delegate;
@property(nonatomic, assign)NSInteger indexPlayer;
@property(nonatomic, assign)NSURL *assetUrl;
@property(nonatomic, assign)GPUImageView *gpuImageView;
@property(nonatomic, assign)MY_FILTERS selectedFilter;
-(void)checkAndRemoveAllTargets;
-(void)getOrientationAndFitting;
-(void)prepareForProcessing;
-(void)endMyProcessing;
-(id)initWithURL:(NSURL *)url;
-(void)setPlayerThumbView;
@end
