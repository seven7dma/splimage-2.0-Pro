//GPUImageMovie.m
//
#import "GPUImageMovie.h"
#import "GPUImageMovieWriter.h"
#import "GPUImageAudioPlayer.h"

@interface GPUImageMovie ()
{
    BOOL audioEncodingIsFinished, videoEncodingIsFinished;
    GPUImageMovieWriter *synchronizedMovieWriter;
    CVOpenGLESTextureCacheRef coreVideoTextureCache;
    AVAssetReader *reader;
    BOOL keepLooping;
    
    GPUImageAudioPlayer *audioPlayer;
    CFAbsoluteTime assetStartTime;
    dispatch_queue_t audio_queue;
}

- (void)processAsset;

@end

@implementation GPUImageMovie

@synthesize url = _url;
@synthesize asset = _asset;
@synthesize runBenchmark = _runBenchmark;
@synthesize playAtActualSpeed = _playAtActualSpeed;
@synthesize delegate = _delegate;
@synthesize shouldRepeat = _shouldRepeat;

#pragma mark -
#pragma mark Initialization and teardown

- (id)initWithURL:(NSURL *)url;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    [self textureCacheSetup];
    
    self.url = url;
    self.asset = nil;
    self.alwaysCopiesSampleData = YES;
    
    return self;
}

- (id)initWithAsset:(AVAsset *)asset;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    [self textureCacheSetup];
    
    self.url = nil;
    self.asset = asset;
    self.alwaysCopiesSampleData = YES;
    
    return self;
}

- (void)textureCacheSetup;
{
    if ([GPUImageContext supportsFastTextureUpload])
    {
        runSynchronouslyOnVideoProcessingQueue(^{
            [GPUImageContext useImageProcessingContext];
#if defined(__IPHONE_6_0)
            CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, [[GPUImageContext sharedImageProcessingContext] context], NULL, &coreVideoTextureCache);
#else
            CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, (__bridge void *)[[GPUImageContext sharedImageProcessingContext] context], NULL, &coreVideoTextureCache);
#endif
            if (err)
            {
                NSAssert(NO, @"Error at CVOpenGLESTextureCacheCreate %d", err);
            }
            
            // Need to remove the initially created texture
            [self deleteOutputTexture];
        });
    }
}

- (void)dealloc
{
    if (audio_queue != nil){
        // dispatch_release(audio_queue);
    }
    
    if ([GPUImageContext supportsFastTextureUpload])
    {
        CFRelease(coreVideoTextureCache);
    }
}

#pragma mark -
#pragma mark Movie processing

- (void)enableSynchronizedEncodingUsingMovieWriter:(GPUImageMovieWriter *)movieWriter;
{
    synchronizedMovieWriter = movieWriter;
    movieWriter.encodingLiveVideo = NO;
}

- (void)startProcessing
{
    if(self.url == nil)
    {
        [self processAsset];
        return;
    }
    
    if (_shouldRepeat) keepLooping = YES;
    
    NSDictionary *inputOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *inputAsset = [[AVURLAsset alloc] initWithURL:self.url options:inputOptions];
    
    GPUImageMovie __block *blockSelf = self;
    
    [inputAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler: ^{
        //        runSynchronouslyOnVideoProcessingQueue(^{
        NSError *error = nil;
        AVKeyValueStatus tracksStatus = [inputAsset statusOfValueForKey:@"tracks" error:&error];
        if (!tracksStatus == AVKeyValueStatusLoaded)
        {
            return;
        }
        blockSelf.asset = inputAsset;
        [blockSelf processAsset];
        blockSelf = nil;
        //        });
    }];
}

