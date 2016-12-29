//
//  ZAAudioUtils.h
//  ZeusAudio
//
//  Created by lingchen on 12/23/16.
//  Copyright © 2016 LingChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ZAAudioUtils : NSObject

#pragma mark - OSStatus Utility

+(void)checkOSStatus:(OSStatus)result operation:(const char *)operation;

#pragma mark - AudioDescription
+ (AudioStreamBasicDescription)formatWithNumberOfChannels:(UInt32)channels
                                               simpleRate:(float)sampleRate;

+ (BOOL)isInterleaved:(AudioStreamBasicDescription)basicDes;


+ (AudioBufferList *)audioBufferListWithNumberOfFrames:(UInt32)frames
                                      numberOfChannels:(UInt32)channels
                                           interleaved:(BOOL)interleaved;

+ (float **)floatBuffersWithNumberOfFrames:(UInt32)frames
                          numberOfChannels:(UInt32)channels;

@end
