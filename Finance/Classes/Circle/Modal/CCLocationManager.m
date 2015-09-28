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
@property (nonatomic, copy) NSStringBlock cityBlock;
@property (nonatomic, copy) NSStringBlock addressBlock;
@property (nonatomic, copy) LocationErrorBlock errorBlock;

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
        self.lastCity = [standard objectForKey:CCLastCity];
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
- (void) getCity:(NSStringBlock)cityBlock
{
    self.cityBlock = cityBlock;
    [self startLocation];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [SHGGloble sharedGloble].provinceName = @"";
    [SHGGloble sharedGloble].cityName = @"";
    NSUserDefaults *standard = [NSUserDefaults standardUserDefaults];
    CLLocation *newLocation = [locations firstObject];
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks,NSError *error){
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.lastCity = [NSString stringWithFormat:@"%@%@",placemark.administrativeArea,placemark.locality];
            [standard setObject:self.lastCity forKey:CCLastCity];//省市地址
            NSLog(@"______%@",self.lastCity);

            if([self.lastCity rangeOfString:@"市"].location != NSNotFound && [self.lastCity rangeOfString:@"省"].location != NSNotFound){
                NSArray *array = [self.lastCity componentsSeparatedByString:@"省"];
                NSString *provinceName = [array[0] stringByAppendingString:@"\r"];
                NSString *cityName = array[1];

                NSArray *cityArray = [cityName componentsSeparatedByString:@"市"];
                cityName = cityArray[0];
                if(provinceName && provinceName.length != 0){
                    [SHGGloble sharedGloble].provinceName = provinceName;
                }
                if(cityName && cityName.length != 0){
                    [SHGGloble sharedGloble].cityName = cityName;
                }
            }
            self.lastAddress = [NSString stringWithFormat:@"%@%@%@%@%@%@",placemark.country,placemark.administrativeArea,placemark.locality,placemark.subLocality,placemark.thoroughfare,placemark.subThoroughfare];//详细地址
            NSLog(@"______%@",self.lastAddress);
            
        }
        if (self.cityBlock) {
            self.cityBlock(self.lastCity);
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
    
    [manager stopUpdatingLocation];
}

-(void)startLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        if (IS_IOS8){
            self.CLManager = [[CLLocationManager alloc] init];
//            [_manager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
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
    [SHGGloble sharedGloble].cityName = @"";
    [self stopLocation];

}
-(void)stopLocation
{
    self.CLManager = nil;
}


@end
