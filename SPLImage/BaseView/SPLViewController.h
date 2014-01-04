//
//  SPLViewController.h
//  SPLImage
//
//  Created by Girish Rathod on 07/12/12.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "MPAdView.h"
#import "GoProViewController.h"

@protocol SPLViewControllerDelegate <NSObject>
@optional
-(void)navBarButtonClicked:(UIButton *)sender;
@end


@interface SPLViewController : UIViewController<MPAdViewDelegate,MBProgressHUDDelegate,UIImagePickerControllerDelegate>
{
    UIImageView * imageViewBaseBg;
    //UIView *advertView;
    UIToolbar *toolBar;
    UINavigationBar *navBarPrimary;
    UIBarButtonItem *btnLeftNavBar;
    UIButton *btnRightNav;
    UIButton *btnLeftNav;
    UIButton *btnCenterNav;
    BOOL useSuperButtons;
    MBProgressHUD *HUD;
    GoProViewController *goProViewController;
}

@property(nonatomic,assign)id <SPLViewControllerDelegate> delegate;
@property(nonatomic,retain)MPAdView *adView;
//@property(nonatomic,retain)UIView *advertView;
-(void)updatePrimaryUI;
-(void)leftBarButtonClicked:(UIButton *)sender;
-(void)rightBarButtonClicked:(UIButton *)sender;
-(NSArray *)getPatternArrayForPattern:(NSInteger)selectedPattern;
-(NSArray *)readPlistForImagesArray;
- (CGRect)getScreenFrameForCurrentOrientation;
- (CGRect)getScreenFrameForOrientation:(UIInterfaceOrientation)orientation; 
-(void) layoutTopViewForInterfaceFrame: (CGRect) frame; 

@end