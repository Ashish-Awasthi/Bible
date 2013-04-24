//
//  Animator.h
//  HPS
//
//  Created by abhishek on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Animator : NSObject 
{
    NSMutableArray *layerArray;
    
    UIImageView *animatedView;
    
    BOOL animationState;
    
    NSTimer *animationTimer;
    
    NSInteger repeatCount;
    
    id delegate;
}

@property(nonatomic,retain)UIImageView *animatedView;
@property(nonatomic)BOOL animationState;
@property(nonatomic)NSInteger repeatCount;
@property(nonatomic, retain)id delegate;

-(void)initialize;
-(void)initializeArray;
-(void)initializeImageViews;
-(void)initializeImage:(UIImageView *)imageView withLayer:(CALayer *)layer;
-(void)removeAllLayersImageView:(UIImageView *)imageView;
-(void)startAnimation:(UITapGestureRecognizer *)gesture;
-(void)updateImage;
-(void)updateImage:(UIImageView *)imageView withLayers:(NSMutableArray *)layerArr callBack:(SEL)selector delegate:(id)delegate;
-(void)animationCompleted:(id)sender;
-(void)restartAnimation;

@end

@protocol AnimatorDelegate <NSObject>

@optional
-(void)animationDidFinished:(Animator *)object;
-(void)animationDidBegin:(Animator *)object;
@end

