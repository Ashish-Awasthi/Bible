//
//  PageViewController.h
//  Bible
//
//  Created by Ashish Awasthi on 4/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface PageViewController : UIViewController<UIWebViewDelegate,
AVAudioPlayerDelegate,UIScrollViewDelegate>{

    UIImageView         *imageView;
    UIButton     *menuOptionBtn;
   
    
    NSArray           *audioInfoPageArr;
    NSInteger        hieghtLightRemoveTime;
    NSInteger        hieghLightNumber;
    BOOL             isAudioEnable;
    BOOL             isAduioObjectAlive;
    BOOL             letItReadEnable;
   // UIActivityIndicatorView*  pinner;
}
@property(nonatomic,retain) AVAudioPlayer     *audioPlayer;
@property (strong, nonatomic) id dataObject;
@property(nonatomic,retain) UIWebView    *webView;
@property(nonatomic,retain)UILabel     *dataLabel;
@property(nonatomic,copy) NSString         *lastSpanIdStr;
-(void)loadHtml:(NSString *)htmlName;
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
            withTitle:(NSString *)titleStr
          withHtmlStr:(NSString *)htmlName;
-(void)releaseAudioObjcet;
-(void)hieghtTextWhenSwipeUpperCorner:(NSInteger)pageId;
-(void)tabOnAudioIcon:(NSInteger )pageId;
@end
