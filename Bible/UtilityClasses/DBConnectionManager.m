//
//  DBConnectionManager.m
//  CR Tech
//
//  Created by Ashish Awasthi on 14/01/13.
//  Copyright (c) 2013 Kiwitech International. All rights reserved.
//

//

#import "DBConnectionManager.h"
#import "Data.h"
#define DATABASE_NAME @"Bible.Sqlite"

@implementation DBConnectionManager

static sqlite3 *m_database = nil;



+(void)createDatabaseCopyIfNotExist{
    
	BOOL success;
	NSFileManager *fileManager=[NSFileManager defaultManager];
	NSError *error;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
	NSString *cachesDirectory=[paths objectAtIndex:0];
	NSString *writableDBPath=[cachesDirectory stringByAppendingPathComponent:DATABASE_NAME];
	success=[fileManager fileExistsAtPath:writableDBPath];
	if(success)return;
	
	NSString *defaultDBPath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:DATABASE_NAME];
	success=[fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
	if(!success){
		NSAssert1(0,@"Failed to create writable database file with massage '%@'.",[error localizedDescription]);
	}
	
}


+(BOOL)openConnection
{
	NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES);
	NSString *cachesDirectory=[paths objectAtIndex:0];
	NSString *path=[cachesDirectory stringByAppendingPathComponent:DATABASE_NAME];
	if(sqlite3_open([path UTF8String],&m_database)==SQLITE_OK)
		return TRUE;
	else
		return FALSE;
}


+(NSMutableArray *)getDataFromStateTable:(NSString *)query{

    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if ([DBConnectionManager openConnection])
    {
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(m_database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
			
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                StateData *thisObj = [[StateData alloc] init];
                
                if(sqlite3_column_text(statement,0))
                {
                    thisObj._stateName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                }
                else{
                    thisObj._stateName = @"";
                }
                
                if(sqlite3_column_text(statement,1))
                {
                    thisObj._regionId =  sqlite3_column_int(statement, 1);
                }
                else{
                    thisObj._regionId = -1;
                }
                
                if(sqlite3_column_text(statement,2))
                {
                    thisObj._stateImageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                }
                else{
                    thisObj._stateImageName=@"";
                }
                
                if(sqlite3_column_text(statement,3))
                {
                    thisObj._stateXcor = sqlite3_column_double(statement, 3);
                }
                else{
                    thisObj._stateXcor = -1;
                }
                if(sqlite3_column_text(statement,4))
                {
                    thisObj._stateYcor = sqlite3_column_double(statement, 4);
                }
                else{
                    thisObj._stateYcor = -1;
                }
                
                [tempArray addObject:thisObj];
                [thisObj release];
            }
            
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(m_database);
    }
    
    
    else{
        sqlite3_close(m_database);
        NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(m_database));
    }
	
	return [tempArray autorelease];

}
+(NSMutableArray *)getSeletedRegionsStateTable:(NSString *)query{
    
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if ([DBConnectionManager openConnection])
    {
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(m_database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
			
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                StateData *thisObj = [[StateData alloc] init];
                
               
                if(sqlite3_column_text(statement,0))
                {
                    thisObj._stateId =  sqlite3_column_int(statement, 0);
                }
                else{
                    thisObj._stateId = -1;
                }
                
                
                if(sqlite3_column_text(statement,1))
                {
                    thisObj._stateName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                }
                else{
                    thisObj._stateName = @"";
                }
                
                if(sqlite3_column_text(statement,2))
                {
                    thisObj._regionId =  sqlite3_column_int(statement, 2);
                }
                else{
                    thisObj._regionId = -1;
                }
                
                if(sqlite3_column_text(statement,3))
                {
                    thisObj._stateImageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                }
                else{
                    thisObj._stateImageName=@"";
                }
                
                if(sqlite3_column_text(statement,4))
                {
                    thisObj._stateXcor = sqlite3_column_double(statement, 4);
                }
                else{
                    thisObj._stateXcor = -1;
                }
                if(sqlite3_column_text(statement,5))
                {
                    thisObj._stateYcor = sqlite3_column_double(statement, 5);
                }
                else{
                    thisObj._stateYcor = -1;
                }
                
                [tempArray addObject:thisObj];
                [thisObj release];
            }
            
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(m_database);
    }
    
    
    else{
        sqlite3_close(m_database);
        NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(m_database));
    }
	
	return [tempArray autorelease];
}



