//
//  ShareViewController.m
//  Bible
//
//  Created by Ashish Awasthi on 5/13/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import "ShareViewController.h"
#import "PersistenceDataStore.h"
#define ShareOptionArr \
@"icon_email.png",\
@"icon_facebook.png",\
@"icon_facebook.png",\
@"icon_twitter.png",\
nil

// ,
@interface ShareViewController ()
-(void)callSocialMediaClasses;
-(void)addShareOption;
-(void)shareMessageViaEmail;
-(void)shareMessageViaFaceBook;
-(void)shareMessageViaTwitter;
-(void)likeOnFaceBook;
@end

@implementation ShareViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage     *image;
    CGRect    frameSize;
    image = [UIImage imageNamed:@"Share_Bg.png"];
    frameSize = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIImageView    *bgImageView = [[UIImageView alloc] init];
    [bgImageView setUserInteractionEnabled:YES];
    [bgImageView setFrame:frameSize];
    [bgImageView setImage:image];
    [self.view addSubview:bgImageView];
     RELEASE(bgImageView);
    
    image = [UIImage imageNamed:@"btn_back.png"];
    frameSize = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:frameSize];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBackOnLastView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [self callSocialMediaClasses];
    [self addShareOption];
	// Do any additional setup after loading the view.
}

#pragma marks
#pragma Button Eevent
-(void)goBackOnLastView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Go back On last Page");
    }];
}
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
    [FBShareManager sharedManager].m_titleName  = @"Testing Project....";
    [FBShareManager sharedManager].m_caption = @"No caption related to wall";
    [FBShareManager sharedManager].m_description = @"testing only social networking on iPhone or iPad....";
    [FBShareManager sharedManager].m_iconUrl = @"";
    [FBShareManager sharedManager].m_linkUrl = @"";
    [FBShareManager sharedManager].m_msg =     @"Testing.....";
    
    [[FBShareManager sharedManager]  publishStream];
}
#pragma marks-
#pragma mark <FBShareManagerDelegate>:
-(void)facebookLoginSuccess
{
    NSLog(@"=======FacBook login success");
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
    [m_twtManger tweetWithMsg:@"Hi every one... hope so injoy today......"];
}


#pragma marks-
#pragma mark TwitterManager delegates
-(void)twitterLoginFail
{
    NSLog(@"Twitter login Fail");
    
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


-(void)addShareOption{
    
    UIImage     *image;
    CGRect    frameSize;
    NSArray   *optionArr = [NSArray arrayWithObjects:ShareOptionArr];
    int xOffSet = 150;
    int yoffSet = 360;
    
    for (int i = 0; i<[optionArr count]; i++) {
    image = [UIImage imageNamed:[optionArr objectAtIndex:i]];
    frameSize = CGRectMake(xOffSet, yoffSet, image.size.width, image.size.height);
    UIButton *shareOptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareOptionBtn setTag:i];
    [shareOptionBtn setFrame:frameSize];
    [shareOptionBtn setImage:image forState:UIControlStateNormal];
    [shareOptionBtn addTarget:self action:@selector(tabOnShareOption:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareOptionBtn];
    yoffSet = yoffSet+image.size.height+50;
        
    }

}



-(void)tabOnShareOption:(id)sender{
    
    UIButton    *shareOptionBtn = (UIButton *)sender;
    
    switch (shareOptionBtn.tag) {
        case ShareViaEmail:
            [self shareMessageViaEmail];
            break;
        case ShareViaFacebook:
            [self shareMessageViaFaceBook];
            break;
        case LikeOnFaceBook:
            [self likeOnFaceBook];
            break;
        case ShareViaTwitter:
            [self shareMessageViaTwitter];
            break;
            
        default:
            break;
    }
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
-(void)likeOnFaceBook{
     NSLog(@"likeOnFaceBook");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)postMessageViaEmail{
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Test mail"];
        [controller setMessageBody:@"Hi Ashi, \n\n Are u there ?" isHTML:NO];
        if (controller) [self presentModalViewController:controller animated:YES];
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
        [mySLComposerSheet setInitialText:@"Post Message\n"];
        [mySLComposerSheet addImage:[UIImage imageNamed:@"image_1.png"]];
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://wwww.flaggShow.info"]];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        
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
        [mySLComposerSheet setInitialText:@"Post Message\n"];
        [mySLComposerSheet addImage:[UIImage imageNamed:@"image_1.png"]];
        [mySLComposerSheet addURL:[NSURL URLWithString:@"http://wwww.flaggShow.info"]];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
        
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
    [self dismissModalViewControllerAnimated:YES];
}

@end
