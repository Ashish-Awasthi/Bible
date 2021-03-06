//
//  ShareViewCommanClass.h
//  Bible
//
//  Created by Ashish Awasthi on 5/21/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWSharedManager.h"
#import "FBShareManager.h"
#import "PersistenceDataStore.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
@interface ShareViewCommanClass :NSObject <MFMailComposeViewControllerDelegate,
TWSharedManagerDelegate,FBShareManagerDelegate>{
    SLComposeViewController    *mySLComposerSheet;
    TWSharedManager           *m_twtManger;
}
@property(nonatomic,retain)id viewController;
-(void)shareMessageViaEmail;
-(void)shareMessageViaEmailwithMailId:(NSString *)mailIdStr;
-(void)shareMessageViaFaceBook;
-(void)shareMessageViaTwitter;
-(void)openfaceLikeView;
-(void)callSocialMediaClasses;
@end
