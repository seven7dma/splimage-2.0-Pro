//
//  EVButton.m
//  SapnaPDFReaderNew
//
//  Created  on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EVButton.h"

@implementation EVButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void) awakeFromNib
{
    [super awakeFromNib];
//    [EVCommon detectAndSetFontForControl:self.titleLabel];
}

+(EVButton *)buttonWithImage:(NSString *)imageName selectedImage:(NSString *)selectedImage title:(NSString *)title frame:(CGRect)frame andSelector:(SEL)touchUpEvent andTarget:(id)target andTag:(NSInteger)tag
{
    EVButton * evButton;
    if([imageName length] != 0)
        evButton = [EVButton buttonWithType:UIButtonTypeCustom];
    else
        evButton = [EVButton buttonWithType:UIButtonTypeRoundedRect];
    
    UIImage * buttonImage = [UIImage imageNamed:imageName];
    if([[imageName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])
    {
        frame.size = buttonImage.size;
    }
    
    [evButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [evButton setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateSelected];
//    [EVCommon setFontForControl:evButton.titleLabel Font:MyriadWebProBold withSize:12];
    [evButton setTitle:title forState:UIControlStateNormal];
    [evButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [evButton setFrame:frame];
    [evButton setTag:tag];
    [evButton addTarget:target action:touchUpEvent forControlEvents:UIControlEventTouchUpInside];
    return evButton;
}

+(EVButton *)buttonWithImage:(NSString *)imageName highlightImage:(NSString *)selectedImage title:(NSString *)title frame:(CGRect)frame andSelector:(SEL)touchUpEvent andTarget:(id)target andTag:(NSInteger)tag
{
    EVButton * evButton;
    if([imageName length] != 0)
        evButton = [EVButton buttonWithType:UIButtonTypeCustom];
    else
        evButton = [EVButton buttonWithType:UIButtonTypeRoundedRect];
    
    UIImage * buttonImage = [UIImage imageNamed:imageName];
    frame.size = buttonImage.size;
    
    [evButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [evButton setBackgroundImage:[UIImage imageNamed:selectedImage] forState:UIControlStateHighlighted];
//    [EVCommon setFontForControl:evButton.titleLabel Font:[UIFont] withSize:12];
    [evButton setTitle:title forState:UIControlStateNormal];
    [evButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [evButton setFrame:frame];
    [evButton setTag:tag];
    [evButton addTarget:target action:touchUpEvent forControlEvents:UIControlEventTouchUpInside];
    return evButton;
}

@end
