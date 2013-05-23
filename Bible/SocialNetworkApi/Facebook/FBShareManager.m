//
//  FBShareManager.m
//  MusicChoice
//
//  Created by Ashish Awasthi on 21/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define kFbIdKey  @"id"

#import "FBShareManager.h"


/***************************************** Private Member Functions ***************************************/

@interface FBShareManager (privateFn)

-(void)resetAllMembers;

-(void)postNewFeedOnFBWithType:(NSString*)postType 
                    withParams:(NSMutableDictionary*)param;

-(void)fbUserLogin;

-(void)publishFBPost;

-(void)publishPhotoOnFB;

-(void)likeOnFB;

-(void)setFBAccessToken;

-(void)getProfilePhoto;

-(void)getUserProfileInfo;

@end



@implementation FBShareManager

@synthesize m_getPostOption;
@synthesize delegate;
@synthesize m_titleName;
@synthesize m_linkUrl;
@synthesize m_description;
@synthesize m_iconUrl;
@synthesize m_caption;
@synthesize m_msg;
@synthesize m_imgData;
@synthesize m_feedId;
@synthesize m_userId;
@synthesize devName;
@synthesize devUrl;
@synthesize isFBDialog;


static FBShareManager* _sharedManager; // self

#pragma mark Singleton Methods

+(FBShareManager *)sharedManager{
    
	@synchronized(self) {
		
        if (_sharedManager == nil) {
			
            [[self alloc] init]; // assignment not done here
        }
    }
    
    return _sharedManager;
}


