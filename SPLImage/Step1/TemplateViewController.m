//
//  TemplateViewController.m
//  SPLImage
//
//  Created by Girish Rathod on 07/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TemplateViewController.h"
#import "SPLSettingViewController.h"

@interface TemplateViewController () {
}
@end

@implementation TemplateViewController
//#define PADDINGHEIGHT 50
#define PADDINGHEIGHT ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 100 : 50 )

//#define PADDINGWIDTH 12
#define PADDINGWIDTH ( (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 60 : 12 )


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    useSuperButtons = YES;
    [super viewDidLoad];
    CGRect frame = [super getScreenFrameForCurrentOrientation];
    scrollTemplateView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navBarPrimary.frame.size.height + 20, frame.size.width , frame.size.height - navBarPrimary.frame.size.height - toolBar.frame.size.height - 20)];
    [scrollTemplateView setPagingEnabled:YES];
    [scrollTemplateView setBackgroundColor:[UIColor clearColor]];
    [scrollTemplateView setShowsHorizontalScrollIndicator:NO];
    [scrollTemplateView setDelegate:self];
    scrollTemplateView.autoresizesSubviews = YES;
    
    [self.view addSubview:scrollTemplateView];
    [self.view bringSubviewToFront:scrollTemplateView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, toolBar.frame.origin.y - 20 , 5, 10)];
    
    [pageControl setCenter:CGPointMake(self.view.center.x, pageControl.center.y)];
    [pageControl setNumberOfPages:2];
    [pageControl setCurrentPage:0];
    [pageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [pageControl setCurrentPageIndicatorTintColor:COLOR_RGB(151, 203, 255, 1.0)];
    [pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:pageControl];
    
    [self setTemplateButtons];
    [self setUpToolBarButton];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    //Delete files in tmp folder
    [SavedData removeAllImportedFiles];
    [self reloadSelfViewForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void) viewDidAppear:(BOOL)animated {

    [super viewDidAppear:YES];
}

#pragma - mark User Functions

-(void)setUpToolBarButton{
    NSMutableArray *arrayBtn = [NSMutableArray arrayWithCapacity:0];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];// UIBarButtonSystemItemFixedSpace
    spacer.width = 600;
    
//    [arrayBtn addObject:spacer];

    UIImage *imgBtn = [UIImage imageNamed:@"tabbar_setting"];
    btnSettings = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSettings setFrame:CGRectMake(25, 5, imgBtn.size.width, imgBtn.size.height)];
    [btnSettings setImage:imgBtn forState:UIControlStateNormal];
    [btnSettings setTag:INDEX_LEFT];
    [btnSettings addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *barBtn1 = [[UIBarButtonItem alloc] initWithCustomView:btnSettings];
    [arrayBtn addObject:barBtn1];

    [arrayBtn addObject:spacer];
    [arrayBtn addObject:spacer];
    [arrayBtn addObject:spacer];
    [arrayBtn addObject:spacer];
    [arrayBtn addObject:spacer];
    [arrayBtn addObject:spacer];

    UIImage *imgStars = [UIImage imageNamed:@"icon-heart-rate"];
    UIButton *btnRateStars = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRateStars setFrame:CGRectMake(100, 5, imgStars.size.width, imgStars.size.height)];
    [btnRateStars setImage:imgStars forState:UIControlStateNormal];
    [btnRateStars setTag:INDEX_RIGHT];
    [btnRateStars addTarget:self action:@selector(tabBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtn2 = [[UIBarButtonItem alloc] initWithCustomView:btnRateStars];
    [arrayBtn addObject:barBtn2];

    [toolBar setItems:arrayBtn animated:YES];

}

-(void)setTemplateButtons{
    
    CGRect frame = [super getScreenFrameForCurrentOrientation];
    
    // calculate the height of scrollview
    CGFloat scrollViewHeight = frame.size.height - navBarPrimary.frame.size.height - toolBar.frame.size.height;
    
    NSInteger buttonNumber =0;
    CGFloat btnWidth = 90;
    CGFloat btnHeight = 90;
    
    if (IS_IPAD) {
        btnWidth = btnHeight = 160;
    }
    
    CGFloat widthPadding = (navBarPrimary.frame.size.width/3 - btnWidth) / 2;
    CGFloat heightPadding = (scrollViewHeight/3 - btnHeight) / 2;

    NSLog(@"width padding :%f heightPadding : %f", widthPadding, heightPadding);
    
    for (NSString *strBtnImage in [self readPlistForImagesArray]) {
        UIImage * btnImage = [UIImage imageNamed:strBtnImage];
        NSInteger buttonNumberOnPage = buttonNumber % 9;
        NSInteger pageNumber = floor(buttonNumber/9);
        NSInteger numberOfwidthPaddings = buttonNumberOnPage % 3;
        NSInteger rowNumber = floor(buttonNumberOnPage/3);
        NSLog(@"button height:%f",btnImage.size.height);
        CGFloat x = (2 * numberOfwidthPaddings + 1)*widthPadding + numberOfwidthPaddings * btnWidth + pageNumber * navBarPrimary.frame.size.width;
        CGFloat y = (2 * rowNumber + 1)*heightPadding + rowNumber*btnHeight;
        [self createButtonsWithImage:btnImage andTag:buttonNumber andPoint:CGRectMake(x,y,btnWidth,btnHeight)];
        buttonNumber++;
        [pageControl setNumberOfPages:pageNumber+1];
        [scrollTemplateView  setContentSize:CGSizeMake(pageControl.numberOfPages * navBarPrimary.frame.size.width, scrollViewHeight)];
    }
}


-(void)resetTemplateButtonsforRotation:(UIInterfaceOrientation) interfaceOrientation{
    
    CGRect frame = [super getScreenFrameForOrientation:interfaceOrientation];
    
    // calculate the height of scrollview
    CGFloat scrollViewHeight = frame.size.height - navBarPrimary.frame.size.height - toolBar.frame.size.height - 20;
    
    NSInteger buttonNumber =0;
    CGFloat btnWidth = 90;
    CGFloat btnHeight = 90;
    
    if (IS_IPAD) {
        btnWidth = btnHeight = 180;
    }
    
    CGFloat widthPadding = (navBarPrimary.frame.size.width/3 - btnWidth) / 2;
    CGFloat heightPadding = (scrollViewHeight/3 - btnHeight) / 2;
    
    NSLog(@"width padding :%f heightPadding : %f", widthPadding, heightPadding);
    
    for (UIView *buttons in scrollTemplateView.subviews) {

        if ( [buttons isKindOfClass:[UIButton class]] ) {
            
            NSInteger buttonNumberOnPage = buttonNumber % 9;
            NSInteger pageNumber = floor(buttonNumber/9);
            NSInteger numberOfwidthPaddings = buttonNumberOnPage % 3;
            NSInteger rowNumber = floor(buttonNumberOnPage/3);
            CGFloat x = (2 * numberOfwidthPaddings + 1)*widthPadding + numberOfwidthPaddings * btnWidth + pageNumber * navBarPrimary.frame.size.width;
            CGFloat y = (2 * rowNumber + 1)*heightPadding + rowNumber*btnHeight;
            buttons.frame = CGRectMake(x,y,btnWidth,btnHeight);
            buttonNumber++;
            [pageControl setNumberOfPages:pageNumber+1];
            [scrollTemplateView  setContentSize:CGSizeMake(pageControl.numberOfPages * navBarPrimary.frame.size.width, scrollViewHeight)];
        }
    }
}


-(void)createButtonsWithImage:(UIImage *)imgBtn andTag:(NSInteger)tagBtn andPoint:(CGRect)btnFrame{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:btnFrame];
    [btn setBackgroundImage:imgBtn forState:UIControlStateNormal];
    [btn setTag:tagBtn];
    [btn addTarget:self action:@selector(patternSelected:) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"array count: %d", [[self readPlistForImagesArray] count]);
    [scrollTemplateView addSubview:btn];
    btn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
}

