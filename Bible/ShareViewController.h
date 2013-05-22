//
//  ShareViewController.h
//  Bible
//
//  Created by Ashish Awasthi on 5/13/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWSharedManager.h"
#import "FBShareManager.h"

typedef enum{
 ShareViaEmail = 0,
 ShareViaFacebook,
 LikeOnFaceBook,
 ShareViaTwitter,
}ShareOption;


#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface ShareViewController : UIViewController<MFMailComposeViewControllerDelegate,
TWSharedManagerDelegate,FBShareManagerDelegate>{
    SLComposeViewController    *mySLComposerSheet;
     TWSharedManager           *m_twtManger;
    FaceBooKGetAndPostOption   _faceBooKGetAndPostOption;
}


@end
