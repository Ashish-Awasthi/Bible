//
//  PageViewController.m
//  Bible
//
//  Created by Ashish Awasthi on 4/17/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//




#import "PageViewController.h"


@interface PageViewController ()
-(void)audioPlay;
-(void)audioPause;
-(void)audioPlay:(NSString  *)audioFileName
       withStart:(NSTimeInterval)seekTime;

-(void)audioSycWithText:(NSString *)audioFileName
          withStartTime:(float)startTime
            withEndTime:(float)endTime
     withHighLightColor:(NSString *)hightColorStr
             withSpanId:(NSString *)spanIdStr;

-(void)removeLastHieghtLightStartNext;

@end

@implementation PageViewController

@synthesize dataObject;
@synthesize audioPlayer = _audioPlayer;
@synthesize webView = _webView;
@synthesize dataLabel = _dataLabel;
@synthesize lastAudioPlayerObj;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
            withTitle:(NSString *)titleStr
          withHtmlStr:(NSString *)htmlName{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
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
        [self.webView setOpaque:YES];
        [self.webView setBackgroundColor:[UIColor blackColor]];
        
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
        
        
//        pinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        [pinner setBackgroundColor:[UIColor redColor]];
//        [pinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)]; // I do this because I'm in landscape mode
//        [self.webView addSubview:pinner];
        
        NSString* text = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                                                   pathForAuxiliaryExecutable:htmlName]] encoding:NSASCIIStringEncoding error:nil];
        
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        [self.webView loadHTMLString:text baseURL:baseURL];
       
        if ([BibleSingletonManager sharedManager].isFirstTime) {
            frameSize = CGRectMake(0, 0, 768, 1024);
            imageView = [[UIImageView alloc] init];
            [imageView setBackgroundColor:[UIColor blackColor]];
            [imageView setUserInteractionEnabled:YES];
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
  
    NSString* text = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                                               pathForAuxiliaryExecutable:htmlName]] encoding:NSASCIIStringEncoding error:nil];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webView loadHTMLString:text baseURL:baseURL];
    
    
}

#pragma marks
#pragma UIWebView  Delegate Method-
- (void)webViewDidStartLoad:(UIWebView *)webView{
    //[pinner startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
     //[pinner stopAnimating];
    [BibleSingletonManager sharedManager].isFirstTime = NO;
    if (imageView) {
        
         [[BibleSingletonManager sharedManager] hideWithAlphaAnimation:YES withView:imageView withSelector:@selector(removeSplashView) withDuration:.8 withDelegate:self];
    }

    //  not show copy paste option in webview
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTouchCallout='none';  document.body.style.KhtmlUserSelect='none'"];
    
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


-(void)hieghtTextWhenSwipeUpperCorner:(NSInteger)pageId{

     [BibleSingletonManager sharedManager].isItGoforNextPage = NO;
     _currentPageId = pageId;
    //if (pageId == 4) {
      letItReadEnable = YES;
     //}
    
    hieghLightNumber = 0;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self removeHightLightWithId:nil];
    [self releaseAudioObjcet];
    
    NSString    *queryStr = [NSString stringWithFormat:KAudioDataQueryWherePageId,pageId];
    
    if (audioInfoPageArr) {
        RELEASE(audioInfoPageArr);
    }
    audioInfoPageArr =  [[DBConnectionManager getDataFromAudioTable:queryStr] retain];
    
    float    startTime = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._audioStartTime;
    float    endTime = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._audioEndTime;
    NSString     *spanIdStr =  ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._spanIdStr;
    NSString     *audioFileNameStr = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._audioFileNameStr;
    
    
    NSString     *colorCodeStr = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._colorCodeStr;
    
    // NSLog(@"Start Time is %f    endTime is %f  audioFileName is:- %@, spanIDStr %@",startTime,endTime,audioFileName,spanIdStr);
    
    [self audioSycWithText:audioFileNameStr withStartTime:startTime withEndTime:endTime withHighLightColor:colorCodeStr withSpanId:spanIdStr];
    

}

