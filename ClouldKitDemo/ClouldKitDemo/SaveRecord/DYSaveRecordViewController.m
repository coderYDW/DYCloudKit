//
//  DYSaveRecordViewController.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/4/4.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import "DYSaveRecordViewController.h"

@interface DYSaveRecordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UITextField *title1;
@property (weak, nonatomic) IBOutlet UITextField *artist;

@end

@implementation DYSaveRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)saveButton:(id)sender {
    
    if (self.address.text.length <= 0 || self.title1.text.length <= 0 || self.artist.text.length <= 0) {
        NSLog(@"请填写信息完整");
        return;
    }
    
    // Insert your just-in-time schema code here
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    f.dateFormat = @"yyyyMMddhhmmss";
    NSString *dateString = [f stringFromDate:nowDate];
    NSLog(@"%@",dateString);
    
    CKRecordID *artworkRecordID = [[CKRecordID alloc] initWithRecordName:@"20180408144418"];
    
    CKRecord *artworkRecord = [[CKRecord alloc] initWithRecordType:RECORD_TYPE_ARTWORK recordID:artworkRecordID];
    
    artworkRecord[@"title" ] = self.title1.text;
    
    artworkRecord[@"artist"] = self.artist.text;
    
    artworkRecord[@"address"] = self.address.text;
    
    artworkRecord[@"date"] = [NSDate date];
    
    CKContainer *myContainer = [CKContainer defaultContainer];
    
    //    CKDatabase *privateDatabase = [myContainer privateCloudDatabase];
    CKDatabase *publicDatabase = [myContainer publicCloudDatabase];
    
    [publicDatabase saveRecord:artworkRecord completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"failed,%@,code:%ld,domain:%@,userinfo:%@",error,error.code,error.domain,error.userInfo);
            if (error.code == 9) {
                NSLog(@"未授权");
            }
            else if (error.code == 14) {
                NSLog(@"保存失败");
            }
            
            return;
        }
        
        NSLog(@"success");
        
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
