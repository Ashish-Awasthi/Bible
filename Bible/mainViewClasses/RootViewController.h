//
//  RootViewController.h
//  NewProj
//
//  Created by Ashish Awasthi on 4/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenView.h"
@interface RootViewController : UIViewController <UIPageViewControllerDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,MenViewDelegate>{
    
    NSInteger    findPageIndex;
   BOOL pageAnimationFinished;
    MenView *menuView;
}

@property (strong, nonatomic) UIPageViewController *pageViewController;
-(void)loadNextTwoWebView:(BOOL )isItLoadNextView
                withIndex:(NSInteger)index;

-(void)loadPrevView:(NSInteger )withViewControllerIndex
          withIndex:(NSInteger)htmlIndex;
    
@end
