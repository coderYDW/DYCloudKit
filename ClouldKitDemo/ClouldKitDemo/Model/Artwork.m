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
        self.title = [dictionary objectForKey:@"title"];
        self.date = [dictionary objectForKey:@"date"];
        self.artist = [dictionary objectForKey:@"artist"];
        self.address = [dictionary objectForKey:@"address"];
    }
    return self;
}

- (instancetype)initWithRecord:(CKRecord *)record {
    if (self = [super init]) {
        self.title = [record objectForKey:@"title"];
        self.date = [record objectForKey:@"date"];
        self.artist = [record objectForKey:@"artist"];
        self.address = [record objectForKey:@"address"];
    }
    return self;
}

@end
