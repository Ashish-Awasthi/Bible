//
//  MenView.m
//  Bible
//
//  Created by Ashish Awasthi on 4/23/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//


#define KMenuOptionArr \
@"stories_text.png",\
@"readmore_text.png",\
@"fineprint_text.png",\
@"makeityourself_text.png",\
@"share_text.png",\
nil

#import "MenView.h"



@implementation MenView

@synthesize delegate = _delegate;

@synthesize isItShow = _isItShow;

- (id)initWithFrame:(CGRect)frame
       withDelegate:(id)delegate

{
    self.delegate = delegate;
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.isItShow = YES;
        
        CGRect    frameSize;
        UIImage    *image;
        int xOffSet = 35;
        int yOffSet = 15;
       // CGRect   frameSize;
        image = [UIImage imageNamed:@"menu_bg.png"];
        [self setBackgroundColor:[UIColor colorWithPatternImage:image]];
        
        image = [UIImage imageNamed:@"hearpage_text.png"];
        
        frameSize = CGRectMake(xOffSet, yOffSet, image.size.width, image.size.height);
        UIButton      *hearPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [hearPageBtn setImage:image forState:UIControlStateNormal];
        [hearPageBtn setFrame:frameSize];
        [hearPageBtn addTarget:self action:@selector(tabObHearItNowButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:hearPageBtn];
        
        xOffSet = xOffSet+image.size.width+10;
        
        image = [UIImage imageNamed:@"audio_btn.png"];
        
        frameSize = CGRectMake(xOffSet, yOffSet+2, image.size.width, image.size.height);
        UIButton      *audioBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [audioBtn setImage:image forState:UIControlStateNormal];
        [audioBtn setFrame:frameSize];
        [audioBtn addTarget:self action:@selector(tabOnAudioButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:audioBtn];
        
         xOffSet = xOffSet+image.size.width+10;
        image = [UIImage imageNamed:@"letitread_text.png"];
        frameSize = CGRectMake(xOffSet, yOffSet, image.size.width, image.size.height);
        UIButton      *letItReadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [letItReadBtn setImage:image forState:UIControlStateNormal];
        [letItReadBtn setFrame:frameSize];
        [letItReadBtn addTarget:self action:@selector(tabOnLetItReadButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:letItReadBtn];
      
        NSArray   *optionArr = [NSArray arrayWithObjects:KMenuOptionArr];
     
        xOffSet = 20;
        
        yOffSet = yOffSet+image.size.height+20;
        image = [UIImage imageNamed:[optionArr objectAtIndex:0]];
        frameSize = CGRectMake(xOffSet, yOffSet, image.size.width, image.size.height);
        UIButton      *storyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [storyBtn setImage:image forState:UIControlStateNormal];
        [storyBtn setFrame:frameSize];
        [storyBtn addTarget:self action:@selector(tabOnOptionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:storyBtn];
        
        yOffSet = yOffSet+image.size.height+15;
    
        image = [UIImage imageNamed:[optionArr objectAtIndex:1]];
        frameSize = CGRectMake(xOffSet, yOffSet, image.size.width, image.size.height);
        UIButton      *readMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [readMoreBtn setImage:image forState:UIControlStateNormal];
        [readMoreBtn setFrame:frameSize];
        [readMoreBtn addTarget:self action:@selector(tabOnOptionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:readMoreBtn];
        
        yOffSet = yOffSet+image.size.height+15;
        image = [UIImage imageNamed:[optionArr objectAtIndex:2]];
        frameSize = CGRectMake(xOffSet, yOffSet, image.size.width, image.size.height);
        UIButton      *finePrintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [finePrintBtn setImage:image forState:UIControlStateNormal];
        [finePrintBtn setFrame:frameSize];
        [finePrintBtn addTarget:self action:@selector(tabOnOptionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:finePrintBtn];
        
        yOffSet = yOffSet+image.size.height+15;
        
        image = [UIImage imageNamed:[optionArr objectAtIndex:3]];
        frameSize = CGRectMake(xOffSet, yOffSet, image.size.width, image.size.height);
        UIButton      *makeItYourSelfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [makeItYourSelfBtn setImage:image forState:UIControlStateNormal];
        [makeItYourSelfBtn setFrame:frameSize];
        [makeItYourSelfBtn addTarget:self action:@selector(tabOnOptionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:makeItYourSelfBtn];
        
        yOffSet = yOffSet+image.size.height+10;
        
        image = [UIImage imageNamed:[optionArr objectAtIndex:4]];
        frameSize = CGRectMake(xOffSet, yOffSet, image.size.width, image.size.height);
        UIButton      *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareBtn setImage:image forState:UIControlStateNormal];
        [shareBtn setFrame:frameSize];
        [shareBtn addTarget:self action:@selector(tabOnOptionButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareBtn];
       

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveView:)];
        
        panGesture.delegate = self;
        
        panGesture.maximumNumberOfTouches = 1;
        
        panGesture.minimumNumberOfTouches = 1;
        
        [self addGestureRecognizer:panGesture];
        
        [panGesture release];
        
        
    }
    return self;
}


-(void)tabObHearItNowButton:(id)sender{
    NSLog(@"tabObHearItNowButton");
}

-(void)tabOnAudioButton:(id)sender{
    NSLog(@"tabOnAudioButton");

}

-(void)tabOnLetItReadButton:(id)sender{
    NSLog(@"tabOnLetItReadButton");

}

-(void)tabOnOptionButton:(id)sender{
    UIButton    *optionBtn = (UIButton *)sender;
    
    
    switch (optionBtn.tag) {
        case 0:
            NSLog(@"tabOnOptionButton %d",optionBtn.tag);
            break;
        case 1:
            NSLog(@"tabOnOptionButton %d",optionBtn.tag);
            break;

        case 2:
            NSLog(@"tabOnOptionButton %d",optionBtn.tag);
            break;

        case 3:
            NSLog(@"tabOnOptionButton %d",optionBtn.tag);
            break;

        case 4:
            NSLog(@"tabOnOptionButton %d",optionBtn.tag);
            break;
        case 5:
            NSLog(@"tabOnOptionButton %d",optionBtn.tag);
            break;

        case 6:
            NSLog(@"tabOnOptionButton %d",optionBtn.tag);
            break;

            
        default:
            break;
    }
    NSLog(@"tabOnLetItReadButton");
    
}

-(void)moveView:(id)sender
{
    
    [self bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    
	CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.superview];
    // firstY = [[sender superview] frame].origin.y;
    NSLog(@"firstX  %f",translatedPoint.y);
	
	if (translatedPoint.y<0)
	{
		if ([self.delegate respondsToSelector:@selector(hideMenuView:)]) {
            [self.delegate hideMenuView:translatedPoint.y];
        }
	}
	else if(translatedPoint.y>0)
	{
		if ([self.delegate respondsToSelector:@selector(showMenuView:)]) {
            [self.delegate showMenuView:translatedPoint.y];
        }
	}
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    distance = location.y;
    
    if (self.isItShow) {
        if (location.y >805) {
            if ([self.delegate respondsToSelector:@selector(showMenuView:)]) {
                //[self.delegate showMenuView:826.0];
           }
        }
    }else{
        if (location.y >805) {
            if ([self.delegate respondsToSelector:@selector(hideMenuView:)]) {
                //[self.delegate hideMenuView:-826.0];
            }
        }
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self.superview];
    
    distance = touchLocation.y - distance;
    
    if ([self.delegate respondsToSelector:@selector(showMenuView:)]) {
        //[self.delegate showMenuView:touchLocation.y];
    }

    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