-(void)tabOnAudioIcon:(NSInteger )pageId{
    
     [BibleSingletonManager sharedManager].isItGoforNextPage = NO;
    
    _currentPageId = pageId;
    
    hieghLightNumber = 0;
    letItReadEnable = YES;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self removeHightLightWithId:nil];
    [self releaseAudioObjcet];
    
     NSString    *queryStr = [NSString stringWithFormat:KAudioDataQueryWherePageId,pageId];
        
        if (audioInfoPageArr) {
            RELEASE(audioInfoPageArr);
        }
        audioInfoPageArr =  [[DBConnectionManager getDataFromAudioTable:queryStr] retain];
        float    startTime = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._audioStartTime;
        float    endTime = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._audioEndTime;
        NSString     *spanIdStr =  ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._spanIdStr;
        NSString     *audioFileNameStr = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._audioFileNameStr;
      
        
        NSString     *colorCodeStr = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._colorCodeStr;
        
        // NSLog(@"Start Time is %f    endTime is %f  audioFileName is:- %@, spanIDStr %@",startTime,endTime,audioFileName,spanIdStr);
        
         [self audioSycWithText:audioFileNameStr withStartTime:startTime withEndTime:endTime withHighLightColor:colorCodeStr withSpanId:spanIdStr];
        
       
    
}


-(void)removeLastHieghtLightStartNext{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeHightLightWithId:) object:nil];
    hieghLightNumber++;
    //  NSLog(@"hieghLightNumber======%d arro element%@ ",hieghLightNumber,audioInfoPageArr);
    
    [self removeHightLightWithId:nil];
    [self releaseAudioObjcet];
    
    if (hieghLightNumber <=[audioInfoPageArr count]-1) {//last of page
        float    startTime = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._audioStartTime;
        float    endTime = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._audioEndTime;
        NSString     *spanIdStr =  ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._spanIdStr;
        NSString     *audioFileNameStr = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._audioFileNameStr;
            NSString     *colorCodeStr = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._colorCodeStr;
       // NSLog(@"Start Time is %f    endTime is %f  audioFileName is:- %@, spanIDStr %@",startTime,endTime,audioFileNameStr,spanIdStr);
        
         [self audioSycWithText:audioFileNameStr withStartTime:startTime withEndTime:endTime withHighLightColor:colorCodeStr withSpanId:spanIdStr];
        
    }else{
        //letItReadEnable = NO;
    }
    
}

#pragma marks
#pragma AudioSyc and text hieght method-

-(void)removeHightLightWithId:(NSString  *)spanIdStr{
    
   [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeHightLightWithId:) object:nil];
    
    NSString    *fuctionStr = [NSString stringWithFormat:@"removeHighlight('%@')",self.lastSpanIdStr];
    [self.webView stringByEvaluatingJavaScriptFromString:fuctionStr];
   [self releaseAudioObjcet];
}

-(void)removeHightLightTabOnSentenceWithId:(NSString  *)spanIdStr{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeHightLightWithId:) object:nil];
    
    NSString    *fuctionStr = [NSString stringWithFormat:@"removeHighlight('%@')",self.lastSpanIdStr];
    [self.webView stringByEvaluatingJavaScriptFromString:fuctionStr];
    [self releaseAudioObjcet];
}


