//
//  FaceBookLikeViewController.h.m
//  SPLImage
//
//  Created by Girish Rathod on 20/12/12.
//
//

#import "FaceBookLikeViewController.h"

@interface FaceBookLikeViewController ()

@end

@implementation FaceBookLikeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.delegate =self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect screenFrame = [super getScreenFrameForCurrentOrientation];

//    [self likeOnFaceBookClicked];
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navBarPrimary.frame.size.height, screenFrame.size.width, screenFrame.size.height-navBarPrimary.frame.size.height)];
    [webView setDelegate:self];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:FACEBOOK_LIKE_LINK]];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    
    HUD = [[MBProgressHUD alloc] initWithView:webView];
    [webView addSubview:HUD];
//    HUD.labelText = @"Loading";

    
    [btnRightNav setHidden:YES];
    UIImage *backImage = [UIImage imageNamed:@"back_btn"];
    [btnLeftNav setImage:backImage forState:UIControlStateNormal];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)navBarButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UIWEBVIEW DELEGATES

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [HUD show:YES];
    [HUD setHidden:NO];

    NSLog(@"%@",[request.URL description]);
    
        return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [HUD show:YES];
    [HUD setHidden:NO];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [HUD show:NO];
    [HUD setHidden:YES];

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [HUD show:NO];
    [HUD setHidden:YES];
}

#pragma mark - FaceBook

-(void)likeOnFaceBookClicked{
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    
    if (version >= 6) {
        SLComposeViewController *fbController=[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
                
                [fbController dismissViewControllerAnimated:YES completion:nil];
                
                switch(result){
                    case SLComposeViewControllerResultCancelled:
                    default:
                    {
                        
                   //     EVLog(@"Cancelled.....");
                        
                    }
                        break;
                    case SLComposeViewControllerResultDone:
                    {
                  //      EVLog(@"Posted....");
                    }
                        break;
                }};
            
            [fbController setInitialText:@"Check out this article."];
            [fbController addURL:[NSURL URLWithString:FACEBOOK_LIKE_LINK]];
            [fbController setCompletionHandler:completionHandler];
            //        [self presentViewController:fbController animated:YES completion:nil];
        }
    }
    else{
        if (![FBSession.activeSession isOpen]) {
            [FBSession.activeSession openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                if ([session isOpen]) {
                    [self likeAFaceBookPage];
                }
            }];
            
        }
        else
            [self likeAFaceBookPage];
    }
}
-(void)likeAFaceBookPage{
    
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        [connection setUrlRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:FACEBOOK_LIKE_LINK]]];
        if (error) {
            NSLog(@"error");
        }else
            NSLog(@"%@",result);
    }];
    
    
    
}


@end
