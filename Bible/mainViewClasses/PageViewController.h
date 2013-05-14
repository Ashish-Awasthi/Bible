//
//  PageViewController.h
//  Bible
//
//  Created by Ashish Awasthi on 4/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//
@protocol PageViewController <NSObject>
@optional
-(void)nextPageFlipAutomaticallyWhenAudioFinsh:(NSArray *)viewControllersArr;
@end
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface PageViewController : UIViewController<UIWebViewDelegate,
AVAudioPlayerDelegate,UIScrollViewDelegate>{
    UIProgressView*     loadingProgessView;
    float               increaseProgess;
    UIImageView         *imageView;
    UIButton       *menuOptionBtn;

    NSArray           *audioInfoPageArr;
    NSInteger        hieghtLightRemoveTime;
    NSInteger        hieghLightNumber;
    BOOL             isAudioEnable;
    BOOL             isAduioObjectAlive;
    BOOL             letItReadEnable;
    BOOL             wantAudioCompletelyOff;
    NSInteger        _currentPageId;
    UIActivityIndicatorView*  pinner;
    NSMutableArray*        audioObjectArr;
    
    NSTimer*              progessTimer;
    AVAudioPlayer     *audioPlayer;
}
@property(nonatomic,assign)id delegate;
@property(nonatomic,retain)AVAudioPlayer     *lastAudioPlayerObj;
@property (strong, nonatomic) id dataObject;
@property(nonatomic,retain) UIWebView    *webView;
@property(nonatomic,retain)UILabel     *dataLabel;
@property(nonatomic,copy) NSString         *lastSpanIdStr;
@property(nonatomic,copy)NSString          *lastSentenceTextColorStr;
-(void)loadHtml:(NSString *)htmlName;
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
            withTitle:(NSString *)titleStr
          withHtmlStr:(NSString *)htmlName;
-(void)releaseAudioObjcet;
-(void)hieghtTextWhenSwipeUpperCorner:(NSInteger)pageId;
-(void)tabOnAudioIcon:(NSInteger )pageId;
-(void)reStoreLastAudioState;
@end
