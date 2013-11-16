//
//  SplPlayerView.h
//  Splimage
//
//  Created by Girish Rathod on 01/02/13.
//
//

#import <UIKit/UIKit.h>
#import "SplimagePlayer.h"
#import "SplimageInput.h"

@protocol SplPlayerViewDelegate <NSObject>
-(void)splPlayerDidStopPlaying:(NSInteger)playerIndex;
@end

@interface SplPlayerView : UIView<SplimagePlayerDelegate,UIScrollViewDelegate>{
    UIScrollView *myScrollView;
    UIScrollView *yourScrollView;
    GPUImageView *viewVideoArea;
    SplimagePlayer *thePlayer;
    SplimageInput *splimageInput;
    UIButton *btnPlayVideo;
    NSURL *urlPlayerVideo;
    MY_FILTERS myFilter;
    CGFloat ratioHeight;
    CGFloat ratioWidth;
    CGFloat ratioZoom;
}
@property(nonatomic, assign)id <SplPlayerViewDelegate> delegate;
@property(nonatomic, retain)SplimagePlayer *thePlayer;
@property(nonatomic, retain)GPUImageView *viewVideoArea;
-(id)initWithFrame:(CGRect)frame andUrl:(NSURL *)urlVideo andFiltered:(MY_FILTERS)filterApplied;
-(void)addThumbViewImage;
-(void)loadUpPlayerThumb;
-(void)loadUpPlayer;
-(void)startPlayer;
-(void)stopPlayer;
-(void)setZoomAndContentOffset;

@end
