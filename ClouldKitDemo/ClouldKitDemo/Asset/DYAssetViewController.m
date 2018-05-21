//
//  DYAssetViewController.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/4/9.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import "DYAssetViewController.h"

@interface DYAssetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *imagename;

@end

@implementation DYAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)saveImage:(id)sender {
    [self assetImage];
}

- (void)assetImage {
    
    if (self.imagename.text.length <= 0 ||
        self.name.text.length <= 0) {
        NSLog(@"请填写信息完整");
        return;
    }
    
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:self.imagename.text ofType:nil];
    
    NSURL *imageUrl = [NSURL fileURLWithPath:path];
    
    if (imageUrl) {
        CKAsset *asset = [[CKAsset alloc] initWithFileURL:imageUrl];
        
        [publicDatabase fetchRecordWithID:[[CKRecordID alloc] initWithRecordName:self.name.text] completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            if (error) {
                
                NSLog(@"failed : %@",error);
                
                return;
            }
            NSLog(@"%@",record);
            [record setObject:asset forKey:FIELD_IMAGE];
            
            [publicDatabase saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                
                if (error) {
                    NSLog(@"save failed %@",error);
                    return;
                }
                NSLog(@"save success");
                
            }];
            
        }];
        
    }
}


@end
