//
//  SPLViewController.m
//  SPLImage
//
//  Created by Girish Rathod on 07/12/12.
//
//

#import "SPLViewController.h"
#define CAMERA_TRANSFORM   1.12412

@interface SPLViewController () {
    UIImagePickerController *_pickerController;
}
@end

@implementation SPLViewController
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizesSubviews = YES;
    CGRect screenFrame = [self getScreenFrameForCurrentOrientation];
    
    // setup filters
    NSMutableArray * filtersArray = [NSMutableArray array];
    
    [filtersArray addObject:[GPUImageBrightnessFilter new]];
    [filtersArray addObject:[GPUImageSketchFilter new]];
    [filtersArray addObject:[GPUImageAmatorkaFilter new]];
    [filtersArray addObject:[GPUImageEmbossFilter new]];
    [filtersArray addObject:[GPUImageTiltShiftFilter new]];
    [filtersArray addObject:[GPUImageSepiaFilter new]];
    [filtersArray addObject:[GPUImageGrayscaleFilter new]];
    [filtersArray addObject:[GPUImagePosterizeFilter new]];
    [filtersArray addObject:[GPUImageToonFilter new]];
    [filtersArray addObject:[GPUImageSobelEdgeDetectionFilter new]];
    [filtersArray addObject:[GPUImageMissEtikateFilter new]];
    [filtersArray addObject:[GPUImageColorInvertFilter new]];
    
    [SavedData setValue:filtersArray forKey:ARRAY_FILTERS];
//    [SavedData setValue:[NSArray arrayWithObjects:@"No Filter",@"Sketch", @"Amatorka", @"Emboss", @"Tilt Shift",@"Sepia", @"B & W",@"Tsunami", @"300", @"Electronica",@"Mahogany",@"X-RAY", @"2X", @"Inebriated", nil] forKey:ARRAY_FILTER_NAMES];
  
    // only 9 filters in free verson.
    [SavedData setValue:[NSArray arrayWithObjects:@"No Filter",@"Sketch", @"Amatorka", @"Emboss", @"Tilt Shift",@"Sepia", @"B & W",@"Tsunami", @"300", @"Electronica",@"Mahogany",@"X-RAY", nil] forKey:ARRAY_FILTER_NAMES];
    
    // setup background Image
    imageViewBaseBg = [[UIImageView alloc] initWithFrame:screenFrame];
    [self.view addSubview:imageViewBaseBg];
    
    // setup toolbar image
    UIImage *imgToolBar = [UIImage imageNamed:@"tabbar_bg"];
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screenFrame.size.height-imgToolBar.size.height, screenFrame.size.width , imgToolBar.size.height)];
    [toolBar setBackgroundImage:imgToolBar forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    [self.view addSubview:toolBar];
    
    UIImage *imgNavBar = [UIImage imageNamed:@"topbar_bg"];
    navBarPrimary = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,20, screenFrame.size.width, imgNavBar.size.height)];
    [navBarPrimary setBackgroundImage:imgNavBar forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:navBarPrimary];
    
    [self.navigationController.navigationBar setHidden:YES];
    if (useSuperButtons) {
        UIImage *imgBtnNav = [UIImage imageNamed:@"icon-facebook"];
        btnLeftNav = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnLeftNav setFrame:CGRectMake(15, 5, imgBtnNav.size.width + 10, imgBtnNav.size.height)];
        [btnLeftNav setTag:INDEX_LEFT];
        [btnLeftNav addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnLeftNav setBackgroundImage:imgBtnNav forState:UIControlStateNormal];
        btnLeftNav.contentMode = UIViewContentModeScaleAspectFit;
        [navBarPrimary addSubview:btnLeftNav];
        
        imgBtnNav = nil;
        imgBtnNav = [UIImage imageNamed:@"topbar_instagram"];
        btnRightNav = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnRightNav setFrame:CGRectMake(screenFrame.size.width - imgBtnNav.size.width - 10, 5, imgBtnNav.size.width + 15, imgBtnNav.size.height + 15)];
        [btnRightNav setTag:INDEX_RIGHT];
        [btnRightNav addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnRightNav setImage:imgBtnNav forState:UIControlStateNormal];
        
        [navBarPrimary addSubview:btnRightNav];
        
        if (IS_IPAD)
            imgBtnNav = [UIImage imageNamed:@"SplImageBrandiPad"];
        else
            imgBtnNav = [UIImage imageNamed:@"splImageBrandiPhone"];
        
        btnCenterNav = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnCenterNav setFrame:CGRectMake(screenFrame.size.width/2 - imgBtnNav.size.width/2, 5, imgBtnNav.size.width, imgBtnNav.size.height)];
        [btnCenterNav addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnCenterNav setImage:imgBtnNav forState:UIControlStateNormal];
        btnCenterNav.userInteractionEnabled = NO;
        [navBarPrimary addSubview:btnCenterNav];
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [self updatePrimaryUI];
}

