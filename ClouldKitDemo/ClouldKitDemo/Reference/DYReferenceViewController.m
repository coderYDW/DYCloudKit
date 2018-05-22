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

@property (weak, nonatomic) IBOutlet UITextField *recordName;
@property (weak, nonatomic) IBOutlet UITextField *artistName;
@property (weak, nonatomic) IBOutlet UISwitch *s1;

@end

@implementation DYReferenceViewController

- (IBAction)addReference:(id)sender {
    
    [self fetchArtist:self.artistName.text];
}


- (void)fetchArtist:(NSString *)RecordName {
    
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:RecordName];
    
    [self.publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"fetch error %@",error);
            return;
        }
        
        NSLog(@"%@",record);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fetchArtwork:self.recordName.text artistId:record.recordID];
        });
        
        
    }];
    
}

- (void)fetchArtwork:(NSString *)recordName artistId:(CKRecordID *)artistId {
    
    CKReferenceAction action = self.s1.on ? CKReferenceActionDeleteSelf : CKReferenceActionNone;
    CKReference *reference = [[CKReference alloc] initWithRecordID:artistId action:action];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:self.recordName.text];
    [self.publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error) {
            NSLog(@"fetch error %@",error);
            return;
        }
        
        NSLog(@"record : %@",record);
        
        [record setObject:reference forKey:FIELD_ARTIST1];
        
        [self.publicDatabase saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            if (error) {
                NSLog(@"save reference : %@",error);
                return;
            }
            NSLog(@"save reference success");
        }];
        
    }];
}



- (IBAction)save:(id)sender {
    
    CKRecordID *artistRecordID = [[CKRecordID alloc] initWithRecordName:self.recordName.text];
    
    CKRecord *artistRecord = [[CKRecord alloc] initWithRecordType:RECORD_TYPE_ARTIST recordID:artistRecordID];
    
    [artistRecord setObject:@"Xiao" forKey:FIELD_FIRST_NAME];
    [artistRecord setObject:@"Rose" forKey:FIELD_MIDDLE_NAME];
    [artistRecord setObject:@"Hong" forKey:FIELD_LAST_NAME];
    
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
