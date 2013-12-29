//
//  GoProViewController.m
//  SplImage
//
//  Created by Girish Rathod on 9/11/13.
//  Copyright (c) 2013 Girish Rathod. All rights reserved.
//

#import "GoProViewController.h"

@interface GoProViewController ()

@end

@implementation GoProViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName =  IS_IPAD ? @"GoProViewController_iPad" : @"GoProViewController";
    
    
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = [self getScreenFrameForCurrentOrientation];
    self.view.frame = CGRectMake(0, 0,frame.size.width - 40, frame.size.height - 100);
    self.presentingViewController.view.alpha = 0.4;
    
    self.navigationController.navigationBarHidden = YES;

    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
    self.presentingViewController.view.alpha = 1.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)buyButtonClicked:(id)sender {
    // go pro
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/splimage-shoot-it.-splice/id608308710?mt=8"]];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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

@end
