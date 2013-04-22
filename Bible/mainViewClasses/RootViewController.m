//
//  RootViewController.m
//  NewProj
//
//  Created by Ashish Awasthi on 4/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import "RootViewController.h"
#import "ModelController.h"
#import "PageViewController.h"

@interface RootViewController ()
@property (readonly, strong, nonatomic) ModelController *modelController;
-(void)addPreLoadView;
@end

@implementation RootViewController

@synthesize modelController = _modelController;

- (void)dealloc
{
    [_pageViewController release];
    [_modelController release];
    [super dealloc];
}

-(void)addPreLoadView{
    
    m_currentIndex = 1;
    
    AppDelegate    *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    PageViewController *viewController1 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"" withHtmlStr:@"Empty.htm"];
    [viewController1.view setTag:ExtremLeftView];
    [appDelegate.preLoadViewArr  addObject:viewController1];
    
    PageViewController *viewController2 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"" withHtmlStr:@"Empty.htm"];
    [viewController2.view setTag:LeftView];
    [appDelegate.preLoadViewArr  addObject:viewController2];
    
    PageViewController *viewController3 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"1" withHtmlStr:@"Page_001.htm"];
    
    [viewController3.view setTag:CurrentView];
    [appDelegate.preLoadViewArr  addObject:viewController3];
    
    PageViewController *viewController4 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"2" withHtmlStr:@"Page_002.htm"];
    [viewController4.view setTag:RightView];
    [appDelegate.preLoadViewArr  addObject:viewController4];
    
    PageViewController *viewController5 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"3" withHtmlStr:@"Page_003.htm"];
    
    [viewController5.view setTag:ExtremRightView];
    [appDelegate.preLoadViewArr  addObject:viewController5];
    
    
    
}

-(PageViewController *)getViewControllerFrameArr:(PreLoadView )viewNumber{
    
    AppDelegate    *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    PageViewController   *viewController;
    
    for (int i = 0; i<[appDelegate.preLoadViewArr count]; i++) {
        viewController = [appDelegate.preLoadViewArr objectAtIndex:i];
        if (viewController.view.tag == viewNumber) {
            break;
        }
    }
    
    return viewController;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    pageAnimationFinished = YES;
    [self addPreLoadView];
    m_currentIndex = 0;
    
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil] autorelease];
    self.pageViewController.delegate = self;

    PageViewController *viewController = [self getViewControllerFrameArr:CurrentView];
    
    NSArray *viewControllers = @[viewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];

    self.pageViewController.dataSource = self.modelController;

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        pageViewRect = CGRectInset(pageViewRect, 0, 0.0);
    }
    self.pageViewController.view.frame = pageViewRect;

    [self.pageViewController didMoveToParentViewController:self];

    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
     self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    for (UIGestureRecognizer * gesRecog in self.pageViewController.gestureRecognizers)
    {
        if ([gesRecog isKindOfClass:[UITapGestureRecognizer class]])
            gesRecog.enabled = NO;
        else if ([gesRecog isKindOfClass:[UIPanGestureRecognizer class]])
            gesRecog.delegate = self;
    }
}

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
  
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ([gestureRecognizer.view isEqual:self.view] || [gestureRecognizer.view isEqual:self.pageViewController.view]))
    {
        UIPanGestureRecognizer * panGes = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint distance = [panGes translationInView:self.view];
        
        if (distance.x > 0) { // right
            NSLog(@"user swiped right");
            m_currentIndex--;
            if (m_currentIndex<=0) {
                m_currentIndex = 0;
            }
                        
        } else if (distance.x < 0) { //left
             m_currentIndex++;
            if (m_currentIndex>=10) {
                m_currentIndex = 10;
            }
        }
        
        NSLog(@"=====%d",m_currentIndex);
        
        if((m_currentIndex)<= 0 || m_currentIndex >= 10){
            return NO;
        }
        if(pageAnimationFinished == NO){
            return NO;
            
        }
        
        pageAnimationFinished = NO;
    }
    return YES;
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    pageAnimationFinished = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ModelController *)modelController
{
     // Return the model controller object, creating it if necessary.
     // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[ModelController alloc] init];
        [_modelController setViewController:self];
    }
    return _modelController;
}

#pragma mark - UIPageViewController delegate methods

/*
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    
}
 */

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
        
        UIViewController *currentViewController = self.pageViewController.viewControllers[0];
        NSArray *viewControllers = @[currentViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];
        
        self.pageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }

    // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
    DataViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = nil;

    NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
        UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
        viewControllers = @[currentViewController, nextViewController];
    } else {
        UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
        viewControllers = @[previousViewController, currentViewController];
    }
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];


    return UIPageViewControllerSpineLocationMid;
}

@end
