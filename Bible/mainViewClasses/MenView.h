//
//  MenView.h
//  Bible
//
//  Created by Ashish Awasthi on 4/23/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenViewDelegate <NSObject>

-(void)hideMenuView;

@end
@interface MenView : UIView

@property(nonatomic,assign) id <NSObject,MenViewDelegate> delegate;
- (id)initWithFrame:(CGRect)frame
       withDelegate:(id)delegate;
@end
