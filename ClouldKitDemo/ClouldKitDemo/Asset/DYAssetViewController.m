//
//  DYAssetViewController.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/4/9.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import "DYAssetViewController.h"

@interface DYAssetViewController ()

@end

@implementation DYAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)assetImage {
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"timg" ofType:@"jpeg"];
    
    NSURL *imageUrl = [NSURL fileURLWithPath:path];
    
    if (imageUrl) {
        CKAsset *asset = [[CKAsset alloc] initWithFileURL:imageUrl];
        
        [publicDatabase fetchRecordWithID:[[CKRecordID alloc] initWithRecordName:@"115"] completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            if (error) {
                
                NSLog(@"failed : %@",error);
                
                return;
            }
            NSLog(@"%@",record);
            [record setObject:asset forKey:FIELD_IMAGE];
            
            [publicDatabase saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                
                if (error) {
                    NSLog(@"save failed %@",error);
                    return;
                }
                NSLog(@"save success");
                
            }];
            
        }];
        
    }
}


@end
