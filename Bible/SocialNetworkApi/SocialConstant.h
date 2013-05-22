//
//  Constants.h
//  MusicChoice
//
//  Created by Ashish Awasthi on 17/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#define kDOCUMENT_DIR		[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

/**************************************************************************************************/



#define kPostMethod @"POST"
#define kFbMeAction @"me"
#define KFbfriends  @"friends"
#define kWallFeedAction @"feed"
#define kCommentsAction @"comments"
#define kLikesAction @"likes"
#define kPhotoAction  @"photos"
#define kResultKey    @"result"
#define kFbNameKey    @"name"
#define kFbMessageKey  @"message"
#define kFbDescriptionKey @"description"
#define kFbLinkKey     @"link"
#define kFbCaptionKey  @"caption"
#define kFbPictureKey  @"picture"
#define kFBVideoKey    @"videos"
#define kFbProperties @"properties"
#define kFbMyFeedsKey      @"me/feed"
#define KFbMyPhotoKey     @"me/photos"
#define kFbMyAlbumsKey     @"me/albums"
#define kFbMyEventskey     @"me/events"
#define KFbMyFriendskey    @"me/friends"
#define KFbMyCheckInskey   @"me/checkins"
#define KFbMyGroupkey      @"me/groups"
#define KFbMyLocationskey  @"me/locations"
#define KFbMyLikeskey      @"me/likes"
#define KFbPageLikeskey      @"pages/Music Choice/372563200384"



/************************************* SignIn/like/follow Info Keys ******************************************/

#define kFBAccessTokenKey                       @"fbAccessToken"
#define kSocialSiteLoginKey                     @"socialSiteLogin"
#define kFBLoginKey                             @"fbLogin"
#define kTWLoginKey                             @"twLogin"

#define kFBProfilePictureNameKey                @"fbProfilePicture.png"
#define kTWProfilePictureNameKey                @"twProfilePicture.png"

#define kFollowingMConTwitter                   @"FollowingMConTwitter"
#define KTwitterLoginIdKey                      @"TwitterLoginId"
#define KFaceBoooKLoginIdKey                    @"FaceBoooKLoginId"

#define kFontFamillyName                    @"Helvetica"
#define kUrlApplication   @"http://itunes.apple.com/in/app/hursts-the-heart-13th-edition/id509997109?mt=8"
#define KFacebookUrl @"https://graph.facebook.com/"

//**********  Twitter Constants ***********************

#define   KTwitterLoginKey   @"TwitterLogin"
#define   KTwitterUserScreenNameKey  @"screen_name"

typedef enum {
    FB_GetProfileImage = 1,
    FB_GetProfileDeatils,
    FB_GetProfileInfo,
    FB_PostProfileWall,
    FB_PostImages,
    FB_PostVideo,
    FB_friendsList,
    FB_GetFriendDetails,
    FB_GetFeeds,
    FB_GetPhotos,
    FB_GetAlbums,
    Fb_UpLoadVideo,
    FB_getEvents,
    FB_CheckIns,
    FB_Groups,
    Fb_Location,
    Fb_LikesPage,
    Fb_PageLike,
    FB_WallPost,
    
}FaceBooKGetAndPostOption;


typedef enum {
    
    kTwitterRequestTypeFollow =1 ,
    kTwitterLoginReasonFollow,
    kTwitterRequestTypeUnFollow,
    
}FollowOnTwitter;


typedef enum {
    
    LoginOnTwitter = 1,
    TweetOnTwitter,
    FollowSomeOneOnTwitter,
    UnFollowSomeOneOnTwitter,
        
}TwitterRequestType;