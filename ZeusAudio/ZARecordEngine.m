//
//  ZARecordEngine.m
//  ZeusAudio
//
//  Created by lingchen on 12/23/16.
//  Copyright © 2016 LingChen. All rights reserved.
//

#import "ZARecordEngine.h"
#import <AudioToolbox/AudioToolbox.h>
#import "ZAAudioUtils.h"
#import <AVFoundation/AVFoundation.h>

typedef struct ZAAudioInfo
{
    AudioUnit audioUnit;
    AudioBufferList *audioBufferList;
    AudioStreamBasicDescription   inputFormat;
    AudioStreamBasicDescription   streamFormat;
    float                       **floatData;
}ZAAudioInfo;

@interface ZARecordEngine()

@property (nonatomic, assign) struct ZAAudioInfo *info;

@end

@implementation ZARecordEngine

- (id)init
{
    if (self = [super init]) {
        
        //info需要初始化
        self.info = (ZAAudioInfo *)malloc(sizeof(ZAAudioInfo));
        memset(self.info, 0, sizeof(ZAAudioInfo));
        
        [self setupAudioUnit];
        
    }
    return self;
}

- (void)setupAudioUnit
{
    //1、描述音频单元
    AudioComponentDescription inputComponentDescription;
    
    inputComponentDescription.componentType = kAudioUnitType_Output;
    inputComponentDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    inputComponentDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    inputComponentDescription.componentFlags = 0;
    inputComponentDescription.componentFlagsMask = 0;
    
    //2、查找音频单元
    AudioComponent inputComponent = AudioComponentFindNext(NULL,
                                                           &inputComponentDescription);
    
    NSAssert(inputComponent, @"Couldn`t get input component unit!");
    
    //3、获取音频单元实例
    [ZAAudioUtils checkOSStatus:AudioComponentInstanceNew(inputComponent, &(self.info->audioUnit))
                      operation:"Failed to get audio component instance"];
    
    //4、启用录制功能
    UInt32 flag = 1;
    [ZAAudioUtils checkOSStatus:AudioUnitSetProperty(self.info->audioUnit,
                                                     kAudioOutputUnitProperty_EnableIO,
                                                     kAudioUnitScope_Input,
                                                     1,
                                                     &flag,
                                                     sizeof(flag))
                      operation:"Couldn't enable input on remote IO unit."];
    
    
    
    UInt32 propSize = sizeof(self.info->inputFormat);
    [ZAAudioUtils checkOSStatus:AudioUnitGetProperty(self.info->audioUnit,
                                                     kAudioUnitProperty_StreamFormat,
                                                     kAudioUnitScope_Input,
                                                     1,
                                                     &self.info->inputFormat,
                                                     &propSize)
                      operation:"Failed to get stream format of microphone input scope"];
    
    self.info->inputFormat.mSampleRate = [[AVAudioSession sharedInstance] sampleRate];
    NSAssert(self.info->inputFormat.mSampleRate,
             @"Expected AVAudioSession sample rate to be greater than 0.0. Did you setup the audio session?");
    
    
    //5、音频流描述
    AudioStreamBasicDescription basicDescription = [self defaultStreamFormat];
    
    //6、应用录制和播放的音频流描述
    [self setAudioStreamBasicDescription:basicDescription];
    
    
    //7、设置回调
    AURenderCallbackStruct renderCallbackStruct;
    renderCallbackStruct.inputProc = ZAAudioRecordCallback;
    renderCallbackStruct.inputProcRefCon = (__bridge void *)(self);
    [ZAAudioUtils checkOSStatus:AudioUnitSetProperty(self.info->audioUnit,
                                                     kAudioOutputUnitProperty_SetInputCallback,
                                                     kAudioUnitScope_Global,
                                                     1,
                                                     &renderCallbackStruct,
                                                     sizeof(renderCallbackStruct))
                      operation:"Failed to set render callback"];
    
    
    [ZAAudioUtils checkOSStatus:AudioUnitInitialize(self.info->audioUnit)
                      operation:"Failed to initialize input unit"];
    
    
    
}



- (AudioStreamBasicDescription)defaultStreamFormat
{
    return [ZAAudioUtils formatWithNumberOfChannels:[self numberOfChannels]
                                         simpleRate:self.info->inputFormat.mSampleRate];
}

//------------------------------------------------------------------------------

- (UInt32)numberOfChannels
{
    return 1;

}

- (void)setAudioStreamBasicDescription:(AudioStreamBasicDescription)basicDescription
{
    self.info->streamFormat = basicDescription;
    
    [ZAAudioUtils checkOSStatus:AudioUnitSetProperty(self.info->audioUnit,
                                                     kAudioUnitProperty_StreamFormat,
                                                     kAudioUnitScope_Input,
                                                     0,
                                                     &basicDescription,
                                                     sizeof(basicDescription))
                      operation:"Failed to set stream format on input scope"];
    
    [ZAAudioUtils checkOSStatus:AudioUnitSetProperty(self.info->audioUnit,
                                                     kAudioUnitProperty_StreamFormat,
                                                     kAudioUnitScope_Output,
                                                     1,
                                                     &basicDescription,
                                                     sizeof(basicDescription))
                      operation:"Failed to set stream format on output scope"];
    
    UInt32 maximumBufferSize = [self maximumBufferSize];
    BOOL isInterleaved = [ZAAudioUtils isInterleaved:basicDescription];
    UInt32 channels = basicDescription.mChannelsPerFrame;
    
    self.info->floatData = [ZAAudioUtils floatBuffersWithNumberOfFrames:maximumBufferSize
                                                       numberOfChannels:channels];
    
    self.info->audioBufferList = [ZAAudioUtils audioBufferListWithNumberOfFrames:maximumBufferSize
                                                                numberOfChannels:channels
                                                                     interleaved:isInterleaved];
    
}

#pragma mark - RenderCallBack
static OSStatus ZAAudioRecordCallback(void                          *inRefCon,
                                      AudioUnitRenderActionFlags    *ioActionFlags,
                                      const AudioTimeStamp          *inTimeStamp,
                                      UInt32                        inBusNumber,
                                      UInt32                        inNumberFrames,
                                      AudioBufferList               *ioData)
{
    ZARecordEngine *record = (__bridge ZARecordEngine *)(inRefCon);
    
    ZAAudioInfo *info = record.info;
    
    for(UInt32 i = 0; i < info->audioBufferList->mNumberBuffers; i ++) {
        
        info->audioBufferList->mBuffers[i].mDataByteSize = inNumberFrames * info -> streamFormat.mBytesPerFrame;
    }
    
    OSStatus result = AudioUnitRender(info->audioUnit,
                                      ioActionFlags,
                                      inTimeStamp,
                                      inBusNumber,
                                      inNumberFrames,
                                      info->audioBufferList);
    
    //do something
    
    return result;
}

-(void)startFetchingAudio
{
    //
    // Start output unit
    //
    [ZAAudioUtils checkOSStatus:AudioOutputUnitStart(self.info->audioUnit)
                      operation:"Failed to start microphone audio unit"];
    
}

- (UInt32)maximumBufferSize
{
    UInt32 maximumBufferSize;
    UInt32 propSize = sizeof(maximumBufferSize);
    
    [ZAAudioUtils checkOSStatus:AudioUnitGetProperty(self.info->audioUnit,
                                                     kAudioUnitProperty_MaximumFramesPerSlice,
                                                     kAudioUnitScope_Global,
                                                     0,
                                                     &maximumBufferSize,
                                                     &propSize)
                      operation:"Failed to get maximum number of frames per slice"];
    
    return maximumBufferSize;
}



@end