-(id)init{
    self = [super init];
    
    if (self) {
        
        m_permissions =  [[NSArray arrayWithObjects:
                           @"read_stream",
                           @"publish_stream",
                           @"user_photos",
                           @"offline_access",
                           @"email",
                           @"user_events",
                           @"user_groups",
                           @"user_checkins",
                           @"user_likes",
                           nil] retain];
        
        m_facebook = [[Facebook alloc] initWithAppId:[[[[[[NSBundle mainBundle] 
                                                          objectForInfoDictionaryKey:@"CFBundleURLTypes"]  
                                                         objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"] 
                                                       objectAtIndex:0] substringFromIndex:2]];
        
        [self setFBAccessToken];
        [self resetAllMembers];
    }
    
    return self;
}


+ (id)allocWithZone:(NSZone *)zone{	
    
    @synchronized(self) {
		
        if (_sharedManager == nil) {
			
            _sharedManager = [super allocWithZone:zone];			
            return _sharedManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone{
    
    return self;	
}


- (id)retain{
	
    return self;	
}

- (unsigned)retainCount{
    
    return UINT_MAX;  //denotes an object that cannot be released
}

- (void)release{
    
    //do nothing
}

- (id)autorelease{
    
    return self;	
}

- (void)dealloc{
    
	if (m_facebook) {
		m_facebook = nil;
	}
    
    if (m_permissions) {
		[m_permissions release];
	}
    
    [super dealloc];
}



#pragma mark FBSessionDelegate Methods

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin{
    
    [[NSUserDefaults standardUserDefaults] setBool:TRUE
                                            forKey:kFBLoginKey];
    
    [[NSUserDefaults standardUserDefaults] setBool:TRUE
                                            forKey:kSocialSiteLoginKey];
    
    [[NSUserDefaults standardUserDefaults] setObject:m_facebook.accessToken
                                              forKey:kFBAccessTokenKey];
    if(m_onlyLogin){
		
        if ([delegate respondsToSelector: @selector(facebookLoginSuccess)]){
            
            [delegate performSelector:@selector(facebookLoginSuccess)];
        }
        
		return;
        
	}
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled
{
    [[NSUserDefaults standardUserDefaults] setBool:FALSE
                                            forKey:kFBLoginKey];
    
    if(!cancelled)
    {

        
        if ([delegate respondsToSelector: @selector(facebookLoginFail)])
        {
            [delegate facebookLoginFail];
        }
        
    } else {
        
                
        if ([delegate respondsToSelector: @selector(facebookLoginCancel)])
        {
            [delegate facebookLoginCancel];
        }
    }
    
}

-(void)publishFBPostWithDialog{
	
	NSMutableDictionary *fbArguments = [[[NSMutableDictionary alloc] init] autorelease];
	
	[fbArguments setObject:self.m_titleName forKey:@"name"];
	[fbArguments setObject:self.m_caption forKey:@"caption"];
	[fbArguments setObject:self.m_description forKey:@"description"];
	[fbArguments setObject:self.m_linkUrl forKey:@"link"];
	[fbArguments setObject:KBibleLogoUrl forKey:@"picture"];
	[fbArguments setObject:m_msg forKey:@"message"];
	
	if(![self.devName isEqualToString:@""] && ![self.devUrl isEqualToString:@""]){
		
		[fbArguments setObject:[NSString stringWithFormat:@"{\"Developed by\":{\"text\":\"%@\",\"href\":\"%@\"}}",
								self.devName,self.devUrl] forKey:@"properties"];
	}
	
	if(isFBDialog == TRUE){
		
		[m_facebook dialog:@"feed"
			   andParams:fbArguments
			 andDelegate:self];
		
	} else {
		
		[m_facebook requestWithGraphPath:@"me/feed"
                             andParams:fbArguments
                         andHttpMethod:@"POST"
                           andDelegate:self];
	}
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout{
    
    //[MCSingletonManager sharedManager].m_isFBLogin = FALSE;
    
    if ([delegate respondsToSelector: @selector(facebookLogoutSuccess)]){
        
        [delegate performSelector:@selector(facebookLogoutSuccess)];
    }
}




#pragma mark Publlic Methods

-(void)fbUserLogin{
    
    [m_facebook authorize:m_permissions delegate:self];
}


-(void)getFBUserDetail{
    
    [self getProfilePhoto];
}

-(void)fbUserLogout{
    
    [m_facebook logout:self];
    
}

-(void)loginFacebook{
	
	m_onlyLogin = TRUE;
   [self fbUserLogin];
	
}

-(void)publishStream{
	
    [self setFBAccessToken];
    
    m_isFBPhoto = FALSE;
    m_isLike = FALSE;
	m_onlyLogin = FALSE;
    
    if([m_facebook isSessionValid]){
        [self publishFBPost];
    } else {
        [self fbUserLogin];
    }
}




-(void)setFBAccessToken{
    
    m_facebook.accessToken = [[NSUserDefaults standardUserDefaults]
                              objectForKey:kFBAccessTokenKey];
}


//************** Get data form facebook api*****************************

- (void)getUserLikedPagesList:(id)sender
{
    [m_facebook requestWithGraphPath:KFbMyLikeskey andDelegate:self];
    
}

-(void)getUserProfileInfo{
	
	[m_facebook requestWithGraphPath:kFbMeAction andDelegate:self];
}

-(void)getProfilePhoto{
    
    [m_facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/%@",
                                    kFbMeAction,kFbPictureKey]
                       andDelegate:self];
    
}

-(void)getProfilePhotoFriend:(NSString *)userId{
    
    [m_facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/picture",
                                userId]
                         andDelegate:self];
}

- (void)getDetailOfCurrentlyLoggedInUser
{
    [m_facebook requestWithGraphPath:kFbMeAction andDelegate:self];
}

-(void)getCurrentUserLoginFriendsList{
  [m_facebook requestWithGraphPath:KFbMyFriendskey andDelegate:self];
 }

-(void)getFriendsDeatils:(NSString *)userId{
    
 [m_facebook requestWithGraphPath:userId andDelegate:self];
    
}

-(void)getFeeds:(id)sender{
    
    [m_facebook requestWithGraphPath:kFbMyFeedsKey andDelegate:self];

}

-(void)getPhotos:(id)sender{
    
    [m_facebook requestWithGraphPath:KFbMyPhotoKey andDelegate:self];
    
}
-(void)getAlbums:(id)sender{
    
    [m_facebook requestWithGraphPath:kFbMyAlbumsKey andDelegate:self];
    
}

-(void)getEvents:(id)sender{
    
   [m_facebook requestWithGraphPath:kFbMyEventskey andDelegate:self];
 
}

-(void)getCheckinsList:(id)sender{
    
     [m_facebook requestWithGraphPath:KFbMyCheckInskey andDelegate:self];
}

-(void)getGroupList:(id)sender{
    
  [m_facebook requestWithGraphPath:KFbMyGroupkey andDelegate:self];
}

-(void)getLocation:(id)sender{
    
    [m_facebook requestWithGraphPath:KFbMyLocationskey andDelegate:self];
}
//********* Post Data on Facebook*******************************

-(void)postNewFeedOnFBWithType:(NSString*)postType
                    withParams:(NSMutableDictionary*)param{
    
    [param setObject:@"{\"Developed By\":{\"text\":\"KiwiTech\",\"href\":\"www.kiwitech.com\"}}"
              forKey:kFbProperties];
    
    [m_facebook requestWithGraphPath:postType
                           andParams:param
                       andHttpMethod:kPostMethod
                         andDelegate:self];
    
}

-(void)publishPhoto{
    
    [self setFBAccessToken];
    
    m_isFBPhoto = TRUE;
    m_isLike = FALSE;
	m_onlyLogin = FALSE;
    
	if([m_facebook isSessionValid]){
        
        [self publishPhotoOnFB];
    } else {
        
        [self fbUserLogin];
    }
}

-(void)postVideo:(NSMutableDictionary *)dataDict{
    
    [self postNewFeedOnFBWithType:[NSString stringWithFormat:@"%@/%@",
                                   kFbMeAction,kFBVideoKey]
                       withParams:dataDict];
}

-(void)publishPhotoOnFB{
    
    NSMutableDictionary *fbArguments = [[[NSMutableDictionary alloc] init] autorelease];
    
    [fbArguments setObject:self.m_imgData forKey:kFbPictureKey];
	[fbArguments setObject:self.m_msg forKey:kFbMessageKey];
    
    [self postNewFeedOnFBWithType:[NSString stringWithFormat:@"%@/%@",
                                   kFbMeAction,kPhotoAction]
                       withParams:fbArguments];
    
}


-(void)publishFBPost{
    
    NSMutableDictionary *fbArguments = [[NSMutableDictionary alloc] init];
	
	[fbArguments setObject:self.m_titleName forKey:kFbNameKey];
	[fbArguments setObject:self.m_caption forKey:kFbCaptionKey];
	[fbArguments setObject:self.m_description forKey:kFbDescriptionKey];
	[fbArguments setObject:self.m_linkUrl forKey:kFbLinkKey];
	[fbArguments setObject:self.m_iconUrl forKey:kFbPictureKey];
	[fbArguments setObject:self.m_msg forKey:kFbMessageKey];
    
    [self postNewFeedOnFBWithType:[NSString stringWithFormat:@"%@/%@",
                                   kFbMeAction,kWallFeedAction]
                       withParams:fbArguments];
    
}
-(void)likesFacebookPage:(NSDictionary *)dataDict{
    
     [m_facebook requestWithGraphPath:KFbPageLikeskey andDelegate:self];
}

#pragma mark FBRequestDelegate Methods

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result{
    
    NSLog(@"loaded %@",request.url);
   // NSLog(@"==== %@",result);
    
    NSLog(@"%d",self.m_getPostOption);
    
    switch (self.m_getPostOption) {
            
        case FB_GetProfileImage:{
            
            if(result != nil){
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                
                NSString *documentsPath = [[paths objectAtIndex:0]
                                           stringByAppendingPathComponent:kFBProfilePictureNameKey];
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                BOOL success = [fileManager fileExistsAtPath:documentsPath];
                
                if (success){
                    [fileManager removeItemAtPath:documentsPath error:nil];
                }
                
                [fileManager createFileAtPath:documentsPath contents:result attributes:nil];
            }
            
            if ([self.delegate respondsToSelector:@selector(showProfileImage:)]) {
                
                [self.delegate  showProfileImage:result];
            }

        }
            break;
        case FB_PostImages:{
            
            if([(NSDictionary*)result objectForKey:kFbIdKey] != NULL){
                
                if ([delegate respondsToSelector: @selector(facebookPostPhotoSuccess)]){
                
                [delegate facebookPostPhotoSuccess];
                    }
                
                } else {
                
                if ([delegate respondsToSelector: @selector(facebookPostPhotoFail)]){
                                
                [delegate facebookPostPhotoFail];
                }    
                }
           }
            break;
        case FB_PostProfileWall:{
            
            if([(NSDictionary*)result objectForKey:kFbIdKey] != NULL){
                
                if ([delegate respondsToSelector: @selector(facebookPostFeedSuccess)]){
                    
                    [delegate facebookPostFeedSuccess];
                }
                
            } else {
                
                if ([delegate respondsToSelector: @selector(facebookPostFeedFail)]){
                    
                    [delegate facebookPostFeedFail];
                }
            }

        }
            break;
         case FB_GetProfileDeatils:{
             
             if ([delegate respondsToSelector: @selector(facebookGetUserInfoSuccess:)]){
                 
                 [delegate facebookGetUserInfoSuccess:(NSDictionary*)result];
             }
             

         }
         break;   
        case FB_friendsList:{
            
            if(result != nil){
                
                if ([self.delegate respondsToSelector:@selector(getCurrentUserFriendsList:)]) {
                    
                    [self.delegate  getCurrentUserFriendsList:result];
                }
            }

        }
        break;
            
        case FB_GetFriendDetails:{
            
            if(result != nil){
            
            if ([self.delegate respondsToSelector:@selector(showFriendsDeatils:)]) {
              [self.delegate  showFriendsDeatils:result];
            }
            }

         }
        break;
        case FB_GetFeeds:{
            
            if(result != nil){
                
                if ([self.delegate respondsToSelector:@selector(showUserFeedsList:)]) {
                    [self.delegate  showUserFeedsList:result];
                }
            }
            
        }
            break;
            
        case FB_GetPhotos:{
            
            if(result != nil){
            if([(NSDictionary*)result objectForKey:kFbIdKey] != NULL){
                
                if ([self.delegate respondsToSelector:@selector(showUserPhotos:)]) {
                    [self.delegate  showUserPhotos:result];
                }
                }
            }
            
        }
            break;
            
        case FB_GetAlbums:{
            
            if(result != nil){
                
                if ([self.delegate respondsToSelector:@selector(showUserAlbums:)]) {
                    [self.delegate  showUserAlbums:result];
                }
            }
            
        }
            break;
            
        case FB_getEvents:{
            
            if(result != nil){
                if ([self.delegate respondsToSelector:@selector(showEventsList:)]) {
                    [self.delegate  showEventsList:result];
                }
            }
        
          }
            
        break;
            
        case FB_CheckIns:{
            
            if(result != nil){
                if ([self.delegate respondsToSelector:@selector(showCheckInList:)]) {
                    [self.delegate  showCheckInList:result];
                }
            }
            
        }
            
        break;
            
        case FB_Groups:{
            
            if(result != nil){
                if ([self.delegate respondsToSelector:@selector(showGroupList:)]) {
                    [self.delegate  showGroupList:result];
                }
            }
            
        }
            
            break;
            
        case Fb_Location:{
            
            if(result != nil){
                if ([self.delegate respondsToSelector:@selector(showLocation:)]) {
                    [self.delegate  showLocation:result];
                }
            }
            
           }
            
            break;

        case Fb_LikesPage:{
            
            if(result != nil){
                if ([self.delegate respondsToSelector:@selector(showLikesList:)]) {
                    [self.delegate  showLikesList:result];
                }
            }
            
            
        }
            break;
            
            
        case FB_PostVideo:{
            
            if(result != nil){
                if ([self.delegate respondsToSelector:@selector(upLoadVedioSuccess:)]) {
                    [self.delegate  upLoadVedioSuccess:result];
                }
            }
            
            else{
                if ([self.delegate respondsToSelector:@selector(upLoadVedioFail:)]) {
                    [self.delegate  upLoadVedioFail:result];
                }
                
            }
        }
        
        break;

   
       
            
        default:
            break;
    }
    
}



/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    
    NSLog(@"%@", [[[error userInfo] objectForKey:@"error"] objectForKey:kFbMessageKey]);
    
    NSString   *returnMsgStr = [[[error userInfo] objectForKey:@"error"] objectForKey:kFbMessageKey];
    returnMsgStr = [[returnMsgStr componentsSeparatedByString:@")"]lastObject];
    [returnMsgStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([returnMsgStr isEqualToString:@" Duplicate status message"]) {
        
        if ([delegate respondsToSelector: @selector(duplicateMessageSendagain:)]){
            [delegate respondsToSelector:@selector(duplicateMessageSendagain:)];
        }
        return;
    }
    
    if([[[[error userInfo] objectForKey:@"error"] objectForKey:kFbMessageKey]
        rangeOfString:@"Error validating access token: The session has been invalidated because the user has changed the password."].
       length){
        
        [self fbUserLogin];
        
        return;
    }
    
    switch (m_getPostOption) {
            
        case FB_PostImages:
            if ([delegate respondsToSelector: @selector(facebookPostPhotoFail)]){
                
                [delegate facebookPostPhotoFail];
            }
            break;
        case FB_PostProfileWall:
            if ([delegate respondsToSelector: @selector(facebookPostFeedFail)]){
                
                [delegate facebookPostFeedFail];
            }
            break;
            
        case FB_GetProfileDeatils:
            
            if ([delegate respondsToSelector: @selector(facebookGetUserInfoFail)]){
                
                [delegate facebookGetUserInfoFail];
            }
            
            break;
            
        case FB_PostVideo:{
            if ([self.delegate respondsToSelector:@selector(upLoadVedioFail:)]) {
                [self.delegate  upLoadVedioFail:error];
            }
            break;
        }
            
            
            
        default:
            break;
    }
    
    if([request.url hasSuffix:[NSString stringWithFormat:@"%@/%@",
                               kFbMeAction,kFbPictureKey]]){
        
        [self getUserProfileInfo];
    }
    else if([request.url hasSuffix:[NSString stringWithFormat:@"%@/%@",
                                    kFbMeAction,KFbfriends]]){
        
        [self getUserProfileInfo];
    }
}

/**
 * Called just before the request is sent to the server.
 */
- (void)requestLoading:(FBRequest *)request{
    
}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response{
    
}

#pragma mark FBDialogDelegate Methods
/**
 * Called when the dialog succeeds and is about to be dismissed.
 */
- (void)dialogDidComplete:(FBDialog *)dialog{
}

/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)dialogDidNotComplete:(FBDialog *)dialog{
    
    //NSLog(@"cancelled");
}

/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error{
    
    //NSLog(@"Dialog Error : %@",[error localizedDescription]);
}

-(void)resetAllMembers{
    
    self.m_titleName = @"";
    self.m_linkUrl = @"";
    self.m_description = @"";
    self.m_iconUrl = @"";
    self.m_caption = @"";
    self.m_msg = @"";
    self.m_imgData = [NSData data];
    m_isFBPhoto = FALSE;
    m_isLike = FALSE;
	m_onlyLogin = FALSE;
}


@end

