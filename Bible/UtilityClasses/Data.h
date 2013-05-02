//
//  Data.h
//  DermDX
//
//  Created by Ashish Awasthi on 14/01/13.
//  Copyright (c) 2013 Kiwitech International. All rights reserved.
//

//

#import <Foundation/Foundation.h>


@interface Data : NSObject {

}

@end

/////////////////////////////////////////////////////////////////////////////////////

@interface PageData : NSObject {

}
@property(nonatomic,assign) NSInteger _pageId;
@property (nonatomic, copy) NSString *_pageHtmlNameStr;
@end

//************************* Audio Data Object *************************

@interface AudioData : NSObject {
    
}
@property (nonatomic, copy) NSString *_colorCodeStr;
@property(nonatomic,assign) NSInteger _pageId;
@property(nonatomic,copy)  NSString * _spanIdStr;
@property (nonatomic, copy) NSString *_audioFileNameStr;
@property(nonatomic,assign) float _audioStartTime;
@property(nonatomic,assign) float _audioEndTime;

@end

