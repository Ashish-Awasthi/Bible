//
//  MenView.m
//  Bible
//
//  Created by Ashish Awasthi on 4/23/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import "MenView.h"

@implementation MenView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
       withDelegate:(id)delegate

{
    self.delegate = delegate;
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor redColor]];
        UIImage    *image;
       // CGRect   frameSize;
        image = [UIImage imageNamed:@"menu_bg.png"];
        
        [self setBackgroundColor:[UIColor colorWithPatternImage:image]];
    }
    return self;
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    if (location.y >805) {
        if ([self.delegate performSelector:@selector(hideMenuView)]) {
            [self.delegate hideMenuView];
        }
    }
    NSLog(@"X: %f",location.x);
    NSLog(@"Y: %f",location.y);
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
