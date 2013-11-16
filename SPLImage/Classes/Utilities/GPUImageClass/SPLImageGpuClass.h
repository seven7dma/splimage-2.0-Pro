//
//  SPLImageGpuClass.h
//  SPLImage
//
//  Created by Girish Rathod on 28/12/12.
//
//

#import <UIKit/UIKit.h>


@interface SPLImageGpuClass : UIScrollView<UIScrollViewDelegate>
{
    GPUImageView *viewGpuImage;
    UIButton *btnAddVideo;
    UIImageView *viewThumb;
    UIView *myContentView;
    int counter;
    float zScale;
}

@property(nonatomic,retain)GPUImageView *viewGpuImage;
@property(nonatomic,retain)UIButton *btnAddVideo;
@property(nonatomic,retain)UIImageView *viewThumb;
@property(nonatomic,assign)BOOL shouldZoom;
@property(readwrite,assign)NSInteger counter;

- (id)initWithFrame:(CGRect)frame andTag:(int)selfTag;
- (void)rearrangeSubviews;
- (void)scrollViewShouldRevertZoom:(UIScrollView *)scrollView;
- (void)setThumbView:(UIImage *)_image;
- (void)setScaleWidthandHeight;
- (void)revertVideoScrollDimensionDataAt:(NSInteger)_index;

@end
