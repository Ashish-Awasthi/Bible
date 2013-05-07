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
//@synthesize audioPlayer = _audioPlayer;
@synthesize webView = _webView;
@synthesize dataLabel = _dataLabel;


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

            UIImage   *image = [UIImage imageNamed:@"loaderBg.png"];
            increaseProgess = 0.1;
            loadingProgessView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
            loadingProgessView.trackImage = [UIImage imageNamed:@"loaderBg.png"] ;
            loadingProgessView.progressImage = [UIImage imageNamed:@"selectedPg.png"];
            [loadingProgessView setFrame:CGRectMake(235,230, image.size.width, image.size.height)];
            [loadingProgessView setProgress: increaseProgess];
            [imageView addSubview:loadingProgessView];
            
           progessTimer  = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(progessIncrease:) userInfo:nil repeats:YES];
            

        }
       
        // Custom initialization
    }
    return self;
}

-(void)progessIncrease:(id)sender{
    
    increaseProgess = increaseProgess+.1;
    [loadingProgessView setProgress:increaseProgess animated:YES];
    if (increaseProgess>=1) {
        [progessTimer invalidate];
        RELEASE(loadingProgessView);
    }
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
    isAudioEnable = NO;
    [BibleSingletonManager sharedManager].pageLoadingComplete = NO;
    NSString* text = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                                               pathForAuxiliaryExecutable:htmlName]] encoding:NSASCIIStringEncoding error:nil];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webView loadHTMLString:text baseURL:baseURL];
    
    
}

#pragma marks
#pragma UIWebView  Delegate Method-
- (void)webViewDidStartLoad:(UIWebView *)webView{
   
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
    
   [self performSelector:@selector(pageLoadingComplete) withObject:nil afterDelay:.3];

    //*****************************close**************************************************************************
    
}

-(void)pageLoadingComplete{
     [BibleSingletonManager sharedManager].pageLoadingComplete = YES;
}


-(void)hieghtTextWhenSwipeUpperCorner:(NSInteger)pageId{
    if (isAudioEnable == NO) {
        isAudioEnable = YES;
    }else{
      isAudioEnable = NO;
      letItReadEnable = NO;
      [NSObject cancelPreviousPerformRequestsWithTarget:self];
      [self.lastAudioPlayerObj stop];
      [self removeHightLightTabOnSentenceWithId:nil];
      self.lastSpanIdStr = @"";
      return;
    }
    [BibleSingletonManager sharedManager].isItGoforNextPage = NO;
     _currentPageId = pageId;
    letItReadEnable = YES;
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
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    // Here we check user want stop audio 
    if (isAudioEnable == NO) {
        isAudioEnable = YES;
    }else{
        isAudioEnable = NO;
        letItReadEnable = NO;
        [self releaseAudioObjcet];
        [self.lastAudioPlayerObj stop];
        [self removeHightLightTabOnSentenceWithId:nil];
         self.lastSpanIdStr = nil;
        return;
    }
    
    [BibleSingletonManager sharedManager].isItGoforNextPage = NO;
    _currentPageId = pageId;
    
    hieghLightNumber = 0;
    letItReadEnable = YES;
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
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    hieghLightNumber++;
    //  NSLog(@"hieghLightNumber======%d arro element%@ ",hieghLightNumber,audioInfoPageArr);
    
    [self removeHightLightWithId:nil];
    [self releaseAudioObjcet];
    
    if ([BibleSingletonManager sharedManager].isItGoforNextPage) {
        // use all condition for stop audio when you go in next page*******************
        [audioPlayer stop];
        [self releaseAudioObjcet];
        [self stopLastAudio];
        hieghLightNumber = [audioInfoPageArr count]+10;
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        return;
    }
    if (hieghLightNumber <=[audioInfoPageArr count]-1) {//last of page
        float    startTime = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._audioStartTime;
        float    endTime = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._audioEndTime;
        NSString     *spanIdStr =  ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._spanIdStr;
        NSString     *audioFileNameStr = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._audioFileNameStr;
            NSString     *colorCodeStr = ((AudioData *)[audioInfoPageArr objectAtIndex:hieghLightNumber])._colorCodeStr;
       // NSLog(@"Start Time is %f    endTime is %f  audioFileName is:- %@, spanIDStr %@",startTime,endTime,audioFileNameStr,spanIdStr);
        
         [self audioSycWithText:audioFileNameStr withStartTime:startTime withEndTime:endTime withHighLightColor:colorCodeStr withSpanId:spanIdStr];
        
    }else{
         isAudioEnable = NO;
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
            [self tabOnAudioIcon:[chapeterIdStr integerValue]];  
            return YES;
        }
        // Here we check user again tab on same sentence,show stop last audio and remove last hieghtlight--------
        if ([self.lastSpanIdStr caseInsensitiveCompare:spanIdStr] == NSOrderedSame) {
            [self.lastAudioPlayerObj stop];
            [self releaseAudioObjcet];
            [self removeHightLightTabOnSentenceWithId:nil];
             self.lastSpanIdStr = @"";
             isAudioEnable = NO;
            return YES;
        }
        
        if (letItReadEnable) {
            
        NSString    *queryStr = [NSString stringWithFormat:KAudioDataQueryWhereSpanID,spanIdStr];
        
        NSArray    *pageData =  [DBConnectionManager getDataFromAudioTable:queryStr];
        
        float    startTime = ((AudioData *)[pageData objectAtIndex:0])._audioStartTime;
        float    endTime = ((AudioData *)[pageData objectAtIndex:0])._audioEndTime;
        NSString     *audioFileNameStr = ((AudioData *)[pageData objectAtIndex:hieghLightNumber])._audioFileNameStr;
        
        NSString     *colorCodeStr = ((AudioData *)[pageData objectAtIndex:hieghLightNumber])._colorCodeStr;
        //  NSLog(@"Start Time is %f    endTime is %f  audioFileName is:- %@",startTime,endTime,audioFileNameStr);
        [self audioSycWithText:audioFileNameStr withStartTime:startTime withEndTime:endTime withHighLightColor:colorCodeStr withSpanId:spanIdStr];
         }
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
         [self audioPlay];
         [self performSelector:@selector(removeLastHieghtLightStartNext) withObject:nil afterDelay:removeHightTime];
        
       
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
    
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
   audioPlayer.currentTime = seekTime;
    [audioPlayer prepareToPlay];
    [audioPlayer setDelegate:self];
    [audioPlayer setNumberOfLoops:0];
    [audioPlayer play];
    self.lastAudioPlayerObj = audioPlayer;
}

-(void)releaseAudioObjcet{
    
    if (isAduioObjectAlive) {
        isAduioObjectAlive = NO;
       [audioPlayer stop];
        RELEASE(audioPlayer);
       [self removeHightLightWithId:nil];
    }
}

-(void)reStoreLastAudioState{
     hieghLightNumber = [audioInfoPageArr count]+10;
    isAudioEnable = NO;
}

-(void)stopLastAudio{
    [self.lastAudioPlayerObj stop];
}

-(void)audioPlay{
    [audioPlayer play];
}

-(void)audioStop{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(audioStop) object:nil];
    [audioPlayer stop];
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
