//
//  AudioClass.m
//  Bible
//
//  Created by Ashish Awasthi on 4/24/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import "AudioClass.h"


@implementation AudioClass
@synthesize    audioPlayer;


-(void)audioPlay:(NSString  *)audioFileNameStr
       withStart:(NSTimeInterval)seekTime{
    //isAduioObjectAlive = YES;
    NSString *soundPath =[[NSBundle mainBundle]pathForAuxiliaryExecutable:audioFileNameStr];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    NSError *error;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    self.audioPlayer.currentTime = seekTime;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer setDelegate:self];
    [self.audioPlayer setNumberOfLoops:0];
    [self.audioPlayer play];
    
}

-(void)releaseAudioObjcet{
    
    //if (isAduioObjectAlive) {
       // isAduioObjectAlive = NO;
        [self.audioPlayer stop];
        RELEASE(self.audioPlayer);
        //[self removeHightLightWithId:nil];
    //}
}


-(void)audioPlay{
    [self.audioPlayer play];
}

-(void)audioStop{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(audioStop) object:nil];
    [self.audioPlayer stop];
}

-(void)audioPause{
    [self.audioPlayer pause];
}

@end
