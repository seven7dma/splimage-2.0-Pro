//
//  SPLViewController.h
//  SPLImage
//
//  Created by Girish Rathod on 07/12/12.
//
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@protocol SPLViewControllerDelegate <NSObject>
@optional
-(void)navBarButtonClicked:(UIButton *)sender;
@end


@interface SPLViewController : UIViewController<MPAdViewDelegate,MBProgressHUDDelegate>
{
    UIImageView * imageViewBaseBg;
    UIView *advertView;
    UIToolbar *toolBar;
    UINavigationBar *navBarPrimary;
    UIBarButtonItem *btnLeftNavBar;
    UIButton *btnRightNav;
    UIButton *btnLeftNav;
    MBProgressHUD *HUD;
    MPAdView *adView;

}
@property(nonatomic,assign)id <SPLViewControllerDelegate> delegate;
@property(nonatomic,retain)MPAdView *adView;
@property(nonatomic,retain)UIView *advertView;
-(void)updatePrimaryUI;
-(void)leftBarButtonClicked:(UIButton *)sender;
-(void)rightBarButtonClicked:(UIButton *)sender;
-(NSArray *)getPatternArrayForPattern:(NSInteger)selectedPattern;
-(NSArray *)readPlistForImagesArray;

@end