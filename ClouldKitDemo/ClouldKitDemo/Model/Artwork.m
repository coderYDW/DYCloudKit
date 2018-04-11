//
//  Artwork.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/4/8.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import "Artwork.h"

@implementation Artwork

- (instancetype)initTitle:(NSString *)title address:(NSString *)address artist:(NSString *)artist date:(NSDate *)date {
    if (self = [super init]) {
        self.title = title;
        self.date = date;
        self.artist = artist;
        self.address = address;
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.title = [dictionary objectForKey:FIELD_TITLE];
        self.date = [dictionary objectForKey:FIELD_DATE];
        self.artist = [dictionary objectForKey:FIELD_ARTIST];
        self.address = [dictionary objectForKey:FIELD_ADDRESS];
    }
    return self;
}

- (instancetype)initWithRecord:(CKRecord *)record {
    if (self = [super init]) {
        self.title = [record objectForKey:FIELD_TITLE];
        self.date = [record objectForKey:FIELD_DATE];
        self.artist = [record objectForKey:FIELD_ARTIST];
        self.address = [record objectForKey:FIELD_ADDRESS];
    }
    return self;
}

@end
