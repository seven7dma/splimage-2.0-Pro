//
//  SPLSettingViewController.m
//  SplImage
//
//  Created by Nikhil Lele on 8/9/13.
//  Copyright (c) 2013 Nikhil Lele. All rights reserved.
//

#import "SPLSettingViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

//#import "SHKFacebook.h"
//#import "SHKTwitter.h"
//#import "SHKMail.h"
//#import "pianAppDelegate.h"
//#import "Global.h"

@interface SPLSettingViewController ()

@end

@implementation SPLSettingViewController


+(id)sharedSettingViewController{
    NSString *nibName =  IS_IPHONE5 ? @"SPLSettingViewController_iPhone5" : @"SPLSettingViewController";
	return [[SPLSettingViewController alloc] initWithNibName:nibName bundle:nil] ;
}

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
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

-(IBAction)actionBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)actionCustomWaterMark:(id)sender{
 /*   if (_globalData.bCustomWatermark == TRUE) {
        actionWatermark = [[UIActionSheet alloc] initWithTitle:@"Select an Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Library", @"Take Photo",@"Hide Watermark", @"Set Default", nil];
        [actionWatermark showInView:self.view];
//        [actionWatermark release];
    }else{
        actionWatermark = [[UIActionSheet alloc] initWithTitle:@"Select an Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose From Library", @"Take Photo",@"Show Watermark", @"Set Default", nil];
        [actionWatermark showInView:self.view];
//        [actionWatermark release];
    } */
    
}

-(IBAction)actionRestorePurchase:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bit.ly/18yDNQ7"]];
}

-(IBAction)actionRateus:(id)sender{
    
    // EVLog(@"Rate us Btn");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rate Splimage"
                                                    message:@"Having fun with Splimage? \nWe would love to hear from you.\n If you can take a moment to write a 5-star review; we would greatly appreciate it.\n Thank you for your support :-)"
                                                   delegate:self
                                          cancelButtonTitle:@"Not now"
                                          otherButtonTitles:@"Rate", nil];
    [alert show];
 /*   NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa";
    str = [NSString stringWithFormat:@"%@/wa/viewContentsUserReviews?", str];
    str = [NSString stringWithFormat:@"%@type=Purple+Software&id=", str];
    
    // Here is the app id from itunesconnect
    str = [NSString stringWithFormat:@"%@694589312", str];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]]; */
}

