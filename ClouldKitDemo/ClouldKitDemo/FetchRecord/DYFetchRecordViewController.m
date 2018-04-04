//
//  DYFetchRecordViewController.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/4/4.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import "DYFetchRecordViewController.h"

@interface DYFetchRecordViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *records;

@end

@implementation DYFetchRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"record"];
}

- (IBAction)fetchAction:(id)sender {
    
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    CKRecordID *dd = [[CKRecordID alloc] initWithRecordName:@"115"];
    [publicDatabase fetchRecordWithID:dd completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error) {
            
            return;
        }
    }];
//    [[[CKContainer defaultContainer] publicCloudDatabase] fetchAllRecordZonesWithCompletionHandler:^(NSArray<CKRecordZone *> * _Nullable zones, NSError * _Nullable error) {
//        if (error) {
//
//            return;
//        }
//    }];
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"record"];
    
    // 设置 Cell...
    
    return cell;
}

#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
