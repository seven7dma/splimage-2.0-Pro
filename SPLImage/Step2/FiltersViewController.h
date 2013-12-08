//
//  FiltersViewController.h
//  SPLImage
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
@interface FiltersViewController : SPLViewController<SPLViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,SplPlayerViewDelegate,MBProgressHUDDelegate>
{
    UIToolbar *toolBarFilters;
    UITableView *tableFilters;
    NSInteger selectedIndex;
    SplPlayerView *splPlayerView;
    MY_FILTERS selectedFilter;
    
    NSMutableArray *arrayFilteredImages;
    UIImage *imageThumb;
    NSURL *videoPath;
    //MBProgressHUD *HUD;

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTag:(NSInteger)selectedTag;
@end