-(void)addHightLightWithId:(NSString  *)spanIdStr
                 withColor:(NSString *) hieghtLightColorCode{
    
    NSString    *fuctionStr = [NSString stringWithFormat:@"addHighlight('%@','%@')",spanIdStr,hieghtLightColorCode];
    
    [self.webView stringByEvaluatingJavaScriptFromString:fuctionStr];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
     hieghLightNumber = 0;
     [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked)
	{
        NSString *selectedId   = [NSString stringWithFormat:@"selectedId"];
        NSString * spanIdStr = [webView stringByEvaluatingJavaScriptFromString:selectedId];
        NSString     *chapeterIdStr     = [[spanIdStr componentsSeparatedByString:@"Audio_#"] lastObject];
        
        if ([chapeterIdStr integerValue]>=3) {
           letItReadEnable = YES;
          [self tabOnAudioIcon:[chapeterIdStr integerValue]];
          return YES;
        }

        NSString    *queryStr = [NSString stringWithFormat:KAudioDataQueryWhereSpanID,spanIdStr];
        
        NSArray    *pageData =  [DBConnectionManager getDataFromAudioTable:queryStr];
        
        float    startTime = ((AudioData *)[pageData objectAtIndex:0])._audioStartTime;
        float    endTime = ((AudioData *)[pageData objectAtIndex:0])._audioEndTime;
        NSString     *audioFileNameStr = ((AudioData *)[pageData objectAtIndex:hieghLightNumber])._audioFileNameStr;
        
        NSString     *colorCodeStr = ((AudioData *)[pageData objectAtIndex:hieghLightNumber])._colorCodeStr;
        //  NSLog(@"Start Time is %f    endTime is %f  audioFileName is:- %@",startTime,endTime,audioFileNameStr);
        [self audioSycWithText:audioFileNameStr withStartTime:startTime withEndTime:endTime withHighLightColor:colorCodeStr withSpanId:spanIdStr];
    }
    
    
    return YES;
}


-(void)audioSycWithText:(NSString *)audioFileName
    withStartTime:(float)startTime
    withEndTime:(float)endTime
    withHighLightColor:(NSString *)hightColorStr
             withSpanId:(NSString *)spanIdStr{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    NSString*    hightNumberIdStr = [[spanIdStr componentsSeparatedByString:@"_"] lastObject];
    self.lastSpanIdStr = spanIdStr;
    float     removeHightTime = endTime - startTime;
    
    [self releaseAudioObjcet];
    if (self.lastSpanIdStr) {
        [self removeHightLightWithId:nil];
    }
    [self audioPlay:audioFileName withStart:startTime];
    [self addHightLightWithId:spanIdStr withColor:hightColorStr];
    
    if (letItReadEnable) {
        NSString    *queryStr = [NSString stringWithFormat:KAudioDataQueryWherePageId,_currentPageId];
         if (audioInfoPageArr) {
            RELEASE(audioInfoPageArr);
          }
         audioInfoPageArr =  [[DBConnectionManager getDataFromAudioTable:queryStr] retain];
         hieghLightNumber = [hightNumberIdStr integerValue]-1;
        
        if ([BibleSingletonManager sharedManager].isItGoforNextPage) {
            // use all condition for stop audio when you go in next page*******************
            [BibleSingletonManager sharedManager].isItGoforNextPage = NO;
            [self.audioPlayer stop];
            [self releaseAudioObjcet];
            [self stopLastAudio];
            hieghLightNumber = [audioInfoPageArr count]+10;
            //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            return;
        }else{
            [self audioPlay];
         [self performSelector:@selector(removeLastHieghtLightStartNext) withObject:nil afterDelay:removeHightTime];
        }
       
    }else{
        [self performSelector:@selector(removeHightLightTabOnSentenceWithId:) withObject:nil afterDelay:removeHightTime];
    }

}

-(void)audioPlay:(NSString  *)audioFileName
       withStart:(NSTimeInterval)seekTime{
   
    isAduioObjectAlive = YES;
    NSString *soundPath =[[NSBundle mainBundle]pathForAuxiliaryExecutable:audioFileName];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    NSError *error;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    self.audioPlayer.currentTime = seekTime;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer setDelegate:self];
    [self.audioPlayer setNumberOfLoops:0];
    [self.audioPlayer play];
    self.lastAudioPlayerObj = self.audioPlayer;
}

-(void)releaseAudioObjcet{
    
    if (isAduioObjectAlive) {
        isAduioObjectAlive = NO;
       [self.audioPlayer stop];
        RELEASE(self.audioPlayer);
        [self removeHightLightWithId:nil];
    }
}

-(void)stopLastAudio{
    [self.lastAudioPlayerObj stop];
}

-(void)audioPlay{
    [self.audioPlayer play];
}

-(void)audioStop{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(audioStop) object:nil];
    [self.audioPlayer stop];
}

-(void)audioPause{
    [self.audioPlayer pause];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
