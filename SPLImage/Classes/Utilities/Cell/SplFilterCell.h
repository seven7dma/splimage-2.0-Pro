//
//  SplFilterCell.h
//  Splimage
//
//  Created by Girish Rathod on 09/01/13.
//
//

#import <UIKit/UIKit.h>
#import "SplimageInput.h"
@interface SplFilterCell : UITableViewCell{
    UIImageView *btnFilterView;
    UILabel *labelFilterName;
}
@property(nonatomic)MY_FILTERS thisFilter;
@property(nonatomic)UIImage *btnFilterImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
