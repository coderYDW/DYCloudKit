//
//  ViewController.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/3/29.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import "ViewController.h"
#import <CloudKit/CloudKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        
        if (accountStatus == CKAccountStatusNoAccount) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign in to iCloud"
                                        
                                                                           message:@"Sign in to your iCloud account to write records. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID."
                                        
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                              
                                                      style:UIAlertActionStyleCancel
                              
                                                    handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        else {
            
            // Insert your just-in-time schema code here
            CKRecordID *artworkRecordID = [[CKRecordID alloc] initWithRecordName:@"115"];
            
            CKRecord *artworkRecord = [[CKRecord alloc] initWithRecordType:@"ArtWork" recordID:artworkRecordID];
            
            artworkRecord[@"title" ] = @"MacKerricher State Park";
            
            artworkRecord[@"artist"] = @"Mei Chen";
            
            artworkRecord[@"address"] = @"Fort Bragg, CA";
            
            CKContainer *myContainer = [CKContainer defaultContainer];
            
            //    CKDatabase *privateDatabase = [myContainer privateCloudDatabase];
            CKDatabase *publicDatabase = [myContainer publicCloudDatabase];
            
            [publicDatabase saveRecord:artworkRecord completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                
                if (error) {
                    NSLog(@"failed,%@",error);
                    return;
                }
                
                NSLog(@"success");
                
            }];
            
        }
        
    }];
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