+(NSMutableArray *)getDataFromDataBase:(NSString *)query{
    
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if ([DBConnectionManager openConnection])
    {
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(m_database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
			
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                LocalityIndex *thisObj = [[LocalityIndex alloc] init];
                
                if(sqlite3_column_text(statement,0))
                {
                    thisObj._imageName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                }
                else{
                    thisObj._imageName = @"";
                }
                if(sqlite3_column_text(statement,1))
                {
                    thisObj._imageData = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                }
                else{
                    thisObj._imageData=@"";
                }
                if(sqlite3_column_text(statement,2))
                {
                    thisObj._imgId = sqlite3_column_int(statement, 2);
                }
                else{
                    thisObj._imgId = -1;
                }
                
                [tempArray addObject:thisObj];
                [thisObj release];
            }
            
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(m_database);
    }
    
    
    else{
        sqlite3_close(m_database);
        NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(m_database));
    }
	
	return [tempArray autorelease];
}

+(RegionData *)getRegionEndCordRegionTable:(NSString *)query{
    
    RegionData *thisObj = nil;
    
    if ([DBConnectionManager openConnection])
    {
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(m_database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
			
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                thisObj = [[RegionData alloc] init];
                
                if(sqlite3_column_text(statement,0))
                {
                    thisObj._regionId =  sqlite3_column_int(statement, 0);
                }
                else{
                    thisObj._regionId = -1;
                }
                
                if(sqlite3_column_text(statement,1))
                {
                    thisObj._regionXCord = sqlite3_column_double(statement, 1);
                }
                else{
                    thisObj._regionXCord = -1;
                }
                
                if(sqlite3_column_text(statement,2))
                {
                    thisObj._regionYCord = sqlite3_column_double(statement, 2);
                }
                else{
                    thisObj._regionYCord = -1;
                }
                
            }
            
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(m_database);
        
    }else{
        
        sqlite3_close(m_database);
        NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(m_database));
        
    }
	
	return [thisObj autorelease];
}


+(NSMutableArray *)getStateRegionData:(NSString *)query{
    
    
    StateRegionData *thisObj = nil;
    
    NSMutableArray    *dataObjArr = [[NSMutableArray alloc] init] ;
    
    if ([DBConnectionManager openConnection])
    {
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(m_database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
			
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                thisObj = [[StateRegionData alloc] init];
                
                if(sqlite3_column_text(statement,0))
                {
                    thisObj._stateId =  sqlite3_column_int(statement, 0);
                }
                else{
                    thisObj._stateId = -1;
                }
                
                if(sqlite3_column_text(statement,1))
                {
                    thisObj._regionId = sqlite3_column_double(statement, 1);
                }
                else{
                    thisObj._regionId = -1;
                }
                
                if(sqlite3_column_text(statement,2))
                {
                    thisObj._regionName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                }
                else{
                    thisObj._regionName = @"";
                }
                
                if(sqlite3_column_text(statement,3))
                {
                    thisObj._regionImage = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                }
                else{
                    thisObj._regionImage = @"";
                }
                
                if(sqlite3_column_text(statement,4))
                {
                    thisObj._regionXCord = sqlite3_column_double(statement, 4);
                }
                else{
                    thisObj._regionXCord = -1;
                }
                
                if(sqlite3_column_text(statement,5))
                {
                    thisObj._regionYCord = sqlite3_column_double(statement, 5);
                }
                else{
                    thisObj._regionYCord = -1;
                }

                
                [dataObjArr addObject:thisObj];
                RELEASE(thisObj);
            }
            
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(m_database);
        
    }else{
        
        sqlite3_close(m_database);
        NSAssert1(0,@"Failed to open database with message '%s'.",sqlite3_errmsg(m_database));
        
    }
	
	return [dataObjArr autorelease];


}
@end