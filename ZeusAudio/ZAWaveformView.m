//
//  ZAWaveformView.m
//  ZeusAudio
//
//  Created by lingchen on 12/21/16.
//  Copyright © 2016 LingChen. All rights reserved.
//

#import "ZAWaveformView.h"
#import "ZARecordEngine.h"

@interface ZAWaveformView()

@property (nonatomic, strong) ZARecordEngine *recordEngine;


@end

@implementation ZAWaveformView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.recordEngine = [[ZARecordEngine alloc] init];
    }
    return self;
}


-(void)startFetchingAudio
{
    [self.recordEngine startFetchingAudio];
}

@end