- (void)processAsset
{
    __unsafe_unretained GPUImageMovie *weakSelf = self;
    NSError *error = nil;
    reader = [AVAssetReader assetReaderWithAsset:self.asset error:&error];
    
    NSMutableDictionary *outputSettings = [NSMutableDictionary dictionary];
    [outputSettings setObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]  forKey: (NSString*)kCVPixelBufferPixelFormatTypeKey];
    // Maybe set alwaysCopiesSampleData to NO on iOS 5.0 for faster video decoding
    AVAssetReaderTrackOutput *readerVideoTrackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:[[self.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] outputSettings:outputSettings];
    readerVideoTrackOutput.alwaysCopiesSampleData = self.alwaysCopiesSampleData;
    [reader addOutput:readerVideoTrackOutput];
    
    AVAssetReaderTrackOutput *readerAudioTrackOutput = nil;
    NSArray *audioTracks = [self.asset tracksWithMediaType:AVMediaTypeAudio];
    BOOL hasAudioTraks = [audioTracks count] > 0;
    BOOL shouldPlayAudio = hasAudioTraks && self.playSound;
    // look here
    BOOL shouldRecordAudioTrack = (hasAudioTraks && (weakSelf.audioEncodingTarget != nil));
    
    if (shouldRecordAudioTrack || shouldPlayAudio){
        audioEncodingIsFinished = NO;
        
        // This might need to be extended to handle movies with more than one audio track
        AVAssetTrack* audioTrack = [audioTracks objectAtIndex:0];
        NSDictionary *audioReadSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                           [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                           [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                           [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                           [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                                           [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                           nil];
        
        readerAudioTrackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:audioReadSettings];
        [reader addOutput:readerAudioTrackOutput];
        
        if (shouldPlayAudio){
            if (audio_queue == nil){
                audio_queue = dispatch_queue_create("GPUAudioQueue", nil);
            }
            
            if (audioPlayer == nil){
                audioPlayer = [[GPUImageAudioPlayer alloc] init];
                [audioPlayer initAudio];
                [audioPlayer startPlaying];
            }
        }
    }
    
    if (shouldRecordAudioTrack) {
        [self.audioEncodingTarget setShouldInvalidateAudioSampleWhenDone:YES];
    }
    
    if ([reader startReading] == NO)
    {
        NSLog(@"Error reading from file at URL: %@", weakSelf.url);
        return;
    }
    
    if (synchronizedMovieWriter != nil)
    {
        [synchronizedMovieWriter setVideoInputReadyCallback:^{
            [weakSelf readNextVideoFrameFromOutput:readerVideoTrackOutput];
        }];
        
        [synchronizedMovieWriter setAudioInputReadyCallback:^{
            [weakSelf readNextAudioSampleFromOutput:readerAudioTrackOutput];
        }];
        
        [synchronizedMovieWriter enableSynchronizationCallbacks];
    }
    else
    {
        // look here see if this gets called when playaudio = YES
        assetStartTime = 0.0;
        while (reader.status == AVAssetReaderStatusReading && (!_shouldRepeat || keepLooping))
        {
            runSynchronouslyOnVideoProcessingQueue(^{
                [weakSelf readNextVideoFrameFromOutput:readerVideoTrackOutput];
                
                if (shouldPlayAudio && (!audioEncodingIsFinished)){
                    
                    if (audioPlayer.readyForMoreBytes) {
                        //process next audio sample if the player is ready to receive it
                        [weakSelf readNextAudioSampleFromOutput:readerAudioTrackOutput];
                    }
                    
                } else if (shouldRecordAudioTrack && (!audioEncodingIsFinished)) {
                    [weakSelf readNextAudioSampleFromOutput:readerAudioTrackOutput];
                }
            });
        }
        
        if (reader.status == AVAssetWriterStatusCompleted) {
            
            [reader cancelReading];
            
            if (keepLooping) {
                reader = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self startProcessing];
                });
            } else {
                [weakSelf endProcessing];
                if ([self.delegate respondsToSelector:@selector(didCompletePlayingMovie)]) {
                    [self.delegate didCompletePlayingMovie];
                }
            }
            
        }
    }
}