-(void)patternSelected:(UIButton *)btnPatternSelected{
    
    NSLog(@"pattern selected: %d", btnPatternSelected.tag);
    if (btnPatternSelected.tag == 7) {
        // depic button
        
        if ([[UIApplication sharedApplication]
             canOpenURL:[NSURL URLWithString:@"DePic://"]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"DePic://"]];
        }else if ([[UIApplication sharedApplication]
              canOpenURL:[NSURL URLWithString:@"DePicfree://"]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"DePicfree://"]];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/ag/app/depic-transparent-collage/id694589312?mt=8&ign-mpt=uo%3D2"]];
        }
        return;
    } else {
        patternLayoutView = [[PatternLayoutViewController alloc] initWithNibName:@"PatternLayoutViewController" bundle:nil andTag:[btnPatternSelected tag]];
        [self.navigationController pushViewController:patternLayoutView animated:YES];
    }
}

- (void)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = scrollTemplateView.frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = scrollTemplateView.frame.size;
    [scrollTemplateView scrollRectToVisible:frame animated:YES];
}

#pragma mark - UIScrollView Delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    pageControl.currentPage=page;
}

#pragma mark -

-(void)tabBarButtonClicked:(UIButton *)sender{
    switch ([sender tag]) {
        case INDEX_LEFT:{
 
            SPLSettingViewController *settingsVC = [SPLSettingViewController sharedSettingViewController];
            [self.navigationController pushViewController:settingsVC animated:YES];
            break;
        }
        case INDEX_RIGHT:{
            // EVLog(@"Rate us Btn");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rate Splimage"
                                                            message:@"Having fun with Splimage? \nWe would love to hear from you.\n If you can take a moment to write a 5-star review; we would greatly appreciate it.\n Thank you for your support :-)"
                                                           delegate:self
                                                  cancelButtonTitle:@"Not now"
                                                  otherButtonTitles:@"Rate", nil];
            [alert show];
            break;
        }

        default:
            break;
    }
}


