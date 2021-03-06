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

// Add five controller of pageView and cache all five controller>>>>>>>> 
-(void)addPreLoadView{
    
    PageViewController *viewController1 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"" withHtmlStr:@"Empty.htm"];
    [viewController1 setDelegate:self];
    [viewController1.view setTag:ExtremLeftView];
    [[BibleSingletonManager sharedManager].preLoadViewArr  addObject:viewController1];
    RELEASE(viewController1);
    
    PageViewController *viewController2 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"" withHtmlStr:@"Empty.htm"];
     [viewController2 setDelegate:self];
    [viewController2.view setTag:LeftView];
    [[BibleSingletonManager sharedManager].preLoadViewArr  addObject:viewController2];
    RELEASE(viewController2);
    
    PageViewController *viewController3 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"1" withHtmlStr:@"Page_001.htm"];
     [viewController3 setDelegate:self];
    
    [viewController3.view setTag:CurrentView];
    [[BibleSingletonManager sharedManager].preLoadViewArr  addObject:viewController3];
      RELEASE(viewController3);
    
    PageViewController *viewController4 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"2" withHtmlStr:@"Page_002.htm"];
     [viewController4 setDelegate:self];
    [viewController4.view setTag:RightView];
    [[BibleSingletonManager sharedManager].preLoadViewArr  addObject:viewController4];
    RELEASE(viewController4);
    
    PageViewController *viewController5 = [[PageViewController alloc]
                                           initWithNibName:nil bundle:nil withTitle:@"3" withHtmlStr:@"Page_003.htm"];
     [viewController5 setDelegate:self];
    
    [viewController5.view setTag:ExtremRightView];
    [[BibleSingletonManager sharedManager].preLoadViewArr  addObject:viewController5];
    RELEASE(viewController5);
    
    
    
}

-(PageViewController *)getViewControllerFormArr:(PreLoadView )viewNumber{
    
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
    
    self.view.multipleTouchEnabled = NO;
    self.view.exclusiveTouch = YES;
    
    isitTabAnimationComplete = YES;
    self.pageAnimationFinished = YES;
    
    [BibleSingletonManager sharedManager]._rootViewController = self;
    
    [[BibleSingletonManager sharedManager].shareViewCommanClass callSocialMediaClasses];
    
    [BibleSingletonManager sharedManager].firstGetTouchMenuSliderView = NO;
    NSArray    *pageData =  [[DBConnectionManager getDataFromDataBase:KPageDataQuery] retain];
    
    for (int i = 0; i<[pageData count]; i++) {
      NSString   *indexIdStr = [NSString stringWithFormat:@"%d",((PageData *)[pageData objectAtIndex:i])._pageId];
      [[BibleSingletonManager sharedManager].pageIndexArr addObject:indexIdStr];
     }
    
   
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil] autorelease];
    self.pageViewController.delegate = self;

    PageViewController *viewController = [self getViewControllerFormArr:CurrentView];
    
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
    self.pageViewController.doubleSided = NO;
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
     self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    for (UIGestureRecognizer * gesRecog in self.pageViewController.gestureRecognizers)
    {
        if ([gesRecog isKindOfClass:[UITapGestureRecognizer class]]){
            gesRecog.enabled = NO;
            gesRecog.delegate = self;
        }
        else if ([gesRecog isKindOfClass:[UIPanGestureRecognizer class]]){
            gesRecog.enabled = NO;
            gesRecog.delegate = self;
            [self  performSelector:@selector(enablePanGesture) withObject:nil afterDelay:2.0];
           }
        
    }
    
    [self reAddMenuViewController];
    [self setMenuSliderViewHidden:YES];
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
- (BOOL)shouldAutorotate
{
      return NO;
   
}
- (NSUInteger)supportedInterfaceOrientations
{
    return NO;
  
    
}

