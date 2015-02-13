//
//  Song.m
//  I-transpose_TableView
//
//  Created by Phuong Nguyen on 1/24/15.
//  Copyright (c) 2015 msse650. All rights reserved.
//

#import "Song.h"



static NSString * const TITLE = @"title";
static NSString * const KEY = @"key";
static NSString * const LYRIC = @"lyric";


@implementation Song

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:TITLE];
     [coder encodeObject:self.key forKey:KEY];
     [coder encodeObject:self.lyric forKey:LYRIC];
     }

- (id)initWithCoder:(NSCoder *)coder {
         self = [super init];
         if (self) {
             _title = [coder decodeObjectForKey:TITLE];
             _key = [coder decodeObjectForKey:KEY];
             _lyric = [coder decodeObjectForKey:LYRIC];
         }
         return self;
     }
     
 
     
- (NSString *) description {
    return [NSString stringWithFormat: @"TITLE: %@, KEY: %@, LYRIC: %@",
            _title, _key, _lyric];
}



@end

