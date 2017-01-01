//
//  LCBaiduMapManager.m
//  LinkCity
//
//  Created by roy on 11/21/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCBaiduMapManager.h"

@interface LCBaiduMapManager()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
@property (nonatomic,strong) BMKLocationService *locService;
@property (nonatomic,strong) BMKGeoCodeSearch *searcher;
@property (nonatomic,strong) CLLocationManager *locationManager;
@end
@implementation LCBaiduMapManager

#pragma mark - Init
+ (instancetype)sharedInstance{
    static LCBaiduMapManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        instance = [[LCBaiduMapManager alloc]init];
    });
    return instance;
}

- (BOOL)startBaiduMap{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mapManager = [[BMKMapManager alloc]init];
    });
    BOOL ret = [_mapManager start:BaiduMapAppID generalDelegate:nil];
    RLog(@"BMap Start %@",ret?@"Succeed!":@"Failed!");
    return ret;
}

- (BOOL)isLocationEnabled{
    BOOL ret = NO;
    
    if (![CLLocationManager locationServicesEnabled] ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        ret = NO;
        LCLogInfo(@"did not open location service");
    }else{
        ret = YES;
        LCLogInfo(@"did open location service");
    }
    
    return ret;
}

#pragma mark - Location Listening
- (void)startUpdateUserLocation{
//*************如果用户拒绝后，会弹出对话框，引导用户跳转到app的设置页面，打开定位
//    self.locationManager = [[CLLocationManager alloc]init];
//    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
//    if (status == kCLAuthorizationStatusDenied) {
//        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
//        NSString *title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
//                                                            message:message
//                                                           delegate:self
//                                                  cancelButtonTitle:@"取消"
//                                                  otherButtonTitles:@"设置", nil];
//        [alertView show];
//    }else{
//        ELog(@"start update user location");
//        static dispatch_once_t onceToken;
//        dispatch_once(&onceToken, ^{
//            _locService = [[BMKLocationService alloc]init];
//            _locService.delegate = self;
//        });
//        [_locService startUserLocationService];
//    }
    
    LCLogInfo(@"start update user location");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    });
    [_locService startUserLocationService];
}

- (void)stopUpdateUserLocation{
    if (_locService) {
        [_locService stopUserLocationService];
    }
}

- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation{
    [LCDataManager sharedInstance].userLocation.lat = userLocation.location.coordinate.latitude;
    [LCDataManager sharedInstance].userLocation.lng = userLocation.location.coordinate.longitude;
    [LCDataManager sharedInstance].userLocation.type = LocationTypeBaidu;
    [LCDataManager sharedInstance].userLocation.updateTime = [NSDate date];
    
    [self stopUpdateUserLocation];
    
    self.currentCoordinate = userLocation.location.coordinate;
    LCLogInfo(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationJustUpdateLocation object:nil];
    [self getNameFromCoordinateLat:self.currentCoordinate.latitude Lon:self.currentCoordinate.longitude];
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationJustFailUpdateLocation object:nil];
}
#pragma mark - Location encode
- (void)getNameFromCoordinateLat:(double)latitude Lon:(double)longitude{
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){latitude,longitude};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    LCLogInfo(@"Geo 检索发送 %@",flag?@"成功":@"失败");
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
//        NSString *province = result.addressDetail.province;
//        NSString *cityName = result.addressDetail.city;
//        NSString *district = result.addressDetail.district;
//        NSString *streetName = result.addressDetail.streetName;
//        NSString *streetNum = result.addressDetail.streetNumber;
//        RLog(@"%@,%@,%@,%@,%@",province,cityName,district,streetName,streetNum);
        
        self.currentAddress = result.addressDetail;
        [LCDataManager sharedInstance].userLocation.cityName = result.addressDetail.city;
        [LCDataManager sharedInstance].userLocation.provinceName = result.addressDetail.province;
        [LCDataManager sharedInstance].userLocation.areaName = result.addressDetail.district;
        LCLogInfo(@"onGetReverseGeoCodeResult: %@",result.addressDetail.city);
    }else{
        RLog(@"reverseGeoCode error %d",error);
    }
}





#pragma mark - Coordinate Transfer
- (CLLocationCoordinate2D)getBaiduCoordinateFromAppleCoordinate:(double)latitude Lon:(double)longitude{
    CLLocationCoordinate2D test = CLLocationCoordinate2DMake(latitude, longitude);
    
    //转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(test,BMK_COORDTYPE_COMMON);
    CLLocationCoordinate2D resCoor = BMKCoorDictionaryDecode(testdic);
    LCLogInfo(@"getBaiduCoordinateFromAppleCoordinate apple:%f,%f   baidu:%f,%f",latitude,longitude,resCoor.latitude,resCoor.longitude);
    return resCoor;
}
- (CLLocationCoordinate2D)getAppleCoordinateFromBaiduCoordinate:(double)latitude Lon:(double)longitude{
    CLLocationCoordinate2D test = CLLocationCoordinate2DMake(latitude, longitude);
    
    //转换GPS坐标至百度坐标
    NSDictionary* testdic = BMKConvertBaiduCoorFrom(test,BMK_COORDTYPE_GPS);
    CLLocationCoordinate2D resCoor = BMKCoorDictionaryDecode(testdic);
    LCLogInfo(@"getAppleCoordinateFromBaiduCoordinate baidu:%f,%f   apple:%f,%f",latitude,longitude,resCoor.latitude,resCoor.longitude);
    return resCoor;
}
#pragma mark - AlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}
@end
