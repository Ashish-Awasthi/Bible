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

#pragma Social Media Login

-(void)callSocialMediaClasses{
    
    m_twtManger = [[TWSharedManager alloc] init];
    m_twtManger.delegate        = self;
    m_twtManger.m_controller    = self;
    [FBShareManager sharedManager].delegate = self;
}

-(void)faceBookLogin:(id)sender{
    [[FBShareManager sharedManager] loginFacebook];
}

-(void)postWallOnFacebook:(id)sender{
    [FBShareManager sharedManager].m_getPostOption = FB_PostProfileWall;
    [FBShareManager sharedManager].m_titleName  = @"";
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
    [self postWallOnFacebook:nil];
}


#pragma marks-
#pragma FaceResponce Delegate Message
-(void)facebookPostFeedSuccess{
    
    NSLog(@"face post now Success.....");
    
}
-(void)facebookPostFeedFail{
    NSLog(@"face post now fail.....");
    
}


-(void)twitterLogin:(id)sender{
    
    NSString    *isItAlreadyLogin =  [[PersistenceDataStore sharedManager] getDatawithKey:KTwitterLoginKey];
    
    if ([isItAlreadyLogin isEqualToString:@"YES"]) {
        [self postTweetButton:nil];
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
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Info" message:@"Thanks for sharing this post...." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
    
}
-(void)shareMessageViaEmail{
    [self postMessageViaEmail];
}
-(void)shareMessageViaFaceBook{
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysVer >= 6.0) {
        [self postMessageViaSocilaFrameWorkInFaceBook];
        
        // iOS-6.01+ code
    } else {
        [self faceBookLogin:nil];
        // prior iOS versions
    }
    
}
-(void)shareMessageViaTwitter{
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysVer >= 6.0) {
        [self postMessageViaSocilaFrameWorkInTwitter];
        
        // iOS-6.01+ code
    } else {
        [self twitterLogin:nil];
        // prior iOS versions
    }
    
}

-(void)postMessageViaEmail{
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"History of a Bible, illustrated by Benjamin Morse"];
        [controller setMessageBody:EmailShareMsg isHTML:NO];
        if (controller)
            [[BibleSingletonManager sharedManager]._rootViewController presentModalViewController:controller animated:YES];
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
        [mySLComposerSheet setInitialText:FaceBookMsg];
        [mySLComposerSheet addImage:[UIImage imageNamed:@"Icon-72.png"]];
        [mySLComposerSheet addURL:[NSURL URLWithString:@"www.biblebeautiful.com"]];
        [[BibleSingletonManager sharedManager]._rootViewController presentViewController:mySLComposerSheet animated:YES completion:nil];
        
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
        [mySLComposerSheet addImage:[UIImage imageNamed:@"image_1.png"]];
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://orsonandco.com/"]];
        [[BibleSingletonManager sharedManager]._rootViewController presentViewController:mySLComposerSheet animated:YES completion:nil];
        
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
            messageStr = @"Your mail send successfully.";
            break;
        case MFMailComposeResultSaved:
            messageStr = @"Your mail saved successfully.";
            break;
        case MFMailComposeResultCancelled:
            messageStr = @"Your mail send cancel.";
            break;
        case MFMailComposeResultFailed:
            messageStr = @"Your mail sending failed.";
            break;
            
        default:
            break;
    }
    
    [[BibleSingletonManager sharedManager] showAlert:@"Mail" message:messageStr withTag:-1 withDelegate:nil];
    [[BibleSingletonManager sharedManager]._rootViewController dismissModalViewControllerAnimated:YES];
}
-(void)openfaceLikeView{
    
    FbLikeViewViewController    *fbLikeViewViewController = [[FbLikeViewViewController alloc] init];
    fbLikeViewViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [[BibleSingletonManager sharedManager]._rootViewController presentViewController:fbLikeViewViewController animated:YES completion:^{
        NSLog(@"Now Show FbLikeViewViewController");
    }];
    RELEASE(fbLikeViewViewController);
}
@end
