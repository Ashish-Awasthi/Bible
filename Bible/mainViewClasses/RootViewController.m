//
//  RootViewController.m
//  NewProj
//
//  Created by Ashish Awasthi on 4/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import "RootViewController.h"
#import "PageViewController.h"

@interface RootViewController ()
@property (readonly, strong, nonatomic) ModelController *modelController;
-(void)addPreLoadView;
@end

@implementation RootViewController

@synthesize modelController = _modelController;
@synthesize pageAnimationFinished = _pageAnimationFinished;

- (void)dealloc
{
    [_pageViewController release];
    [_modelController release];
    [super dealloc];
}

-(void)addPreLoadView{
    
    PageViewController *viewController1 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"" withHtmlStr:@"Empty.htm"];
    [viewController1.view setTag:ExtremLeftView];
    [[BibleSingletonManager sharedManager].preLoadViewArr  addObject:viewController1];
    RELEASE(viewController1);
    
    PageViewController *viewController2 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"" withHtmlStr:@"Empty.htm"];
    [viewController2.view setTag:LeftView];
    [[BibleSingletonManager sharedManager].preLoadViewArr  addObject:viewController2];
    RELEASE(viewController2);
    
    PageViewController *viewController3 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"1" withHtmlStr:@"Page_001.htm"];
    
    [viewController3.view setTag:CurrentView];
    [[BibleSingletonManager sharedManager].preLoadViewArr  addObject:viewController3];
      RELEASE(viewController3);
    
    PageViewController *viewController4 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"2" withHtmlStr:@"Page_002.htm"];
    [viewController4.view setTag:RightView];
    [[BibleSingletonManager sharedManager].preLoadViewArr  addObject:viewController4];
    RELEASE(viewController4);
    
    PageViewController *viewController5 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"3" withHtmlStr:@"Page_003.htm"];
    
    [viewController5.view setTag:ExtremRightView];
    [[BibleSingletonManager sharedManager].preLoadViewArr  addObject:viewController5];
    RELEASE(viewController5);
    
    
    
}

-(PageViewController *)getViewControllerFrameArr:(PreLoadView )viewNumber{
    
    PageViewController   *viewController;
    
    for (int i = 0; i<[[BibleSingletonManager sharedManager].preLoadViewArr count]; i++) {
        viewController = [[BibleSingletonManager sharedManager].preLoadViewArr objectAtIndex:i];
        if (viewController.view.tag == viewNumber) {
            break;
        }
    }
    
    return viewController;
    
}

