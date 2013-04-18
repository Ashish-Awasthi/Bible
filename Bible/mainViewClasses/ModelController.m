//
//  ModelController.m
//  NewProj
//
//  Created by Ashish Awasthi on 4/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//



#import "ModelController.h"

#import "DataViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */
#import "PageViewController.h"

@interface ModelController()
//@property (readonly, strong, nonatomic) NSArray *pageData;
@property (readonly, strong, nonatomic) NSArray *webViewpageData;
@end

@implementation ModelController

@synthesize webViewpageData;

@synthesize viewController;

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
        currentIndex = 0;
        findPageIndex = 0;
        webViewpageData = [[NSArray arrayWithObjects:PageArr] retain];
        
    }
    return self;
}

- (PageViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    // Return the data view controller for the given index.
    if (([self.webViewpageData count] == 0) || (index >= [self.webViewpageData count])) {
        return nil;
    }
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    PageViewController *startingViewController = [appDelegate.pageViewArr objectAtIndex:0];
    startingViewController.dataObject = [webViewpageData objectAtIndex:index];
    
    return startingViewController;
}

- (NSUInteger)indexOfViewController:(DataViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    
    return [self.webViewpageData indexOfObject:viewController.dataObject];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    //NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    
    if ((currentIndex == 0) || (currentIndex == NSNotFound)) {
        return nil;
    }
    
    currentIndex--;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    PageViewController *startingViewController = [appDelegate.pageViewArr objectAtIndex:currentIndex];
    
    return startingViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
   // NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    if (currentIndex == NSNotFound) {
        return nil;
    }
    
    currentIndex++;
    findPageIndex++;
    if (currentIndex >= [self.webViewpageData count]) {
        currentIndex = [self.webViewpageData count];
        return nil;
    }
    
    if (currentIndex >=3) {
        [self.viewController loadNextTwoWebView:YES loadPreviousTwowebView:NO  withIndex:currentIndex+2];
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    PageViewController *startingViewController = [appDelegate.pageViewArr objectAtIndex:findPageIndex];
    
    if (findPageIndex >= 4) {
        findPageIndex = -1;
    }
    return startingViewController;
}

@end
