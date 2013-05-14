//
//  FBShareManager.h
//  MusicChoice
//
//  Created by Ashish Awasthi on 21/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"


@protocol FBShareManagerDelegate <NSObject>

@optional

-(void)facebookLoginSuccess;
-(void)facebookLoginFail;
-(void)facebookLoginCancel;

-(void)facebookLogoutSuccess;

-(void)facebookPostFeedSuccess;
-(void)facebookPostFeedFail;

-(void)facebookPostPhotoSuccess;
-(void)facebookPostPhotoFail;

-(void)deleteCurrentUnauthorisedUser;

-(void)facebookGetUserInfoSuccess:(NSDictionary *)a_dictUserDetail;
-(void)facebookGetUserInfoFail;

- (void)userDetailReceived:(NSDictionary *)a_dict;
-(void)showProfileImage:(NSData *)imgData;

-(void)duplicateMessageSendagain:(id)sender;

-(void)getCurrentUserFriendsList:(id)sender;
-(void)getCurrentUserFriendsListFail:(id)sender;

-(void)showFriendsDeatils:(id)sender;

-(void)showUserFeedsList:(id)sender;

-(void)showUserPhotos:(id)sender;

-(void)showUserAlbums:(id)sender;

-(void)showEventsList:(id)sender;

-(void)showCheckInList:(id)sender;

-(void)showGroupList:(id)sender;

-(void)showLocation:(id)sender;

-(void)showLikesList:(id)sender;


// ******* Upload Vedio Delegate Method************************
-(void)upLoadVedioSuccess:(id)sender;
-(void)upLoadVedioFail:(id)sender;

@end


@interface FBShareManager : NSObject <FBRequestDelegate,
                                    FBDialogDelegate,
                                    FBSessionDelegate>{
    Facebook* m_facebook;
   
    NSArray* m_permissions;
    
    NSString *m_commentMsg;
    NSString *m_titleName;
    NSString *m_linkUrl;
    NSString *m_description;
    NSString *m_iconUrl;
	NSString *m_caption;
	NSString *m_msg;
    NSData *m_imgData;
    NSString *m_feedId;
    
    BOOL m_onlyLogin;
    BOOL m_isFBPhoto;
    BOOL m_isLike;
    
    /***************************************** Public Member Variables ***************************************/
    
    id <FBShareManagerDelegate> delegate;
                                        
                                        
   
    /********************************************************************************************************/
}
@property(nonatomic,assign)FaceBooKGetAndPostOption  m_getPostOption;
/**
 @required In case of publish.
 You can use the delegate to track whether publish is post or not on Facebook.
 */
@property (nonatomic, readwrite, assign)id <FBShareManagerDelegate> delegate;

/**
 Title of Post
 */
@property(nonatomic,retain) NSString *m_titleName;

/**
 Link Url of Post eg. iTunes Url of app
 */
@property(nonatomic,retain) NSString *m_linkUrl;

/**
 Descripton of Post
 */
@property(nonatomic,retain) NSString *m_description;

/**
 Photo Url of Post
 */
@property(nonatomic,retain) NSString *m_iconUrl;

/**
 Caption of Post
 */
@property(nonatomic,retain) NSString *m_caption;

/**
 message of Post
 */
@property(nonatomic,retain) NSString *m_msg;

/**
 Photo data
 */
@property(nonatomic,retain) NSData *m_imgData;

/**
 Post Id
 */
@property(nonatomic,retain) NSString *m_feedId;
@property(nonatomic,retain) NSString *m_userId;

+ (FBShareManager*)sharedManager;


-(void)loginFacebook;

-(void)publishStream;


-(void)publishPhoto;


- (void)fbUserLogout;

- (void)getFBUserDetail;


- (void)getUserLikedPagesList:(id)sender;

- (void)getDetailOfCurrentlyLoggedInUser;

-(void)getProfilePhoto;
-(void)publishPhotoOnFB;
-(void)getCurrentUserLoginFriendsList;
-(void)getFriendsDeatils:(NSString *)userId;
-(void)getFeeds:(id)sender;
-(void)getPhotos:(id)sender;
-(void)getAlbums:(id)sender;
-(void)getEvents:(id)sender;
-(void)getCheckinsList:(id)sender;
-(void)getGroupList:(id)sender;
-(void)getLocation:(id)sender;

-(void)postVideo:(NSMutableDictionary *)dataDict;
-(void)likesFacebookPage:(NSDictionary *)dataDict;



@end
