//
//  Animator.m
//  HPS
//
//  Created by abhishek on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

//

#import "Animator.h"
#import <QuartzCore/QuartzCore.h>

@implementation Animator
@synthesize animatedView;
@synthesize animationState;
@synthesize repeatCount;
@synthesize delegate;

static int repeats =0;

-(void)initialize
{
    [self initializeArray];
    [self initializeImageViews];
    
    [self startAnimation:nil];
}

-(void)initializeArray
{
    layerArray = [[NSMutableArray alloc] init];
    for (int i=0; i<9; i++)
    {
        CALayer *animatedViewLayer1 = [CALayer layer];
        
        animatedViewLayer1.frame = CGRectMake(0,0, animatedView.frame.size.width, animatedView.frame.size.height);
        
        NSString *no = [NSString stringWithFormat:@"%04i",i+1];
        
        NSString *imageName = [NSString stringWithFormat:@"anm_%@.png",no];
        
        NSLog(@"imageName=>>%@",imageName);
        
        animatedViewLayer1.contents =(id)[UIImage imageNamed:imageName].CGImage;
        
        [layerArray addObject:animatedViewLayer1];
        
        //[animatedViewLayer1 release];
    }
    
}

-(void)initializeImageViews
{
    [self initializeImage:self.animatedView withLayer:[layerArray objectAtIndex:0]];
}

-(void)initializeImage:(UIImageView *)imageView withLayer:(CALayer *)layer
{
    if([[imageView.layer sublayers] count]==0)
        [imageView.layer addSublayer:layer];
}

-(void)removeAllLayersImageView:(UIImageView *)imageView
{
    for (NSInteger i = 0; i<[[imageView.layer sublayers] count]; i++)
    {
        [[[imageView.layer sublayers] objectAtIndex:i] removeFromSuperlayer];
    }
    
}

-(void)startAnimation:(UITapGestureRecognizer *)gesture
{
    //isViewUp= NO;
    
    self.animationState = YES;
    
    if (layerArray == nil || [layerArray count]==0) 
	{
        NSLog(@"layerArray>>%@",layerArray);
        [self initializeArray];
	}
    NSLog(@"layerArray>>%@",layerArray);
	SEL animatingFunction = @selector(updateImage);
		
    if ([self.delegate respondsToSelector:@selector(animationDidBegin:)])
    {
        [self.delegate performSelector:@selector(animationDidBegin:) withObject:self];
    }
    
	animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:animatingFunction  userInfo:nil repeats:YES];
}

-(void)updateImage
{
    SEL function = @selector(animationCompleted:);
    
	id delegateObj = self;
    
	[self updateImage:self.animatedView withLayers:layerArray callBack:function delegate:delegateObj];
    
}

-(void)updateImage:(UIImageView *)imageView withLayers:(NSMutableArray *)layerArr callBack:(SEL)selector delegate:(id)delegateObj
{
    static int currentIndex = 0;
    static int previousIndex = 0;
    
	if (currentIndex >= [layerArr count])
	{
		[animationTimer invalidate];
		
		animationTimer =nil;
		
        currentIndex  = 0;
        
        previousIndex = 0;
        
        if([delegateObj respondsToSelector:selector])
            [delegateObj performSelector:selector withObject:imageView];        
        
        return;
	}
	
    imageView.userInteractionEnabled = NO;
	
	CALayer *currentImageLayer = [layerArr objectAtIndex:currentIndex];
	
	CALayer *previousImageLayer = [layerArr objectAtIndex:previousIndex];
	
	if(currentIndex>0)
	{
        for (int i =0; i<[[imageView.layer sublayers] count]; i++)
        {
            if ([[imageView.layer sublayers] containsObject:previousImageLayer])
            {
                [imageView.layer replaceSublayer:previousImageLayer with:currentImageLayer];
            }
        }
	}
	previousIndex = currentIndex;
	
	currentIndex = currentIndex +1;
}

-(void)animationCompleted:(id)sender
{
    UIImageView *imageView = (UIImageView *)sender;
    [self removeAllLayersImageView:imageView];
    [self initializeImage:imageView withLayer:[layerArray objectAtIndex:0]];


    
    imageView.userInteractionEnabled = YES;

    self.animationState = NO;

    if(repeats <= self.repeatCount)
    {
        [self startAnimation:nil];
        
        repeats++;
    }
    
    // calling function if delegate conforms to protocol
    
    if (!self.animationState) 
    {
        SEL selectorObj = @selector(animationDidFinished:);
        
        if ([self.delegate respondsToSelector:selectorObj]) 
        {
            [self.delegate performSelector:selectorObj withObject:self];
        }
    }
}

-(void)restartAnimation
{
    repeats = 0;
    
    if(repeats <= self.repeatCount)
    {
        [self startAnimation:nil];
        
        repeats++;
    }
}

@end
