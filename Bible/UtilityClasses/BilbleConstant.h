


//
//  RootViewController.h
//  PageWebView
//
//  Created by Ashish Awasthi on 18/04/13.
//  Copyright (c) 2013 Tech Soft LABS. All rights reserved.
//

#define kBibleFacebookPageURL             @"https://www.facebook.com/pages/The-Bible-Beautiful-Series/496298287061110?fref=ts"

#define  KBibleLogoUrl  @"http://208.109.209.216/secrets/share/Icon-72.png"

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

#define   StoriesPageName      @"Page_076.htm"
#define   ReadMorePageName     @"Page_078.htm"
#define   FinePrintPageName    @"Page_084.htm"
#define   MakeItYourPageName   @"Page_089.htm"

typedef enum{
    ShareViaEmail = 0,
    ShareViaFacebook,
    LikeOnFaceBook,
    ShareViaTwitter,
}ShareOption;

typedef enum{
 ExtremLeftView = 0,
 LeftView,
 CurrentView,
 RightView,
 ExtremRightView,
}PreLoadView;

#define FaceBookMsg  @"I am reading The Oldest Bedtime Story Ever, written and illustrated by Benjamin Morse.  Now available in hardback and as an eLuminated app. Preview pages at www.biblebeautiful.com."

#define IOS6FaceBookMsg @"I am reading The Oldest Bedtime Story Ever, written and illustrated by Benjamin Morse.  Now available in hardback and as an eLuminated app. Preview pages at www.biblebeautiful.com \nDeveloped by: Orson & Co"

#define TwitterShareMsg  @"I am loving The Oldest Bedtime Story Ever by Benjamin Morse. Preview the hardback and eLuminated app at www.biblebeautiful.com."

#define EmailShareMsg @"I am reading The Oldest Bedtime Story Ever, written and illustrated by Benjamin Morse.  Now available in hardback and as an eLuminated app. Preview it at www.biblebeautiful.com"

#define KFaceBookLikeMsgKey                     @"You liked Yardsellr. Thanks!"


#define KFaceBookUnLikeMsgKey                     @"You unliked Yardsellr. Where's the love?"
//*************************************************Query part ***************************************

#define KPageDataQuery @"Select * from PageTable limit 92"

#define KAudioDataQueryWherePageId @"Select * from AudioTable where PageId = %d order by SpanId"

#define KAudioDataQueryWhereSpanID @"Select * from AudioTable where spanId = '%@'"
