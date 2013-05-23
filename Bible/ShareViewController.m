//
//  ShareViewController.m
//  Bible
//
//  Created by Ashish Awasthi on 5/13/13.
//  Copyright (c) 2013 Ashish Awasthi. All rights reserved.
//

#import "ShareViewController.h"
#import "PersistenceDataStore.h"
#import "FbLikeViewViewController.h"
#define ShareOptionArr \
@"icon_email.png",\
@"icon_facebook.png",\
@"icon_facebook.png",\
@"icon_twitter.png",\
nil

// ,
@interface ShareViewController ()
-(void)shareMessageViaEmail;
-(void)shareMessageViaFaceBook;
-(void)shareMessageViaTwitter;
-(void)addShareOption;
@end

@implementation ShareViewController

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
    
    UIImage     *image;
    CGRect    frameSize;
    image = [UIImage imageNamed:@"Share_Bg.png"];
    frameSize = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIImageView    *bgImageView = [[UIImageView alloc] init];
    [bgImageView setUserInteractionEnabled:YES];
    [bgImageView setFrame:frameSize];
    [bgImageView setImage:image];
    [self.view addSubview:bgImageView];
     RELEASE(bgImageView);
    
    image = [UIImage imageNamed:@"btn_back.png"];
    frameSize = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:frameSize];
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBackOnLastView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [self addShareOption];
    
    frameSize = CGRectMake(250,60,100, 40);
	// Do any additional setup after loading the view.
}

-(void)addShareOption{
    
    UIImage     *image;
    CGRect    frameSize;
    NSArray   *optionArr = [NSArray arrayWithObjects:ShareOptionArr];
    int xOffSet = 150;
    int yoffSet = 360;
    
    for (int i = 0; i<[optionArr count]; i++) {
        image = [UIImage imageNamed:[optionArr objectAtIndex:i]];
        frameSize = CGRectMake(xOffSet, yoffSet, image.size.width, image.size.height);
        
        UIButton *shareOptionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareOptionBtn setTag:i];
        [shareOptionBtn setFrame:frameSize];
        [shareOptionBtn setImage:image forState:UIControlStateNormal];
        [shareOptionBtn addTarget:self action:@selector(tabOnShareOption:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareOptionBtn];
        yoffSet = yoffSet+image.size.height+50;
    }
    
}

#pragma marks
#pragma Button Eevent
-(void)goBackOnLastView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Go back On last Page");
    }];
}


-(void)tabOnShareOption:(id)sender{
    
    UIButton    *shareOptionBtn = (UIButton *)sender;
    
    switch (shareOptionBtn.tag) {
        case ShareViaEmail:
            [self shareMessageViaEmail];
            break;
        case ShareViaFacebook:
            [self shareMessageViaFaceBook];
            break;
        case LikeOnFaceBook:
            [BibleSingletonManager sharedManager].shareViewCommanClass.viewController = self;
            [[BibleSingletonManager sharedManager].shareViewCommanClass openfaceLikeView];
            break;
        case ShareViaTwitter:
            [self shareMessageViaTwitter];
            break;
            
        default:
            break;
    }
}



-(void)shareMessageViaEmail{
    [BibleSingletonManager sharedManager].shareViewCommanClass.viewController = self;
    [[BibleSingletonManager sharedManager].shareViewCommanClass shareMessageViaEmail];
}
-(void)shareMessageViaFaceBook{
    
    [BibleSingletonManager sharedManager].shareViewCommanClass.viewController = self;
    [[BibleSingletonManager sharedManager].shareViewCommanClass shareMessageViaFaceBook];
}
-(void)shareMessageViaTwitter{
 [BibleSingletonManager sharedManager].shareViewCommanClass.viewController = self;
 [[BibleSingletonManager sharedManager].shareViewCommanClass shareMessageViaTwitter];
}
         
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
