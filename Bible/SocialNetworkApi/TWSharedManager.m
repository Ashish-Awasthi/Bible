//
//  TWSharedManager.m
//  MusicChoice
//
//  Created by Ashish Awasthi on 21/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TWSharedManager.h"
#import "SA_OAuthTwitterEngine.h"

@interface TWSharedManager (privateFn)

-(void)openTwitterAPI;
-(NSString*)deviceNameFor:(NSString *)aName ofType:(NSString *)aType;
-(void)setDeviceType;

@end


@implementation TWSharedManager

@synthesize delegate;
@synthesize m_controller;
@synthesize requestType;


- (id)initWithController:(UIViewController*)a_controller{
    
    self = [super init];
    if (self) {
        // Initialization code.
		m_controller = a_controller;
    }
    return self;
}

- (void)dealloc {
	
	if (_engine) {
		[_engine release];
		_engine = nil;
	}
    [super dealloc];
}

#pragma  Shared Maneger Public Method    

-(void)loginTwitter{

	[self openTwitterAPI];
}

-(void)openTwitterAPI
{
	[self setDeviceType];
	
	if(m_controller.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || 
       m_controller.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
		
        m_deviceMode = kDeviceModeLandscape;
		
	} else {
		m_deviceMode = kDeviceModePotrait;
	}
	
	if(!_engine){
		_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
		_engine.consumerKey    = kOAuthConsumerKey;
		_engine.consumerSecret = kOAuthConsumerSecret;	
	}
	
	UIViewController *controller1 = [SA_OAuthTwitterController 
                                     controllerToEnterCredentialsWithTwitterEngine:_engine 
                                     delegate:self 
                                     forOrientation:m_controller.interfaceOrientation];
	
	    if (controller1){
		m_isLogInReq = TRUE;
		[m_controller presentModalViewController:controller1 animated:YES];
		
	     }  else if([SA_OAuthTwitterController credentialEntryRequiredWithTwitterEngine:_engine] == FALSE){
        
          [_engine sendUpdate:[NSString stringWithFormat:@"%@",m_msg]];
		
          }
}


-(void)tweetWithMsg:(NSString *)a_msg{
	
	m_msg = [[NSString alloc]initWithString:a_msg];
  
	[self openTwitterAPI];
}

-(void)getLoginUserDetails:(NSString *) userName{
    
    [_engine getUserInformationFor:userName];
}

-(void)follow:(NSString *)a_strScreenName
{
    [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate: self];
    [_engine enableUpdatesFor:a_strScreenName];
}


-(void)unfollow:(NSString *)a_strScreenName
{
    [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate: self];
    [_engine disableUpdatesFor:a_strScreenName];
}

-(void)getUserProfileImage:(NSString * )userName{

}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller 
	  authenticatedWithUsername: (NSString *) username{

      //  [m_controller dismissModalViewControllerAnimated:YES];
        
        if ([delegate respondsToSelector: @selector(twitterLoginSuccess:)]){
            
            [delegate twitterLoginSuccess:username];
        }
		return;
		
    [_engine sendUpdate:[NSString stringWithFormat:@"%@",m_msg]];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller{
	    
   // [m_controller dismissModalViewControllerAnimated:YES];
    
    if ([delegate respondsToSelector: @selector(twitterLoginFail)]){
        
        [delegate performSelector:@selector(twitterLoginFail)];
    }
}


- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller
{
       
   // [m_controller dismissModalViewControllerAnimated:YES];
	
    if ([delegate respondsToSelector: @selector(twitterLoginCancel)]){
        
        [delegate performSelector:@selector(twitterLoginCancel)];
    }
}

#pragma mark SA_OAuthTwitterEngineDelegate method

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

#pragma mark TwitterEngineDelegate

- (void) requestSucceeded: (NSString *) requestIdentifier {
	
    [m_controller dismissModalViewControllerAnimated:YES];
    
    switch (requestType) {
            
        case LoginOnTwitter:
            
           
            break;
            
        case TweetOnTwitter:
            
            if ([delegate respondsToSelector: @selector(twitterPostDidSuccess:)]){
                
                [delegate twitterPostDidSuccess:requestIdentifier];
            }
            
            break;
            
        case FollowSomeOneOnTwitter:
            
            if ([delegate respondsToSelector: @selector(twitterOnFollowSuccess:)]){
                
                [delegate twitterOnFollowSuccess:requestIdentifier];
            }
            break;
            
        case UnFollowSomeOneOnTwitter:
            
            if ([delegate respondsToSelector: @selector(twitterOnUnFollowSuccess:)]){
                
                [delegate twitterOnUnFollowSuccess:requestIdentifier];
                
            }
            break;
            
        default:
            break;
    }
    
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
	
    [m_controller dismissModalViewControllerAnimated:YES];
	
	if(error.code == 403){
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Info" message:@"You already posted this Message, please post different Message." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
	} else {
		
		if ([delegate respondsToSelector: @selector(twitterPostDidFail)]){
			
			[delegate twitterPostDidFail];
		}
	}
}


#pragma mark device settings 

-(void)setDeviceType 
{
	float systemValue = [[UIDevice currentDevice].systemVersion floatValue];
	NSString *deviceModel = [UIDevice currentDevice].model;
	NSRange rangeVar = [deviceModel rangeOfString:@" "];
	
	if(rangeVar.length != 0){
		
		rangeVar.length =rangeVar.location;
		rangeVar.location = 0;
		deviceModel = [deviceModel substringWithRange:rangeVar];
	}
	
	if(systemValue >= 3.2 && [deviceModel isEqualToString:@"iPad"]){
		m_deviceType = kDeviceTypeIPad;
		return;
	}
	
	if(systemValue < 3.2 || (systemValue >= 4.0 && ![deviceModel isEqualToString:@"iPad"])){
		
		if(systemValue < 3.2){
			m_deviceType = kDeviceTypeIPhone;
		} else if([UIScreen mainScreen].currentMode.size.width == 640 || [UIScreen mainScreen].currentMode.size.width == 960){
			m_deviceType = kDeviceTypeIPhoneRetina;
		} else {
			m_deviceType = kDeviceTypeIPhone;
		}
		
	}
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier
{
	
	NSLog(@"User Info Received: %@", userInfo);
    
    if([delegate respondsToSelector:@selector(userInfoReceived:)])
    {
        [delegate userInfoReceived:userInfo];
    }
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier
{
	
	NSLog(@"Misc Info Received: %@", miscInfo);
}


@end

