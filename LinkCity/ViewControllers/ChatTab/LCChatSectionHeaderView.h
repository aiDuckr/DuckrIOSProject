//
//  LCChatRoomMemberSectionView.h
//  LinkCity
//
//  Created by roy on 3/11/15.
//  Copyright (c) 2015 linkcity. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCChatSectionHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

+ (CGFloat)getHeaderViewHeight;
@end
