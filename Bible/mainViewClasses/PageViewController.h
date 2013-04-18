//
//  PageViewController.h
//  Bible
//
//  Created by Ashish Awasthi on 4/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIViewController<UIWebViewDelegate>{

    UIImageView         *imageView;
    NSArray             *pageViewControllerObjArr;
}

@property (strong, nonatomic) id dataObject;
@property(nonatomic,retain) UIWebView    *webView;
-(void)loadHtml:(NSString *)htmlName;
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
         withHtmlName:(NSString *)htmlName;
@end
