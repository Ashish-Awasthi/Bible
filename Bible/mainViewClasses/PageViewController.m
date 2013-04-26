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
        
        CGRect   frameSize;
        
       // UIImage    *image;
        
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
        for (UIView   *subViews in [self.webView subviews]) {
            if ([subViews isKindOfClass:[UIScrollView class]]) {
               UIScrollView    *scrollView = (UIScrollView *)subViews;
                [scrollView setScrollEnabled:NO];
                [scrollView setDelegate:self];
            }
        }
        [self.webView setDelegate:self];
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
       
        // Custom initialization
    }
    return self;
}

#pragma marks
#pragma UIScrollView Delegate-
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
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
    
   // NSLog(@"%@",htmlName);
    
    NSString* text = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                                               pathForAuxiliaryExecutable:htmlName]] encoding:NSASCIIStringEncoding error:nil];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webView loadHTMLString:text baseURL:baseURL];
    
    
}

#pragma marks
#pragma UIWebView  Delegate Method-

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [BibleSingletonManager sharedManager].isFirstTime = NO;
    if (imageView) {
         [[BibleSingletonManager sharedManager] hideWithAlphaAnimation:YES withView:imageView withSelector:@selector(removeSplashView) withDuration:.2 withDelegate:self];
    }

    // * if you wanna find audio span id from webView, when user tab on sentence. must we add these javascript file in our resuorce bundle********************
    
    NSString *jqueryFilePath      = [[NSBundle mainBundle] pathForResource:@"jquery1_7_1"
                                                                    ofType:@"js" inDirectory:@""];
    NSData *jqueryFileData        = [NSData dataWithContentsOfFile:jqueryFilePath];
    NSString *jqueryString  = [[NSMutableString alloc] initWithData:jqueryFileData
                                                           encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jqueryString];
    
    NSString *filePath      = [[NSBundle mainBundle] pathForResource:@"selectedElement"
                                                              ofType:@"js" inDirectory:@""];
    NSData *fileData        = [NSData dataWithContentsOfFile:filePath];
    NSString *jsString      = [[NSMutableString alloc] initWithData:fileData
                                                           encoding:NSUTF8StringEncoding];
    [webView stringByEvaluatingJavaScriptFromString:jsString];
    //*****************************close**************************************************************************
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if(navigationType ==UIWebViewNavigationTypeLinkClicked)
	{
//        
//         NSInteger   firstSentenceStartTime = 0;
//         NSInteger   firstSentencEndTime = 2;
//        
//        NSInteger   secondSentenceStartTime = 4;
//        NSInteger   secondSentencEndTime = 6;
//        
//        NSInteger   thirdSentenceStartTime = 8;
//        NSInteger   thirdSentencEndTime = 14;
        
        NSString *selectedId   = [NSString stringWithFormat:@"selectedId"];
        NSString * selectedIdString = [webView stringByEvaluatingJavaScriptFromString:selectedId];
        //NSInteger   audioNumber = [[selectedIdString componentsSeparatedByString:@"_"] lastObject];
        
        [self audioPlay:@"p3_120312.wav"];
        //[self performSelector:@selector(audioStop) withObject:nil afterDelay:2];
        NSLog(@"string = %@",selectedIdString);
    }
   // NSString    *requestStr = request.URL;
    
    return YES;
}



-(void)audioPlay:(NSString  *)audioFileName {
    
    NSString *soundPath =[[NSBundle mainBundle]pathForAuxiliaryExecutable:audioFileName];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    NSError *error;
    
     audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    [audioPlayer setDelegate:self];
    [audioPlayer setNumberOfLoops:0];
    [audioPlayer play];
    
}

-(void)releaseAudioObjcet{
    
    [audioPlayer stop];
    RELEASE(audioPlayer);
}

-(void)audioPlay{
    [audioPlayer play];
}

-(void)audioStop{
   [audioPlayer stop];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(audioStop) object:nil];
}

-(void)audioPause{
   [audioPlayer pause];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
