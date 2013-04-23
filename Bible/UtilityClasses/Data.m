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

@implementation LocalityIndex

@synthesize _imgId;
@synthesize _imageData;
@synthesize _imageName;


- (void) dealloc {
	
    _imgId = -1;
    
    RELEASE(_imageData);
     RELEASE(_imageName);
    
	[super dealloc];
}

@end

//  ************************* State Data Object *************************

@implementation StateData

@synthesize _stateId;
@synthesize _stateName;
@synthesize _regionId;
@synthesize _stateImageName;
@synthesize _stateXcor;
@synthesize _stateYcor;

- (void) dealloc {
	_regionId = -1;
    _stateId = -1;
    _stateXcor = -1;
    _stateYcor = -1;
    RELEASE(_stateImageName);
    RELEASE(_stateName);
    
	[super dealloc];
}

@end
//  ************************* Region EndData Object *************************

@implementation RegionData

@synthesize _regionId;
@synthesize _regionXCord;
@synthesize _regionYCord;

- (void) dealloc {
	
    _regionId = -1;
    _regionXCord = -1;
    _regionYCord = -1;
    
	[super dealloc];
}

@end

//  ************************* Region EndData Object *************************

@implementation StateRegionData

@synthesize _stateId;
@synthesize _regionId;
@synthesize _regionName;
@synthesize _regionImage;
@synthesize _regionXCord;
@synthesize _regionYCord;

- (void) dealloc {
	
    _regionId = -1;
    _stateId = -1;
    _regionXCord = -1;
    _regionYCord = -1;
    RELEASE(_regionImage);
     RELEASE(_regionName);
	[super dealloc];
}

@end
