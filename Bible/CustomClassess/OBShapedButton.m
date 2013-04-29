

//  Created by Ashish Awasthi on 14/01/13.
//  Copyright (c) 2013 Kiwitech International. All rights reserved.
//

#import "OBShapedButton.h"
#import "UIImage+ColorAtPixel.h"



@implementation OBShapedButton

- (BOOL)isAlphaVisibleAtPoint:(CGPoint)point forImage:(UIImage *)image 
{
    // Correct point to take into account that the image does not have to be the same size
    // as the button. See https://github.com/ole/OBShapedButton/issues/1
    CGSize iSize = image.size;
    CGSize bSize = self.frame.size;
    point.x *= (bSize.width != 0) ? (iSize.width / bSize.width) : 1;
    point.y *= (bSize.height != 0) ? (iSize.height / bSize.height) : 1;

    CGColorRef pixelColor = [[image colorAtPixel:point] CGColor];
    CGFloat alpha = CGColorGetAlpha(pixelColor);
    return alpha >= kAlphaVisibleThreshold;
}


// UIView uses this method in hitTest:withEvent: to determine which subview should receive a touch event.
// If pointInside:withEvent: returns YES, then the subview’s hierarchy is traversed; otherwise, its branch
// of the view hierarchy is ignored.
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event 
{
    // Return NO if even super returns NO (i.e., if point lies outside our bounds)
    BOOL superResult = [super pointInside:point withEvent:event];
    if (!superResult) {
        return superResult;
    }

    // We can't test the image's alpha channel if the button has no image. Fall back to super.
    UIImage *buttonImage = [self imageForState:UIControlStateNormal];
    UIImage *buttonBackground = [self backgroundImageForState:UIControlStateNormal];

    if (buttonImage == nil && buttonBackground == nil) {
        return YES;
    }
    else if (buttonImage != nil && buttonBackground == nil) {
        return [self isAlphaVisibleAtPoint:point forImage:buttonImage];
    }
    else if (buttonImage == nil && buttonBackground != nil) {
        return [self isAlphaVisibleAtPoint:point forImage:buttonBackground];
    }
    else {
        if ([self isAlphaVisibleAtPoint:point forImage:buttonImage]) {
            return YES;
        } else {
            return [self isAlphaVisibleAtPoint:point forImage:buttonBackground];
        }
    }
}

@end
