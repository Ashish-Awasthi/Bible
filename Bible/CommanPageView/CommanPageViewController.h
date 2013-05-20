//
//  CommanPageViewController.h
//  Bible
//
//  Created by Ashish Awasthi on 5/20/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommanPageViewController : UIViewController<UIWebViewDelegate,
UIScrollViewDelegate>{
    UIActivityIndicatorView*   identicaterView;
    NSString*                  _htmlNameStr;
}
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             withHtml:(NSString *)htmlNameStr;
@end
