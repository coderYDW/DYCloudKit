//
//  DYSubscriptionsViewController.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/5/22.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import "DYSubscriptionsViewController.h"

@interface DYSubscriptionsViewController ()

@end

@implementation DYSubscriptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)subscriptions {
    
    CKRecordID *artistRecordID = [[CKRecordID alloc] initWithRecordName:@"Mei Chen"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"artist = %@", artistRecordID];
    
    CKSubscription *subscription = [[CKSubscription alloc] initWithRecordType:RECORD_TYPE_ARTWORK predicate:predicate options:CKSubscriptionOptionsFiresOnRecordCreation];
    
    CKNotificationInfo *notificationInfo = [CKNotificationInfo new];
    
    notificationInfo.alertLocalizationKey = @"New artwork by your favorite artist.";
    
    notificationInfo.shouldBadge = YES;
    
    subscription.notificationInfo = notificationInfo;
    
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    
    [publicDatabase saveSubscription:subscription completionHandler:^(CKSubscription *subscription, NSError *error) {
        
        if (error) {
            
            // insert error handling
            
        }
        
    }];
    
}

@end
