//
//  CanvasView.h
//  SPLImage
//
//  Created by Girish Rathod on 12/12/12.
//
//

#import <UIKit/UIKit.h>
#import "SPLImageGpuClass.h"
#import "SplimagePlayer.h"
@protocol CanvasViewDelegate <NSObject>
@optional
-(void)addVideoButtondClicked:(UIButton *)selectedBtn;
-(void)viewSelected:(NSInteger)selectedView;
-(void)sequenceChangedFrom:(NSInteger)seq1 to:(NSInteger)seq2;
-(void)videoPositionsChanged;
@end

@interface CanvasView : UIView<UIScrollViewDelegate,SplimagePlayerDelegate>{
    NSMutableArray *arrayButtonsAdd;
    NSMutableArray *arrayButtonSound;
    NSMutableArray *arrayCenterPoints;
    NSMutableArray *arraySequences;
    NSMutableArray *arrayPlayButtons;
    NSMutableArray *arrayPanGestures;
    
    UITapGestureRecognizer *singleTapGesture;
    UITapGestureRecognizer *doubleTapGestureRecognizer;
    UILongPressGestureRecognizer *longPressGestureRecognizer;
    UIPanGestureRecognizer *panGestureRecognizer;
    UIPinchGestureRecognizer *pinchGestureRecognizer;
    
    CGFloat mLastScale;
    CGFloat mCurrentScale;
    CGPoint _priorPoint;
    SPLImageGpuClass *myScrollView;
    SplimagePlayer *theGpuPlayer;
    
}

@property(nonatomic,retain)NSMutableArray *arrayCanvasView;
@property(nonatomic,assign)id <CanvasViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andPattern:(NSArray *)patternArray andBGImage:(UIImage *)bgImage;
-(void)setTheSelectedView:(NSInteger)viewTag;
-(void)setTheSelectedSounds:(id)sender;
-(void)disableAllSoundButtons:(BOOL)_disable;
-(void)displayAllSoundButtons:(BOOL)_display;
-(void)hideVideoAddBtns;
-(void)disableVideoAddBtnsWithTag:(NSInteger)btnTag;
-(void)handleDoubleTap:(UITapGestureRecognizer *)recognizer;
-(void)handleSingleTap:(UITapGestureRecognizer *)recognizer;
-(void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer;
-(BOOL)checkAllButtons;
-(void)loadSelectedVideosOnView:(NSInteger)viewTag;
-(void)stopPlayer;
-(void)shouldAddAllTheGesture:(BOOL)_shouldAdd;
-(void)shouldAddLongPressGestureRecognizer:(BOOL)_shouldAdd;
-(void)shouldDisplayAllSequenceViews:(BOOL)_display;
-(void)shouldAddSwipeGestureRecognizers:(BOOL)_shouldAdd;
-(void)disableTheGreenBorders;
@end