#pragma marks-
#pragma UIGestureRecognizer  Delegate Method-

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    BOOL    isItGetTouch = YES;
   // NSLog(@" Number of count %d", [touch tapCount]);
    numberOfTabCount = [touch tapCount];
    if (isitTabAnimationComplete == NO && [touch tapCount] >= 2) {
       isItGetTouch = NO;
    }
    return isItGetTouch;
}

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (numberOfTabCount>=2) {
        return NO;
    }
    
    NSArray * indexArr = [BibleSingletonManager sharedManager].pageIndexArr;
    
    PageViewController    *currentViewController = (PageViewController *)[self getViewControllerFormArr:CurrentView];
    NSString    *currentPagePostion = currentViewController.dataLabel.text;
    currentPosition = [currentPagePostion intValue];
    // implement logic if user tab on right side in 44 pixel area:- page flip left
    // implement logic if user tab on left side in 44 pixel area:- page flip right
   
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && ([gestureRecognizer.view isEqual:self.view] || [gestureRecognizer.view isEqual:self.pageViewController.view]))
    {
         
        if (isitTabAnimationComplete == NO || self.pageAnimationFinished == NO) {
            return NO;
         }
        UIPanGestureRecognizer * tapRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [tapRecognizer locationInView:self.view];
        if (point.x>self.view.frame.size.width-44) {
            // if Menu view present on rootView,not get Touch on rootView......
            if ([BibleSingletonManager sharedManager].firstGetTouchMenuSliderView == YES) {
                [BibleSingletonManager sharedManager].firstGetTouchMenuSliderView = NO;
                return NO;
            }
            if ([currentPagePostion intValue] == [indexArr count]) {//Here check this is last page>>>>>>>>>>
                [self setMenuSliderViewHidden:NO];
                return NO;
            }else{
              isitTabAnimationComplete = NO;
                // enable here it page option.............
              [menuViewController enableHearitPageOption];
              NSArray  *viewControllerArr = [NSArray arrayWithObject:[self getViewControllerFormArr:RightView]];
              [self setMenuSliderViewHidden:YES];
              [self nextPageFlipAutomaticallyWhenAudioFinsh:viewControllerArr];
              return YES;
            }
           // NSLog(@"Right touch ");
           }else if(point.x<44){
               if ([currentPagePostion intValue] <= 1) {
                   // NSLog(@"No swape remaing left");// Here check this is first page>>>>>>>>>>
                   return NO;
               }else{
                [self setMenuSliderViewHidden:YES];
                isitTabAnimationComplete = NO;
                // enable here it page option.............
                [menuViewController enableHearitPageOption];
                NSArray  *viewControllerArr = [NSArray arrayWithObject:[self getViewControllerFormArr:LeftView]];
               [self prevPageFlipAutomaticallyWhenAudioFinsh:viewControllerArr];
                return YES;
               }
            // NSLog(@"left  touch ");
            }else{
             return NO;
            }
     // NSLog(@" location data x %f && location data Y %f",point.x,point.y);
     }
    
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ([gestureRecognizer.view isEqual:self.view] || [gestureRecognizer.view isEqual:self.pageViewController.view]))
    {
        isitTabAnimationComplete  = YES;
        UIPanGestureRecognizer * panGes = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint distance = [panGes translationInView:self.view];
        
       
        [BibleSingletonManager sharedManager].currentPageId = currentPosition;
        if (distance.x > 0) {
            [self.view.window setUserInteractionEnabled:NO];
            [self  performSelector:@selector(setWindowUserinteractionEnable) withObject:nil afterDelay:.7];
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
            // NSLog(@"======= touch swape view left.....");
             [self.view.window setUserInteractionEnabled:NO];
             [self  performSelector:@selector(setWindowUserinteractionEnable) withObject:nil afterDelay:.7];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIPageViewController delegate methods
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    self.pageAnimationFinished = YES;
    
    if (completed) {
        [self reAddMenuViewController];
        // enable here it page option.............
         [menuViewController enableHearitPageOption];
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
            
            if (currentPosition >=3) {
                [self setMenuSliderViewHidden:NO];
            }else{
                //NSLog(@"currentPosition  %d",currentPosition);
                [self setMenuSliderViewHidden:YES];
            }
        }
        
        // NSLog(@"NOT flip complete page");
    }
    
    // NSLog(@"currentPosition  %d",currentPosition);
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    return viewController;
    
}
#pragma marks-
#pragma PageViewControllerDelegate method-
-(void)nextPageFlipAutomaticallyWhenAudioFinsh:(NSArray *)viewControllersArr{
    
    [self stopAudioWhenUserSwitchPage];
     [self reAddMenuViewController];
    [self.pageViewController setViewControllers:viewControllersArr direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        if (finished) {
            [[BibleSingletonManager sharedManager].modelViewController loadNextView];
            if (currentPosition >=ShowMenuOptionNumberPage) {
                [self setMenuSliderViewHidden:NO];
            }else{
                [self setMenuSliderViewHidden:YES];
            }
            // start read and highlight next page, if letitread option enable..........
            if ([BibleSingletonManager sharedManager].isItLetItRead) {
              [self performSelector:@selector(readNextPageDataWhenLetItReadEnable) withObject:nil afterDelay:0.6];
             }
            [self performSelector:@selector(tapPageAnimationIsComplete) withObject:nil afterDelay:0.2];
        }
    }];
}

