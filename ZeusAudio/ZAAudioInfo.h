//
//  ZAAudioInfo.h
//  ZeusAudio
//
//  Created by lingchen on 12/26/16.
//  Copyright © 2016 LingChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ZAAudioInfo : NSObject

@property (nonatomic, assign) AudioUnit audioUnit;
@property (nonatomic, assign) AudioBufferList *audioBufferList;


@end
