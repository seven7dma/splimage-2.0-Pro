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
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    NSMutableArray * filtersArray = [NSMutableArray array];
    
    [filtersArray addObject:[GPUImageBrightnessFilter new]];
    [filtersArray addObject:[GPUImageBrightnessFilter new]];
    //[filtersArray addObject:[GPUImageMosaicFilter new]];
    [filtersArray addObject:[GPUImagePerlinNoiseFilter new]];
    [filtersArray addObject:[GPUImageEmbossFilter new]];
    [filtersArray addObject:[GPUImageTiltShiftFilter new]];
    [filtersArray addObject:[GPUImageSepiaFilter new]];
    [filtersArray addObject:[GPUImageGrayscaleFilter new]];
    [filtersArray addObject:[GPUImagePosterizeFilter new]];
    [filtersArray addObject:[GPUImageToonFilter new]];
    [filtersArray addObject:[GPUImageSobelEdgeDetectionFilter new]];
    [filtersArray addObject:[GPUImageMissEtikateFilter new]];
    
    [filtersArray addObject:[GPUImageColorInvertFilter new]];

    [filtersArray addObject:[GPUImageBrightnessFilter new]];
    [filtersArray addObject:[GPUImageBrightnessFilter new]];
    
    
    [SavedData setValue:filtersArray forKey:ARRAY_FILTERS];

    [SavedData setValue:[NSArray arrayWithObjects:@"No Filter",@"Mosaic", @"add noise", @"Emboss", @"Tilt Shift",@"Sepia", @"B & W",@"Tsunami", @"300", @"Electronica",@"Mahogany",@"X-RAY", @"2X", @"Inebriated", nil] forKey:ARRAY_FILTER_NAMES];
    
    imageViewBaseBg = [[UIImageView alloc] initWithFrame:screenFrame];
    [self.view addSubview:imageViewBaseBg];
    
    UIImage *imgToolBar = [UIImage imageNamed:@"tabbar_bg"];
    NSLog(@"tab bar image height:%f",imgToolBar.size.height);
    NSLog(@"screenframe image height:%f",screenFrame.size.height);
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screenFrame.size.height-imgToolBar.size.height, screenFrame.size.width , imgToolBar.size.height)];
    [toolBar setBackgroundImage:imgToolBar forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    [self.view addSubview:toolBar];
    NSLog(@"toolbar height: %f",toolBar.frame.origin.y);
 //   advertView = [[UIView alloc] initWithFrame:CGRectMake(0, toolBar.frame.origin.y - ADVERT_BAR_HEIGHT, screenFrame.size.width, ADVERT_BAR_HEIGHT)];
 //   [self.view addSubview:advertView];
 //   advertView.backgroundColor = [UIColor lightGrayColor];
    
   //testing***
    
    if (self.adView.superview == nil) {
       self.adView = [[MPAdView alloc] initWithAdUnitId:@"5b9fb0e4fdc846a08970907490054507" size:MOPUB_BANNER_SIZE];
        self.adView.delegate = self;
        CGRect frame = self.adView.frame;
        frame.origin.y = toolBar.frame.origin.y - ADVERT_BAR_HEIGHT;
        self.adView.frame = frame;
        [self.view addSubview:self.adView];
        [self.adView loadAd];
        self.adView.backgroundColor = [UIColor lightGrayColor];
        [self.view bringSubviewToFront:self.adView];
    } else {
        [self.adView refreshAd];
    }

    UIImage *imgNavBar = [UIImage imageNamed:@"topbar_bg"];
    navBarPrimary = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,20, screenFrame.size.width, imgNavBar.size.height)];
    [navBarPrimary setBackgroundImage:imgNavBar forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:navBarPrimary];
    
    [self.navigationController.navigationBar setHidden:YES];
    if (useSuperButtons) {
        UIImage *imgBtnNav = [UIImage imageNamed:@"topbar_twitter"];
        btnLeftNav = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnLeftNav setFrame:CGRectMake(9, 5, imgBtnNav.size.width, imgBtnNav.size.height)];
        [btnLeftNav setTag:INDEX_LEFT];
        [btnLeftNav addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnLeftNav setBackgroundImage:imgBtnNav forState:UIControlStateNormal];
        [navBarPrimary addSubview:btnLeftNav];
    
        imgBtnNav = nil;
        imgBtnNav = [UIImage imageNamed:@"topbar_instagram"];
        btnRightNav = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnRightNav setFrame:CGRectMake(screenFrame.size.width - (imgBtnNav.size.width+9), 5, imgBtnNav.size.width, imgBtnNav.size.height)];
        [btnRightNav setTag:INDEX_RIGHT];
        [btnRightNav addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [btnRightNav setImage:imgBtnNav forState:UIControlStateNormal];
        [navBarPrimary addSubview:btnRightNav];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    //  [self updatePrimaryUI];
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
    
   /* _pickerController = [[UIImagePickerController alloc] init];
	_pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
	//_pickerController.delegate = self;
	_pickerController.showsCameraControls = NO;
	_pickerController.allowsEditing = NO;
    _pickerController.wantsFullScreenLayout = YES;
    _pickerController.cameraViewTransform = CGAffineTransformScale(_pickerController.cameraViewTransform, CAMERA_TRANSFORM, CAMERA_TRANSFORM);
	[self.view addSubview:_pickerController.view];
	[self.view sendSubviewToBack:_pickerController.view];

    */
    NSString *imageName =  IS_IPHONE5 ? @"background_iPhone5" : @"background";

    UIImage *backImage = [UIImage imageNamed:imageName];
    [imageViewBaseBg setImage:backImage];
    imageViewBaseBg.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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



@end
