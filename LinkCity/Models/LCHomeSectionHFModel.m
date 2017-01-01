//
//  LCHomeSectionHFModel.m
//  LinkCity
//
//  Created by Roy on 8/21/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import "LCHomeSectionHFModel.h"

@implementation LCHomeSectionHFModel
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super initWithDictionary:dic];
    if (self)
    {
        self.title = [LCStringUtil getNotNullStr:[dic objectForKey:@"Title"]];
        
        self.recmdNum = [[dic objectForKey:@"RecmdNum"] integerValue];
        self.isShowMore = [[dic objectForKey:@"IsShowMore"] integerValue];
        
        self.tableTitle = [LCStringUtil getNotNullStr:[dic objectForKey:@"TableTitle"]];
        
        NSMutableArray *tableTabs = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSString *tableTab in [dic arrayForKey:@"TableTabs"]){
            if (tableTab) {
                [tableTabs addObject:tableTab];
            }
        }
        self.tableTabs = tableTabs;
        
        NSMutableArray *tableTabIds = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSNumber *tableTabId in [dic arrayForKey:@"TableTabIds"]){
            if (tableTabId) {
                [tableTabIds addObject:tableTabId];
            }
        }
        self.tableTabIds = tableTabIds;
        
        self.tableTabIndex = [[dic objectForKey:@"TableTabIndex"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder: (NSCoder *)coder
{
    [coder encodeObject:self.title forKey:@"Title"];
    
    [coder encodeInteger:self.recmdNum forKey:@"RecmdNum"];
    [coder encodeInteger:self.isShowMore forKey:@"IsShowMore"];
    
    [coder encodeObject:self.tableTitle forKey:@"TableTitle"];
    [coder encodeObject:self.tableTabs forKey:@"TableTabs"];
    [coder encodeObject:self.tableTabIds forKey:@"TableTabIds"];
    
    [coder encodeInteger:self.tableTabIndex forKey:@"TableTabIndex"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self)
    {
        self.title = [coder decodeObjectForKey:@"Title"];
        
        self.recmdNum = [coder decodeIntegerForKey:@"RecmdNum"];
        self.isShowMore = [coder decodeIntegerForKey:@"IsShowMore"];
        
        self.tableTitle = [coder decodeObjectForKey:@"TableTitle"];
        self.tableTabs = [coder decodeObjectForKey:@"TableTabs"];
        self.tableTabIds = [coder decodeObjectForKey:@"TableTabIds"];
        
        self.tableTabIndex = [coder decodeIntegerForKey:@"TableTabIndex"];
    }
    return self;
}
@end

