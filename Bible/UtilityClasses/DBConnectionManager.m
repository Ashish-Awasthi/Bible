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


+(NSMutableArray *)getDataFromDataBase:(NSString *)query{
    
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if ([DBConnectionManager openConnection])
    {
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(m_database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
			
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                PageData *thisObj = [[PageData alloc] init];
                
                if(sqlite3_column_text(statement,0))
                {
                    thisObj._pageId = sqlite3_column_int(statement, 0);
                }
                else{
                    thisObj._pageId = -1;
                }
                if(sqlite3_column_text(statement,1))
                {
                    thisObj._pageHtmlNameStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                }
                else{
                    thisObj._pageHtmlNameStr = @"";
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

+(NSMutableArray *)getDataFromAudioTable:(NSString *)query{
    
	NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    
    if ([DBConnectionManager openConnection])
    {
        sqlite3_stmt *statement;
        
        if (sqlite3_prepare_v2(m_database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK)
        {
			
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                AudioData *thisObj = [[AudioData alloc] init];
                
                if(sqlite3_column_text(statement,0))
                {
                    thisObj._pageId = sqlite3_column_int(statement, 0);
                }
                else{
                    thisObj._pageId = -1;
                }
                
                if(sqlite3_column_text(statement,1))
                {
                    thisObj._spanIdStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                }
                else{
                    thisObj._spanIdStr = @"";
                }
                if(sqlite3_column_text(statement,2))
                {
                    thisObj._audioFileNameStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                }
                else{
                    thisObj._audioFileNameStr = @"";
                }
                
                if(sqlite3_column_text(statement,3))
                {
                    thisObj._audioStartTime = sqlite3_column_int(statement, 3);
                }
                else{
                    thisObj._audioStartTime = -1;
                }
                
                if(sqlite3_column_text(statement,4))
                {
                    thisObj._audioEndTime = sqlite3_column_int(statement, 5);
                }
                else{
                    thisObj._audioEndTime = -1;
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


@end