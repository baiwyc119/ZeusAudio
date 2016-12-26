//
//  ZARecordEngine.m
//  ZeusAudio
//
//  Created by lingchen on 12/23/16.
//  Copyright © 2016 LingChen. All rights reserved.
//

#import "ZARecordEngine.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation ZARecordEngine

- (id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setupAudioUnit
{
    AudioComponentDescription inputComponentDescription;
    
    inputComponentDescription.componentType = kAudioUnitType_Output;
    inputComponentDescription.componentManufacturer = kAudioUnitManufacturer_Apple;
    
    inputComponentDescription.componentSubType = kAudioUnitSubType_RemoteIO;
    inputComponentDescription.componentFlags = 0;
    inputComponentDescription.componentFlagsMask = 0;
    
    AudioComponent inputComponent = AudioComponentFindNext(NULL,
                                                           &inputComponentDescription);
    
    NSAssert(inputComponent, @"Couldn`t get input component unit!");
    
    
}

@end
