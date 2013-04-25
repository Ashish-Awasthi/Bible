    //
//  MenuSliderViewController.m
//  HPS
//
//  Created by KiwiTech on 7/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuSliderViewController.h"
#import "Animator.h"
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
	return YES;
}


-(void)slideUpDown:(UIGestureRecognizer *)gesture
{
	if (!self.isExpanded)
	{
		[self slideDown];
	}
	else 
    {
		[self slideUp];
	}
	[self pageSwiped];
	isExpanded = !isExpanded;
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
  
}// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Overriden to allow any orientation.
    return NO;
}
#pragma marks
#pragma Button Eevets....

-(IBAction)tabObHearItNowButton:(id)sender{
    NSLog(@"tabObHearItNowButton");
}

-(IBAction)tabOnAudioButton:(id)sender{
    NSLog(@"tabOnAudioButton");
    
}

-(IBAction)tabOnLetItReadButton:(id)sender{
    NSLog(@"tabOnLetItReadButton");
    
}

-(IBAction)tabOnLetItStoryButton:(id)sender{
    NSLog(@"tabOnLetItStoryButton");
    
}
-(IBAction)tabOnReadMoreButton:(id)sender{
    NSLog(@"tabOnReadMoreButton");
    
}
-(IBAction)tabOnFinePrintButton:(id)sender{
    NSLog(@"tabOnFinePrintButton");
    
}
-(IBAction)tabOnMakeItYourSelfButton:(id)sender{
    NSLog(@"tabOnMakeItYourSelfButton");
    
}
-(IBAction)tabOnShareButton:(id)sender{
    NSLog(@"tabOnShareButton");
    
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
