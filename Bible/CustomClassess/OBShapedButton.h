

//  Created by Ashish Awasthi on 14/01/13.
//  Copyright (c) 2013 Kiwitech International. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 OBShapedButton is a UIButton subclass optimized for non-rectangular button shapes.
 Instances of OBShapedButton respond to touches only in areas where the image that is
 assigned to the button for UIControlStateNormal is non-transparent.
 
 Usage:
 - Add OBShapedButton.h, OBShapedButton.m, UIImage+ColorAtPixel.h, and UIImage+ColorAtPixel.m
   to your Xcode project.
 - Design your UI in Interface Builder with UIButtons as usual. Set the Button type to Custom
   and provide transparent PNG images for the different control states as needed.
 - In the Identity Inspector in Interface Builder, set the Class of the button to OBShapedButton.
   That's it! Your button will now only respond to touches where the PNG image for the normal
   control state is non-transparent.
 */



// -[UIView hitTest:withEvent: ignores views that an alpha level less than 0.1.
// So we will do the same and treat pixels with alpha < 0.1 as transparent.
#define kAlphaVisibleThreshold (0.1f)


@interface OBShapedButton : UIButton {
    // Our class interface is empty. OBShapedButton only overwrites one method of UIView.
    // It has no attributes of its own.
}

@end
