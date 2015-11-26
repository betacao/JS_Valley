//
//  CCLocationManager.m
//  MMLocationManager
//
//  Created by WangZeKeJi on 14-12-10.
//  Copyright (c) 2014年 Chen Yaoqiang. All rights reserved.
//

#import "CCLocationManager.h"
@interface CCLocationManager ()

@property (nonatomic, strong) CLLocationManager *CLManager;
@property (nonatomic, copy) LocationBlock locationBlock;
//@property (nonatomic, copy) NSStringBlock cityBlock;
@property (nonatomic, copy) NSStringBlock addressBlock;
@property (nonatomic, copy) LocationErrorBlock errorBlock;
@property (nonatomic, copy) FYFinishBlock finishBlock;

@end

@implementation CCLocationManager


+ (CCLocationManager *)shareLocation{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
        
        float longitude = [standard floatForKey:CCLastLongitude];
        float latitude = [standard floatForKey:CCLastLatitude];
        self.longitude = longitude;
        self.latitude = latitude;
        self.lastCoordinate = CLLocationCoordinate2DMake(longitude,latitude);
        self.lastCityName = [standard objectForKey:CCLastCityName] ? [standard objectForKey:CCLastCityName] : @"";
        self.lastPrivinceName = [standard objectForKey:CCLastProvinceName] ? [standard objectForKey:CCLastProvinceName] : @"";
        self.lastAddress=[standard objectForKey:CCLastAddress];
    }
    return self;
}
//获取经纬度
- (void) getLocationCoordinate:(LocationBlock) locaiontBlock
{
    self.locationBlock = locaiontBlock;
    [self startLocation];
}

- (void) getLocationCoordinate:(LocationBlock) locaiontBlock  withAddress:(NSStringBlock) addressBlock
{
    self.locationBlock = locaiontBlock;
    self.addressBlock = addressBlock;
    [self startLocation];
}

- (void) getAddress:(NSStringBlock)addressBlock
{
    self.addressBlock = addressBlock;
    [self startLocation];
}
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
//获取省市
- (void) getCity:(FYFinishBlock)finishBlock
{
    self.finishBlock = finishBlock;
    [self startLocation];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    [SHGGloble sharedGloble].provinceName = @"";
    [SHGGloble sharedGloble].cityName = @"";
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    CLLocation *newLocation = [locations firstObject];
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error){
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks firstObject];
            self.lastCityName = [NSString stringWithFormat:@"%@",placemark.locality];
            self.lastPrivinceName = [NSString stringWithFormat:@"%@",placemark.administrativeArea];
            if([self.lastCityName rangeOfString:@"市"].location != NSNotFound){
                self.lastCityName = [self.lastCityName substringToIndex:[self.lastCityName rangeOfString:@"市"].location];
            }else{
                self.lastCityName = @"";
            }
            if([self.lastPrivinceName rangeOfString:@"省"].location != NSNotFound){
                self.lastPrivinceName = [self.lastPrivinceName substringToIndex:[self.lastPrivinceName rangeOfString:@"省"].location];
            }else{
                self.lastPrivinceName = @"";
            }
            [standard setObject:self.lastCityName forKey:CCLastCityName];//省市地址
            [standard setObject:self.lastPrivinceName forKey:CCLastProvinceName];
            [standard synchronize];
            NSLog(@"______%@",self.lastCityName);
            [SHGGloble sharedGloble].provinceName = self.lastPrivinceName;
            [SHGGloble sharedGloble].cityName = self.lastCityName;
            self.lastAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@",placemark.country,placemark.administrativeArea,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare];//详细地址
            NSLog(@"______%@",self.lastAddress);
            
        } else{
            [SHGGloble sharedGloble].provinceName = self.lastPrivinceName;
            [SHGGloble sharedGloble].cityName = self.lastCityName;
        }
        if (self.finishBlock) {
            self.finishBlock();
        }
        if (self.addressBlock) {
            self.addressBlock(self.lastAddress);
        }
    }];
    
    self.lastCoordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude ,newLocation.coordinate.longitude );
    if (self.locationBlock) {
        self.locationBlock(self.lastCoordinate);
    }
    
    NSLog(@"%f--%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    [standard setObject:@(newLocation.coordinate.latitude) forKey:CCLastLatitude];
    [standard setObject:@(newLocation.coordinate.longitude) forKey:CCLastLongitude];
    [standard synchronize];

    [self stopLocation];
}

-(void)startLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        if (IS_IOS8){
            self.CLManager = [[CLLocationManager alloc] init];
            [self.CLManager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
            self.CLManager.distanceFilter = 100;
            self.CLManager.desiredAccuracy=kCLLocationAccuracyBest;
            self.CLManager.delegate = self;
        } else{
            self.CLManager = [[CLLocationManager alloc] init];
            self.CLManager.distanceFilter = 100;
            self.CLManager.delegate = self;
            self.CLManager.desiredAccuracy=kCLLocationAccuracyBest;
        }
        [self.CLManager startUpdatingLocation];
    }
    else{
        UIAlertView *alvertView=[[UIAlertView alloc]initWithTitle:@"提示" message:@"需要开启定位服务,请到设置->隐私,打开定位服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alvertView show];
    }
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [manager stopUpdatingLocation];
    //加个空格的目的是为了与""区分
    [SHGGloble sharedGloble].provinceName = self.lastPrivinceName;
    [SHGGloble sharedGloble].cityName = self.lastCityName;
    if(self.finishBlock){
        self.finishBlock();
    }
    [self stopLocation];

}
-(void)stopLocation
{
    [self.CLManager stopUpdatingLocation];
    self.CLManager = nil;
}


@end