-(void)readNextPageDataWhenLetItReadEnable{
    
    PageViewController    *currentViewController = [self getViewControllerFormArr:CurrentView];
    NSInteger    currentPageId = [BibleSingletonManager sharedManager].currentPageId;
    //audio not be play,when user go after page 72
    if (currentPageId<=72) {
        [currentViewController hieghtTextWhenSwipeUpperCorner:currentPageId+1];
    }
}

-(void)prevPageFlipAutomaticallyWhenAudioFinsh:(NSArray *)viewControllersArr{
     [self stopAudioWhenUserSwitchPage];
     [self reAddMenuViewController];
    [self.pageViewController setViewControllers:viewControllersArr direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        if (finished) {
            [[BibleSingletonManager sharedManager].modelViewController loadPrevView];
            if (currentPosition >3) {
                [self setMenuSliderViewHidden:NO];
            }else{
                //NSLog(@"currentPosition  %d",currentPosition);
                [self setMenuSliderViewHidden:YES];
            }
            [self performSelector:@selector(tapPageAnimationIsComplete) withObject:nil afterDelay:.2];
        }
    }];
}

-(void)tapPageAnimationIsComplete{
    isitTabAnimationComplete = YES;
}

-(void)enablePanGesture{
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    for (UIGestureRecognizer * gesRecog in self.pageViewController.gestureRecognizers)
    {
        if ([gesRecog isKindOfClass:[UITapGestureRecognizer class]]){
            gesRecog.enabled = YES;
            gesRecog.cancelsTouchesInView = YES;
        }
        if ([gesRecog isKindOfClass:[UIPanGestureRecognizer class]]){
            gesRecog.enabled = YES;
        }
    }
}
-(void)setWindowUserinteractionEnable{
   [self.view.window setUserInteractionEnabled:YES];
}

-(void)setMenuSliderViewHidden:(BOOL) isHidden{
    [menuViewController.view setHidden:isHidden];
}

-(void)reAddMenuViewController{
    if (menuViewController) {
        [menuViewController.view removeFromSuperview];
        [menuViewController release];
     }
     menuViewController = [[MenuSliderViewController alloc]initWithNibName:@"MenuSliderViewController" bundle:nil];
    [menuViewController setDelegate:self];
    [self.view addSubview:menuViewController.view];
}
-(void)stopAudioWhenUserSwitchPage{
    // Stop Audio When you flip page
    [BibleSingletonManager sharedManager].isAudioEnable = NO;
    [BibleSingletonManager sharedManager].isItGoforNextPage = YES;
    PageViewController    *currentViewController = [self getViewControllerFormArr:CurrentView];
    [currentViewController releaseAudioObjcet];
    [currentViewController reStoreLastAudioState];
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
}
#pragma marks
#pragma MenuSliderViewControllerDelegate-
-(void)setPageFlip:(BOOL)isFlip{
    self.pageAnimationFinished = isFlip;
    isItTouchInMenuView = YES;
}

