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

@interface LocalityIndex : NSObject {

}
@property(nonatomic,assign)NSInteger _imgId;
@property (nonatomic, copy) NSString *_imageName;
@property (nonatomic, copy) NSString *_imageData;
@end

//  ************************* State Data Object *************************

@interface StateData : NSObject {
    
}
@property(nonatomic,assign)NSInteger  _stateId;
@property (nonatomic, copy) NSString *_stateName;
@property(nonatomic,assign)NSInteger  _regionId;
@property (nonatomic, copy) NSString *_stateImageName;
@property(nonatomic,assign)NSInteger _stateXcor;
@property(nonatomic,assign)NSInteger _stateYcor;
@end

//  ************************* Region Data Object *************************

@interface RegionData : NSObject {
    
}
@property(nonatomic,assign)NSInteger _regionId;
@property(nonatomic,assign)NSInteger _regionXCord;
@property(nonatomic,assign)NSInteger _regionYCord;
@end

//  ************************* StateRegion Objects *************************

@interface StateRegionData : NSObject {
    
}
@property(nonatomic,assign)NSInteger _stateId;
@property(nonatomic,assign)NSInteger _regionId;
@property(nonatomic,copy)NSString    *_regionName;
@property(nonatomic,copy)NSString    *_regionImage;
@property(nonatomic,assign)NSInteger _regionXCord;
@property(nonatomic,assign)NSInteger _regionYCord;
@end
