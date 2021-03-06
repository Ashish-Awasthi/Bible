//
//  ModelController.m
//  NewProj
//
//  Created by Ashish Awasthi on 4/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//



#import "ModelController.h"
#import "PageViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */
#import "PageViewController.h"

@interface ModelController()

-(PageViewController *)getViewControllerFormArr:(PreLoadView )viewNumber;
-(void)reLoadDataOnNextView:(NSString *) changeTitleStr
                  withHtmlName:(NSString *)htmlNameStr;
-(void)reLoadDataOnPrevView:(NSString *) changeTitleStr

                  withHtmlName:(NSString *)htmlNameStr;
@property (nonatomic, retain) NSMutableArray *webViewpageData;
@property(nonatomic,retain)NSArray     *htmlPageIndexArr;
@end

@implementation ModelController

@synthesize webViewpageData = webViewpageData;
@synthesize delegate;
@synthesize htmlPageIndexArr = _htmlPageIndexArr;


-(PageViewController *)getViewControllerFormArr:(PreLoadView )viewNumber{
    
    PageViewController   *pageViewController;
    
    for (int i = 0; i<[[BibleSingletonManager sharedManager].preLoadViewArr count]; i++) {
        pageViewController = [[BibleSingletonManager sharedManager].preLoadViewArr objectAtIndex:i];
        if (pageViewController.view.tag == viewNumber) {
            break;
        }
    }
    
    return pageViewController;
    
}


-(void)reLoadDataOnNextView:(NSString *) changeTitleStr
                 withHtmlName:(NSString *)htmlNameStr{
    
    NSArray   *objectArr = [[BibleSingletonManager sharedManager].preLoadViewArr copy];
    [[BibleSingletonManager sharedManager].preLoadViewArr removeAllObjects];
    
    PageViewController   *pageViewController;
    
    for (int i = 0; i<[objectArr count]; i++) {
        
        pageViewController = [objectArr objectAtIndex:i];
        
        switch (pageViewController.view.tag) {
                
            case ExtremLeftView:
                 pageViewController.view.tag = ExtremRightView;
                [pageViewController  loadHtml:htmlNameStr withIdenticator:NO];
                [pageViewController.dataLabel setText:changeTitleStr];
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                break;
            case LeftView:
                pageViewController.view.tag = ExtremLeftView;
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                break;
                
            case CurrentView:
                pageViewController.view.tag = LeftView;
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                break;
            case RightView:
                 pageViewController.view.tag = CurrentView;
                [pageViewController startPageThirdAnimation];
                 [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                 [BibleSingletonManager sharedManager].pageViewController = (id)pageViewController;
                break;
                
            case ExtremRightView:
                pageViewController.view.tag = RightView;
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                break;
                
            default:
                break;
        }
        
    }
    
    [objectArr release];
}

-(void)reLoadDataOnPrevView:(NSString *) changeTitleStr
                  withHtmlName:(NSString *)htmlNameStr{
    
    NSArray   *objectArr = [[BibleSingletonManager sharedManager].preLoadViewArr copy];
    [[BibleSingletonManager sharedManager].preLoadViewArr removeAllObjects];
    
    PageViewController   *pageViewController;
    
    for (int i = 0; i<[objectArr count]; i++) {
        
        pageViewController = [objectArr objectAtIndex:i];
        
        switch (pageViewController.view.tag) {
                
            case ExtremLeftView:
                 pageViewController.view.tag = LeftView;
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                
                break;
            case LeftView:
                pageViewController.view.tag = CurrentView;
                [pageViewController startPageThirdAnimation];
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                [BibleSingletonManager sharedManager].pageViewController = (id)pageViewController;
                break;
                
            case CurrentView:
                 pageViewController.view.tag = RightView;
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                break;
            case RightView:
                pageViewController.view.tag = ExtremRightView;
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                break;
                
            case ExtremRightView:
                [pageViewController  loadHtml:htmlNameStr withIdenticator:NO];
                  pageViewController.view.tag = ExtremLeftView;
                 [pageViewController.dataLabel setText:changeTitleStr];
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                break;
                
            default:
                break;
        }
        
    }
    
    [objectArr release];
}

- (void)dealloc
{
   // [_pageData release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        // Create the data model.
        [BibleSingletonManager sharedManager].modelViewController = self;
        self.htmlPageIndexArr = [[BibleSingletonManager sharedManager].pageIndexArr retain];
        self.webViewpageData = [[NSMutableArray alloc] init];
        
        NSArray    *pageData =  [[DBConnectionManager getDataFromDataBase:KPageDataQuery] retain];
        
         for (int i = 0; i<[pageData count]; i++) {
             NSString    *htmlName = ((PageData *)[pageData objectAtIndex:i])._pageHtmlNameStr;
             [self.webViewpageData addObject:htmlName];
             [[BibleSingletonManager sharedManager].htmlPageArr addObject:htmlName];
             
         }
        
       // NSLog(@"self.htmlPageIndexArr  count %d\n  self.webViewpageData %d",[self.htmlPageIndexArr count],[self.webViewpageData count]);
        
    }
    return self;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    [self stopAudioWhenUserSwitchPage];
    PageViewController    *leftPageViewController = [self getViewControllerFormArr:LeftView];
 return leftPageViewController;
  
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
       [self stopAudioWhenUserSwitchPage];
    // Hide menu View when you flip page.
    if ([self.delegate performSelector:@selector(setMenuSliderViewHidden:)]) {
        [self.delegate setMenuSliderViewHidden:YES];
    }
    
    PageViewController    *rightPageViewController = [self getViewControllerFormArr:RightView];
    
    return rightPageViewController;
}

-(void)loadPrevView{
    
    PageViewController    *precurrentViewController = [self getViewControllerFormArr:CurrentView];
    NSString    *findPrevValueStr = precurrentViewController.dataLabel.text;
    
    if ([findPrevValueStr integerValue] == 2 || [findPrevValueStr integerValue] == 3) {
        [self reLoadDataOnPrevView:@"" withHtmlName:@"Empty.htm"];
        return;
    }
    
     NSInteger    finPrevIndex;
    finPrevIndex = [findPrevValueStr integerValue]-4;
    if (finPrevIndex>=0) {
    [self reLoadDataOnPrevView:[self.htmlPageIndexArr objectAtIndex:finPrevIndex] withHtmlName:[self.webViewpageData objectAtIndex:finPrevIndex]];
    }
  

}

-(void)loadNextView{
    
    PageViewController    *previousViewController = (PageViewController *)[self getViewControllerFormArr:CurrentView];
    NSString    *nextValueStr = previousViewController.dataLabel.text;
    NSInteger    findIndex = [nextValueStr integerValue]+2;
    
    if (findIndex<[self.webViewpageData count]) {
            [self reLoadDataOnNextView:[self.htmlPageIndexArr objectAtIndex:findIndex]
                             withHtmlName:[self.webViewpageData objectAtIndex:findIndex]];
    }else{
          if (findIndex == [self.htmlPageIndexArr count] || findIndex == [self.htmlPageIndexArr count]+1 ) {
                [self reLoadDataOnNextView:@"" withHtmlName:@"Empty.htm"];
          }
    }
}

-(void)stopAudioWhenUserSwitchPage{
    // Stop Audio When you flip page
    [BibleSingletonManager sharedManager].isAudioEnable = NO;
    [BibleSingletonManager sharedManager].isItGoforNextPage = YES;
    PageViewController    *currentViewController = [self getViewControllerFormArr:CurrentView];
    [currentViewController releaseAudioObjcet];
    [currentViewController reStoreLastAudioState];
    //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
}
@end