-(void)leftBarButtonClicked:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(navBarButtonClicked:)]) {
        [_delegate navBarButtonClicked:sender];
    }
}


-(void)rightBarButtonClicked:(UIButton *)sender
{
    if ([self  respondsToSelector:@selector(navBarButtonClicked:)]) {
        [_delegate navBarButtonClicked:sender];
    }
}


-(void) updatePrimaryUI
{
    CGRect screenFrame = [self getScreenFrameForCurrentOrientation];
    NSString *imageName = @"background";
    UIImage *backImage = [UIImage imageNamed:imageName];
    [imageViewBaseBg setImage:backImage];
    imageViewBaseBg.frame = CGRectMake(0, 0, screenFrame.size.width, screenFrame.size.height);
    imageViewBaseBg.autoresizesSubviews = YES;
    imageViewBaseBg.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


#pragma mark MPAdViewDelegate Methods

- (UIViewController *)viewControllerForPresentingModalView
{
    if (self)
        return self;
    return nil;
}

- (void)adViewDidFailToLoadAd:(MPAdView *)view{
    NSLog(@"Failed to load add");
}

- (void)adViewDidLoadAd:(MPAdView *)view{
    NSLog(@"did load ad");
}

#pragma mark - Read Plist

-(NSArray *)getPatternArrayForPattern:(NSInteger)selectedPattern{
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"Tag == %d",selectedPattern];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Templates" ofType:@"plist"];
    NSArray *arrayPlist = [NSArray arrayWithContentsOfFile:plistPath];
    return [[[arrayPlist filteredArrayUsingPredicate:predicate] valueForKey:@"Pattern"] objectAtIndex:0];
}

-(NSArray *)readPlistForImagesArray{
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"Templates" ofType:@"plist"];
    NSArray *arrayPlist = [NSArray arrayWithContentsOfFile:plistPath];
    
    NSMutableArray *arrayOfImages = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dict in arrayPlist) {
        [arrayOfImages addObject:[dict valueForKey:@"Image"]];
    }
    return arrayOfImages;
}

#pragma screen convenience methods 

- (CGRect)getScreenFrameForCurrentOrientation {
    return [self getScreenFrameForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (CGRect)getScreenFrameForOrientation:(UIInterfaceOrientation)orientation {
    
    UIScreen *screen = [UIScreen mainScreen];
    CGRect fullScreenRect = screen.bounds;
    BOOL statusBarHidden = [UIApplication sharedApplication].statusBarHidden;
    
    //implicitly in Portrait orientation.
    if(orientation == UIInterfaceOrientationLandscapeRight || orientation == UIInterfaceOrientationLandscapeLeft){
        CGRect temp = CGRectZero;
        temp.size.width = fullScreenRect.size.height;
        temp.size.height = fullScreenRect.size.width;
        fullScreenRect = temp;
    }
    
    if(!statusBarHidden){
     //   CGFloat statusBarHeight = 20;//Needs a better solution, FYI statusBarFrame reports wrong in some cases..
     //   fullScreenRect.size.height -= statusBarHeight;
    }
    
    return fullScreenRect;
}

-(void) layoutTopViewForInterfaceFrame: (CGRect) frame{

    // resize navigation bar
    CGRect navBarFrame = navBarPrimary.frame;
    navBarPrimary.frame = CGRectMake(0, 20, frame.size.width, navBarFrame.size.height);
    
    // resize instagram button
    UIImage *imgBtnNav = btnRightNav.imageView.image;
    btnRightNav.frame = CGRectMake(frame.size.width - (imgBtnNav.size.width+9), 5, imgBtnNav.size.width, imgBtnNav.size.height);
    
    // resize splimage icon
    imgBtnNav = btnCenterNav.imageView.image;
    btnCenterNav.frame = CGRectMake(frame.size.width/2 - imgBtnNav.size.width/2, 5, imgBtnNav.size.width, imgBtnNav.size.height);

    // resize toolbar
    UIImage *imgToolBar = [UIImage imageNamed:@"tabbar_bg"];
    toolBar.frame = CGRectMake(0, frame.size.height- imgToolBar.size.height, frame.size.width , imgToolBar.size.height);
    
}

@end
