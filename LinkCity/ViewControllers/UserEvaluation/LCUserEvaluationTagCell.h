//
//  LCPlanSubjectPageSubjectCell.h
//  LinkCity
//
//  Created by roy on 2/9/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCUserEvaluationTagCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (nonatomic, assign) BOOL isSubjectSelected;

- (void)setSubjectSelected:(BOOL)selected;
@end
