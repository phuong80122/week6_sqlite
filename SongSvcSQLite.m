//
//  SongSvcSQLite.m
//  I-transpose_TableView
//
//  Created by Phuong Nguyen on 2/12/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "SongSvcSQLite.h"

#import "sqlite3.h"

@implementation SongSvcSQLite


NSString *databasePath = nil;
sqlite3 *database = nil;

-(id)init {
    if ((self = [super init])) {
        
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [documentPaths objectAtIndex:0];
        databasePath = [documentsDir stringByAppendingPathComponent:@"song.sqlite3"];
        
        if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            NSLog(@"database is open");
            NSLog(@"database file path: %@", databasePath);
            
            NSString *createSql = @"create table if not exists song (id integer primary key autoincrement, title varchar(60), key varchar(10), lyric text)";
            
            char *errMsg;
            if (sqlite3_exec(database, [createSql UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table %s", errMsg);
            }
            
        } else {
            NSLog(@"*** Failed to open database!");
            NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
        }
    }
    return self;
}


- (Song *) createSong: (Song *) song {
    sqlite3_stmt *statement;
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO song (title, key, lyric) VALUES (\"%@\",\"%@\",\"%@\")", song.title, song.key, song.lyric];
    if (sqlite3_prepare_v2(database, [insertSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE) {
            song.id = (int)sqlite3_last_insert_rowid(database);
            NSLog(@"*** Contact added");
        } else {
            NSLog(@"*** Contact NOT added");
            NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
        
    }
    return song;
}

- (NSMutableArray *) retrieveAllSongs {
    NSMutableArray *songs = [NSMutableArray array];
    NSString *selectSQL = [NSString stringWithFormat:@"SELECT * FROM song ORDER BY title"];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [selectSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        NSLog(@"*** Songs retrieved");
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int id = sqlite3_column_int(statement, 0);
            char *titleChars = (char *)sqlite3_column_text(statement, 1);
            char *keyChars = (char *)sqlite3_column_text(statement, 2);
            char *lyricChars = (char *)sqlite3_column_text(statement, 3);
            
            Song *song = [[Song alloc] init];
            song.id = id;
            song.title = [[NSString alloc] initWithUTF8String:titleChars];
            song.key = [[NSString alloc] initWithUTF8String:keyChars];
            song.lyric = [[NSString alloc] initWithUTF8String:lyricChars];
            [songs addObject:song];
        }
        sqlite3_finalize(statement);
    } else {
        NSLog(@"*** Songs NOT retrieved");
        NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
    }
    return songs;
}

- (Song *) updateSong: (Song *) song {
    NSString *updateSQL = [NSString stringWithFormat: @"UPDATE song SET title=\"%@\", key=\"%@\", lyric=\"%@\" WHERE id = %i", song.title, song.key, song.lyric, song.id];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [updateSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"*** Song updated");
        } else {
            NSLog(@"*** Song NOT updated");
            NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }
    return song;
}

- (Song *) deleteSong: (Song *) song {
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM song WHERE id = %i", song.id];
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [deleteSQL UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_DONE) {
            NSLog(@"*** Song deleted");
        } else {
            NSLog(@"*** Song NOT deleted");
            NSLog(@"*** SQL error: %s\n", sqlite3_errmsg(database));
        }
        sqlite3_finalize(statement);
    }
    return song;
}

-(void)dealloc {
    sqlite3_close(database);
}


@end
