//
//  EffectsViewController.m
//  SPLImage
//
//  Created by Girish Rathod on 18/12/12.
//
//

#import "EffectsViewController.h"

@interface EffectsViewController ()

@end


@implementation EffectsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTag:(NSInteger)selectedTag
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
        // Custom initialization
        selectedIndex = selectedTag;
    }
    return self;
}

- (void)viewDidLoad
{
    useSuperButtons = YES;
    [super viewDidLoad];
    UIImage *back = [UIImage imageNamed:@"btn_back"];
    [btnLeftNav setFrame:CGRectMake(9, 5, back.size.width, back.size.height)];
    //[btnLeftNav setImage:back forState:UIControlStateNormal];
    [btnLeftNav setBackgroundImage:back forState:UIControlStateNormal];
    
    //UIImage *effects = [UIImage imageNamed:@"Effects"];
    //[btnCenterNav setFrame:CGRectMake(9, 5, effects.size.width, effects.size.height)];
    //[btnCenterNav setBackgroundImage:effects forState:UIControlStateNormal];
    
    UIImage *goPro = [UIImage imageNamed:@"tabbar_pro"];
    [btnRightNav setFrame:CGRectMake(self.navigationController.navigationBar.frame.size.width - goPro.size.width - 5, 5, goPro.size.width, goPro.size.height)];
    [btnRightNav setImage:goPro forState:UIControlStateNormal];
    
    CGRect screenFrame = [super getScreenFrameForCurrentOrientation];
    
    videoPath = [SavedData getVideoURLAtIndex:selectedIndex];
    arrayFilteredImages = [NSMutableArray array];
    
    SplimageInput *splImageClass = [[SplimageInput alloc] initWithInputUrl:videoPath];
    for (NSInteger i=0; i<[[SavedData getValueForKey:ARRAY_FILTER_NAMES] count]; i++) {
        [arrayFilteredImages addObject:[splImageClass imageProcessedUsingGPUFilter:i]];
    }
    
    UIImage *imgToolBar = [UIImage imageNamed:@"tabbar_bg"];
    toolBarFilters = [[UIToolbar alloc] initWithFrame:CGRectMake(0, screenFrame.size.height-imgToolBar.size.height, screenFrame.size.width , imgToolBar.size.height)];
    [toolBarFilters setBackgroundImage:imgToolBar forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    [self.view addSubview:toolBarFilters];
    
    // Do any additional setup after loading the view from its nib.
    [self setUpToolBarButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CGRect frame = [super getScreenFrameForCurrentOrientation];
    [self adjustFrameBeforeView:frame];
 
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self adjustFrameAfterView];
//    [FlurryAds setAdDelegate:self];
//    [FlurryAds fetchAndDisplayAdForSpace:@"BANNER_MAIN_VIEW" view:self.adView size:BANNER_BOTTOM];
    
    //set selected filter by default
    
 //   [tableFilters selectRowAtIndexPath:[NSIndexPath indexPathForItem:selectedFilter inSection:0] animated:NO  scrollPosition:UITableViewScrollPositionNone ];
  //  [[tableFilters delegate] tableView:tableFilters didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:selectedFilter inSection:0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // add activity indicator here...
    // Dispose of any resources that can be recreated.
}

#pragma mark - SplimagePlayer methods

-(void)loadUpPlayer{
    
    if (splPlayerView) {
        [splPlayerView stopPlayer];
        [splPlayerView removeFromSuperview];
        splPlayerView=nil;
    }
    
    CGRect screenFrame = [super getScreenFrameForCurrentOrientation];

    splPlayerView = [[SplPlayerView alloc] initWithFrame:CGRectMake(5, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height, screenFrame.size.width - 10, screenFrame.size.height - 150) andUrl:videoPath andFiltered:selectedFilter];
    [splPlayerView setTag:selectedIndex];
    [splPlayerView setDelegate:self];
    [splPlayerView addThumbViewImage];
    [self.view addSubview:splPlayerView];
}

-(void)stopPlayer{
    [splPlayerView stopPlayer];
}

-(void)prepareAndPlayThePlayer{
    [self loadUpPlayer];
    [splPlayerView startPlayer];
}

#pragma mark - userFunctions

-(void)btnPlayPauseClicked:(UIButton *)sender{
    [sender setSelected:![sender isSelected]];
    
    if (![sender isSelected]) {
        [self stopPlayer];
    }else{
        [self prepareAndPlayThePlayer];
    }
}


-(void)setUpToolBarButton{
    
    NSMutableArray *arrayBtn = [NSMutableArray arrayWithCapacity:0];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 40;
    
    UIImage *imgBtn = [UIImage imageNamed:@"icon_filter"];
    UIButton * btnFx = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFx setFrame:CGRectMake(25, 5, imgBtn.size.width, imgBtn.size.height)];
    [btnFx setImage:imgBtn forState:UIControlStateNormal];
    [btnFx setTag:INDEX_LEFT];
    [btnFx addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn1 = [[UIBarButtonItem alloc] initWithCustomView:btnFx];
    [arrayBtn addObject:barBtn1];
    
    [arrayBtn addObject:spacer];
    
    UIImage *imgRev = [UIImage imageNamed:@"rev"];
    UIButton * btnRev = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRev setFrame:CGRectMake(25, 5, imgRev.size.width, imgRev.size.height)];
    [btnRev setImage:imgRev forState:UIControlStateNormal];
    [btnRev setTag:INDEX_LEFT_NEXT];
    [btnRev addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btnRev];
    [arrayBtn addObject:barBtn2];
    
    [arrayBtn addObject:spacer];
    
    UIImage *imgFwd = [UIImage imageNamed:@"fwd"];
    UIButton * btnFwd = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFwd setFrame:CGRectMake(30, 5, imgFwd.size.width, imgFwd.size.height)];
    [btnFwd setImage:imgFwd forState:UIControlStateNormal];
    [btnFwd setTag:INDEX_RIGHT_PREVIOUS];
    [btnFwd addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn3 = [[UIBarButtonItem alloc] initWithCustomView:btnFwd];
    [arrayBtn addObject:barBtn3];
    
    [arrayBtn addObject:spacer];

    UIImage *imgCut = [UIImage imageNamed:@"Cut"];
    UIButton * btnCut = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCut setFrame:CGRectMake(70, 5, imgCut.size.width, imgCut.size.height)];
    [btnCut setImage:imgCut forState:UIControlStateNormal];
    [btnCut setTag:INDEX_RIGHT];
    [btnCut addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn4 = [[UIBarButtonItem alloc] initWithCustomView:btnCut];
    [arrayBtn addObject:barBtn4];
    
    [arrayBtn addObject:spacer];
    
    [toolBarFilters setItems:arrayBtn animated:YES];
}

