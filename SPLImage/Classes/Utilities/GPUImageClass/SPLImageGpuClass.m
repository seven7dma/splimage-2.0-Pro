//
//  SPLImageGpuClass.m
//  SPLImage
//
//  Created by Girish Rathod on 28/12/12.
//
//

#import "SPLImageGpuClass.h"

@implementation SPLImageGpuClass
@synthesize viewGpuImage;
@synthesize btnAddVideo;
@synthesize viewThumb;
@synthesize shouldZoom =_shouldZoom;
@synthesize counter;
#define PADDING 0.3

- (id)initWithFrame:(CGRect)frame andTag:(int)selfTag
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        zScale =[SavedData getZoomScaleAtIndex:selfTag];

        [self setScrollEnabled:YES];
        [self setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
        [self setTag:selfTag];
        [[self layer] setBorderWidth:3.0];
        [[self layer] setBorderColor:[[UIColor clearColor] CGColor]];
        [self setBounces:NO];
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        [self setMaximumZoomScale:4.0];
        [self setMinimumZoomScale:1.0];
        [self setZoomScale:zScale];
        [self setDelegate:self];
        
        myContentView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width*zScale,self.frame.size.height*zScale)];
       // [myContentView setBackgroundColor:[UIColor lightGrayColor]];
        
        [myContentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"canvasForeground"]]];
        [self addSubview:myContentView];
        //myContentView.alpha = 0.5;
        viewGpuImage = [[GPUImageView alloc] initWithFrame:CGRectMake(0,0,myContentView.frame.size.width,myContentView.frame.size.height)];
        [viewGpuImage setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"canvasForeground"]]];
        [viewGpuImage setTag:self.tag];
        [myContentView addSubview:viewGpuImage];

        UIImage *imgBtn = [UIImage imageNamed:@"btn_addphoto"];
        btnAddVideo = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAddVideo setTag:selfTag];
        [btnAddVideo setImage:imgBtn forState:UIControlStateNormal];
        [btnAddVideo setFrame:CGRectMake(10, 10, imgBtn.size.width, imgBtn.size.height)];
        
        [self addSubview:btnAddVideo];
        
        viewThumb = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,myContentView.frame.size.width,myContentView.frame.size.height)];
        [viewThumb setBackgroundColor:[UIColor clearColor]];
        [viewThumb setTag:self.tag];
        [myContentView addSubview:viewThumb ];
        
        [self rearrangeSubviews];
        
        _shouldZoom = YES;
        counter =0;
    }
    return self;
}


