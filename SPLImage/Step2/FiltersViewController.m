//
//  FiltersViewController.m
//  SPLImage
//
//  Created by Girish Rathod on 18/12/12.
//
//

#import "FiltersViewController.h"

@interface FiltersViewController ()

@property (nonatomic, strong) UITableViewCell *selectedCell;

@end


@implementation FiltersViewController

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
    [btnLeftNav setBackgroundImage:back forState:UIControlStateNormal];
    
    UIImage *done = [UIImage imageNamed:@"btn_done"];
    [btnRightNav setFrame:CGRectMake(self.navigationController.navigationBar.frame.size
                                     .width - done.size.width - 9, 5, done.size.width, done.size.height)];
    [btnRightNav setImage:done forState:UIControlStateNormal];
    
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
    
    tableFilters = [[UITableView alloc] initWithFrame:CGRectMake(0, screenFrame.size.height - FILTER_TABLE_HEIGHT , screenFrame.size.width, FILTER_TABLE_HEIGHT)];
    NSLog(@"adview height : %f",self.adView.frame.size.height);
    //tableFilters.backgroundColor = [UIColor greenColor];
    //[tableFilters setBackgroundColor:[UIColor blackColor]];
    [tableFilters setDelegate:self];
    [tableFilters setDataSource:self];
    [tableFilters setSeparatorColor:[UIColor clearColor]];
    [tableFilters setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:tableFilters];

    CGAffineTransform rotateTable = CGAffineTransformMakeRotation(-M_PI_2);
    tableFilters.transform = rotateTable;
    tableFilters.frame = CGRectMake(0,screenFrame.size.height - FILTER_TABLE_HEIGHT ,tableFilters.frame.size.height,tableFilters.frame.size.width);
    
    // Do any additional setup after loading the view from its nib.
    
    [self setUpToolBarButton];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    selectedFilter = [SavedData getFilterAtIndex:selectedIndex];
 
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
//    [FlurryAds setAdDelegate:self];
//    [FlurryAds fetchAndDisplayAdForSpace:@"BANNER_MAIN_VIEW" view:self.adView size:BANNER_BOTTOM];
    //set selected filter by default

    [tableFilters selectRowAtIndexPath:[NSIndexPath indexPathForItem:selectedFilter inSection:0] animated:NO  scrollPosition:UITableViewScrollPositionNone ];
    [[tableFilters delegate] tableView:tableFilters didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:selectedFilter inSection:0]];
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
    
    splPlayerView = [[SplPlayerView alloc] initWithFrame:CGRectMake(5, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height, screenFrame.size.width - 10, screenFrame.size.height - FILTER_TABLE_HEIGHT - 70) andUrl:videoPath andFiltered:selectedFilter];
    
    [splPlayerView setTag:selectedIndex];
    
    [splPlayerView setDelegate:self];
    [splPlayerView loadUpPlayer];
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
    
    UIBarButtonItem * spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 80;
    
    [arrayBtn addObject:spacer];
    
    UIImage * imgCross = [UIImage imageNamed:@"cancel_icon"];
    UIButton * btnCross = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnCross setFrame:CGRectMake(150, 8, imgCross.size.width, imgCross.size.height)];
    [btnCross setImage:imgCross forState:UIControlStateNormal];
    [btnCross setTag:INDEX_LEFT];
    [btnCross addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    btnCross.tintColor = [UIColor redColor];
    
    UIBarButtonItem *barBtn3 = [[UIBarButtonItem alloc] initWithCustomView:btnCross];
    barBtn3.tintColor = [UIColor redColor];
    [arrayBtn addObject:barBtn3];
    
    [arrayBtn addObject:spacer];
    
    UIImage * imgBtnOk = [UIImage imageNamed:@"accept_icon"];
    UIButton * btnBtnOk = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBtnOk.tintColor = [UIColor greenColor];
    [btnBtnOk setFrame:CGRectMake(CGRectGetMaxX(btnCross.frame), 8, imgBtnOk.size.width, imgBtnOk.size.height)];
    [btnBtnOk setImage:imgBtnOk forState:UIControlStateNormal];
    [btnBtnOk setTag:INDEX_RIGHT];
    [btnBtnOk addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * barBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btnBtnOk];
    barBtn2.tintColor = [UIColor greenColor];
    [arrayBtn addObject:barBtn2];
    
    [arrayBtn addObject:spacer];

    [toolBarFilters setItems:arrayBtn animated:YES];
}

-(void)tabBarButtonClicked:(UIButton *)sender{
   
    [self stopPlayer];
    [splPlayerView removeFromSuperview];
    
    switch ([sender tag]) {
        case INDEX_LEFT:
            NSLog(@"Cancel") ;
            break;
            
        case INDEX_RIGHT:
            [self setTheFilter];
            NSLog(@"OK") ;
            break;
            
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
    if (self.selectedCell) {
        //reset the old selected cell
        self.selectedCell.layer.borderColor = [UIColor clearColor].CGColor;
        self.selectedCell.layer.borderWidth = 0.0f;
    }
    //set new selected cell and border color
    self.selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedCell.layer.borderColor = [UIColor greenColor].CGColor;
    self.selectedCell.layer.borderWidth = 2.0f;
}

#pragma mark- SplPlayerViewDelegate
-(void)splPlayerDidStopPlaying:(NSInteger)playerIndex{
    
}

-(void)navBarButtonClicked:(UIButton *)sender{
    
    if (splPlayerView) {
        [self stopPlayer];
        [splPlayerView removeFromSuperview];
    }
    switch ([sender tag]) {
        case INDEX_LEFT:
            NSLog(@"back");
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case INDEX_RIGHT:
            NSLog(@"Done");
            [self setTheFilter];
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    CGRect frame = [super getScreenFrameForOrientation:toInterfaceOrientation];
    [self adjustFrameBeforeView:frame];
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {

    UIInterfaceOrientation orientation;
    if ( (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) )
        orientation = UIInterfaceOrientationPortrait;
    else
        orientation = UIInterfaceOrientationLandscapeLeft;
    
    CGRect frame = [super getScreenFrameForOrientation:orientation];
    [self adjustFrameAfterView:frame];
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
    [tableFilters removeFromSuperview];
}

-(void)adjustFrameAfterView:(CGRect) frame{
    
    [self setUpToolBarButton];
    
    UIImage *imgToolBar = [UIImage imageNamed:@"tabbar_bg"];
    toolBarFilters.frame = CGRectMake(0, frame.size.height-imgToolBar.size.height, frame.size.width + 88, imgToolBar.size.height);
    
    tableFilters.frame = CGRectMake(0, frame.size.height - FILTER_TABLE_HEIGHT, frame.size.width, FILTER_TABLE_HEIGHT);

    [self.view addSubview:tableFilters];
    selectedFilter = [SavedData getFilterAtIndex:selectedIndex];
    [tableFilters reloadData];

    [tableFilters selectRowAtIndexPath:[NSIndexPath indexPathForItem:selectedFilter inSection:0] animated:NO  scrollPosition:UITableViewScrollPositionNone ];
    [[tableFilters delegate] tableView:tableFilters didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:selectedFilter inSection:0]];

}

@end
