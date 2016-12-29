//
//  ZAAudioUtils.m
//  ZeusAudio
//
//  Created by lingchen on 12/23/16.
//  Copyright © 2016 LingChen. All rights reserved.
//

#import "ZAAudioUtils.h"


@implementation ZAAudioUtils

+(void)checkOSStatus:(OSStatus)result operation:(const char *)operation
{
    if (result == noErr) {
        return;
    }
    char errorString[20];
    
    *(UInt32 *)(errorString + 1) = CFSwapInt32HostToBig(result);
    if (isprint(errorString[1]) &&
        isprint(errorString[2]) &&
        isprint(errorString[3]) &&
        isprint(errorString[4])) {
        
        errorString[0] = errorString[5] = '\'';
        errorString[6] = '\0';
    }
    else
    {
        sprintf(errorString,"%d",(int)result);
    }
    
    fprintf(stderr, "Error: %s (%s)\n",operation, errorString);
    
}

//5、音频流描述
+ (AudioStreamBasicDescription)formatWithNumberOfChannels:(UInt32)channels
                                               simpleRate:(float)sampleRate
{
    AudioStreamBasicDescription basicDescription;
    
    UInt32 floatByteSize = sizeof(float);
    
    basicDescription.mSampleRate        = sampleRate;
    basicDescription.mFormatID          = kAudioFormatLinearPCM;
    basicDescription.mFormatFlags       = kAudioFormatFlagIsFloat | kAudioFormatFlagIsNonInterleaved;
    basicDescription.mBytesPerPacket    = floatByteSize;
    basicDescription.mFramesPerPacket   = 1;
    basicDescription.mBytesPerFrame     = floatByteSize;
    basicDescription.mChannelsPerFrame  = channels;
    basicDescription.mBitsPerChannel    = 8 * floatByteSize;
    
    return basicDescription;
}


+ (BOOL)isInterleaved:(AudioStreamBasicDescription)basicDes
{
    return !(basicDes.mFormatFlags & kAudioFormatFlagIsNonInterleaved);
}

#pragma mark - AudioBufferList Utility
+ (AudioBufferList *)audioBufferListWithNumberOfFrames:(UInt32)frames
                                      numberOfChannels:(UInt32)channels
                                           interleaved:(BOOL)interleaved
{
    unsigned nBuffers;
    unsigned bufferSize;
    unsigned channelsPerBuffer;
    
    //这个逻辑看不明白
    if (interleaved) {
        nBuffers = 1;
        bufferSize = sizeof(float) * frames * channels;
        channelsPerBuffer = channels;
    }
    else {
        nBuffers = channels;
        bufferSize = sizeof(float) * frames;
        channelsPerBuffer = 1;
    }
    
    AudioBufferList *audioBufferList = (AudioBufferList *)malloc(sizeof(AudioBufferList) + sizeof(AudioBuffer) * (channels - 1));
    audioBufferList->mNumberBuffers = nBuffers;
    
    for (unsigned i = 0; i < nBuffers; i++) {
        audioBufferList->mBuffers[i].mNumberChannels = channelsPerBuffer;
        audioBufferList->mBuffers[i].mDataByteSize = bufferSize;
        audioBufferList->mBuffers[i].mData = calloc(bufferSize, 1);
    }
    
    return audioBufferList;
}

+ (float **)floatBuffersWithNumberOfFrames:(UInt32)frames
                          numberOfChannels:(UInt32)channels
{
    size_t size = sizeof(float *) * channels;
    float **buffers = (float **)malloc(size);
    for (int i = 0; i < channels; i++)
    {
        size = sizeof(float) * frames;
        buffers[i] = (float *)malloc(size);
    }
    return buffers;
}
@end
