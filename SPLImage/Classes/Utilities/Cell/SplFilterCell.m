//
//  SplFilterCell.m
//  Splimage
//
//  Created by Girish Rathod on 09/01/13.
//
//

#import "SplFilterCell.h"

@implementation SplFilterCell

#define BTN_FRAME_SELECTED CGRectMake(10, 14, 67, 67)
#define BTN_FRAME_UNSELECTED CGRectMake(10, 15, 65, 65)

@synthesize thisFilter =_thisFilter;
@synthesize btnFilterImage = _btnFilterImage;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier  
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        btnFilterView = [[UIImageView alloc] initWithFrame:BTN_FRAME_UNSELECTED];
        [btnFilterView setContentMode:UIViewContentModeScaleAspectFill];
        [btnFilterView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:btnFilterView];
        CALayer *imagelayer = [btnFilterView layer];
        [imagelayer setMasksToBounds:YES];
        [imagelayer setCornerRadius:5.0];
        [imagelayer setBorderWidth:4.0];
        [imagelayer setBorderColor:[[UIColor clearColor] CGColor]];
        
        labelFilterName = [[UILabel alloc] initWithFrame:CGRectMake(btnFilterView.frame.origin.x , btnFilterView.frame.origin.y + btnFilterView.frame.size.height+5, btnFilterView.frame.size.width,20)];
        [labelFilterName setBackgroundColor:[UIColor clearColor]];
        [labelFilterName setTextAlignment:NSTextAlignmentCenter];
        [labelFilterName setTextColor:[UIColor grayColor]];
        [labelFilterName setFont:[UIFont boldSystemFontOfSize:11.0]];
        [self addSubview:labelFilterName];
        
        CGAffineTransform rotateTable = CGAffineTransformMakeRotation(M_PI_2);
        self.transform = rotateTable;
        self.frame = CGRectMake(0,self.frame.size.height,self.frame.size.height,self.frame.size.width);
        //[self setBackgroundColor:[UIColor whiteColor]];
        [btnFilterView setCenter:CGPointMake(self.center.y, self.center.x)];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:NO animated:animated];
    // Configure the view for the selected state
    if (selected){
        [[btnFilterView layer] setBorderColor:[[UIColor whiteColor] CGColor]];
        [btnFilterView setFrame:BTN_FRAME_SELECTED];
        //[labelFilterName setTextColor:[UIColor whiteColor]];
    }
    else{
        [[btnFilterView layer] setBorderColor:[[UIColor clearColor] CGColor]];
        [btnFilterView setFrame:BTN_FRAME_UNSELECTED];
        [labelFilterName setTextColor:[UIColor grayColor]];
    }
}

-(void)setThisFilter:(MY_FILTERS )thisFilter{
    [labelFilterName setText:[[SavedData getValueForKey:ARRAY_FILTER_NAMES] objectAtIndex:thisFilter]];
}
-(void)setBtnFilterImage:(UIImage *)btnFilterImage{
    [btnFilterView setImage:btnFilterImage];
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
}
-(void)actionFilterSelected:(id)sender{

}
@end
