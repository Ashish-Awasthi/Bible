//
//  ShareViewCommanClass.m
//  Bible
//
//  Created by Ashish Awasthi on 5/21/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import "ShareViewCommanClass.h"
#import "FbLikeViewViewController.h"

@implementation ShareViewCommanClass

@synthesize viewController;

#pragma Social Media Login


-(void)callSocialMediaClasses{
    
    m_twtManger = [[TWSharedManager alloc] init];
    [FBShareManager sharedManager].delegate = self;
}

-(void)faceBookLogin:(id)sender{
    [[FBShareManager sharedManager] loginFacebook];
}

-(void)postWallOnFacebook:(id)sender{
    [FBShareManager sharedManager].m_getPostOption = FB_PostProfileWall;
    [FBShareManager sharedManager].m_titleName  = @"The Oldest Bedtime Story Ever";
    [FBShareManager sharedManager].m_caption = @"";
    [FBShareManager sharedManager].m_description = FaceBookMsg;
    [FBShareManager sharedManager].m_iconUrl = @"";
    [FBShareManager sharedManager].m_linkUrl = @"";
    [FBShareManager sharedManager].m_msg =     FaceBookMsg;
    
    [[FBShareManager sharedManager]  publishStream];
}
#pragma marks-
#pragma mark <FBShareManagerDelegate>:
-(void)facebookLoginSuccess
{
    [BibleSingletonManager sharedManager].m_isFBLogin = YES;
    [FBShareManager sharedManager].m_getPostOption = FB_PostProfileWall;
    
    [FBShareManager sharedManager].delegate = self;
    [FBShareManager sharedManager].m_titleName = @"The Oldest Bedtime Story Ever";
    [FBShareManager sharedManager].m_description = FaceBookMsg;
    //[FBShareManager sharedManager].caption = @"Caption";
    [FBShareManager sharedManager].m_linkUrl = @"http://www.biblebeautiful.com"; // to be change to itunes link page
    [FBShareManager sharedManager].m_iconUrl = KBibleLogoUrl;
    [FBShareManager sharedManager].devName = @"Orson & Co";
    [FBShareManager sharedManager].devUrl = @"http://orsonandco.com/";
    [[FBShareManager sharedManager] publishFBPostWithDialog];
   
}


#pragma marks-
#pragma FaceResponce Delegate Message
-(void)facebookPostFeedSuccess{
    
    [[BibleSingletonManager sharedManager] showAlert:@"Facebook Message" message:@"Thanks for sharing." withTag:-1 withDelegate:nil];
    NSLog(@"face post now Success.....");
    
}
-(void)facebookPostFeedFail{
    NSLog(@"face post now fail.....");
    
    [[BibleSingletonManager sharedManager] showAlert:@"Failed" message:@"failed your post." withTag:-1 withDelegate:nil]; 
}


-(void)twitterLogin:(id)sender{
    
    NSString    *isItAlreadyLogin =  [[PersistenceDataStore sharedManager] getDatawithKey:KTwitterLoginKey];
    m_twtManger.delegate        = self;
    m_twtManger.m_controller    = viewController;
    
    if ([isItAlreadyLogin isEqualToString:@"YES"]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Info" message:@"You already posted this Message, please post different Message." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
        
       // [self postTweetButton:nil];
        // NSLog(@"Twitter already login is True....");
    }else{
        m_twtManger.requestType = LoginOnTwitter;
        [m_twtManger loginTwitter];
    }
  }
-(void)postTweetButton:(id)sender{
    m_twtManger.requestType = TweetOnTwitter;
    [m_twtManger tweetWithMsg:TwitterShareMsg];
}


#pragma marks-
#pragma mark TwitterManager delegates
-(void)twitterLoginFail
{
    [[BibleSingletonManager sharedManager] showAlert:@"Error" message:@"Log-in failed,try later." withTag:-1 withDelegate:nil];
    
}

- (void)twitterLoginSuccess:(NSString *)a_username
{
    NSLog(@"Twitter login success %@",a_username);
    [[PersistenceDataStore sharedManager] setData:@"YES" withKey:KTwitterLoginKey];
    [self postTweetButton:nil];
}


