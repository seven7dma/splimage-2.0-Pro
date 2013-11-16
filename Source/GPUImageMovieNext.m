#import "GPUImageMovieNext.h"
#import "GPUImageMovieWriter.h"
#import "TPCircularBuffer+AudioBufferList.h"

#define kOutputBus 0

TPCircularBuffer tpCircularBuffer1;

void checkStatus(int status);
static OSStatus playbackCallback(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData);

void checkStatus(int status)
{
	if (status) {
		printf("Status not 0! %d\n", status);
        //		exit(1);
	}
}

/**
 This callback is called when the audioUnit needs new data to play through the
 speakers. If you don't have any, just don't write anything in the buffers
 */
static OSStatus playbackCallback(void *inRefCon,
								 AudioUnitRenderActionFlags *ioActionFlags,
								 const AudioTimeStamp *inTimeStamp,
								 UInt32 inBusNumber,
								 UInt32 inNumberFrames,
								 AudioBufferList *ioData) {
    
  //  GPUImageMovie* iosAudio = (__bridge GPUImageMovie *)inRefCon;
    
    // Notes: ioData contains buffers (may be more than one!)
    // Fill them up as much as you can. Remember to set the size value in each buffer to match how
    // much data is in the buffer.
 //   &tpCircularBuffer, &audioBufferList, NULL, kTPCircularBufferCopyAll, NULL))

 // AudioBufferList outputBufferList;
    // TPCircularBufferDequeueBufferListFrames(TPCircularBuffer *buffer, UInt32 *ioLengthInFrames, AudioBufferList *outputBufferList, AudioTimeStamp *outTimestamp, AudioStreamBasicDescription *audioFormat);
    
    UInt32 ioLengthInFrames = inNumberFrames;
    
    AudioStreamBasicDescription audioFormat;
	audioFormat.mSampleRate			= 44100.00;
	audioFormat.mFormatID			= kAudioFormatLinearPCM;
	audioFormat.mFormatFlags		= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
	audioFormat.mFramesPerPacket	= 1;
	audioFormat.mChannelsPerFrame	= 2;
	audioFormat.mBitsPerChannel		= 16;
	audioFormat.mBytesPerPacket		= 4;
	audioFormat.mBytesPerFrame		= 4;
    
    AudioTimeStamp outTimestamp;
    
    
    UInt32 retVal = TPCircularBufferPeek(&tpCircularBuffer1, &outTimestamp, &audioFormat);
     NSLog (@"Pippo  %ld\n", retVal);
    
    if (retVal > 0)
  //  TPCircularBuffer tpCirc = [iosAudio tpCircularBuffer];
        TPCircularBufferDequeueBufferListFrames(&tpCircularBuffer1, &ioLengthInFrames, ioData, &outTimestamp, &audioFormat);
    
   
    
 /*
    AudioBuffer aBuffer = outputBufferList.mBuffers[0];
    AudioBuffer buffer = ioData->mBuffers[0];
    
    UInt32 size = min(buffer.mDataByteSize, aBuffer.mDataByteSize); // dont copy more data then we have, or then fits
    memcpy(buffer.mData, aBuffer.mData, size);
    buffer.mDataByteSize = size; // indicate how much data we wrote in the buffer
    */
    /*
    AudioBuffer *pBuffer = [iosAudio.sampleBuffer getAudioBuffer];
    if (pBuffer != NULL) {
        AudioBuffer aBuffer = *pBuffer ;
    
        AudioBuffer buffer = ioData->mBuffers[0];
        
        //   [[iosAudio.array objectAtIndex:[iosAudio.array count]-1] getValue:&aBuffer];
        //   [iosAudio.array removeObjectAtIndex:[iosAudio.array count]-1];
        
        UInt32 size = min(buffer.mDataByteSize, aBuffer.mDataByteSize); // dont copy more data then we have, or then fits
        memcpy(buffer.mData, aBuffer.mData, size);
        buffer.mDataByteSize = size; // indicate how much data we wrote in the buffer
    }
    */
	
	/*for (int i=0; i < ioData->mNumberBuffers; i++) { // in practice we will only ever have 1 buffer, since audio format is mono
		AudioBuffer buffer = ioData->mBuffers[i];
		
        //		NSLog(@"  Buffer %d has %d channels and wants %d bytes of data.", i, buffer.mNumberChannels, buffer.mDataByteSize);
		
		// copy temporary buffer data to output buffer
		UInt32 size = min(buffer.mDataByteSize, [iosAudio aBuffer].mDataByteSize); // dont copy more data then we have, or then fits
		memcpy(buffer.mData, [iosAudio aBuffer].mData, size);
		buffer.mDataByteSize = size; // indicate how much data we wrote in the buffer
		
		
	}  */
	
    return noErr;
}

