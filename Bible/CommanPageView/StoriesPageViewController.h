//
//  StoriesPageViewController.h
//  Bible
//
//  Created by Ashish Awasthi on 5/20/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface StoriesPageViewController : UIViewController<UIWebViewDelegate,
AVAudioPlayerDelegate,UIScrollViewDelegate>{
  
    NSArray          *audioInfoPageArr;
    NSInteger        hieghtLightRemoveTime;
    NSInteger        hieghLightNumber;
    BOOL             isAudioEnable;
    BOOL             isAduioObjectAlive;
    BOOL             letItReadEnable;
    BOOL             wantAudioCompletelyOff;
    NSInteger        _currentPageId;
    AVAudioPlayer     *audioPlayer;
}

@property(nonatomic,retain)AVAudioPlayer     *lastAudioPlayerObj;
@property(nonatomic,retain)UIWebView         *webView;
@property(nonatomic,copy) NSString           *lastSpanIdStr;
@property(nonatomic,copy)NSString            *lastSentenceTextColorStr;
-(void)loadHtml:(NSString *)htmlName;
-(void)releaseAudioObjcet;
-(void)tabOnAudioIcon:(NSInteger )pageId;
-(void)reStoreLastAudioState;
@end