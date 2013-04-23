//
//  PageViewController.m
//  Bible
//
//  Created by Ashish Awasthi on 4/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//



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
       [ self.webView setUserInteractionEnabled:NO];
        [self.webView.scrollView setScrollEnabled:NO];
        if ([BibleSingletonManager sharedManager].isFirstTime) {
           
            [self.webView setDelegate:self];
        }
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
            [imageView setImage:[UIImage imageNamed:@"Page_001.jpg"]];
            [imageView setFrame:frameSize];
            [self.view addSubview:imageView];
        }
       
        
        
        

        // Custom initialization
    }
    return self;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
   [BibleSingletonManager sharedManager].isFirstTime = NO;
    [[BibleSingletonManager sharedManager] hideWithAlphaAnimation:YES withView:imageView withSelector:@selector(removeSplaashView) withDuration:.2 withDelegate:self];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
