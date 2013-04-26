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


-(void)reLoadDataOnNextView:(NSString *) changeTitleStr
                  withHtmlName:(NSString *)htmlNameStr;
-(void)reLoadDataOnPrevView:(NSString *) changeTitleStr
                  withHtmlName:(NSString *)htmlNameStr;
//@property (readonly, strong, nonatomic) NSArray *pageData;
@property (nonatomic, retain) NSArray *webViewpageData;
@property(nonatomic,retain)NSArray     *htmlPageIndexArr;
@end

@implementation ModelController

@synthesize webViewpageData = webViewpageData;

@synthesize viewController;
@synthesize htmlPageIndexArr = _htmlPageIndexArr;


-(PageViewController *)getViewControllerFrameArr:(PreLoadView )viewNumber{
    
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
                [pageViewController loadHtml:htmlNameStr];
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
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
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
                [[BibleSingletonManager sharedManager].preLoadViewArr addObject:pageViewController];
                
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
                pageViewController.view.tag = ExtremLeftView;
                 [pageViewController loadHtml:htmlNameStr];
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
        self.webViewpageData  = [[NSArray arrayWithObjects:HtmlArrName,nil] retain];
     //   NSLog(@"===%@",self.htmlPageIndexArr);
        //NSLog(@"===%@",self.webViewpageData);
    }
    return self;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
   
    if ([BibleSingletonManager sharedManager].leftToRight) {
    PageViewController    *leftPageViewController = [self getViewControllerFrameArr:LeftView];
    
    if (leftPageViewController) {
        return leftPageViewController;
    }else{
        return NO;
    }
   }
    return NO;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
        
    if ([BibleSingletonManager sharedManager].rightToLeft) {
    //NSLog(@"Left flip");
    firstTimeRightFlip = NO;

    PageViewController    *pageViewController = [self getViewControllerFrameArr:RightView];
        if (pageViewController) {
             return pageViewController;
        }else{
           return NO;
        }
   
    }else{
        return NO;
    }
}

-(void)loadPrevView{
    
    PageViewController    *precurrentViewController = [self getViewControllerFrameArr:CurrentView];
    NSString    *findPrevValueStr = precurrentViewController.dataLabel.text;
    
    if ([findPrevValueStr integerValue] == 2 || [findPrevValueStr integerValue] == 3) {
        [self reLoadDataOnPrevView:@"" withHtmlName:@"Empty.htm"];
        return;
    }
     NSInteger    finPrevIndex;
    finPrevIndex = [findPrevValueStr integerValue]-4;
        
    [self reLoadDataOnPrevView:[self.htmlPageIndexArr objectAtIndex:finPrevIndex] withHtmlName:[self.webViewpageData objectAtIndex:finPrevIndex]];
        
    
}

-(void)loadNextView{
    
    PageViewController    *previousViewController = (PageViewController *)[self getViewControllerFrameArr:CurrentView];
    
    NSString    *nextValueStr = previousViewController.dataLabel.text;
    NSInteger    findIndex = [nextValueStr integerValue]+2;
    
    if (findIndex<[self.webViewpageData count]) {
            [self reLoadDataOnNextView:[self.htmlPageIndexArr objectAtIndex:findIndex]
                             withHtmlName:[self.webViewpageData objectAtIndex:findIndex]];
    }else{
        if (findIndex == [self.htmlPageIndexArr count] || findIndex == [self.htmlPageIndexArr count]+1 ) {
                [self reLoadDataOnNextView:@"" withHtmlName:@"Empty.htm"];
        }else{
              
        }
        }
}
@end
