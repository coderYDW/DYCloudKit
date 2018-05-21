//
//  DYLocationViewController.m
//  ClouldKitDemo
//
//  Created by Apple on 2018/4/9.
//  Copyright © 2018年 Dongwu Yang. All rights reserved.
//

#import "DYLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface DYLocationViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *recordName;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) CLLocation *location;

@end

@implementation DYLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self locatemap];
}

- (void)locatemap{
    
    if ([CLLocationManager locationServicesEnabled] &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {

        self.locationManager.delegate = self;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 5.0;
        [self.locationManager startUpdatingLocation];

    }
    else {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
//    NSLog(@"newLocation : %@  oldLocation : %@",newLocation,oldLocation);
    
    self.location = newLocation;
    
}

//重写了此方法就不会走上面的方法了
//- (void)locationManager:(CLLocationManager *)manager
//     didUpdateLocations:(NSArray<CLLocation *> *)locations {
//    NSLog(@"locations : %@",locations);
//}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
}

- (IBAction)locationAction:(id)sender {
    [self saveLocation];
}

- (IBAction)showLocation:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    [self fetchRecordWithRecordName:self.recordName.text success:^(CKRecord * _Nullable record) {
        
        CLLocation *location = [record objectForKey:FIELD_LOCATION];
        
        [weakSelf mapAddAnnotationWithLocation:location];
        
    } failed:^(NSError * _Nullable error) {
        
    }];
    
}

- (void)mapAddAnnotationWithLocation:(CLLocation *)location {
    
    MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
    pointAnnotation.coordinate = location.coordinate;
    pointAnnotation.title = self.recordName.text;
    
    [self.map addAnnotation:pointAnnotation];
    [self.map showAnnotations:@[pointAnnotation] animated:YES];
}

- (void)saveLocation {
    
    [self fetchRecordWithRecordName:self.recordName.text success:^(CKRecord * _Nullable record) {
        //125.683832,42.530341 梅河口市
        //114.085947,22.547    深圳市
        
        if (self.location) {
            [record setObject:self.location forKey:FIELD_LOCATION];
            NSLog(@"%@",self.location);
        }
        
        [PUBLIC_DATABASE saveRecord:record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
            if (error) {
                NSLog(@"error : %@",error);
                return;
            }
            NSLog(@"save success");
            
        }];
        
    } failed:^(NSError * _Nullable error) {
        
        NSLog(@"%@",error);
        
    }];
}

- (void)fetchRecordWithRecordName:(NSString *)recordName
                          success:(void(^)(CKRecord * _Nullable record))success
                           failed:(void(^)(NSError * _Nullable error))failed {
    
    if (recordName.length <= 0) {
        NSLog(@"recordName不能为空");
        return;
    }
    
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:recordName];
    [publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                if (failed) {
                    failed(error);
                }
                return;
            }
            
            if (success) {
                success(record);
            }
            
        });
        
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