#pragma mark - SPLViewController Delegate
-(void)navBarButtonClicked:(UIButton *)sender{
    switch ([sender tag]) {
        case INDEX_LEFT:
            NSLog(@"Facebook Like Btn");
            [self goToFacebook];
            break;
            
        case INDEX_RIGHT:
            NSLog(@"Instagram follow Btn");
            [self goToInstagram];
            break;

        default:
            break;
    }
}

#pragma mark - Rate Us
-(void)rateUsOnAppStore{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"itms-apps://itunes.apple.com/app/id608308710"]];
}

#pragma amrk -  UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [self rateUsOnAppStore];
            break;

        default:
            break;
    }
}

#pragma amrk -

#pragma mark - SMS

-(void) sendShortMessageService
{
	MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init] ;
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = @"Hey, download Splimage.\n It’s an incredible app that lets you create amazing video collages for FREE!!!\n www.splimage.com";
		controller.messageComposeDelegate = self;
		[self presentViewController:controller animated:YES completion:nil];
	}
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:{
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Unknown Error.\nTry again later." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
			[alertView show];
			break;
        }
		case MessageComposeResultSent:{
            UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Message sent." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
			[alertView show];

			break;
        }
		default:
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Social Media
-(void)goToInstagram{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"instagram://user?username=splimage"]];
}

-(void) goToFacebook{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://facebook.com/SPLIMAGE"]];
}

-(void) goToTwitter{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/SPLIMAGE"]];
}

-(void)twitterFollowButtonTapped{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    twitterAlerMsg = @"Twitter follow operation incomplete";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTwitterAlertMessage:) name:@"twitter" object:nil];

    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            // For the sake of brevity, we'll assume there is only one Twitter account present.
            // You would ideally ask the user which account they want to tweet from, if there is more than one Twitter account present.
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                
                NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
                [tempDict setValue:TWITTER_ID forKey:@"screen_name"];
                [tempDict setValue:@"true" forKey:@"follow"];
                
                //requestForServiceType
                
                SLRequest *postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:[NSURL URLWithString:@"https://api.twitter.com/1/friendships/create.json"] parameters:tempDict];
                [postRequest setAccount:twitterAccount];
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString *output = [NSString stringWithFormat:@"HTTP response status: %i Error %d", [urlResponse statusCode],error.code];
                    NSLog(@"%@error %@", output,error.description);
                    if (error) {
                        twitterAlerMsg = @"Twitter follow operation Failed";
                     }
                    else{
                        twitterAlerMsg =  @"You are following @splimage";

                    }

                    [[NSNotificationCenter defaultCenter] postNotificationName:@"twitter" object:nil];


                }];
            }else{
                //ask user to login to twitter
                twitterAlerMsg = @"Twitter follow operation Failed : Login to twitter first";
               [[NSNotificationCenter defaultCenter] postNotificationName:@"twitter" object:nil];
            }
            
        }else
        {
            //ask user to grant access through twitter
            twitterAlerMsg = @"Twitter follow operation Failed : Twitter Access Denied";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"twitter" object:nil];
        }
    }];
}

-(void)showTwitterAlertMessage:(NSNotification *)notification {
    UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Twitter Alert" message:twitterAlerMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    
    [alertView
     performSelector:@selector(show)
     onThread:[NSThread mainThread]
     withObject:nil
     waitUntilDone:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{

    [self reloadSelfViewForOrientation:toInterfaceOrientation];
}

-(void)reloadSelfViewForOrientation:(UIInterfaceOrientation) orientation {

    CGRect frame = [super getScreenFrameForOrientation:orientation];

    [super layoutTopViewForInterfaceFrame:frame];
    
    // resize scrollview
    scrollTemplateView.frame = CGRectMake(0, navBarPrimary.frame.size.height + 20, frame.size.width , frame.size.height - navBarPrimary.frame.size.height - toolBar.frame.size.height - 20);
    [scrollTemplateView  setContentSize:CGSizeMake(pageControl.numberOfPages * frame.size.width, scrollTemplateView.frame.size.height)];
    
    // layout buttons for new orientation
    
    [self resetTemplateButtonsforRotation:orientation];
}

@end
