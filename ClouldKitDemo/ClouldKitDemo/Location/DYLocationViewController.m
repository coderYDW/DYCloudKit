//
//  DYLocationViewController.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/4/9.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import "DYLocationViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface DYLocationViewController ()

@end

@implementation DYLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
}

- (void)location {
    //125.683832,42.530341 梅河口市
    //114.085947,22.547    深圳市
    CLLocation *location = [[CLLocation alloc] initWithLatitude:22.530341 longitude:114.085947];
    
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    
    [publicDatabase fetchRecordWithID:[[CKRecordID alloc] initWithRecordName:@"115"] completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        
        if (error) {
            return;
        }
        
        NSLog(@"%@",record);
        
        [record setObject:location forKey:FIELD_LOCATION];
        
        [publicDatabase saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            if (error) {
                return;
            }
            NSLog(@"save success");
        }];
        
    }];
}


@end
