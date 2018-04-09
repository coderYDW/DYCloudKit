//
//  Artwork.h
//  ClouldKitDemo
//
//  Created by Apple on 2018/4/8.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artwork : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSDate *date;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initTitle:(NSString *)title address:(NSString *)address artist:(NSString *)artist date:(NSDate *)date;

- (instancetype)initWithRecord:(CKRecord *)record;

@end
