    //
//  MenuSliderViewController.m
//  HPS
//
//  Created by KiwiTech on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "MenuSliderViewController.h"
#import "Animator.h"
#import "PageViewController.h"
#import "ReadMoreViewController.h"
#import "StoriesViewController.h"
#import "FinePrintViewController.h"
#import "MakeItYourSelfViewController.h"

#define HearItPageSelected  60001
#define HearItPageUnSelected  60002

#define letItReadPageSelected  60003
#define letItReadPUnSelected   60004

@implementation MenuSliderViewController
@synthesize isExpanded;
@synthesize delegate;
@synthesize isRibbonAnimating;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self)
	{
		[self setFrameCollapsed];
        
		[self addGesture];
    
    }
    return self;
}

-(void)setFrameCollapsed
{
	CGRect menuSliderViewControllerObjRect = self.view.frame;
	
	menuSliderViewControllerObjRect.origin.x = menuSliderViewControllerObjRect.origin.x+(kIPadPortraitScreenWidth-menuSliderViewControllerObjRect.size.width-kRightMenuMargin);
	
	menuSliderViewControllerObjRect.origin.y = (menuSliderViewControllerObjRect.origin.y-sliderImage.frame.size.height)+kCollapseMargin;
	
	self.view.frame=menuSliderViewControllerObjRect;
}

-(void)registerForNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageSwiped) name:PageSwipedNotification object:nil];
}

-(void)UnregisterForNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PageSwipedNotification object:nil];
}

-(void)addGesture
{
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideUpDown:)];
	
	tapGesture.delegate=self;
	
	[ribbonImage addGestureRecognizer:tapGesture];
	
	[self.view addGestureRecognizer:tapGesture];
	
	[tapGesture release];
	
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    
    panGesture.delegate = self;
    
    panGesture.maximumNumberOfTouches = 1;
    
    panGesture.minimumNumberOfTouches = 1;
    
    [self.view addGestureRecognizer:panGesture];
    
    [panGesture release];
}

#pragma maks
#pragma swipe gesture Delegate method-
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    [BibleSingletonManager sharedManager].firstGetTouchMenuSliderView = YES;
    BOOL   isItGetTouchUpDown;
    UIPanGestureRecognizer * panGes = (UIPanGestureRecognizer *)gestureRecognizer;
    CGPoint point = [panGes locationInView:self.view];
    // this condition use for not get touch if user tab on Menu View or only get touch if tab on ribbon...
    if (point.y<800) {
        return NO;
     }
   //  NSLog(@"x.postion is:- %f and ypostion is %f:- ",point.x,point.y);
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        // This condition use for if u tab Upper right corner.....
        PageViewController    *currentpageViewController = (PageViewController *)[BibleSingletonManager sharedManager].pageViewController;
        int  pageId =  [currentpageViewController.dataLabel.text integerValue];
        
        if (point.x<187) {
            NSLog(@"Menu View yPosition %f",self.view.frame.origin.y);
            if (self.view.frame.origin.y>-710) {
                return NO;
            }
            
            switch (pageId) {
                case 4:
                [[BibleSingletonManager sharedManager].pageViewController hieghtTextWhenSwipeUpperCorner:4];
                break;
                case 11:
                [[BibleSingletonManager sharedManager].pageViewController hieghtTextWhenSwipeUpperCorner:11];
                break;
                case 17:
                [[BibleSingletonManager sharedManager].pageViewController hieghtTextWhenSwipeUpperCorner:17];
                    break;
                case 20:
                    [[BibleSingletonManager sharedManager].pageViewController hieghtTextWhenSwipeUpperCorner:20];
                    break;
                case 26:
                    [[BibleSingletonManager sharedManager].pageViewController hieghtTextWhenSwipeUpperCorner:26];
                    break;
                case 39:
                    [[BibleSingletonManager sharedManager].pageViewController hieghtTextWhenSwipeUpperCorner:39];
                    break;
                case 58:
                    [[BibleSingletonManager sharedManager].pageViewController hieghtTextWhenSwipeUpperCorner:58];
                    break;
                case 60:
                    [[BibleSingletonManager sharedManager].pageViewController hieghtTextWhenSwipeUpperCorner:60];
                    break;
                case 62:
                    [[BibleSingletonManager sharedManager].pageViewController hieghtTextWhenSwipeUpperCorner:62];
                    break;
                case 72:
                    [[BibleSingletonManager sharedManager].pageViewController hieghtTextWhenSwipeUpperCorner:72];
                    break;
                case 75:
                    [[BibleSingletonManager sharedManager].pageViewController hieghtTextWhenSwipeUpperCorner:75];
                break;
                default:
                    break;
            }

          return NO;
        }
        return YES;
     }
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ([gestureRecognizer.view isEqual:self.view] || [gestureRecognizer.view isEqual:self.view]))
    {
        CGPoint distance = [panGes translationInView:self.view];
        if (distance.x>0 || distance.x<0) {// disable gesture on left to right swipe and right to left swipe
            isItGetTouchUpDown = NO;
        }else{
            isItGetTouchUpDown = YES;//enable gesture on up to bottom swipe and bottom to up swipe
        }
        
    }else{
        isItGetTouchUpDown = NO;// Avoid tab On touch
    }
    return isItGetTouchUpDown;
}


