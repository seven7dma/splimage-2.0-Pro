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
    NSString *nibName =  IS_IPHONE5 ? @"GoProViewController_iPhone5" : @"GoProViewController";
    
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
@end