- (void)readNextVideoFrameFromOutput:(AVAssetReaderTrackOutput *)readerVideoTrackOutput;
{
    if (reader.status == AVAssetReaderStatusReading)
    {
        CMSampleBufferRef sampleBufferRef = [readerVideoTrackOutput copyNextSampleBuffer];
        
        if (sampleBufferRef)
        {
            BOOL renderVideoFrame = YES;
            
            if (_playAtActualSpeed)
            {
                // Do this outside of the video processing queue to not slow that down while waiting
                CMTime currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(sampleBufferRef);
                CFAbsoluteTime currentActualTime = CFAbsoluteTimeGetCurrent();
                if (assetStartTime == 0){
                    assetStartTime = currentActualTime;
                }
                
                CGFloat delay = (currentSampleTime.value/(float)currentSampleTime.timescale) - (currentActualTime-assetStartTime);
                //                NSLog(@"currentSampleTime: %f, currentTime: %f, delay: %f, sleep: %f", currentSampleTime.value/(float)currentSampleTime.timescale, (currentActualTime-assetStartTime), delay, 1000000.0 * fabs(delay));
                
                if (delay > 0.0){
                    usleep(1000000.0 * fabs(delay));
                }else if (delay < 0){
                    renderVideoFrame = NO;
                }
            }
            
            if (renderVideoFrame){
                __unsafe_unretained GPUImageMovie *weakSelf = self;
                //                runSynchronouslyOnVideoProcessingQueue(^{
                [weakSelf processMovieFrame:sampleBufferRef];
                //                });
            }
            
            CMSampleBufferInvalidate(sampleBufferRef);
            CFRelease(sampleBufferRef);
        }
        else
        {
            if (!keepLooping) {
                videoEncodingIsFinished = YES;
                [self endProcessing];
            }
        }
    }
    else if (synchronizedMovieWriter != nil)
    {
        if (reader.status == AVAssetWriterStatusCompleted)
        {
            [self endProcessing];
        }
    }
}

- (void)readNextAudioSampleFromOutput:(AVAssetReaderTrackOutput *)readerAudioTrackOutput {
    
    if (audioEncodingIsFinished && !self.playSound) {
        // look here
        return;
    }
    
    if (reader.status == AVAssetReaderStatusReading) {
        CMSampleBufferRef audioSampleBufferRef = [readerAudioTrackOutput copyNextSampleBuffer];
        
        if (audioSampleBufferRef) {
            
            // look here
            if (self.playSound){
                CFRetain(audioSampleBufferRef);
                dispatch_async(audio_queue, ^{
                    [audioPlayer copyBuffer:audioSampleBufferRef];
                    
                    CMSampleBufferInvalidate(audioSampleBufferRef);
                    CFRelease(audioSampleBufferRef);
                });
                
            } else if (self.audioEncodingTarget != nil && !audioEncodingIsFinished){
                
                runSynchronouslyOnVideoProcessingQueue(^{
                    CFRetain(audioSampleBufferRef);
                    
                    [self.audioEncodingTarget processAudioBuffer:audioSampleBufferRef];
                    //CMSampleBufferInvalidate(audioSampleBufferRef);
                    /* Don't invalidate the buffer as we retain it and use it asynchronously in the audioEncodingTarget */
                    CFRelease(audioSampleBufferRef);
                });
                
            }
        } else {
            audioEncodingIsFinished = YES;
        }
    }
}