-(void)twitterPostDidSuccess:(NSString *) identifire;{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Tweet post" message:@"Thanks for sharing." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}
-(void)shareMessageViaEmail{
    
    if ([[BibleSingletonManager sharedManager]checkNetworkReachabilityWithAlert]) {
         [self postMessageViaEmail];
     }
}

-(void)shareMessageViaEmailwithMailId:(NSString *)mailIdStr{
    
    if ([[BibleSingletonManager sharedManager]checkNetworkReachabilityWithAlert]) {
        if ([MFMailComposeViewController canSendMail]) {
            
            MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
            [controller setToRecipients:[NSArray arrayWithObjects:mailIdStr, nil]];
            controller.mailComposeDelegate = self;
            [controller setSubject:KEmailSubjectMsgKey];
            [controller setMessageBody:EmailShareMsg isHTML:NO];
            if (controller)
                [viewController presentModalViewController:controller animated:YES];
            [controller release];
            
        } else {
            // Handle the error
            [[BibleSingletonManager sharedManager] showAlert:@"No Mail Accounts" message:@"There are no Mail account configured. You can add or create a Mail account in Settings." withTag:-1 withDelegate:nil];
        }

       
    }
}
-(void)shareMessageViaFaceBook{
    
if ([[BibleSingletonManager sharedManager]checkNetworkReachabilityWithAlert]) {
         
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysVer >= 6.0) {
        [self postMessageViaSocilaFrameWorkInFaceBook];
        
        // iOS-6.01+ code
    } else {
        [self faceBookLogin:nil];
        // prior iOS versions
    }
    }
}
-(void)shareMessageViaTwitter{
    
if ([[BibleSingletonManager sharedManager]checkNetworkReachabilityWithAlert]) {
        
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysVer >= 6.0) {
        [self postMessageViaSocilaFrameWorkInTwitter];
        
        // iOS-6.01+ code
    } else {
        [self twitterLogin:nil];
        // prior iOS versions
    }
    }
}

-(void)postMessageViaEmail{
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:KEmailSubjectMsgKey];
        [controller setMessageBody:EmailShareMsg isHTML:NO];
        if (controller)
            [viewController presentModalViewController:controller animated:YES];
        [controller release];
        
    } else {
        // Handle the error
        [[BibleSingletonManager sharedManager] showAlert:@"No Mail Accounts" message:@"There are no Mail account configured. You can add or create a Mail account in Settings." withTag:-1 withDelegate:nil];
    }
    
}

-(void)postMessageViaSocilaFrameWorkInFaceBook{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [mySLComposerSheet setInitialText:IOS6FaceBookMsg];
        [mySLComposerSheet addImage:[UIImage imageNamed:@"Icon-72.png"]];
        [mySLComposerSheet addURL:nil];
        
        [viewController presentViewController:mySLComposerSheet animated:YES completion:nil];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Thanks for sharing.";
                    break;
                default:
                    break;
            }
            [[BibleSingletonManager sharedManager] showAlert:@"Facebook Message" message:output withTag:-1 withDelegate:nil];
            
        }];
        
    }else{
        [[BibleSingletonManager sharedManager] showAlert:@"No Facebook Accounts" message:@"There are no Facebook account configured. You can add or create a Facebook account in Settings." withTag:-1 withDelegate:nil];
    }
    
}

-(void)postMessageViaSocilaFrameWorkInTwitter{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [mySLComposerSheet setInitialText:TwitterShareMsg];
        [mySLComposerSheet addImage:[UIImage imageNamed:@"Icon-72.png"]];
        [mySLComposerSheet addURL:[NSURL URLWithString:@"www.biblebeautiful.com"]];
        [viewController presentViewController:mySLComposerSheet animated:YES completion:nil];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Cancelled.";
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Thanks for sharing.";
                    break;
                default:
                    break;
            }
            [[BibleSingletonManager sharedManager] showAlert:@"Tweet  post" message:output withTag:-1 withDelegate:nil];
        }];
        
    }else{
        [[BibleSingletonManager sharedManager] showAlert:@"No Twitter Accounts" message:@"There are no Twitter account configured. You can add or create a Twitter account in Settings." withTag:-1 withDelegate:nil];
    }
    
}

#pragma marks
#pragma MFMailComposer Delegate-

-(void)mailComposeController:(MFMailComposeViewController*)controller
         didFinishWithResult:(MFMailComposeResult)result
                       error:(NSError*)error;
{
    
    NSString   *messageStr;
    
    switch (result) {
        case MFMailComposeResultSent:
            messageStr = @"Mail sent successfully.";
            break;
        case MFMailComposeResultSaved:
            messageStr = @"Mail saved successfully.";
            break;
        case MFMailComposeResultCancelled:
            messageStr = @"Mail is cancelled.";
            break;
        case MFMailComposeResultFailed:
            messageStr = @"Mail sending failed.";
            break;
            
        default:
            break;
    }
    
    [[BibleSingletonManager sharedManager] showAlert:@"Mail" message:messageStr withTag:-1 withDelegate:nil];
    [viewController dismissModalViewControllerAnimated:YES];
}
-(void)openfaceLikeView{
    
    if ([[BibleSingletonManager sharedManager] checkNetworkReachabilityWithAlert]) {
        FbLikeViewViewController    *fbLikeViewViewController = [[FbLikeViewViewController alloc] init];
        fbLikeViewViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [viewController presentViewController:fbLikeViewViewController animated:YES completion:^{
            //NSLog(@"Now Show FbLikeViewViewController");
        }];
        RELEASE(fbLikeViewViewController);
  
    }
}

@end
