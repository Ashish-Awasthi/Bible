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
#define kCollapseMargin 140
#define kRightMenuMargin 0
#define kHorizontalMargin 50
#define animationRepeatCount 1
#define PageSwipedNotification @"PageSwipedNotification"
#define PageSwipedForwardNotification @"PageSwipedForwardNotification"
#define PageSwipedBackwardNotification @"PageSwipedBackwardNotification"
#define DeviceDisturbedNotification @"DeviceDisturbedNotification" 

@protocol MenuSliderDelegate <NSObject>
@optional
-(void)setPageFlip:(BOOL)isFlip;
-(void)setMenuSliderViewHidden:(BOOL) isHidden;
@end

@interface MenuSliderViewController : UIViewController <UIGestureRecognizerDelegate, AnimatorDelegate>
{
	IBOutlet UIView *menuView;

	IBOutlet UIImageView *sliderImage;
	IBOutlet UILabel       *tabLbl;
	IBOutlet UIImageView *ribbonImage;
	IBOutlet UILabel     *lbel;
    id delegate;
    
    CGPoint touchStart;
    CGFloat firstX;
    CGFloat firstY;
    CGFloat centerX,centerY;
    Animator *animatorObj;
}

@property(nonatomic, assign) id <NSObject,MenuSliderDelegate>delegate;

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
@property(nonatomic)BOOL isExpanded;
@property(nonatomic)BOOL isRibbonAnimating;
//PageViewController delegate Method
-(void)hieghtTextWhenSwipeUpperCorner:(NSInteger)pageId;
@end
