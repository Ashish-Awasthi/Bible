//
//  MenuSliderViewController.h
//  HPS
//
//  Created by KiwiTech on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animator.h"

#define kIPadPortraitScreenWidth 768
#define kIPadPortraitScreenHeight 1004
#define kCollapseMargin 24
#define kRightMenuMargin 0
#define kHorizontalMargin 50
#define animationRepeatCount 1
#define PageSwipedNotification @"PageSwipedNotification"
#define PageSwipedForwardNotification @"PageSwipedForwardNotification"
#define PageSwipedBackwardNotification @"PageSwipedBackwardNotification"
#define DeviceDisturbedNotification @"DeviceDisturbedNotification" 

@interface MenuSliderViewController : UIViewController <UIGestureRecognizerDelegate, AnimatorDelegate>
{
	IBOutlet UIView *menuView;

	IBOutlet UIImageView *sliderImage;
	
	IBOutlet UIImageView *ribbonImage;
	
   	IBOutlet UILabel *galleryLabel;
    
    IBOutlet UILabel *authorsInterviewLabel1;
    
	IBOutlet UILabel *authorsInterviewLabel2;
	
    IBOutlet UILabel *shareLabel;
    
    IBOutlet UILabel *historyLabel;
    
    IBOutlet UILabel *breadCrumb;
    
    IBOutlet UITextField *breadCrumbCurrentPage;
    
    id delegate;
    
    CGPoint touchStart;
    CGFloat firstX;
    CGFloat firstY;
    CGFloat centerX,centerY;
    Animator *animatorObj;
}

@property(nonatomic,retain) IBOutlet UILabel *breadCrumb;
@property(nonatomic,retain) IBOutlet UITextField *breadCrumbCurrentPage;

-(IBAction)tabObHearItNowButton:(id)sender;
-(IBAction)tabOnAudioButton:(id)sender;
-(IBAction)tabOnLetItReadButton:(id)sender;
-(IBAction)tabOnLetItStoryButton:(id)sender;
-(IBAction)tabOnReadMoreButton:(id)sender;
-(IBAction)tabOnFinePrintButton:(id)sender;
-(IBAction)tabOnMakeItYourSelfButton:(id)sender;
-(IBAction)tabOnShareButton:(id)sender;

-(void)setFrameCollapsed;
-(void)slideUp;
-(void)slideDown;
-(void)addGesture;
-(void)initializeAnimation;
-(void)registerForNotification;
-(void)UnregisterForNotification;
-(BOOL)shouldMakeBreadCrumbEditableOn:(UITouch *)touch;
-(void)makeBreadCrumbEditable;
-(void)makeBreadCrumbNonEditable;
@property(nonatomic)BOOL isExpanded;
@property(nonatomic)BOOL isRibbonAnimating;
@property(nonatomic, retain) id delegate;
@end
@protocol MenuSliderDelegate <NSObject>
-(BOOL)removeNotesAndShareMenu;
@end