-(void)initializeAnimation
{
    if (animatorObj!=nil)
    {
        [animatorObj release],animatorObj=nil;
    }
    
    animatorObj = [[Animator alloc] init];
    
    animatorObj.animatedView = ribbonImage;
    animatorObj.repeatCount = animationRepeatCount;
    animatorObj.delegate = self;
    
    [animatorObj initialize];
}


-(void)pageSwiped
{
    if (!isRibbonAnimating)
    {
        [animatorObj restartAnimation];
    }

}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{

    if ([self.delegate respondsToSelector:@selector(setPageFlip:)]) {
        [self.delegate setPageFlip:YES];
    }
    if ([self.delegate respondsToSelector:@selector(setMenuSliderViewHidden:)]) {
        [self.delegate setMenuSliderViewHidden:NO];
    }
	return YES;
}


-(void)slideUpDown:(UIGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.view];
   // NSLog(@"x.postion is:- %f and ypostion is %f:- ",point.x,point.y);
       // NSLog(@"======= touch Menu view.....");
    if (point.x>185) {// get touch only ribin
	if (!self.isExpanded)
	{
        // in case of Hide audio button to from menu bar
        //[self setAudioIconHiddenCondition:YES];
        
		[self slideDown];
	}
	else
    {
        // in case of Hide audio button to from menu bar
        //[self setAudioIconHiddenCondition:NO];
        
		[self slideUp];
	}
	[self pageSwiped];
	 isExpanded = !isExpanded;
     } else{
//        if ([self.delegate respondsToSelector:@selector(setMenuSliderViewHidden:)]) {
//            [self.delegate setMenuSliderViewHidden:NO];
//        }
    }
}

-(void)slideUp
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];

	self.view.frame  = CGRectMake(self.view.frame.origin.x, 
								  self.view.frame.origin.y-sliderImage.frame.size.height+kCollapseMargin,
								  self.view.frame.size.width,
								  self.view.frame.size.height);
    
    
	[UIView commitAnimations];
}

-(void)slideDown
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.5];

	self.view.frame  = CGRectMake(self.view.frame.origin.x, 
								  0,
								  self.view.frame.size.width,
								  self.view.frame.size.height);
	
	[UIView commitAnimations];
}

-(void)move:(id)sender
{
    UIPanGestureRecognizer   *gesture =  (UIPanGestureRecognizer*)sender;
     CGPoint point = [gesture locationInView:self.view];
    
    if (point.x>185) {
        
    if ([self.delegate respondsToSelector:@selector(setPageFlip:)]) {
        [self.delegate setPageFlip:YES];
    }
    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];

	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view.superview];
    
	if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan)
	{
		firstX = [[sender view] frame].origin.x;
        firstY = [[sender view] frame].origin.y;
	}

    CGFloat finalY = firstY+translatedPoint.y;

    translatedPoint = CGPointMake(self.view.frame.origin.x, firstY+translatedPoint.y);
    
	if (translatedPoint.y<0)
	{
		isExpanded = NO;
	}
	else if(translatedPoint.y>0)
	{
		isExpanded = YES;
	}
	
    if (finalY>=0)
    {
		isExpanded = YES;
        return;
    }
	else
		if (finalY<= kCollapseMargin-sliderImage.frame.size.height)
		{
			isExpanded = NO;
			return;
		}

        [[sender view] setFrame:CGRectMake(self.view.frame.origin.x, finalY, self.view.frame.size.width, self.view.frame.size.height)];

    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged)
    {
        [self pageSwiped];
    }
  
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)animationDidFinished:(Animator *)object
{
    isRibbonAnimating = NO;
}

-(void)animationDidBegin:(Animator *)object
{
    isRibbonAnimating = YES;
}

-(void)setAudioIconHiddenCondition:(BOOL)flag{
    
    isitExpandHideAudioIcon = flag;
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return NO;
}

