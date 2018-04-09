//
//  DYFetchRecordViewController.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/4/4.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import "DYFetchRecordViewController.h"
#import "Artwork.h"

@interface DYFetchRecordViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *records;

@end

@implementation DYFetchRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"record"];
}

- (IBAction)fetchAction:(id)sender {
    
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", @""];

    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Artwork" predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        
        NSLog(@"perform query success : %@", results);
        
    }];
    
}


- (void)fetchAndEditRecord {
    //查询并编辑数据
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    CKRecordID *dd = [[CKRecordID alloc] initWithRecordName:@"115"];
    [publicDatabase fetchRecordWithID:dd completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error) {
            
            return;
        }
        
        NSLog(@"%@",record);
        
        NSDate *date = record[@"date"];
        
        record[@"artist"] = @"Mei Chen";
        
        record[@"date"] = [date dateByAddingTimeInterval:30.0 * 60.0];
        
        [publicDatabase saveRecord:record completionHandler:^(CKRecord *savedRecord, NSError *saveError) {
            
            // Error handling for failed save to public database
            if (saveError) {
                NSLog(@"saveError:%@",saveError);
                return;
            }
            
            NSLog(@"save success");
            
        }];
        
    }];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"record"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"record"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    Artwork *artwork = self.records[indexPath.row];
    
    cell.textLabel.text = artwork.title;
    
    cell.detailTextLabel.text = artwork.address;
    
    return cell;
}

#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (NSMutableArray *)records {
    if (_records == nil) {
        _records = [[NSMutableArray alloc] init];
    }
    return _records;
}


@end
