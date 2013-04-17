//
//  ViewController.m
//  Bible
//
//  Created by Ashish Awasthi on 4/15/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{

    
    UIWebView    *webView = [[UIWebView alloc] init];
    [webView.scrollView setScrollEnabled:NO];
    [webView setScalesPageToFit:YES];
    [webView setDelegate:self];
    [webView setBackgroundColor:[UIColor clearColor]];
    [webView setFrame:self.view.frame];
    [self.view  addSubview:webView];
    
    NSString* text = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                                               pathForResource:@"Page_001" ofType:@"htm"]] encoding:NSASCIIStringEncoding error:nil];

    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [webView setScalesPageToFit:NO];
    [webView loadHTMLString:text baseURL:baseURL];
    
    CGRect    frameSize;
    frameSize = CGRectMake(0, 0, 768, 1024);
    imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"Page_001.jpg"]];
    [imageView setFrame:frameSize];
    [self.view addSubview:imageView];
    
   
    //[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pathOfHtmlStr]]];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
   [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.9];
   [UIView setAnimationDelegate:self];
    [imageView setAlpha:0];
    //[imageView removeFromSuperview];
    [UIView commitAnimations];
  
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
