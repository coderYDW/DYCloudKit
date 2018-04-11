//
//  DYReferenceViewController.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/4/11.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import "DYReferenceViewController.h"

@interface DYReferenceViewController ()

@property (nonatomic, strong) CKDatabase *publicDatabase;

@end

@implementation DYReferenceViewController

- (IBAction)addReference:(id)sender {
    
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:@"Mei Chen"];
    
    [self.publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"fetch error %@",error);
            return;
        }
        
        NSLog(@"%@",record);
            
        CKReference *reference = [[CKReference alloc] initWithRecordID:record.recordID action:CKReferenceActionNone];
        
        CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:@"115"];
        [self.publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            if (error) {
                NSLog(@"fetch error %@",error);
                return;
            }
            
            NSLog(@"record : %@",record);
            
            [record setObject:reference forKey:@"artist1"];
            
            [self.publicDatabase saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"save reference : %@",error);
                    return;
                }
                NSLog(@"save reference success");
            }];
            
        }];
        
    }];
    
    
}

- (IBAction)save:(id)sender {
    
    CKRecordID *artistRecordID = [[CKRecordID alloc] initWithRecordName:@"Mei Chen"];
    
    CKRecord *artistRecord = [[CKRecord alloc] initWithRecordType:@"Artist" recordID:artistRecordID];
    
    [artistRecord setObject:@"Mei" forKey:@"firstName"];
    [artistRecord setObject:@"Chen" forKey:@"lastName"];
    
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    
    [publicDatabase saveRecord:artistRecord completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        
        if (error) {
            return ;
        }
        
        NSLog(@"save success");
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
}

- (CKDatabase *)publicDatabase {
    if (_publicDatabase == nil) {
        _publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    }
    return _publicDatabase;
}


@end
