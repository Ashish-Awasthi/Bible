//
//  RootViewController.h
//  NewProj
//
//  Created by Ashish Awasthi on 4/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuSliderViewController.h"
#import "ModelController.h"

@interface RootViewController : UIViewController <UIPageViewControllerDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate,MenuSliderDelegate,ModelControllerDelegate>{
    
    NSInteger    findPageIndex;
    MenuSliderViewController     *menuViewController;
    BOOL           isItTouchInMenuView;
    NSInteger     currentPosition;
    
}
@property(nonatomic,assign) BOOL pageAnimationFinished;
@property (strong, nonatomic) UIPageViewController *pageViewController;
-(void)setMenuSliderViewHidden:(BOOL) isHidden;
-(void)pageFlipAutomaticallyWhenAudioFinsh:(NSArray *)viewControllersArr;
@end
