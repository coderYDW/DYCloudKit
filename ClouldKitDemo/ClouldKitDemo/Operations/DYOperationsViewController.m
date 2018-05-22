//
//  DYOperationsViewController.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/5/22.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

/*
 
 场景001:
 创建一个引用选择类型CKReferenceActionDeleteSelf关联一个recordArtist001
 这个时候如果删除了recordArtist001就会一起删除掉添加了这个引用的record
 
 场景002:
 创建一个引用reference002选择类型CKReferenceActionNone关联一个recordArtist002
 recordArtwork002添加这个引用到自己的artist字段
 这个时候如果删除了recordArtist002不会一起删除掉recordArtwork002,
 并且recordArtwork002的artist字段还是引用reference002
 当重新创建一个recordArtist002后,reference002还是会指向recordArtist002,
 这时候修改reference002的ActionType为CKReferenceActionDeleteSelf,
 再删除recordArtist002,会连同recordArtwork002一起删除
 
 */



#import "DYOperationsViewController.h"

@interface DYOperationsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *recordName;

@end

@implementation DYOperationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)deleteRecord:(id)sender {
    //
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:@"artist001"];
    [PUBLIC_DATABASE deleteRecordWithID:recordID completionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error : %@",error);
        }
        else {
            NSLog(@"success : %@",recordID);
        }
    }];
    
}

- (IBAction)dd:(id)sender {
    
    [self referenceDelete];
    
}

- (void)optionsFetch {
    CKFetchRecordsOperation *option = [[CKFetchRecordsOperation alloc] initWithRecordIDs:[self recordIds]];
    option.perRecordCompletionBlock = ^(CKRecord * _Nullable record, CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error : %@", error);
        }
        else {
            NSLog(@"perRecordCompletionBlock : %@", record);
        }
    };
    
    option.fetchRecordsCompletionBlock = ^(NSDictionary<CKRecordID *,CKRecord *> * _Nullable recordsByRecordID, NSError * _Nullable operationError) {
        if (operationError) {
            NSLog(@"operationError : %@", operationError);
        }
        else {
            NSLog(@"fetchRecordsCompletionBlock : %@", recordsByRecordID);
        }
    };
    
    option.database = PUBLIC_DATABASE;
    
    [option start];
}


- (NSArray *)recordIds {
    
    NSArray *nameArr = [NSArray arrayWithObjects:@"115", @"116", @"117", nil];// @"118", @"119", @"120",
    NSMutableArray *recordIDs = [NSMutableArray arrayWithCapacity:6];
    for (NSString *name in nameArr) {
        CKRecordID *recordId1 = [[CKRecordID alloc] initWithRecordName:name];
        [recordIDs addObject:recordId1];
    }
    return [recordIDs copy];
}

- (void)referenceDelete {
    if (self.recordName.text.length <= 0) {
        NSLog(@"请填写名字");
        return;
    }
    [self fetchRecordWithRecordName:self.recordName.text success:^(CKRecord * _Nullable record) {
        
        CKReference *reference = [[CKReference alloc] initWithRecordID:[[CKRecordID alloc] initWithRecordName:@"Mei Chen"] action:CKReferenceActionDeleteSelf];
        record[FIELD_ARTIST1] = reference;
        NSLog(@"success");
    } failed:^(NSError * _Nullable error) {
        NSLog(@"failed");
    }];
    
    
}

- (void)fetchRecordWithRecordName:(NSString *)recordName
                          success:(void(^)(CKRecord * _Nullable record))success
                           failed:(void(^)(NSError * _Nullable error))failed {
    
    if (recordName.length <= 0) {
        NSLog(@"recordName不能为空");
        return;
    }
    
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:recordName];
    [publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                if (failed) {
                    failed(error);
                }
                return;
            }
            
            if (success) {
                success(record);
            }
            
        });
        
    }];
    
}

@end