- (void)processMovieFrame:(CMSampleBufferRef)movieSampleBuffer;
{
    CMTime currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(movieSampleBuffer);
    CVImageBufferRef movieFrame = CMSampleBufferGetImageBuffer(movieSampleBuffer);
    
    int bufferHeight = (int)CVPixelBufferGetHeight(movieFrame);
#if TARGET_IPHONE_SIMULATOR
    int bufferWidth = (int)CVPixelBufferGetBytesPerRow(movieFrame) / 4; // This works around certain movie frame types on the Simulator (see https://github.com/BradLarson/GPUImage/issues/424)
#else
    int bufferWidth = (int)CVPixelBufferGetWidth(movieFrame);
#endif
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    
    if ([GPUImageContext supportsFastTextureUpload])
    {
        CVPixelBufferLockBaseAddress(movieFrame, 0);
        
        [GPUImageContext useImageProcessingContext];
        CVOpenGLESTextureRef texture = NULL;
        CVReturn err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault,
                                                                    coreVideoTextureCache,
                                                                    movieFrame,
                                                                    NULL,
                                                                    GL_TEXTURE_2D,
                                                                    self.outputTextureOptions.internalFormat,
                                                                    bufferWidth,
                                                                    bufferHeight,
                                                                    self.outputTextureOptions.format,
                                                                    self.outputTextureOptions.type,
                                                                    0,
                                                                    &texture);
        
        if (!texture || err) {
            NSLog(@"Movie CVOpenGLESTextureCacheCreateTextureFromImage failed (error: %d)", err);
            return;
        }
        
        outputTexture = CVOpenGLESTextureGetName(texture);
        //        glBindTexture(CVOpenGLESTextureGetTarget(texture), outputTexture);
        glBindTexture(GL_TEXTURE_2D, outputTexture);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, self.outputTextureOptions.minFilter);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, self.outputTextureOptions.magFilter);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, self.outputTextureOptions.wrapS);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, self.outputTextureOptions.wrapT);
        
        for (id<GPUImageInput> currentTarget in targets)
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            NSInteger targetTextureIndex = [[targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            
            [currentTarget setInputSize:CGSizeMake(bufferWidth, bufferHeight) atIndex:targetTextureIndex];
            [currentTarget setInputTexture:outputTexture atIndex:targetTextureIndex];
            [currentTarget setTextureDelegate:self atIndex:targetTextureIndex];
            
            [currentTarget newFrameReadyAtTime:currentSampleTime atIndex:targetTextureIndex];
        }
        
        CVPixelBufferUnlockBaseAddress(movieFrame, 0);
        
        // Flush the CVOpenGLESTexture cache and release the texture
        CVOpenGLESTextureCacheFlush(coreVideoTextureCache, 0);
        CFRelease(texture);
        outputTexture = 0;
    }
    else
    {
        // Upload to texture
        CVPixelBufferLockBaseAddress(movieFrame, 0);
        
        glBindTexture(GL_TEXTURE_2D, outputTexture);
        // Using BGRA extension to pull in video frame data directly
        
        
        glTexImage2D(GL_TEXTURE_2D,
                     0,
                     self.outputTextureOptions.internalFormat,
                     bufferWidth,
                     bufferHeight,
                     0,
                     self.outputTextureOptions.format,
                     self.outputTextureOptions.type,
                     CVPixelBufferGetBaseAddress(movieFrame));
        
        CGSize currentSize = CGSizeMake(bufferWidth, bufferHeight);
        for (id<GPUImageInput> currentTarget in targets)
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            NSInteger targetTextureIndex = [[targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            
            [currentTarget setInputSize:currentSize atIndex:targetTextureIndex];
            [currentTarget newFrameReadyAtTime:currentSampleTime atIndex:targetTextureIndex];
        }
        CVPixelBufferUnlockBaseAddress(movieFrame, 0);
    }
    
    if (_runBenchmark)
    {
        CFAbsoluteTime currentFrameTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSLog(@"Current frame time : %f ms", 1000.0 * currentFrameTime);
    }
}

- (void)endProcessing;
{
    keepLooping = NO;
    
    for (id<GPUImageInput> currentTarget in targets)
    {
        [currentTarget endProcessing];
    }
    
    if (synchronizedMovieWriter != nil)
    {
        [synchronizedMovieWriter setVideoInputReadyCallback:^{}];
        [synchronizedMovieWriter setAudioInputReadyCallback:^{}];
    }
    
    if (audioPlayer != nil){
        [audioPlayer stopPlaying];
        audioPlayer = nil;
    }
}

- (void)cancelProcessing
{
    runSynchronouslyOnVideoProcessingQueue(^{
        if (reader) {
            [reader cancelReading];
            reader = nil;
        }
        [self endProcessing];
    });
}

@end