- (void)viewDidLoad
{
    [self addPreLoadView];
    [super viewDidLoad];
    
    
    NSArray    *pageData =  [[DBConnectionManager getDataFromDataBase:KPageDataQuery] retain];
   
    NSString    *htmlName = ((PageData *)[pageData objectAtIndex:0])._pageHtmlNameStr;
     NSLog(@"%@====",htmlName);
    
    self.pageAnimationFinished = YES;
    [BibleSingletonManager sharedManager].pageIndexArr = [NSArray arrayWithObjects:KDataArr, nil];
    
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
    
    menuViewController = [[MenuSliderViewController alloc]initWithNibName:@"MenuSliderViewController" bundle:nil];
    [menuViewController setDelegate:self];
    [self.view addSubview:menuViewController.view];
    [self setMenuSliderViewHidden:YES];
}

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    [self.view.window setUserInteractionEnabled:NO];
    
    [self  performSelector:@selector(setWindowUserinteractionEnable) withObject:nil afterDelay:.7];
    
    NSArray * indexArr = [BibleSingletonManager sharedManager].pageIndexArr;
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ([gestureRecognizer.view isEqual:self.view] || [gestureRecognizer.view isEqual:self.pageViewController.view]))
    {
        UIPanGestureRecognizer * panGes = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint distance = [panGes translationInView:self.view];
        
        PageViewController    *currentViewController = (PageViewController *)[self getViewControllerFrameArr:CurrentView];
         NSString    *currentPagePostion = currentViewController.dataLabel.text;
        currentPosition = [currentPagePostion intValue];
        [BibleSingletonManager sharedManager].currentPageId = currentPosition;
        
        [self setMenuSliderViewHidden:NO];
        if (distance.x > 0) {
            //NSLog(@"currentPagePostion %@", currentPagePostion);
             [self setMenuSliderViewHidden:YES];// Here we check user swaped left to right
            [BibleSingletonManager sharedManager].leftToRight = YES;
            [BibleSingletonManager sharedManager].rightToLeft = NO;

            if ([currentPagePostion intValue] <= 1) {
                // NSLog(@"No swape remaing left");// Here check this is first page>>>>>>>>>>
               return NO;
             }
            } else if (distance.x < 0) { //Here we check user swaped right to left
           // NSLog(@"user swiped Left");
                 NSLog(@"======= touch swape view left.....");
             [BibleSingletonManager sharedManager].leftToRight =  NO;
             [BibleSingletonManager sharedManager].rightToLeft = YES;
              
            if ([currentPagePostion intValue] == [indexArr count]) {//Here check this is last page>>>>>>>>>>
                [self setMenuSliderViewHidden:NO];
                 return NO;
              }
            }else{// This condition used for user niether swipt left or right
                return NO;
            }
        
          if (self.pageAnimationFinished == NO) {
              self.pageAnimationFinished = YES;
              return NO;
           }
           self.pageAnimationFinished = NO;
        }
    
    return YES;
}


- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    // NSArray * indexArr = [BibleSingletonManager sharedManager].pageIndexArr;
    
    self.pageAnimationFinished = YES;
    
    if (completed) {
       // NSLog(@"flip complete page");
         if ([BibleSingletonManager sharedManager].rightToLeft) {
            [[BibleSingletonManager sharedManager].modelViewController loadNextView];
          }
        
         if ([BibleSingletonManager sharedManager].leftToRight) {
          [[BibleSingletonManager sharedManager].modelViewController loadPrevView];
         }
        
        if ([BibleSingletonManager sharedManager].rightToLeft) {
            if (currentPosition >=ShowMenuOptionNumberPage) {
                [self setMenuSliderViewHidden:NO];
            }else{
                [self setMenuSliderViewHidden:YES];
            }
        }else if([BibleSingletonManager sharedManager].leftToRight){
            
            if (currentPosition >3) {
                [self setMenuSliderViewHidden:NO];
            }else{
                [self setMenuSliderViewHidden:YES];
            }
        }

     }else{
         
         if ([BibleSingletonManager sharedManager].rightToLeft) {
             if (currentPosition >ShowMenuOptionNumberPage) {
                 [self setMenuSliderViewHidden:NO];
             }else{
                 [self setMenuSliderViewHidden:YES];
             }
         }else if([BibleSingletonManager sharedManager].leftToRight){
             
             if (currentPosition >3) {
                 [self setMenuSliderViewHidden:NO];
             }else{
                 [self setMenuSliderViewHidden:YES];
             }
         }

        // NSLog(@"NOT flip complete page");
     }
    
    NSLog(@"currentPosition  %d",currentPosition);
    
      
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
        [_modelController setDelegate:self];
    }
    return _modelController;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}
- (NSUInteger)supportedInterfaceOrientations{
    
    return 0;
    
}
- (BOOL)shouldAutorotate{
    return NO;
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

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    return viewController;
    
}

-(void)setWindowUserinteractionEnable{
   [self.view.window setUserInteractionEnabled:YES];
}

-(void)setMenuSliderViewHidden:(BOOL) isHidden{
    [menuViewController.view setHidden:isHidden];
}

#pragma marks
#pragma MenuSliderViewControllerDelegate-
-(void)setPageFlip:(BOOL)isFlip{
    self.pageAnimationFinished = isFlip;
    isItTouchInMenuView = YES;
}
@end
