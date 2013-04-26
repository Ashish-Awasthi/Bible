//
//  ModelController.h
//  NewProj
//
//  Created by Ashish Awasthi on 4/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DataViewController;


@interface ModelController : NSObject <UIPageViewControllerDataSource>{
    BOOL     firstTimeRightFlip;
}

-(void)reloadView;
@property(nonatomic,retain) id viewController;
- (DataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(DataViewController *)viewController;

@end