-(void)setThumbView:(UIImage *)_image{
//    UIDevice* currentDevice = [UIDevice currentDevice];
   // NSLog(@"image Orientation -------------- %d",_image.imageOrientation);
    UIImage * _imageNew =_image;// [self scaleAndRotateImage:_image];
   // NSLog(@"image Orientation -------------- %d",[currentDevice orientation]);

    [viewThumb setImage:_imageNew];
//    [self setUpInitialFrames];
    
    
    if ([SavedData getShouldRevertAtIndex:self.tag]) {
        counter = 0;
        [self setZoomScale:1.0];
        [[[SavedData getValueForKey:ARRAY_FRAMES] objectAtIndex:self.tag] setValue:[NSNumber numberWithBool:NO] forKey:kShouldRevert];
        [self revertVideoScrollDimensionDataAt:self.tag];
    }
    
    
    if (counter>1) {
        [self setScaleWidthandHeight];
    }else{
        CGFloat imageWidth = _imageNew.size.width;
        CGFloat imageHeight =_imageNew.size.height;
        
        NSLog(@"size Width %f",imageWidth);
        NSLog(@"size height %f",imageHeight);
        
        [[[SavedData getValueForKey:ARRAY_FRAMES] objectAtIndex:self.tag] setValue:[NSNumber numberWithFloat:imageWidth] forKey:kWidth];
        [[[SavedData getValueForKey:ARRAY_FRAMES] objectAtIndex:self.tag] setValue:[NSNumber numberWithFloat:imageHeight] forKey:kHeight];
        
        CGFloat contentWidth = self.contentSize.width;//self.frame.size.width;
        CGFloat contentHeight = self.contentSize.height;//self.frame.size.height;
        
        if (contentWidth == contentHeight){
            if (imageWidth>imageHeight) {
                contentWidth = contentWidth*imageWidth/imageHeight;
            }else{
                contentHeight = contentHeight*imageHeight/imageWidth;
            }
        }else if (contentWidth>contentHeight){
            contentHeight  = (imageHeight*contentWidth)/imageWidth;
        }else{
            contentWidth = imageWidth*contentHeight/imageHeight;
        }
        
        NSLog(@"contentHeight Width ------%f",contentHeight);
        NSLog(@"contentWidth height ------%f",contentWidth);
        
        [self setContentSize:CGSizeMake(contentWidth, contentHeight)];
        [myContentView setFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
        [viewThumb setFrame:CGRectMake(0, 0, myContentView.frame.size.width, myContentView.frame.size.height)];
        [viewGpuImage setFrame:CGRectMake(0, 0, myContentView.frame.size.width, myContentView.frame.size.height)];

        [self setScrollViewToCenter];
    }

   

}
-(void)setScrollViewToCenter{
    [self setZoomScale:zScale animated:NO];
    float xScroll,yScroll;
    xScroll = (self.contentSize.width-self.frame.size.width)/2;
    yScroll = (self.contentSize.height-self.frame.size.height)/2;
    CGRect scrollRect = CGRectMake(xScroll, yScroll, self.frame.size.width, self.frame.size.height);
    [self scrollRectToVisible:scrollRect animated:NO];
    [self saveVideoScrollDimensionData];

}

-(void)setScaleWidthandHeight{

    [self setZoomScale:zScale animated:NO];
    [self saveVideoScrollDimensionData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)rearrangeSubviews
{
    btnAddVideo.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    counter++;

    if (_shouldZoom) {
        return myContentView;
    }

    return nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self saveVideoScrollDimensionData];
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    NSLog(@"Zoom Pinching %f",[scrollView zoomScale]);
//    NSLog(NSStringFromCGSize(self.contentSize));

}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{
    counter++;
    zScale = scale;
    [self saveVideoScrollDimensionData];
}
-(void)scrollViewShouldRevertZoom:(UIScrollView *)scrollView{
    CGAffineTransform transform = CGAffineTransformMakeScale(1,1);
    scrollView.transform = transform;
    [scrollView setZoomScale:1.0 animated:YES];
}


-(void)setShouldZoom:(BOOL)shouldZoom
{
    _shouldZoom=shouldZoom;
    [self setScrollEnabled:shouldZoom];
}


-(void)saveVideoScrollDimensionData{
    
    NSValue *offsetPoint = [NSValue valueWithCGPoint:[self contentOffset]];
    
    CGRect visibleRect = CGRectApplyAffineTransform(self.bounds, CGAffineTransformMakeScale(1.0 / zScale, 1.0 / zScale));
    NSLog(@"self.contentSize ==:> %@",NSStringFromCGSize(self.contentSize));
    NSLog(@"offsetPoint saved: %@",[offsetPoint description]);
    NSLog(@"visibleRect saved: %@",NSStringFromCGRect(visibleRect));
    NSLog(@"Zoom saved: %f",zScale);
    
//       CGFloat xPos = (visibleRect.origin.x/self.contentSize.width)* zScale ;
//       CGFloat yPos = (visibleRect.origin.y/self.contentSize.height)* zScale ;

    CGFloat xPos = (self.contentOffset.x /self.contentSize.width);
    CGFloat yPos = (self.contentOffset.y /self.contentSize.height);

    
    CGFloat ratioWidth = (visibleRect.size.width/self.contentSize.width)* zScale ;
    CGFloat ratioHeight = (visibleRect.size.height/self.contentSize.height)* zScale ;
    
    //Tricky: not quite as we do conventionally
        
//        CGRect cropContent = CGRectMake( xPos, yPos, ratioWidth, ratioHeight);//Portrait
    CGRect cropContent = CGRectMake( yPos, xPos,  ratioHeight,ratioWidth);//LandScape

    NSLog(@"cropContent saved: %@\n-----------",NSStringFromCGRect(cropContent));
    
    for (NSDictionary *item in [SavedData getValueForKey:ARRAY_FRAMES]) {
        if ([[item valueForKey:kTag] integerValue]==self.tag) {
           [item setValue:offsetPoint forKey:kContentOffset];
           [item setValue:[NSNumber numberWithFloat:zScale] forKey:kZoomScale];
            [item setValue:[NSValue valueWithCGRect:visibleRect] forKey:kVisibleRect];
            [item setValue:[NSValue valueWithCGRect:cropContent] forKey:kCropContent];
            break;
        }
    }
    
}


-(void)revertVideoScrollDimensionDataAt:(NSInteger)_index{
    counter =0;
    zScale = 1.0;
    for (NSDictionary *item in [SavedData getValueForKey:ARRAY_FRAMES]) {
        if ([[item valueForKey:kTag] integerValue]==_index) {
            [item setValue:[NSValue valueWithCGPoint:CGPointMake(0, 0)] forKey:kContentOffset];
            [item setValue:[NSNumber numberWithFloat:1.0] forKey:kZoomScale];
//            [item setValue:[NSValue valueWithCGRect:visibleRect] forKey:kVisibleRect];
            [item setValue:[NSValue valueWithCGRect:CGRectMake(0.0, 0.0, 1.0, 1.0)] forKey:kCropContent];
            break;
        }
    }
    [self setUpInitialFramesAt:_index];

}
-(void)setUpInitialFramesAt:(NSInteger)_index{
    NSLog(@"setUpInitialFrames %d",_index);
    CGRect thisFrame = [SavedData getFramesAtIndex:_index];
    [self setFrame:CGRectMake(thisFrame.origin.x +PADDING, thisFrame.origin.y +PADDING, thisFrame.size.width - 2*PADDING, thisFrame.size.height - 2*PADDING)];
    [myContentView setFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    [self setContentSize:CGSizeMake(self.frame.size.width, self.frame.size.height)];
    [viewThumb setFrame:CGRectMake(0, 0, myContentView.frame.size.width, myContentView.frame.size.height)];
    [viewGpuImage setFrame:CGRectMake(0, 0, myContentView.frame.size.width, myContentView.frame.size.height)];

}


- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}
@end