-(void)reLoadAllFiveViewDataWhenYouComeFromMenuOption:(NSString *)htmlNameStr{
    
     [self reAddMenuViewController];
   // NSLog(@"htmlNameStr%@",htmlNameStr);
    NSString *pageNumberStr = [[htmlNameStr componentsSeparatedByString:@"Page_0"] lastObject];
    pageNumberStr = [[pageNumberStr componentsSeparatedByString:@"."] objectAtIndex:0];
   
   // NSLog(@"htmlNameStr%@, Page Number is:- %d",htmlNameStr,[pageNumberStr integerValue]);
    
    NSArray   *objectArr = [[BibleSingletonManager sharedManager].preLoadViewArr copy];
    [[BibleSingletonManager sharedManager].preLoadViewArr removeAllObjects];
    
    PageViewController   *pageViewController;
    
    NSString*   htmlFileNameStr = nil;
    NSInteger  pageNumber = [pageNumberStr integerValue];
    NSInteger  totalNumberOfPage = [[BibleSingletonManager sharedManager].htmlPageArr count];
    
    if(pageNumber <= 2){
        [self setMenuSliderViewHidden:YES];
    }
    
    for (int i = 0; i<[objectArr count]; i++) {
        
        pageViewController = [objectArr objectAtIndex:i];
        
        switch (pageViewController.view.tag) {
                
            case ExtremLeftView:
                if (pageNumber <= 1) {
                   htmlFileNameStr = @"Empty.htm";
                  }else{
                   htmlFileNameStr = [[BibleSingletonManager sharedManager].htmlPageArr objectAtIndex: pageNumber-3];
                   [pageViewController  loadHtml:htmlFileNameStr withIdenticator:NO];
                   }
                 [pageViewController.dataLabel setText:[NSString stringWithFormat:@"%d",pageNumber - 2]];
                
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                break;
            case LeftView:
                if (pageNumber <= 1) {
                    htmlFileNameStr = @"Empty.htm";
                 }else{
                   htmlFileNameStr = [[BibleSingletonManager sharedManager].htmlPageArr objectAtIndex:pageNumber -2];
                   [pageViewController  loadHtml:htmlFileNameStr withIdenticator:NO];
                 }
                 [pageViewController.dataLabel setText:[NSString stringWithFormat:@"%d",pageNumber-1]];
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                break;
                
            case CurrentView:
                 htmlFileNameStr = [[BibleSingletonManager sharedManager].htmlPageArr objectAtIndex:pageNumber-1];
                  [pageViewController  loadHtml:htmlFileNameStr withIdenticator:YES];
                 [pageViewController.dataLabel setText:[NSString stringWithFormat:@"%d",pageNumber]];
                // NSLog(@"pageViewController.dataLabel %@",pageViewController.dataLabel.text);
                 [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                break;
            case RightView:
               if (pageNumber >= totalNumberOfPage) {
                    htmlFileNameStr = @"Empty.htm";
                }else{
                 htmlFileNameStr = [[BibleSingletonManager sharedManager].htmlPageArr objectAtIndex:pageNumber];
                [pageViewController  loadHtml:htmlFileNameStr withIdenticator:NO];
                }
                [pageViewController.dataLabel setText:[NSString stringWithFormat:@"%d",pageNumber+1]];
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                [BibleSingletonManager sharedManager].pageViewController = (id)pageViewController;
                break;
                
            case ExtremRightView:
                if (pageNumber >= totalNumberOfPage) {
                    htmlFileNameStr = @"Empty.htm";
                }else{
                 htmlFileNameStr = [[BibleSingletonManager sharedManager].htmlPageArr objectAtIndex:pageNumber+1];
                 [pageViewController  loadHtml:htmlFileNameStr withIdenticator:NO];
                }
                [pageViewController.dataLabel setText:[NSString stringWithFormat:@"%d",pageNumber+2]];
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                break;
                
            default:
                break;
        }
        
    }
    
    [objectArr release];
   
}


@end
