//
//  PageViewController.m
//  Bible
//
//  Created by Ashish Awasthi on 4/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//


#define MenuOptionAnimationDuration  0.7

#import "PageViewController.h"


@interface PageViewController ()

@end

@implementation PageViewController

@synthesize dataObject;

@synthesize webView = _webView;
@synthesize dataLabel = _dataLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
            withTitle:(NSString *)titleStr
          withHtmlStr:(NSString *)htmlName{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        NSLog(@"HTMLName = %@",htmlName);
       
        CGRect   frameSize;
        
        UIImage    *image;
        
        frameSize = CGRectMake(0, 0, 768, 1024);
        
        self.dataLabel = [[UILabel alloc] init];
        [self.dataLabel setTextAlignment:NSTextAlignmentCenter];
        [self.dataLabel setText:titleStr];
        [self.dataLabel setTextColor:[UIColor clearColor]];
        [self.dataLabel setFont:[UIFont boldSystemFontOfSize:100.0 ]];
        [self.dataLabel setBackgroundColor:[UIColor clearColor]];
        [self.dataLabel setFrame:frameSize];
        [self.view addSubview:self.dataLabel];
        
        frameSize = CGRectMake(0, 0, 768, 1024);
        
        self.webView = [[UIWebView alloc] init];
        //[self.webView setUserInteractionEnabled:NO];
        [self.webView.scrollView setScrollEnabled:NO];
        //if ([BibleSingletonManager sharedManager].isFirstTime) {
           
            [self.webView setDelegate:self];
        //}
        [self.webView setScalesPageToFit:YES];
        [self.webView setBackgroundColor:[UIColor clearColor]];
        [self.webView setFrame:frameSize];
        [self.view  addSubview:self.webView];
        
        NSString* text = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                                                   pathForAuxiliaryExecutable:htmlName]] encoding:NSASCIIStringEncoding error:nil];
        
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [self.webView loadHTMLString:text baseURL:baseURL];
       
        if ([BibleSingletonManager sharedManager].isFirstTime) {
            frameSize = CGRectMake(0, 0, 768, 1024);
            imageView = [[UIImageView alloc] init];
            //[imageView setBackgroundColor:[UIColor redColor]];
            [imageView setImage:[UIImage imageNamed:@"Default.png"]];
            [imageView setFrame:frameSize];
            [self.view addSubview:imageView];
        }
        
        image = [UIImage imageNamed:@"Ribbon.png"];
        frameSize =  CGRectMake(self.view.frame.size.width - image.size.width -25, 0, image.size.width, image.size.height);
        menuOptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuOptionBtn setImage:image forState:UIControlStateNormal];
        [menuOptionBtn setFrame:frameSize];
        [menuOptionBtn addTarget:self action:@selector(tabOnMenuOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:menuOptionBtn];
        
        // Custom initialization
    }
    return self;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
   [BibleSingletonManager sharedManager].isFirstTime = NO;
   [[BibleSingletonManager sharedManager] hideWithAlphaAnimation:YES withView:imageView withSelector:@selector(removeSplashView) withDuration:.2 withDelegate:self];
    
}

-(void)tabOnMenuOption:(id)sender{
    
    CGRect   frameSize ;
    UIImage *image;
    image = [UIImage imageNamed:@"menu_bg.png"];
    
    frameSize = CGRectMake(538, 0, image.size.width, 0);
    
    menuView = [[MenView alloc] initWithFrame:frameSize withDelegate:self];
   [self.view addSubview:menuView];
    
    
    frameSize = CGRectMake(self.view.frame.size.width - image.size.width, 0, image.size.width, 973);
    
    [[BibleSingletonManager sharedManager] animationWithFrame:frameSize withView:menuView withSelector:nil withDuration:MenuOptionAnimationDuration withDelegate:nil];
    
}

#pragma maks
#pragma MenuViewDelegate

-(void)hideMenuView{
    CGRect   frameSize ;
    frameSize = CGRectMake(538, 0, 230, 0);
 [[BibleSingletonManager sharedManager] animationWithFrame:frameSize withView:menuView withSelector:nil withDuration:MenuOptionAnimationDuration withDelegate:nil];
}
-(void)removeSplaashView{
    [imageView removeFromSuperview];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(void)loadHtml:(NSString *)htmlName{
    
    NSString* text = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                                               pathForAuxiliaryExecutable:htmlName]] encoding:NSASCIIStringEncoding error:nil];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webView loadHTMLString:text baseURL:baseURL];
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
   // NSString    *requestStr = request.URL;
    
    

    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
