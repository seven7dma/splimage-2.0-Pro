//
//  SavedData.h
//  SPLImage
//
//  Created by Girish Rathod on 26/12/12.
//
//

#import <Foundation/Foundation.h>

@interface SavedData : NSObject

+(void)setValue:(id)value forKey:(NSString *)key;
+(id)getValueForKey:(NSString *)key;
+(void)getAllTheValues;
+(void)removeAllImportedFiles;
+(void)removeFileAtPath:(NSString*)path;

+(void)removePreviousDataAtIndex:(NSInteger)_index;
+(BOOL)isReverseVideoAvalableAtSelectedPosition:(NSInteger )position;
+(BOOL)isVideoAvalableAtSelectedPosition:(NSInteger )position;


//Frames
+(CGRect)getFramesAtIndex:(NSInteger)tagIndex;
//Tag
+(NSInteger)getTagAtIndex:(NSInteger)tagIndex;
//VideoURL
+(NSURL *)getVideoURLAtIndex:(NSInteger)tagIndex;
//ReverseVideoURL
+(NSURL *)getReverseVideoURLAtIndex:(NSInteger)tagIndex;
//Filter
+(MY_FILTERS)getFilterAtIndex:(NSInteger)tagIndex;
//Length
+(CGFloat)getTrackLengthAtIndex:(NSInteger)tagIndex;
//IsReverse
+(BOOL)getIsReverseTrackAtIndex:(NSInteger)tagIndex;
//Sequence
+(NSInteger)getSequenceAtIndex:(NSInteger)tagIndex;
//IsMute
+(BOOL)getIsTrackMuteAtIndex:(NSInteger)tagIndex;
//Width
+(CGFloat)getWidthAtIndex:(NSInteger)tagIndex;
//Height
+(CGFloat)getHeightAtIndex:(NSInteger)tagIndex;
//Rotation
+(UIInterfaceOrientation )getRotationAtIndex:(NSInteger)tagIndex;
//kContentOffset
+(CGPoint)getContentOffsetAtIndex:(NSInteger)tagIndex;
//kZoomScale
+(CGFloat)getZoomScaleAtIndex:(NSInteger)tagIndex;
//kVisibleRect
+(CGRect)getVisibleRectAtIndex:(NSInteger)tagIndex;
//kCropContent
+(CGRect)getCropContentAtIndex:(NSInteger)tagIndex;
//kShouldRevert
+(BOOL)getShouldRevertAtIndex:(NSInteger)tagIndex;
@end
