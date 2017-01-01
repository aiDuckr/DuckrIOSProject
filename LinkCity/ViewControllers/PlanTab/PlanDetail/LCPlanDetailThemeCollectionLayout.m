//
//  LCPlanDetailThemeCollectionLayout.m
//  LinkCity
//
//  Created by roy on 2/26/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import "LCPlanDetailThemeCollectionLayout.h"

@implementation LCPlanDetailThemeCollectionLayout
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    //Cell 居中
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    
    NSMutableDictionary *rowCollections = [NSMutableDictionary new];
    
    // Collect attributes by their midY coordinate.. i.e. rows!
    for (UICollectionViewLayoutAttributes *itemAttributes in superAttributes)
    {
        NSNumber *yCenter = @(CGRectGetMidY(itemAttributes.frame));
        
        if (!rowCollections[yCenter])
            rowCollections[yCenter] = [NSMutableArray new];
        
        [rowCollections[yCenter] addObject:itemAttributes];
    }
    
    // Adjust the items in each row
    [rowCollections enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSArray *itemAttributesCollection = obj;
        
        CGRect previousFrame = CGRectZero;
        for (UICollectionViewLayoutAttributes *itemAttributes in itemAttributesCollection){
            CGRect itemFrame = itemAttributes.frame;
            
            if (CGRectEqualToRect(previousFrame, CGRectZero))
                itemFrame.origin.x = 0;
            else
                itemFrame.origin.x = CGRectGetMaxX(previousFrame);
            
            itemAttributes.frame = itemFrame;
            previousFrame = itemFrame;
        }
    }];
    
    return superAttributes;
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound {
    
    return YES;
    
}
@end
