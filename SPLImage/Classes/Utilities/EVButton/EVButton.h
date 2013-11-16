//
//  EVButton.h
//  SapnaPDFReaderNew
//
//  Created  on 12/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface EVButton : UIButton
+(EVButton *)buttonWithImage:(NSString *)imageName selectedImage:(NSString *)selectedImage title:(NSString *)title frame:(CGRect)frame andSelector:(SEL)touchUpEvent andTarget:(id)target andTag:(NSInteger)tag;

+(EVButton *)buttonWithImage:(NSString *)imageName highlightImage:(NSString *)selectedImage title:(NSString *)title frame:(CGRect)frame andSelector:(SEL)touchUpEvent andTarget:(id)target andTag:(NSInteger)tag;
@end
