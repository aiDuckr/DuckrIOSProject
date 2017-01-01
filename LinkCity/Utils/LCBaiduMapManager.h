//
//  LCBaiduMapManager.h
//  LinkCity
//
//  Created by roy on 11/21/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMapKit.h"
#import "LCDataManager.h"

@interface LCBaiduMapManager : NSObject
@property (nonatomic, strong) BMKMapManager *mapManager;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, strong) BMKAddressComponent *currentAddress;

+ (instancetype)sharedInstance;
- (BOOL)startBaiduMap;
- (BOOL)isLocationEnabled;


//开始更新定位信息
//定位成功后，自动获取坐标描述 （省、市、区、街）,赋值给currentCoordinate 和 currentAddress
//然后自动stopUpdateUserLocation
//建议在每次app唤醒时调用一次
- (void)startUpdateUserLocation;
- (void)stopUpdateUserLocation;


//- (void)getNameFromCoordinateLat:(double)latitude Lon:(double)longitude;

//转换 google地图、soso地图、aliyun地图、mapabc地图和amap地图所用坐标至百度坐标
- (CLLocationCoordinate2D)getBaiduCoordinateFromAppleCoordinate:(double)latitude Lon:(double)longitude;
- (CLLocationCoordinate2D)getAppleCoordinateFromBaiduCoordinate:(double)latitude Lon:(double)longitude;
@end


