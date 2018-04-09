//
//  ViewController.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/3/29.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)fetch:(id)sender {
    
}

- (IBAction)save:(id)sender {
            
    
    
}

- (IBAction)check:(id)sender {
    
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        
        if (accountStatus == CKAccountStatusNoAccount) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请登录iCloud账号"
                                        
                                                                           message:@"请登录您的iCloud账户,来帮助您存储数据. 在首页,打开设置,点击iCloud,并且输入您的Apple ID. 打开iCloud云盘开关. 如果您没有iCloud账户请先创建"
                                        
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"好的"
                              
                                                      style:UIAlertActionStyleCancel
                              
                                                    handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"检查成功"
                                        
                                                                           message:@"您已经登录iCloud账户并打开iCloud云盘"
                                        
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alert addAction:[UIAlertAction actionWithTitle:@"好的"
                              
                                                      style:UIAlertActionStyleCancel
                              
                                                    handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }];
    
    
}



@end
