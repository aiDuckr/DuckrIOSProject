//
//  LCSearchDestinationVC.h
//  LinkCity
//
//  Created by 张宗硕 on 11/7/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSearchDestinationCell.h"
#import "YSSearchBar.h"
#import "LCDataManager.h"
#import "LCDestinationCollectionCell.h"
#import "LCPlaceInfo.h"
#import "LCNewPartnerPlanVC.h"
#import "LCNewReceptionPlanVC.h"
#import "LCStoryboardManager.h"
#import "LCBaseVC.h"

@class LCSearchDestinationVC;

@protocol LCSearchDestinationDelegate <NSObject>
@optional
- (void)searchDestinationFinished:(LCSearchDestinationVC *)destinationVC;

@end

typedef enum {SEARCH_DESTINATION_PARTNER, SEARCH_DESTINATION_RECEPTION, SEARCH_DESTINATION_ADD_PLACE, SEARCH_DESTINATION_FILTER, SEARCH_DESTINATION_HOMEPAGE} SearchDestinationType;

@interface LCSearchDestinationVC : LCBaseVC<UITableViewDataSource, UITableViewDelegate, UISearchDisplayDelegate, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate> {
    YSSearchBar *mySearchBar;
    NSArray *destinationList;
    NSArray *hotDestinationList;
}

+ (instancetype)createInstance;
@property (nonatomic, assign) SearchDestinationType searchType;
@property (nonatomic, assign) LCPlaceInfo *placeInfo;
@property (nonatomic, retain) id<LCSearchDestinationDelegate> delegate;
@end
