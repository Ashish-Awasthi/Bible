//
//  Data.m
//  DermDX
//
//  Created by Ashish Awasthi on 14/01/13.
//  Copyright (c) 2013 Kiwitech International. All rights reserved.
//

//

#import "Data.h"
@implementation Data

@end

/////////////////////////////////////////////////////////////////////////////////////

@implementation PageData

@synthesize _pageId;
@synthesize _pageHtmlNameStr;

- (void) dealloc {
	
    _pageId = -1;
    RELEASE(_pageHtmlNameStr);
	[super dealloc];
}

@end

//  ************************* State Data Object *************************

@implementation AudioData

@synthesize _colorCodeStr;
@synthesize _pageId;
@synthesize _spanIdStr;
@synthesize _audioFileNameStr;
@synthesize _audioStartTime;
@synthesize _audioEndTime;

- (void) dealloc {
    
	_pageId = -1;
    _audioStartTime = -1;
    _audioEndTime = -1;
    RELEASE(_colorCodeStr);
    RELEASE(_spanIdStr);
    RELEASE(_audioFileNameStr);
    
	[super dealloc];
}

@end


