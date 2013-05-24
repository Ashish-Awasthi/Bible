//
//  FbLikeViewViewController.m
//  Bible
//
//  Created by Ashish Awasthi on 5/22/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import "FbLikeViewViewController.h"
#define KFaceBookLikePageTag 100001
@interface FbLikeViewViewController ()

@end

@implementation FbLikeViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isItHaveIdenticatior = YES;
    CGRect   frameSize;
    UIImage   *image;
    image  = [UIImage imageNamed:@"FbLikeBg.png"];
    
    frameSize  = CGRectMake(0 ,0, self.view.frame.size.width, self.view.frame.size.height);
    
    UIImageView   *bgImage = [[UIImageView alloc] init];
    [bgImage setFrame:frameSize];
    [bgImage setImage:image];
    [self.view addSubview:bgImage];
    RELEASE(bgImage);
    
    frameSize = CGRectMake(50, 56, image.size.width-100, image.size.height-112);
    UIView     *faceLikeView = [[UIView alloc] init];
    faceLikeView.layer.cornerRadius = 8.0;
    [faceLikeView setTag:KFaceBookLikePageTag];
    [faceLikeView setFrame:frameSize];
    [faceLikeView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:faceLikeView];
  
    
    frameSize = CGRectMake(20,20,faceLikeView.frame.size.width -40, faceLikeView.frame.size.height-40);
    UIWebView     *faceLikewebView = [[UIWebView alloc] init];
    [faceLikewebView setBackgroundColor:[UIColor whiteColor]];
    [faceLikewebView setOpaque:NO];
    [faceLikewebView setDelegate:self];
    [faceLikewebView setFrame:frameSize];
    [faceLikeView addSubview:faceLikewebView];
    // Hide Below and up Shadow on UiWebView>>>>>>>>>
    for (UIView *view in faceLikewebView.scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.hidden = YES;
        }
    }
    NSURL *baseURL = [NSURL URLWithString:kBibleFacebookPageURL];
   [faceLikewebView loadRequest:[NSURLRequest requestWithURL:baseURL]];
    
    frameSize = CGRectMake((faceLikewebView.frame.size.width - 36)/2, (faceLikewebView.frame.size.height -36)/2, 36, 36);
    identicaterView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [identicaterView setBackgroundColor:[UIColor blackColor]];
    [identicaterView.layer setCornerRadius:4.0];
    [identicaterView setFrame:frameSize];
    [faceLikewebView addSubview:identicaterView];
    
    image = [UIImage imageNamed:@"btn_back.png"];
    frameSize = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:frameSize];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBackOnLastView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    RELEASE(faceLikewebView);
    RELEASE(faceLikeView);
	// Do any additional setup after loading the view.
}

#pragma marks
#pragma UIwebViewDelegate Method-
- (void)webViewDidStartLoad:(UIWebView *)webView{
   [identicaterView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [identicaterView stopAnimating];
    // not show copy paste option in webview
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';  document.body.style.KhtmlUserSelect='none'"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
   if(navigationType == UIWebViewNavigationTypeLinkClicked){
       NSString   *requestUrlStr = [request.URL  absoluteString];
        NSString   *feedStr  = [[requestUrlStr componentsSeparatedByString:@"="] objectAtIndex:1];
       if ([feedStr caseInsensitiveCompare:@"feed&id"] == NSOrderedSame) {
           return NO;
       }
    return YES;
    }
   return YES;
}

#pragma marks
#pragma Button Eevent
-(void)goBackOnLastView:(id)sender{
    
    if (isItHaveIdenticatior) {
        [identicaterView stopAnimating];
        [identicaterView removeFromSuperview];
    }
    [self dismissViewControllerAnimated:YES completion:^{
       // NSLog(@"Go back On last Page");
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
