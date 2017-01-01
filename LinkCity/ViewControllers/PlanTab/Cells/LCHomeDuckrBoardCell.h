//
//  LCHomeDuckrBoardCell.h
//  LinkCity
//
//  Created by 张宗硕 on 5/18/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCHomeDuckrBoardCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *userArr;

- (void)updateShowCell:(NSArray *)userArr;
@end
