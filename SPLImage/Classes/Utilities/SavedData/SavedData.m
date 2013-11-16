//
//  SavedData.m
//  SPLImage
//
//  Created by Girish Rathod on 26/12/12.
//
//

#import "SavedData.h"

static NSMutableDictionary * savedDataDictionary = nil;
@implementation SavedData

+(void)setValue:(id)value forKey:(NSString *)key
{
    if(savedDataDictionary == nil)
        savedDataDictionary = [NSMutableDictionary dictionary];
    [savedDataDictionary setObject:value forKey:key];
}

+(id)getValueForKey:(NSString *)key
{
    return [savedDataDictionary objectForKey:key];
}

+(void)flushSavedData
{
    [savedDataDictionary removeAllObjects];
}
+(void)getAllTheValues{
    for (id items in savedDataDictionary) {
        NSLog(@"item %@", items);
    }
    NSLog(@"%@",[savedDataDictionary description]);
}

#pragma mark -

//Frames
+(CGRect)getFramesAtIndex:(NSInteger)tagIndex{
    return [[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex] valueForKey:kFrames] CGRectValue];
}
//Tag
+(NSInteger)getTagAtIndex:(NSInteger)tagIndex{
    return [[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex] valueForKey:kTag] intValue];
}
//VideoURL
+(NSURL *)getVideoURLAtIndex:(NSInteger)tagIndex{
    return [[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kVideoURL];
}
//ReverseVideoURL
+(NSURL *)getReverseVideoURLAtIndex:(NSInteger)tagIndex{
    return [[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kReverseVideoURL];
}
//Filter
+(MY_FILTERS)getFilterAtIndex:(NSInteger)tagIndex{
    return [[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kFilter] intValue];
}
//Length
+(CGFloat)getTrackLengthAtIndex:(NSInteger)tagIndex{
    return [[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kLength] floatValue];
}
//IsReverse
+(BOOL)getIsReverseTrackAtIndex:(NSInteger)tagIndex{
    return [[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kIsReverse] boolValue];
}
//Sequence
+(NSInteger)getSequenceAtIndex:(NSInteger)tagIndex{
    return [[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kSequence] intValue];
}
//IsMute
+(BOOL)getIsTrackMuteAtIndex:(NSInteger)tagIndex{
    return [[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kIsMute] boolValue];
}
//Width
+(CGFloat)getWidthAtIndex:(NSInteger)tagIndex{
    return [[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kWidth] floatValue];
}
//Height
+(CGFloat)getHeightAtIndex:(NSInteger)tagIndex{
    return [[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kHeight] floatValue];
}
//Rotation
+(UIInterfaceOrientation )getRotationAtIndex:(NSInteger)tagIndex{
    return (UIInterfaceOrientation)[[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kRotation] intValue];

}

//kContentOffset
+(CGPoint)getContentOffsetAtIndex:(NSInteger)tagIndex{
    return [[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kContentOffset] CGPointValue];
}
//kZoomScale
+(CGFloat)getZoomScaleAtIndex:(NSInteger)tagIndex{
    return [[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kZoomScale] floatValue];
}

//kVisibleRect
+(CGRect)getVisibleRectAtIndex:(NSInteger)tagIndex{
    return [[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kVisibleRect] CGRectValue];
}
//kCropContent
+(CGRect)getCropContentAtIndex:(NSInteger)tagIndex{
    return [[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kCropContent] CGRectValue];
}
//kShouldRevert
+(BOOL)getShouldRevertAtIndex:(NSInteger)tagIndex{
    return [[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:tagIndex]  objectForKey:kShouldRevert] boolValue];
}

#pragma mark - 

+(void)removeAllImportedFiles{
    
    NSString *tempDir = NSTemporaryDirectory();
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSDirectoryEnumerator *fileEnumerator = [manager enumeratorAtPath:tempDir];
    
    for (NSString *filename in fileEnumerator) {
        // Do something with file
        if ([filename hasSuffix:@".MOV"]) {
            NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:filename];
            [manager removeItemAtPath:path error:nil];
        }
    }
    
    NSString *folderPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSError *error = nil;
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:&error]) {
        [[NSFileManager defaultManager] removeItemAtPath:[folderPath stringByAppendingPathComponent:file] error:&error];
    }

}
+(void)removeFileAtPath:(NSString*)path{
    NSFileManager *manager = [[NSFileManager alloc] init];
    [manager removeItemAtPath:path error:nil];
   }


+(BOOL)isVideoAvalableAtSelectedPosition:(NSInteger )position{
    NSString *strUrl = [NSString stringWithFormat:@"%@",[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:position]  objectForKey:kVideoURL]];
    
    return [strUrl length]>5 ? YES:NO;
}

+(BOOL)isReverseVideoAvalableAtSelectedPosition:(NSInteger )position{
    NSString *strUrl = [NSString stringWithFormat:@"%@",[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:position]  objectForKey:kReverseVideoURL]];
    
    return [strUrl length]>5 ? YES:NO;
}

+(void)removePreviousDataAtIndex:(NSInteger)_index{
    
    NSString *strUrl = [NSString stringWithFormat:@"%@",[[[SavedData getValueForKey:ARRAY_FRAMES] objectAtIndex:_index]  objectForKey:kVideoURL]];
    if ([self isVideoAvalableAtSelectedPosition:_index])
        [SavedData removeFileAtPath:strUrl];
    NSString *strRevUrl = [NSString stringWithFormat:@"%@",[[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:_index]  objectForKey:kReverseVideoURL]];
    if ([self isReverseVideoAvalableAtSelectedPosition:_index])
        [SavedData removeFileAtPath:strRevUrl];
    [[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:_index] setValue:[NSNumber numberWithBool:NO] forKey:kIsReverse];
    [[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:_index] setObject:[NSURL URLWithString:@""] forKey:kReverseVideoURL];
    [[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:_index] setValue:[NSNumber numberWithBool:YES] forKey:kShouldRevert];
    [[[self getValueForKey:ARRAY_FRAMES] objectAtIndex:_index] setValue:[NSNumber numberWithInt:FILTER_NONE] forKey:kFilter];
    
}

@end
