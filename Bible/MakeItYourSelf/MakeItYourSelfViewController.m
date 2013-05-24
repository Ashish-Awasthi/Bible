//
//  MakeItYourSelfViewController.m
//  Bible
//
//  Created by Ashish Awasthi on 5/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import "MakeItYourSelfViewController.h"
#import "CommanPageViewController.h"

#define   MakeItReadWebViewTag  400001
@interface MakeItYourSelfViewController ()
-(void)loadHtml:(NSString *)htmlName;
@end

@implementation MakeItYourSelfViewController

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
    
    [self loadHtml:MakeItYourPageName];
    UIImage     *image;
    CGRect    frameSize;
    
    image = [UIImage imageNamed:@"btn_back.png"];
    frameSize = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:frameSize];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBackOnLastView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
   
	// Do any additional setup after loading the view.
}

-(void)loadHtml:(NSString *)htmlName{

CGRect   frameSize;
[BibleSingletonManager sharedManager].isAudioEnable = NO;
frameSize = CGRectMake(0, 0, 768, 1024);


 UIWebView           *webView = [[UIWebView alloc] init];
 [webView setTag:MakeItReadWebViewTag];
 [webView setOpaque:YES];
 [webView setBackgroundColor:[UIColor blackColor]];

  for (UIView   *subViews in [webView subviews]) {
    if ([subViews isKindOfClass:[UIScrollView class]]) {
        UIScrollView    *scrollView = (UIScrollView *)subViews;
        [scrollView setScrollEnabled:NO];
        [scrollView setDelegate:self];
    }
    }
  [webView setDelegate:self];
  [webView setScalesPageToFit:YES];
  [webView setBackgroundColor:[UIColor clearColor]];
  [webView setFrame:frameSize];
  [self.view  addSubview:webView];

  NSString* text = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                                           pathForAuxiliaryExecutable:htmlName]] encoding:NSASCIIStringEncoding error:nil];
  NSString *path = [[NSBundle mainBundle] bundlePath];
   NSURL *baseURL = [NSURL fileURLWithPath:path];
  [webView loadHTMLString:text baseURL:baseURL];
   RELEASE(webView);
  [[BibleSingletonManager sharedManager] showIdenticationView:YES withView:webView];
}

#pragma marks
#pragma UIScrollView Delegate-
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}


#pragma marks
#pragma UIwebViewDelegate Method-
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[BibleSingletonManager sharedManager] removeIdenticationFromView];
    // not show copy paste option in webview
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';  document.body.style.KhtmlUserSelect='none'"];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
        NSString  *requestUrlStr = [request.URL absoluteString];
       // NSLog(@" Request Type %@",requestUrlStr);
        if ([requestUrlStr length]>0) {
            [self openSelectedPage:requestUrlStr];
        }
        return NO;
    }
    
    return YES;
}

-(void)openSelectedPage:(NSString *)selectedPageHtmlNameStr{
    
    if ([[BibleSingletonManager sharedManager]checkNetworkReachabilityWithAlert]) {
        CommanPageViewController    *commanPageViewController = [[CommanPageViewController alloc] initWithNibName:nil bundle:nil withHtml:selectedPageHtmlNameStr];
        [commanPageViewController loadUrl:selectedPageHtmlNameStr];
        
        commanPageViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:commanPageViewController animated:YES completion:^{
            // NSLog(@"Now Show commanPageViewController");
            
        }];
        RELEASE(commanPageViewController);
    }
}

#pragma marks
#pragma Button Eevent
-(void)goBackOnLastView:(id)sender{
    [[BibleSingletonManager sharedManager] removeIdenticationFromView];
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Go back On last Page");
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    [super dealloc];
    NSLog(@"Make your self Dealloc call");
}
@end
