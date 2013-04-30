//
//  DBConnectionManager.h
//  CR Tech
//
//  Created by Ashish Awasthi on 14/01/13.
//  Copyright (c) 2013 Kiwitech International. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBConnectionManager : NSObject {
    
}

+(void)createDatabaseCopyIfNotExist;

+(NSMutableArray *)getDataFromDataBase:(NSString *)query;

+(NSMutableArray *)getDataFromAudioTable:(NSString *)query;

@end
