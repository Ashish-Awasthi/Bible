//
//  ModelController.h
//  NewProj
//
//  Created by Ashish Awasthi on 4/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataViewController;

@protocol ModelControllerDelegate <NSObject>
@optional
-(void)setMenuSliderViewHidden:(BOOL) isHidden;
@end

@interface ModelController : NSObject <UIPageViewControllerDataSource>{
    BOOL     firstTimeRightFlip;
}

@property(nonatomic,retain) id <NSObject,ModelControllerDelegate>delegate;
-(void)loadNextView;
-(void)loadPrevView;
@end
