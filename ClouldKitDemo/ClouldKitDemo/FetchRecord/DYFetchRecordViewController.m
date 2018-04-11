//
//  DYFetchRecordViewController.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/4/4.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import "DYFetchRecordViewController.h"
#import "DYRecordDetailViewController.h"

@interface DYFetchRecordViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <CKRecord *>*records;

@end

@implementation DYFetchRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)fetchAction:(id)sender {
    
    
    [self fetchRecordWithReference];
}


- (void)fetchRecordWithReference {
    
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:@"115"];
    [publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        NSLog(@"%@",record);
        
        [self.records addObjectsFromArray:@[record]];
        
        CKReference *reference = [record objectForKey:@"artist1"];
        
        [publicDatabase fetchRecordWithID:reference.recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",error);
                return;
            }
            NSLog(@"%@",record);
            
            [self.records addObjectsFromArray:@[record]];
            
            [self.tableView reloadData];
        }];
        
    }];
    
}

- (void)fetchRecordWithLocation {
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    //根据位置查询记录
    CLLocation *fixedLocation = [[CLLocation alloc] initWithLatitude:22.547 longitude:114.085947];
    CGFloat radius = 100000; // meters
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"distanceToLocation:fromLocation:(location, %@) < %f",fixedLocation,radius];
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Artwork" predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        
        NSLog(@"perform query success : %@", results);
        
        [self.records addObjectsFromArray:results];
        
        [self.tableView reloadData];
        
    }];
}

- (void)fetchRecordWithPredicate {
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    
    //根据条件查询
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"artist = %@", @"Mei Chen"];
    
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Artwork" predicate:predicate];
    
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray<CKRecord *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            return;
        }
        
        NSLog(@"perform query success : %@", results);
        
        [self.records addObjectsFromArray:results];
        
        [self.tableView reloadData];
        
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
    
    CKRecord *artwork = self.records[indexPath.row];
    
    if ([artwork.recordType isEqualToString:@"ArtWork"]) {
        cell.textLabel.text = [artwork objectForKey:@"title"];
        cell.detailTextLabel.text = [artwork objectForKey:@"address"];
    }
    else {
        cell.textLabel.text = [artwork objectForKey:@"firstName"];
        cell.detailTextLabel.text = [artwork objectForKey:@"lastName"];
    }
    
    return cell;
}

#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CKRecord *record = self.records[indexPath.row];
    
    UIStoryboard *rsb = [UIStoryboard storyboardWithName:@"RecordDetail" bundle:[NSBundle mainBundle]];
    
    DYRecordDetailViewController *recordDetail = (DYRecordDetailViewController *)rsb.instantiateInitialViewController;
    recordDetail.record = record;
    [self.navigationController pushViewController:recordDetail animated:YES];
    recordDetail.navigationItem.title = @"RecordDetail";
    
}

- (NSMutableArray *)records {
    if (_records == nil) {
        _records = [[NSMutableArray alloc] init];
    }
    return _records;
}


@end
