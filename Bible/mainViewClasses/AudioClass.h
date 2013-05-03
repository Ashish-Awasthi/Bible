//
//  AudioClass.h
//  Bible
//
//  Created by Ashish Awasthi on 4/24/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioClass : NSObject<AVAudioPlayerDelegate>{
   
}
-(void)audioPlay:(NSString  *)audioFileNameStr
       withStart:(NSTimeInterval)seekTime;

@property(nonatomic,retain) AVAudioPlayer     *audioPlayer;
@end
