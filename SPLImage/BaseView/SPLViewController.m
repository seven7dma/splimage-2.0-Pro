//
//  SPLViewController.m
//  SPLImage
//
//  Created by Girish Rathod on 07/12/12.
//
//

#import "SPLViewController.h"
@interface SPLViewController ()

@end

@implementation SPLViewController
@synthesize delegate = _delegate;
@synthesize adView, advertView;
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
    UIScreen *screen = [UIScreen mainScreen];
    CGRect screenFrame = [screen applicationFrame];
    NSMutableArray * filtersArray = [NSMutableArray array];
    
    [filtersArray addObject:[GPUImageBrightnessFilter new]];
    [filtersArray addObject:[GPUImageGrayscaleFilter new]];
    [filtersArray addObject:[GPUImagePosterizeFilter new]];
    [filtersArray addObject:[GPUImageToonFilter new]];
    [filtersArray addObject:[GPUImageSobelEdgeDetectionFilter new]];
    [filtersArray addObject:[GPUImageMissEtikateFilter new]];
    
    [filtersArray addObject:[GPUImageColorInvertFilter new]];

    [filtersArray addObject:[GPUImageBrightnessFilter new]];
    [filtersArray addObject:[GPUImageBrightnessFilter new]];
    
    
    [SavedData setValue:filtersArray forKey:ARRAY_FILTERS];

    [SavedData setValue:[NSArray arrayWithObjects:@"No Filter",@"B & W",@"Tsunami", @"300", @"Terminator",@"Mahogany",@"Gamma", @"2X", @"Inebriated", nil] forKey:ARRAY_FILTER_NAMES];
    
    imageViewBaseBg = [[UIImageView alloc] initWithFrame:screenFrame];
    [self.view addSubview:imageViewBaseBg];
    
    UIImage *imgToolBar = [UIImage imageNamed:@"toolbar_bg"];
    toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screenFrame.size.height-imgToolBar.size.height, screenFrame.size.width , imgToolBar.size.height)];
    [toolBar setBackgroundImage:imgToolBar forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    [self.view addSubview:toolBar];
    
    advertView = [[UIView alloc] initWithFrame:CGRectMake(0, toolBar.frame.origin.y - ADVERT_BAR_HEIGHT, screenFrame.size.width, ADVERT_BAR_HEIGHT)];
    [self.view addSubview:advertView];
    
   //testing***
    
    adView = [[MPAdView alloc] initWithAdUnitId:@"fc5187d830f111e2a30712313b12f67e" size:MOPUB_BANNER_SIZE];
    adView.delegate = self;
    [adView loadAd];
    [advertView addSubview:adView];
    [adView refreshAd];

    
    UIImage *imgNavBar = [UIImage imageNamed:@"Navbar"];
    navBarPrimary = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenFrame.size.width, imgNavBar.size.height)];
    [navBarPrimary setBackgroundImage:imgNavBar forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:navBarPrimary];
    
    [self.navigationController.navigationBar setHidden:YES];

    UIImage *imgBtnNav = [UIImage imageNamed:@"fbButton"];
    btnLeftNav = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLeftNav setFrame:CGRectMake(9, 20, imgBtnNav.size.width, imgBtnNav.size.height)];
    [btnLeftNav setTag:INDEX_LEFT];
    [btnLeftNav addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnLeftNav setBackgroundImage:imgBtnNav forState:UIControlStateNormal];
    [navBarPrimary addSubview:btnLeftNav];
    
    imgBtnNav = nil;
    imgBtnNav = [UIImage imageNamed:@"twitterButton"];
    btnRightNav = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRightNav setFrame:CGRectMake(screenFrame.size.width - (imgBtnNav.size.width+9), 10, imgBtnNav.size.width, imgBtnNav.size.height)];
    [btnRightNav setTag:INDEX_RIGHT];
    [btnRightNav addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btnRightNav setImage:imgBtnNav forState:UIControlStateNormal];
    [navBarPrimary addSubview:btnRightNav];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
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
    UIImage *backImage = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"background.png", @"background-568h.png")];
    [imageViewBaseBg setImage:backImage];
    imageViewBaseBg.frame = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    [btnLeftNav setCenter:CGPointMake(btnLeftNav.center.x, navBarPrimary.center.y)];
    [btnRightNav setCenter:CGPointMake(btnRightNav.center.x, navBarPrimary.center.y)];

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

}
- (void)adViewDidLoadAd:(MPAdView *)view{
    
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