-(IBAction)actionShareApplication:(id)sender{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share Application" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Facebook", @"Twitter", @"SMS", @"Email", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex { // the user clicked one of the OK/Cancel buttons
  /*  if (actionSheet == actionWatermark) {
        if (buttonIndex == 1) {
            if ([UIImagePickerController isSourceTypeAvailable:
                 UIImagePickerControllerSourceTypeCamera])
            {
                _backPickerContoller = [[UIImagePickerController alloc] init];
                _backPickerContoller.delegate = self;
                _backPickerContoller.sourceType =UIImagePickerControllerSourceTypeCamera;
                _backPickerContoller.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage,nil];
                _backPickerContoller.allowsEditing = YES;
//                [_backPickerContoller navigationController].
                
                [self navigationController:self.navigationController willShowViewController:_backPickerContoller animated:YES];
                
                [self presentViewController:_backPickerContoller animated:YES completion:nil];
                
            }
        }else if(buttonIndex == 0){
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                _backPickerContoller = [[UIImagePickerController alloc] init] ;
                _backPickerContoller.delegate = self;
                _backPickerContoller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                _backPickerContoller.allowsEditing = TRUE;
                _backPickerContoller.wantsFullScreenLayout = YES;
                [self presentViewController:_backPickerContoller animated:YES completion:nil];
                
            }
        }else if (buttonIndex == 2){
            if (_globalData.bCustomWatermark == TRUE){
  //              _globalData.bCustomWatermark = FALSE;
            }else{
  //              _globalData.bCustomWatermark = TRUE;
            }
        }else if (buttonIndex == 3){
    //        _globalData.waterMark = [UIImage imageNamed:@"watermark_depic.png"];
        }
    }else{
        if (buttonIndex == 0){
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                [controller setInitialText:@"#DePic is an Amazing Transparent Photo Collage App for iOS. Download It FREE Today"];
                [controller addURL:[NSURL URLWithString:@"http://bit.ly/18yDNQ7"]];
                [self presentViewController:controller animated:YES completion:Nil];
            }
        }else if (buttonIndex == 1){
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
            {
                SLComposeViewController *tweetSheet = [SLComposeViewController
                                                       composeViewControllerForServiceType:SLServiceTypeTwitter];
                [tweetSheet setInitialText:@"#DePic is an Amazing Transparent Photo Collage App for iOS. Download It FREE Today"];
                [tweetSheet addURL:[NSURL URLWithString:@"http://bit.ly/18yDNQ7"]];
                [self presentViewController:tweetSheet animated:YES completion:nil];
            }
        }else if(buttonIndex == 2){
        //SHKItem *item = [SHKItem image:mShareImage title:mTextCaption.text];
        
        SHKItem *item = [SHKItem URL:[NSURL URLWithString:@"http://bit.ly/18yDNQ7"] title:@"#DePic is an Amazing Transparent Photo Collage App for iOS. Download It FREE Today" contentType:SHKURLContentTypeWebpage];
        SHKTumblr *sharer = [[SHKTumblr alloc] init] ;
//            SHKTumblr *sharer = [[[SHKTumblr alloc] init] autorelease];
        pianAppDelegate* deleg = (pianAppDelegate*)([UIApplication sharedApplication].delegate);
        sharer.shareDelegate = deleg;
        [sharer loadItem:item];
        [sharer share];
        }
        else if(buttonIndex == 3){
                
            if([MFMessageComposeViewController canSendText]) {
                MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
                picker.messageComposeDelegate = self;
                picker.body = [NSString stringWithFormat:@"#DePic is an Amazing Transparent Photo Collage App for iOS. Download It FREE Today - %@", [NSURL URLWithString:@"http://bit.ly/18yDNQ7"]];
                [self presentViewController:picker animated:YES completion:NULL];
            }
        }else if (buttonIndex == 4){
        
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
                mailer.mailComposeDelegate = self;
                [mailer setSubject:@"DePic"];
                NSArray *toRecipients = [NSArray arrayWithObjects:@"", nil];
                [mailer setToRecipients:toRecipients];
                NSString *emailBody = [NSString stringWithFormat:@"#DePic is an Amazing Transparent Photo Collage App for iOS. Download It FREE Today - %@",[NSURL URLWithString:@"http://bit.ly/18yDNQ7"]];
                [mailer setMessageBody:emailBody isHTML:NO];
                [self presentViewController:mailer animated:TRUE completion:nil];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                            message:@"Your device doesn't support the composer sheet"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
                [alert show];
//                [alert release];
            }
        }
    } */
}

#pragma mark  - mailcomposer delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	NSString *feedbackMsg;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			feedbackMsg = @"Mail sending canceled";
			break;
		case MFMailComposeResultSaved:
			feedbackMsg = @"Mail saved";
			break;
		case MFMailComposeResultSent:
			feedbackMsg = @"Mail sent";
			break;
		case MFMailComposeResultFailed:
			feedbackMsg = @"Mail sending failed";
			break;
		default:
			feedbackMsg = @"Mail not sent";
			break;
	}
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:feedbackMsg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
//    [alert release];
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}

// -------------------------------------------------------------------------------
//	messageComposeViewController:didFinishWithResult:
//  Dismisses the message composition interface when users tap Cancel or Send.
//  Proceeds to update the feedback message field with the result of the
//  operation.
// -------------------------------------------------------------------------------
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
	NSString *feedbackMsg;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
			feedbackMsg = @"SMS sending canceled";
			break;
		case MessageComposeResultSent:
			feedbackMsg = @"SMS sent";
			break;
		case MessageComposeResultFailed:
			feedbackMsg = @"SMS sending failed";
			break;
		default:
			feedbackMsg = @"SMS not sent";
			break;
	}
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:feedbackMsg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
//    [alert release];
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark imagepicker controller delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:Nil];
 //   UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
//    RKCropImageController *cropViewController = [[RKCropImageController alloc] initWithImage:image];
//    cropViewController.delegate = self;
//    [self.navigationController pushViewController:cropViewController animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark cropviewcontroller delegate
-(void) cropImageViewControllerDidFinished:(UIImage*)image // cropped image
{
    [self.navigationController popViewControllerAnimated:YES];
    
    CGFloat factor = 1.0f;
    
    if (image.size.height > 50) {
        factor = 50 / image.size.height;
        image = [self resizeImageToSize:CGSizeMake(image.size.width*factor, image.size.height*factor) image:image];
    }
    if (image.size.width > 300) {
        factor = 300 / image.size.width;
        image = [self resizeImageToSize:CGSizeMake(image.size.width*factor, image.size.height*factor) image:image];
   }
//    _globalData.waterMark = image;
}


- (UIImage *)resizeImageToSize:(CGSize)targetSize image : (UIImage*)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // make image center aligned
        if (widthFactor < heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor > heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(CGSizeMake(scaledWidth, scaledHeight));
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    return newImage ;
}


#pragma amrk -  UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
           // [self rateUsOnAppStore];
            break;
            
        default:
            break;
    }
}

#pragma mark - Rate Us
-(void)rateUsOnAppStore{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=608308710"]];
    
}

@end
