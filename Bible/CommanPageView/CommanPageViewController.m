//
//  CommanPageViewController.m
//  Bible
//
//  Created by Ashish Awasthi on 5/20/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import "CommanPageViewController.h"

#define KCommanWebViewTag  700001
@interface CommanPageViewController ()

@end

@implementation CommanPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
             withHtml:(NSString *)htmlNameStr;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _htmlNameStr = htmlNameStr;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    
    UIImage     *image;
    CGRect    frameSize;
    
    [self loadHtml:_htmlNameStr];
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
    [webView setTag:KCommanWebViewTag];
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
    
    frameSize = CGRectMake((webView.frame.size.width - 36)/2, (webView.frame.size.height -36)/2, 36, 36);
    identicaterView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [identicaterView setBackgroundColor:[UIColor blackColor]];
    [identicaterView.layer setCornerRadius:4.0];
    [identicaterView setFrame:frameSize];
    [webView addSubview:identicaterView];
    
}
#pragma marks
#pragma UIScrollView Delegate-
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}

#pragma marks
#pragma UIwebViewDelegate Method-
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [identicaterView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [identicaterView stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked){
       
    }
   
    return YES;
}

#pragma marks
#pragma Button Eevent
-(void)goBackOnLastView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Go back On last Page");
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
