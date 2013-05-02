


//
//  RootViewController.h
//  PageWebView
//
//  Created by Tech Soft LABS on 18/04/13.
//  Copyright (c) 2013 Tech Soft LABS. All rights reserved.
//


#define MenuOptionAnimationDuration  0.7
#define  ShowMenuOptionNumberPage  2

#define kCaches_DIR		[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define RELEASE(obj) if(obj != nil) { [obj release];}

#define NSLog if(1)NSLog


#define   ExtreamLeftViewKey @"ExtremLeft"

#define   LeftViewKey     @"Left"

#define   CurrentViewKey  @"Current"

#define    RightViewKey   @"ExtremRight"

#define   ExtreamRightViewKey @"ExtremRight"

#define  KDataArr \
@"1",\
@"2",\
@"3",\
@"4",\
@"5",\
@"6",\
@"7",\
@"8",\
@"9",\
@"10",\
nil

#define HtmlArrName \
@"Page_001.htm",\
@"Page_002.htm",\
@"Page_003.htm",\
@"Page_004.htm",\
@"Page_005.htm",\
@"Page_006.htm",\
@"Page_007.htm",\
@"Page_008.htm",\
@"Page_009.htm",\
@"Page_010.htm",\
nil


typedef enum{
 ExtremLeftView = 0,
 LeftView,
 CurrentView,
 RightView,
 ExtremRightView,
}PreLoadView;

//*************************************************Query part ***************************************

#define KPageDataQuery @"Select * from PageTable"

#define KAudioDataQueryWherePageId @"Select * from AudioTable where PageId = %d"

#define KAudioDataQueryWhereSpanID @"Select * from AudioTable where spanId = '%@'"
