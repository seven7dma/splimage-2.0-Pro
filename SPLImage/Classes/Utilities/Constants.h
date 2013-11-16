//
//  Constants.h
//  SPLImage
//
//  Created  on 07/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef SPLImage_Constants_h
#define SPLImage_Constants_h

#define ADVERT_BAR_HEIGHT 50.0


typedef enum
{
    INDEX_LEFT,
    INDEX_RIGHT,
    INDEX_LEFT_NEXT,
    INDEX_RIGHT_PREVIOUS,
} MY_NAV_INDEX;

typedef enum
{
    SAVE_DELETE,
    START_STOP,
    SUCCESS_FAIL,
    OK_CANCEL,
    LOGIN_ALERT,
} MY_ALERT_TYPES;


typedef enum
{
    FILTER_NONE,
    FILTER_BLACK_WHITE,
    FILTER_POSTERIZE,
    FILTER_CARTOON,
    FILTER_SOBELEDGE,
    FILTER_ETIKATE,
    FILTER_XRAY,
    FILTER_2X,
    FILTER_LOWPASS,
} MY_FILTERS;


#define XRAY_FILTER [GPUImageColorInvertFilter new]


#define NAVIGATION_CONTROLLER YES //Switches the ViewController using Navigation else using PresentModal

#define COLOR_RGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]


#define FACEBOOK_URL    [NSURL URLWithString:@"https://www.facebook.com"]
#define TWITTER_URL     [NSURL URLWithString:@"https://twitter.com"]
#define FACEBOOK_LIKE_LINK @"http://www.facebook.com/Splimage"




//@girishvr


#define TWITTER_ID @"splimage"

#define FACEBOOK_LIKE_URL @"http://www.facebook.com/plugins/like.php?href=http%3A%2F%2Fwww.facebook.com%2FSplimage&send=false&layout=standard&width=450&show_faces=false&font=arial&colorscheme=light&action=like&height=35&appId=125324237628173"

#define FACEBOOK_APP_ID         @"125324237628173"
#define FACEBOOK_APP_SECRET 	@"c28ab8eb6f25466d9374acf377b93706"




#define ASSET_BY_SCREEN_HEIGHT(regular, longScreen) (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? regular : longScreen)
#define isPhone568 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568)
#define iPhone568ImageNamed(image) (isPhone568 ? [NSString stringWithFormat:@"%@-568h", image] : image)
#define iPhone568Image(image) ([UIImage imageNamed:iPhone568ImageNamed(image)])

//Keys for dictionaries

#define CANVAS_VIEW_GREEN_BG    @"viewBG"
#define CANVAS_VIEW_GRAY        @"view"
#define CANVAS_VIEW_BTN         @"plusButtons"
#define CANVAS_VIEW_PLAY_BTN    @"playButtons"

#define COORDINATE_X            @"CoordinateX"
#define COORDINATE_Y            @"CoordinateY"
#define WIDTH                   @"Width"
#define HEIGHT                  @"Height"

// Saved Data keys

#define SELECTED_PATTERN    @"selectedPattern"
#define ARRAY_FRAMES        @"arrayFrames"
#define ARRAY_FILTERS       @"arrayFilters"
#define ARRAY_FILTER_NAMES  @"arrayFilterNames"
#define ARRAY_PATTERN       @"patternArray"

#define kFrames                 @"frames"
#define kTag                    @"tag"
#define kVideoURL               @"videoUrl"
#define kReverseVideoURL        @"reverseVideoUrl"
#define kFilter                 @"filter"
#define kLength                 @"movieLength"
#define kIsReverse              @"isReverse"
#define kSequence               @"sequence"
#define kIsMute                 @"isMute"
#define kWidth                  @"width"
#define kHeight                 @"height"
#define kRotation               @"rotation"
#define kContentOffset          @"contentOffset"
#define kZoomScale              @"zoomScale"
#define kVisibleRect            @"visibleRect"
#define kCropContent            @"cropContent"

#define kShouldRevert           @"kShouldRevert"

#define kIsFast                 @"isFast"

//center Array
#define kSequenceCenter               @"centerSequence"
#define kFrameCenter                  @"centerFrame"

#define VIDEO_VIEW_HEIGHT 320
#define VIDEO_MAX_DURATION 10.0

//keys and accesses

#define GOOGLE_DEVELOPER_KEY @"AI39si5FPIAmeKQDOiE9ZkWv9DdrZoFylGl91hO7ownZRp1y38KL9Ru_klGbETgISh8Ns1kOZsyNeRhskk9i_13XT--X9KTiDA"

#endif