@interface GPUImageMovieNext ()
{
    BOOL audioEncodingIsFinished, videoEncodingIsFinished;
    GPUImageMovieWriter *synchronizedMovieWriter;
    CVOpenGLESTextureCacheRef coreVideoTextureCache;
    AVAssetReader *reader;
    CMTime previousFrameTime, previousAudioFrameTime;
    CFAbsoluteTime previousActualFrameTime, previousAudioActualFrameTime;
    
    AudioComponentInstance audioUnit;
    
    TPCircularBuffer tpCircularBuffer;
}

- (void)processAsset;

@end

@implementation GPUImageMovieNext

@synthesize url = _url;
@synthesize asset = _asset;
@synthesize runBenchmark = _runBenchmark;
@synthesize playAtActualSpeed = _playAtActualSpeed;
@synthesize completionBlock;
@synthesize tpCircularBuffer;

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
    
    TPCircularBufferInit(&tpCircularBuffer1, 4096*500);

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
    
    TPCircularBufferInit(&tpCircularBuffer1, 4096*500);

    return self;
}

- (void)textureCacheSetup;
{
    if ([GPUImageOpenGLESContext supportsFastTextureUpload])
    {
        runSynchronouslyOnVideoProcessingQueue(^{
            [GPUImageOpenGLESContext useImageProcessingContext];
#if defined(__IPHONE_6_0)
            CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, [[GPUImageOpenGLESContext sharedImageProcessingOpenGLESContext] context], NULL, &coreVideoTextureCache);
#else
            CVReturn err = CVOpenGLESTextureCacheCreate(kCFAllocatorDefault, NULL, (__bridge void *)[[GPUImageOpenGLESContext sharedImageProcessingOpenGLESContext] context], NULL, &coreVideoTextureCache);
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
    if ([GPUImageOpenGLESContext supportsFastTextureUpload])
    {
        CFRelease(coreVideoTextureCache);
    }
    
    TPCircularBufferCleanup(&tpCircularBuffer1);
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
    
    previousFrameTime = kCMTimeZero;
    previousActualFrameTime = CFAbsoluteTimeGetCurrent();
    
    previousAudioFrameTime = kCMTimeZero;
    previousAudioActualFrameTime = CFAbsoluteTimeGetCurrent();
  
    NSDictionary *inputOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *inputAsset = [[AVURLAsset alloc] initWithURL:self.url options:inputOptions];    
    [inputAsset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler: ^{
        NSError *error = nil;
        AVKeyValueStatus tracksStatus = [inputAsset statusOfValueForKey:@"tracks" error:&error];
        if (!tracksStatus == AVKeyValueStatusLoaded) 
        {
            return;
        }
        self.asset = inputAsset;
        [self setupAudio];
        [self processAsset];
    }];
}

- (void)processAsset
{
    __unsafe_unretained GPUImageMovieNext *weakSelf = self;
    NSError *error = nil;
    reader = [AVAssetReader assetReaderWithAsset:self.asset error:&error];

    NSMutableDictionary *outputSettings = [NSMutableDictionary dictionary];
    [outputSettings setObject: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]  forKey: (NSString*)kCVPixelBufferPixelFormatTypeKey];
    // Maybe set alwaysCopiesSampleData to NO on iOS 5.0 for faster video decoding
    AVAssetReaderTrackOutput *readerVideoTrackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:[[self.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] outputSettings:outputSettings];
    [reader addOutput:readerVideoTrackOutput];

    NSArray *audioTracks = [self.asset tracksWithMediaType:AVMediaTypeAudio];
  //  BOOL shouldRecordAudioTrack = (([audioTracks count] > 0) && (weakSelf.audioEncodingTarget != nil) );
    AVAssetReaderTrackOutput *readerAudioTrackOutput = nil;

   //if (shouldRecordAudioTrack)
    if ([audioTracks count] > 0)
    {
        audioEncodingIsFinished = NO;
        
   //     AudioChannelLayout channelLayout;
   //     memset(&channelLayout, 0, sizeof(AudioChannelLayout));
   //     channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
        
        NSMutableDictionary *audioOutputSettings = [NSMutableDictionary dictionary];
        [audioOutputSettings setObject:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [audioOutputSettings setObject:[NSNumber numberWithInt:44100] forKey:AVSampleRateKey];
        [audioOutputSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
      //  [audioOutputSettings setObject:[NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)] forKey:AVChannelLayoutKey];
        [audioOutputSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [audioOutputSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [audioOutputSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
        [audioOutputSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsNonInterleaved];

        // This might need to be extended to handle movies with more than one audio track
        AVAssetTrack* audioTrack = [audioTracks objectAtIndex:0];
        readerAudioTrackOutput = [AVAssetReaderTrackOutput assetReaderTrackOutputWithTrack:audioTrack outputSettings:audioOutputSettings];
        [reader addOutput:readerAudioTrackOutput];
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
        [self startPlay];
        
        while (reader.status == AVAssetReaderStatusReading) 
        {
                [weakSelf readNextVideoFrameFromOutput:readerVideoTrackOutput];

        //    if ( (shouldRecordAudioTrack) && (!audioEncodingIsFinished) )
            if (!audioEncodingIsFinished)
            {
                [weakSelf readNextAudioSampleFromOutput:readerAudioTrackOutput];
            }

        }
        
        [self stopPlay];

        if (reader.status == AVAssetWriterStatusCompleted) {
                [weakSelf endProcessing];
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
            if (_playAtActualSpeed)
            {
                // Do this outside of the video processing queue to not slow that down while waiting
                CMTime currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(sampleBufferRef);
                CMTime differenceFromLastFrame = CMTimeSubtract(currentSampleTime, previousFrameTime);
                CFAbsoluteTime currentActualTime = CFAbsoluteTimeGetCurrent();
                
                CGFloat frameTimeDifference = CMTimeGetSeconds(differenceFromLastFrame);
                CGFloat actualTimeDifference = currentActualTime - previousActualFrameTime;
                
                if (frameTimeDifference > actualTimeDifference)
                {
                    usleep(1000000.0 * (frameTimeDifference - actualTimeDifference));
                }
                
                previousFrameTime = currentSampleTime;
                previousActualFrameTime = CFAbsoluteTimeGetCurrent();
            }

            __unsafe_unretained GPUImageMovieNext *weakSelf = self;
            runSynchronouslyOnVideoProcessingQueue(^{
                [weakSelf processMovieFrame:sampleBufferRef];
            });
            
            CMSampleBufferInvalidate(sampleBufferRef);
            CFRelease(sampleBufferRef);
        }
        else
        {
            videoEncodingIsFinished = YES;
            [self endProcessing];
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

- (void)readNextAudioSampleFromOutput:(AVAssetReaderTrackOutput *)readerAudioTrackOutput;
{
    if (audioEncodingIsFinished)
    {
        return;
    }

    CMSampleBufferRef audioSampleBufferRef = [readerAudioTrackOutput copyNextSampleBuffer];
    
    if (audioSampleBufferRef) 
    {
        __unsafe_unretained GPUImageMovieNext *weakSelf = self;
        runSynchronouslyOnVideoProcessingQueue(^{
            [self.audioEncodingTarget processAudioBuffer:audioSampleBufferRef];
            [weakSelf processAudioFrame:audioSampleBufferRef];
            
            CMSampleBufferInvalidate(audioSampleBufferRef);
            CFRelease(audioSampleBufferRef);
        });
    }
    else
    {
        audioEncodingIsFinished = YES;
      
    }
}

- (void)processMovieFrame:(CMSampleBufferRef)movieSampleBuffer; 
{
//    CMTimeGetSeconds
//    CMTimeSubtract
    
    CMTime currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(movieSampleBuffer);
    CVImageBufferRef movieFrame = CMSampleBufferGetImageBuffer(movieSampleBuffer);

    int bufferHeight = CVPixelBufferGetHeight(movieFrame);
#if TARGET_IPHONE_SIMULATOR
    int bufferWidth = CVPixelBufferGetBytesPerRow(movieFrame) / 4; // This works around certain movie frame types on the Simulator (see https://github.com/BradLarson/GPUImage/issues/424)
#else
    int bufferWidth = CVPixelBufferGetWidth(movieFrame);
#endif

    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();

    if ([GPUImageOpenGLESContext supportsFastTextureUpload])
    {
        CVPixelBufferLockBaseAddress(movieFrame, 0);
        
        [GPUImageOpenGLESContext useImageProcessingContext];
        CVOpenGLESTextureRef texture = NULL;
        CVReturn err = CVOpenGLESTextureCacheCreateTextureFromImage(kCFAllocatorDefault, coreVideoTextureCache, movieFrame, NULL, GL_TEXTURE_2D, GL_RGBA, bufferWidth, bufferHeight, GL_BGRA, GL_UNSIGNED_BYTE, 0, &texture);
        
        if (!texture || err) {
            NSLog(@"Movie CVOpenGLESTextureCacheCreateTextureFromImage failed (error: %d)", err);  
            return;
        }
        
        outputTexture = CVOpenGLESTextureGetName(texture);
        //        glBindTexture(CVOpenGLESTextureGetTarget(texture), outputTexture);
        glBindTexture(GL_TEXTURE_2D, outputTexture);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
        glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        for (id<GPUImageInput> currentTarget in targets)
        {
            NSInteger indexOfObject = [targets indexOfObject:currentTarget];
            NSInteger targetTextureIndex = [[targetTextureIndices objectAtIndex:indexOfObject] integerValue];
            
            [currentTarget setInputSize:CGSizeMake(bufferWidth, bufferHeight) atIndex:targetTextureIndex];
            [currentTarget setInputTexture:outputTexture atIndex:targetTextureIndex];
            
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
        glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, bufferWidth, bufferHeight, 0, GL_BGRA, GL_UNSIGNED_BYTE, CVPixelBufferGetBaseAddress(movieFrame));
        
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
    for (id<GPUImageInput> currentTarget in targets)
    {
        [currentTarget endProcessing];
    }
    
    if (synchronizedMovieWriter != nil)
    {
        [synchronizedMovieWriter setVideoInputReadyCallback:^{}];
        [synchronizedMovieWriter setAudioInputReadyCallback:^{}];
    }
    
    if (completionBlock)
    {
        completionBlock();
    }
}

- (void)processAudioFrame:(CMSampleBufferRef)movieSampleBuffer;
{
   // CMTime currentSampleTime = CMSampleBufferGetOutputPresentationTimeStamp(movieSampleBuffer);
  //  NSLog(@"%f\n", CMTimeGetSeconds(currentSampleTime));
 //   CMItemCount numSamplesInBuffer = CMSampleBufferGetNumSamples(movieSampleBuffer);
    
    AudioBufferList audioBufferList;
    CMBlockBufferRef blockBuffer;
    
    CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(movieSampleBuffer,NULL,&audioBufferList,sizeof(audioBufferList),NULL,NULL,kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment,&blockBuffer);
    
    
    // _audio_buffer = audioBufferList.mBuffers[0];
    
    
  // self.aBuffer = audioBufferList.mBuffers[0];
  //  AudioBuffer aBuf = audioBufferList.mBuffers[0];
    
  //  [sampleBuffer addAudioBuffer:&aBuf];
    
  /*  AudioStreamBasicDescription audioFormat;
	audioFormat.mSampleRate			= 44100.00;
	audioFormat.mFormatID			= kAudioFormatLinearPCM;
	audioFormat.mFormatFlags		= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
	audioFormat.mFramesPerPacket	= 1;
	audioFormat.mChannelsPerFrame	= 2;
	audioFormat.mBitsPerChannel		= 16;
	audioFormat.mBytesPerPacket		= 4;
	audioFormat.mBytesPerFrame		= 4;
   */
    
    if (!TPCircularBufferCopyAudioBufferList(&tpCircularBuffer1, &audioBufferList, NULL, kTPCircularBufferCopyAll, NULL))
        NSLog(@"ahhhhhhh\n");
    
    
    CFRelease(blockBuffer); 
    
 /*   int j=0;
    float* buffer111 = (float*)malloc(numSamplesInBuffer*sizeof(float));
    for (int i = 0; i < numSamplesInBuffer; i+=2)
    {
        //  buffer[i] = (float)(audioBufferList.mBuffers[0].(mData+(i*4)) + audioBufferList.mBuffers[0].mData+((i*4)+1) +audioBufferList.mBuffers[0].(mData+(i*4)+2) +audioBufferList.mBuffers[0].(mData+(i*4)+3) );
        //   buffer[i] =  (float)(*(char*)(aBuffer.mData+i) + *(char*)(aBuffer.mData+i+1) + *(char*)(aBuffer.mData+i+2) + *(char*)(aBuffer.mData+i+3));
      //  int32_t* samples = (int32_t*)(aBuffer.mData);
        
        SInt16* samples = (SInt16*)(audioBufferList.mBuffers[0].mData);
        
        
        // buffer111[i] = (float)(*((int32_t*)aBuffer.mData+(i*sizeof(int32_t))));
        
         buffer111[j++] =  (*(samples+(i*sizeof(SInt16)))) * SHRT_MAX;
    
        //  NSLog(@"%f\n", *(samples+(i*sizeof(float))));
        
        //     buffer[i] = (float)(*(aBuffer.mData+i));
        
        
    }
    
    // NSLog(@"%f ", buffer[0]);
    
    player = [[AVBufferPlayer alloc] initWithBuffer:buffer111 frames:numSamplesInBuffer/2];
    free(buffer111);
    
    [player play];
    */
    
}

- (void) setupAudio {
	OSStatus status;
    
    SInt32 ambient = kAudioSessionCategory_SoloAmbientSound;
    if (AudioSessionSetProperty (kAudioSessionProperty_AudioCategory, sizeof (ambient), &ambient)) {
        NSLog(@"Error setting ambient property");
    }
    
    // Describe audio component
	AudioComponentDescription desc;
	desc.componentType = kAudioUnitType_Output;
	desc.componentSubType = kAudioUnitSubType_RemoteIO;
	desc.componentFlags = 0;
	desc.componentFlagsMask = 0;
	desc.componentManufacturer = kAudioUnitManufacturer_Apple;
	
	// Get component
	AudioComponent inputComponent = AudioComponentFindNext(NULL, &desc);
	
	// Get audio units
	status = AudioComponentInstanceNew(inputComponent, &audioUnit);
	checkStatus(status);
	
    UInt32 flag = 1;
	// Enable IO for playback
	status = AudioUnitSetProperty(audioUnit,
								  kAudioOutputUnitProperty_EnableIO,
								  kAudioUnitScope_Output,
								  kOutputBus,
								  &flag,
								  sizeof(flag));
	checkStatus(status);
	
	// Describe format
	AudioStreamBasicDescription audioFormat;
	audioFormat.mSampleRate			= 44100.00;
	audioFormat.mFormatID			= kAudioFormatLinearPCM;
	audioFormat.mFormatFlags		= kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
	audioFormat.mFramesPerPacket	= 1;
	audioFormat.mChannelsPerFrame	= 2;
	audioFormat.mBitsPerChannel		= 16;
	audioFormat.mBytesPerPacket		= 4;
	audioFormat.mBytesPerFrame		= 4;
    
	
	// Apply format
	status = AudioUnitSetProperty(audioUnit,
								  kAudioUnitProperty_StreamFormat,
								  kAudioUnitScope_Input,
								  kOutputBus,
								  &audioFormat,
								  sizeof(audioFormat));
	checkStatus(status);
	
	// Set output callback
    AURenderCallbackStruct callbackStruct;
	callbackStruct.inputProc = playbackCallback;
	callbackStruct.inputProcRefCon = (__bridge void *)(self);
	status = AudioUnitSetProperty(audioUnit,
								  kAudioUnitProperty_SetRenderCallback,
								  kAudioUnitScope_Global,
								  kOutputBus,
								  &callbackStruct,
								  sizeof(callbackStruct));
	checkStatus(status);
	
	// Allocate our own buffers (1 channel, 16 bits per sample, thus 16 bits per frame, thus 2 bytes per frame).
	// Practice learns the buffers used contain 512 frames, if this changes it will be fixed in processAudio.
	//tempBuffer.mNumberChannels = 1;
	//tempBuffer.mDataByteSize = 512 * 2;
	//tempBuffer.mData = malloc( 512 * 2 );
	
	// Initialise
	status = AudioUnitInitialize(audioUnit);
	checkStatus(status);
}

- (void) startPlay {
    OSStatus status = AudioOutputUnitStart(audioUnit);
	checkStatus(status);
}

- (void) stopPlay {
    OSStatus status = AudioOutputUnitStop(audioUnit);
    checkStatus(status);
}



@end
