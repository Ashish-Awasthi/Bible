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
    
    AppDelegate    *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    PageViewController   *pageViewController;
    
    for (int i = 0; i<[appDelegate.preLoadViewArr count]; i++) {
        pageViewController = [appDelegate.preLoadViewArr objectAtIndex:i];
        if (pageViewController.view.tag == viewNumber) {
            break;
        }
    }
    
    return pageViewController;
    
}



-(void)reLoadDataOnNextView:(NSString *) changeTitleStr
                 withHtmlName:(NSString *)htmlNameStr{
    
    AppDelegate    *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSArray   *objectArr = [appDelegate.preLoadViewArr copy];
    [appDelegate.preLoadViewArr removeAllObjects];
    
    PageViewController   *pageViewController;
    
    for (int i = 0; i<[objectArr count]; i++) {
        
        pageViewController = [objectArr objectAtIndex:i];
        
        switch (pageViewController.view.tag) {
                
            case ExtremLeftView:
                pageViewController.view.tag = ExtremRightView;
                [pageViewController loadHtml:htmlNameStr];
                [pageViewController.dataLabel setText:changeTitleStr];
                [appDelegate.preLoadViewArr addObject:pageViewController];
                break;
            case LeftView:
                pageViewController.view.tag = ExtremLeftView;
                [appDelegate.preLoadViewArr addObject:pageViewController];
                break;
                
            case CurrentView:
                pageViewController.view.tag = LeftView;
                [appDelegate.preLoadViewArr addObject:pageViewController];
                break;
            case RightView:
                pageViewController.view.tag = CurrentView;
                [appDelegate.preLoadViewArr addObject:pageViewController];
                break;
                
            case ExtremRightView:
                pageViewController.view.tag = RightView;
                [appDelegate.preLoadViewArr addObject:pageViewController];
                break;
                
            default:
                break;
        }
        
    }
    
    [objectArr release];
}

-(void)reLoadDataOnPrevView:(NSString *) changeTitleStr
                  withHtmlName:(NSString *)htmlNameStr{
    
    AppDelegate    *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSArray   *objectArr = [appDelegate.preLoadViewArr copy];
    [appDelegate.preLoadViewArr removeAllObjects];
    
    PageViewController   *pageViewController;
    
    for (int i = 0; i<[objectArr count]; i++) {
        
        pageViewController = [objectArr objectAtIndex:i];
        
        switch (pageViewController.view.tag) {
                
            case ExtremLeftView:
                pageViewController.view.tag = LeftView;
                [appDelegate.preLoadViewArr addObject:pageViewController];
                break;
            case LeftView:
                pageViewController.view.tag = CurrentView;
                [appDelegate.preLoadViewArr addObject:pageViewController];
                
                break;
                
            case CurrentView:
                pageViewController.view.tag = RightView;
                [appDelegate.preLoadViewArr addObject:pageViewController];
                break;
            case RightView:
                pageViewController.view.tag = ExtremRightView;
                [appDelegate.preLoadViewArr addObject:pageViewController];
                break;
                
            case ExtremRightView:
                pageViewController.view.tag = ExtremLeftView;
                 [pageViewController loadHtml:htmlNameStr];
                [pageViewController.dataLabel setText:changeTitleStr];
                [appDelegate.preLoadViewArr addObject:pageViewController];
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
        
        self.htmlPageIndexArr = [[NSArray arrayWithObjects:KDataArr] retain];
        self.webViewpageData  = [[NSArray arrayWithObjects:HtmlArrName] retain];
        
    }
    return self;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
     NSLog(@"Right flip");
    
    PageViewController    *precurrentViewController = [self getViewControllerFrameArr:CurrentView];
    NSString    *findPrevValueStr = precurrentViewController.dataLabel.text;
    
    NSLog(@"%@",findPrevValueStr);

    
    if ([findPrevValueStr integerValue] == 2 || [findPrevValueStr integerValue] == 3) {
        [self reLoadDataOnPrevView:@"" withHtmlName:@"Empty.htm"];
        PageViewController    *pageViewControlle = [self getViewControllerFrameArr:CurrentView];
        return pageViewControlle;
    }
    
    if ([findPrevValueStr intValue] == 1) {
        return nil;
    }else{
        NSInteger    finPrevIndex;
        finPrevIndex = [findPrevValueStr integerValue]-4;
       // NSLog(@"====== %@",[self.htmlPageIndexArr objectAtIndex:finPrevIndex]);
        
        [self reLoadDataOnPrevView:[self.htmlPageIndexArr objectAtIndex:finPrevIndex] withHtmlName:[self.webViewpageData objectAtIndex:finPrevIndex]];
        
        PageViewController    *pageViewControlle = [self getViewControllerFrameArr:CurrentView];
        return pageViewControlle;
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSLog(@"Left flip");
    firstTimeRightFlip = NO;
    
    PageViewController    *previousViewController = (PageViewController *)[self getViewControllerFrameArr:CurrentView];
    
    NSString    *nextValueStr = previousViewController.dataLabel.text;
    NSInteger    findIndex = [nextValueStr integerValue]+2;
    
    
   // NSLog(@"%@",nextValueStr);

   // NSLog(@" nextValueStr %d",[nextValueStr integerValue]+2);
    
    if (findIndex<[self.webViewpageData count]) {
        [self reLoadDataOnNextView:[self.htmlPageIndexArr objectAtIndex:findIndex]
                         withHtmlName:[self.webViewpageData objectAtIndex:findIndex]];
    }else{
        if (findIndex == [self.htmlPageIndexArr count] || findIndex == [self.htmlPageIndexArr count]+1 ) {
            [self reLoadDataOnNextView:@"" withHtmlName:@"Empty.htm"];
        }else{
            return nil;
        }
    }
    
   PageViewController    *pageViewControlle = [self getViewControllerFrameArr:CurrentView];
    return pageViewControlle;
}


@end
