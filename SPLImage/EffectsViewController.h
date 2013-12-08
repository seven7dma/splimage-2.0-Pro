//
//  EffectsViewController.h
//  Splimage
//
//  Created by Girish Rathod on 18/12/12.
//
//
#import <UIKit/UIKit.h>
#import "GPUImageView.h"
#import "SplPlayerView.h"
#import "SplFilterCell.h"
#import "SplimageInput.h"
#import "MBProgressHUD.h"
#import "SPLViewController.h"
#import "FiltersViewController.h"

@interface EffectsViewController : SPLViewController<SPLViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,SplPlayerViewDelegate,MBProgressHUDDelegate>
{
    UIToolbar *toolBarFilters;
    NSInteger selectedIndex;
    SplPlayerView *splPlayerView;
    MY_FILTERS selectedFilter;
    NSMutableArray *arrayFilteredImages;
    UIImage *imageThumb;
    NSURL *videoPath;
    FiltersViewController *filterViewController; 
    //MBProgressHUD *HUD;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTag:(NSInteger)selectedTag;
@end