-(void)enableHearitPageOption{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [BibleSingletonManager sharedManager].isItLetItRead = NO;
    UIImage   *imageName;
    imageName = [UIImage imageNamed:@"Hear-page_sel.png"];
    [hereItPageBtn setImage:imageName forState:UIControlStateNormal];
    imageName = [UIImage imageNamed:@"let-it-read_unsel.png"];
    [letItReadBtn setImage:imageName forState:UIControlStateNormal];
}
#pragma marks
#pragma Button Eevets....
-(IBAction)tabObHearItNowButton:(id)sender{
    [self enableHearitPageOption];
}

-(IBAction)tabOnAudioButton:(id)sender{
       
}

-(IBAction)tabOnLetItReadButton:(id)sender{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [BibleSingletonManager sharedManager].isItLetItRead = YES;
    UIImage   *imageName;
    imageName = [UIImage imageNamed:@"Hear_page_unsel.png"];
    [hereItPageBtn setImage:imageName forState:UIControlStateNormal];
    imageName = [UIImage imageNamed:@"let-it-read_sel.png"];
    [letItReadBtn setImage:imageName forState:UIControlStateNormal];
}

-(IBAction)tabOnLetItStoryButton:(id)sender{
    NSLog(@"tabOnLetItStoryButton");
    //Stop audio When user flip page>>>>>>>>>>>>>>
    
    [[BibleSingletonManager sharedManager].modelViewController stopAudioWhenUserSwitchPage];
    StoriesViewController     *storiesViewController = [[StoriesViewController alloc] init];
    storiesViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [[BibleSingletonManager sharedManager]._rootViewController presentViewController:storiesViewController animated:YES completion:^{
        // NSLog(@"Now Show share View");
    }];

     RELEASE(storiesViewController);
}
-(IBAction)tabOnReadMoreButton:(id)sender{
    //NSLog(@"tabOnReadMoreButton");
    //Stop audio When user flip page>>>>>>>>>>>>>>
    
    [[BibleSingletonManager sharedManager].modelViewController stopAudioWhenUserSwitchPage];
    ReadMoreViewController     *readMoreViewController = [[ReadMoreViewController alloc] init];
    readMoreViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [[BibleSingletonManager sharedManager]._rootViewController presentViewController:readMoreViewController animated:YES completion:^{
        // NSLog(@"Now Show share View");
    }];
    RELEASE(readMoreViewController);

}
-(IBAction)tabOnFinePrintButton:(id)sender{
    //NSLog(@"tabOnFinePrintButton");
    //Stop audio When user flip page>>>>>>>>>>>>>>
    
    [[BibleSingletonManager sharedManager].modelViewController stopAudioWhenUserSwitchPage];
    FinePrintViewController     *fineViewController = [[FinePrintViewController alloc] init];
    fineViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [[BibleSingletonManager sharedManager]._rootViewController presentViewController:fineViewController animated:YES completion:^{
        // NSLog(@"Now Show share View");
    }];
   RELEASE(fineViewController);
}
-(IBAction)tabOnMakeItYourSelfButton:(id)sender{
      //Stop audio When user flip page>>>>>>>>>>>>>>
    
    [[BibleSingletonManager sharedManager].modelViewController stopAudioWhenUserSwitchPage];
    MakeItYourSelfViewController     *makeItMoreViewController = [[MakeItYourSelfViewController alloc] init];
    makeItMoreViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [[BibleSingletonManager sharedManager]._rootViewController presentViewController:makeItMoreViewController animated:YES completion:^{
        // NSLog(@"Now Show share View");
    }];
   RELEASE(makeItMoreViewController);
}
-(IBAction)tabOnShareButton:(id)sender{
    //Stop audio When user flip page>>>>>>>>>>>>>>
    
    [[BibleSingletonManager sharedManager].modelViewController stopAudioWhenUserSwitchPage];
    ShareViewController     *shareViewController = [[ShareViewController alloc] init];
    shareViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [[BibleSingletonManager sharedManager]._rootViewController presentViewController:shareViewController animated:YES completion:^{
       // NSLog(@"Now Show share View");
    }];
      RELEASE(shareViewController);
}


-(void)setLastPositionOfMenuOptionView{
   
//   self.view.frame  = CGRectMake(self.view.frame.origin.x,
//                                  -824,
//								  self.view.frame.size.width,
//								  self.view.frame.size.height);
//   // isExpanded = !isExpanded;

}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [self UnregisterForNotification];
    if (animatorObj!=nil)
    {
        [animatorObj release],animatorObj=nil;
    }

    [super dealloc];
}


@end
