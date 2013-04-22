//
//  AppDelegate.h
//  Bible
//
//  Created by Ashish Awasthi on 4/15/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;
#import "RootViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
   
}


@property(nonatomic,assign)BOOL            isFirstTime;

@property(nonatomic,retain)NSMutableArray     *preLoadViewArr;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) RootViewController *viewController;

@end
