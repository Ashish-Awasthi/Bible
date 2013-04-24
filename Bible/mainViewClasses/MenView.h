//
//  MenView.h
//  Bible
//
//  Created by Ashish Awasthi on 4/23/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenViewDelegate <NSObject>

-(void)hideMenuView:(float ) dragheight;
-(void)showMenuView:(float ) dragheight;

@end
@interface MenView : UIView{
    float     distance;
}

@property(nonatomic,assign) id <NSObject,MenViewDelegate,UIGestureRecognizerDelegate> delegate;
@property(nonatomic,assign) BOOL       isItShow;
- (id)initWithFrame:(CGRect)frame
       withDelegate:(id)delegate;
@end