-(void)tabBarButtonClicked:(UIButton *)sender{
    
    [self stopPlayer];
    
    switch ([sender tag]) {
        case INDEX_LEFT:
            NSLog(@"FILTER") ;
            filterViewController  = [[FiltersViewController alloc] initWithNibName:@"FiltersViewController" bundle:nil andTag:selectedIndex];
            [self.navigationController pushViewController:filterViewController animated:YES];
            break;
            
        default:
            goProViewController = [[GoProViewController alloc] initWithNibName:@"GoProViewController" bundle:nil];
            self.view.window.rootViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
            [self presentViewController:goProViewController animated:YES completion:nil];
            break;
    }
}

-(void)setTheFilter{
    [[[SavedData getValueForKey:ARRAY_FRAMES]
      objectAtIndex:selectedIndex]
     setValue:[NSNumber numberWithInt:selectedFilter]
     forKey:kFilter];
}


#pragma mark - table view Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[SavedData getValueForKey:ARRAY_FILTER_NAMES] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SplFilterCell *cell = (SplFilterCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[SplFilterCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:@"Cell"];
    }
    
    [cell setThisFilter:indexPath.row];
    [cell setBtnFilterImage:[arrayFilteredImages objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self stopPlayer];
    selectedFilter = indexPath.row;
    [self loadUpPlayer];
}

#pragma mark- SplPlayerViewDelegate
-(void)splPlayerDidStopPlaying:(NSInteger)playerIndex{
    
}

-(void)navBarButtonClicked:(UIButton *)sender{
    
    if (splPlayerView) {
        [self stopPlayer];
    }
    switch ([sender tag]) {
        case INDEX_LEFT:
            NSLog(@"back");
            if (splPlayerView) {
                [splPlayerView removeFromSuperview];
            }
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case INDEX_RIGHT:
            NSLog(@"go Pro");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/splimage-shoot-it.-splice/id608308710?mt=8"]];
            break;
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
 
    CGRect frame = [super getScreenFrameForOrientation:toInterfaceOrientation];
    [self adjustFrameBeforeView:frame];

}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self adjustFrameAfterView];
}

-(void)adjustFrameBeforeView:(CGRect) frame{
    
    [self layoutTopViewForInterfaceFrame:frame];
    UIImage *imgToolBar = [UIImage imageNamed:@"tabbar_bg"];
    toolBarFilters.frame = CGRectMake(0, frame.size.height-imgToolBar.size.height, frame.size.width , imgToolBar.size.height);
    
    if (splPlayerView) {
        [splPlayerView stopPlayer];
        [splPlayerView removeFromSuperview];
        splPlayerView=nil;
    }
  
}

-(void)adjustFrameAfterView{
    
    [self setUpToolBarButton];
    selectedFilter = [SavedData getFilterAtIndex:selectedIndex];
    [self loadUpPlayer];

}

@end
