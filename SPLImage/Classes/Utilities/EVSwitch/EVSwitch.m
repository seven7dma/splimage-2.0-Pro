//
//  EVSwitch.m
//  SPLImage
//
//  Created by Girish Rathod on 18/12/12.
//
//

#import "EVSwitch.h"

@implementation EVSwitch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self addTarget:self action:@selector(switchChecked:) forControlEvents:UIControlEventValueChanged];

    if (self) {
        // Initialization code
        [self customLayout];

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
-(void) switchChecked:(id) event
{
    switchLayer.backgroundColor=  [self isOn] ? [UIColor greenColor].CGColor : [UIColor redColor].CGColor;
}

-(void) customLayout
{
    switchLayer = [CALayer layer];
    switchLayer.frame = self.frame;
    switchLayer.backgroundColor= [UIColor redColor ].CGColor;

    
    [[self layer] addSublayer:switchLayer];
}

@end
