//
//  DYRecordDetailViewController.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/4/9.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import "DYRecordDetailViewController.h"

@interface DYRecordDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *artist;

@end

@implementation DYRecordDetailViewController

- (instancetype)initWithRecord:(CKRecord *)record {
    if (self = [super init]) {
        self.record = record;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    CKAsset *asset = [self.record objectForKey:@"image"];
    
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:asset.fileURL]];
    self.image.image = image;
    NSString *title = [self.record objectForKey:@"title"];
    self.title1.text = title;
    self.address.text = [self.record objectForKey:@"address"];
    self.artist.text = [self.record objectForKey:@"artist"];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

@end
