//
//  TWSharedManager.h
//  MusicChoice
//
//  Created by Ashish Awasthi on 21/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SA_OAuthTwitterController.h"

#define kDeviceTypeUnknown          0
#define kDeviceTypeIPhone           1
#define kDeviceTypeIPhoneRetina     2
#define kDeviceTypeIPad             3

#define kDeviceModePotrait          0
#define kDeviceModeLandscape        1

#define kOAuthConsumerKey           @"TBA9wfyWiZClQtZg2Y2vQQ"                           //REPLACE With Twitter App OAuth Key  
#define kOAuthConsumerSecret        @"OSyzXHu4vwx43mvUxsPTHp1sV7tAzzJrJNtYfUO4mY"		//REPLACE With Twitter App OAuth Secret

@class SA_OAuthTwitterEngine;

/**
 The TwitterShareManagerDelegate protocol defines a set of optional methods you can use to receive failure or success message 
 when you will publish a post on Twitter. All of the methods in this protocol are optional. 
 You can use them in situations where you might want.
 */

@protocol TWSharedManagerDelegate <NSObject>

@optional
/**
 
 Tells the delegate that got the success message from Twitter.
 @return void
 */

// ********** Login delegate method ************
-(void)twitterPostDidFail;
-(void)twitterLoginSuccess:(NSString *) userName;
-(void)twitterLoginFail;
-(void)twitterLoginCancel;
-(void)twitterPostDidSuccess:(NSString *) identifire;
-(void)twitterOnFollowSuccess:(NSString *) identifire;
-(void)twitterOnUnFollowSuccess:(NSString *) identifire;
- (void)userInfoReceived:(NSArray *)userInfo;
/**
 
 Tells the delegate that got the failure message from Twitter.
 @return void
 */

@end

/**
 Include the following framework into your application :- libxml2.dylib
 Set Header search path into build setting with the following value :- $(SDKROOT)/usr/include/libxml2
 */
@interface TWSharedManager : NSObject <SA_OAuthTwitterControllerDelegate>{
    
    UIViewController *m_controller;
	SA_OAuthTwitterEngine *_engine;	

    NSString *m_msg;
    
	int m_deviceType;
	int m_deviceMode;	
    
    id <TWSharedManagerDelegate> delegate;
    
    BOOL m_isLogInReq;
    
}
@property(nonatomic,assign)TwitterRequestType   requestType;

/**
 @required In case of publish.
 You can use the delegate to track whether publish is post or not on Twitter.
 */
@property (nonatomic, readwrite, assign)id <TWSharedManagerDelegate> delegate;
@property(nonatomic,retain)id   m_controller;
/**
 This method is used to initalize TwitterShareManager.
 @param a_controller to present the Twitter controller
 @return void
 */
- (id)initWithController:(UIViewController*)a_controller;

/**
 This method is used to open Twitter and publsih content.
 @param a_msg content to be published on Twitter
 @return void
 */
-(void)tweetWithMsg:(NSString *)a_msg;

/**
 This method is used to login in the Twitter.
 @return void
 */
-(void)loginTwitter;
-(void)getLoginUserDetails:(NSString *) userName;
-(void)getUserProfileImage:(NSString * )userName;
-(void)follow:(NSString *)a_strScreenName;
-(void)unfollow:(NSString *)a_strScreenName;

@end
