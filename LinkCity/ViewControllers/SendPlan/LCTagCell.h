//
//  LCTagCell.h
//  LinkCity
//
//  Created by Roy on 12/17/15.
//  Copyright © 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCTagCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

- (void)updateShowWithText:(NSString *)text selected:(BOOL)selected;
@end
