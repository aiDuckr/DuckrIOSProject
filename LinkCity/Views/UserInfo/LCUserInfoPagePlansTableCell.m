//
//  LCUserInfoPagePlansTableCell.m
//  LinkCity
//
//  Created by roy on 11/23/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCUserInfoPagePlansTableCell.h"
#import "EGOImageView.h"
#import "LCDateUtil.h"


@interface LCUserInfoPagePlansTableCell()
@property (weak, nonatomic) IBOutlet UIView *leftTopLine;
@property (weak, nonatomic) IBOutlet UIView *leftBottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *footPrintImage;

@property (weak, nonatomic) IBOutlet UIImageView *planCoverImageVIew;
@property (weak, nonatomic) IBOutlet UILabel *planDestinationLabel;
@property (weak, nonatomic) IBOutlet UILabel *planTimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *horizontalLineViewHeightInCell;

//@property (weak, nonatomic) IBOutlet UITextView *planDescriptionTextView;

@property (weak, nonatomic) IBOutlet UILabel *planDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIImageView *planBorderImageView;
@property (weak, nonatomic) IBOutlet EGOImageView *createrAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *planSlogonLabel;



@end
@implementation LCUserInfoPagePlansTableCell

- (void)awakeFromNib {
    // Initialization code
    
    UIImage *img = self.planBorderImageView.image;
    img = [img resizableImageWithCapInsets:UIEdgeInsetsMake(30, 30, 30, 30) resizingMode:UIImageResizingModeStretch];
    self.planBorderImageView.image = img;
    
    //set corner radius to image view
    self.planCoverImageVIew.layer.masksToBounds = YES;
    self.planCoverImageVIew.layer.cornerRadius = 4;
    
    //set height of seperate line
    self.horizontalLineViewHeightInCell.constant = 0.5;
    
    // add shadow to label
    self.planDestinationLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.planDestinationLabel.layer.shadowOpacity = 0.5;
    self.planDestinationLabel.layer.shadowOffset = CGSizeMake(1, 1);
    self.planDestinationLabel.layer.shadowRadius = 1;
    self.planDescriptionLabel.layer.shouldRasterize = YES;
    
    self.planTimeLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.planTimeLabel.layer.shadowOpacity = 0.5;
    self.planTimeLabel.layer.shadowOffset = CGSizeMake(1, 1);
    self.planTimeLabel.layer.shadowRadius = 1;
    self.planTimeLabel.layer.shouldRasterize = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)showPlan:(LCPlan *)plan asFirstCell:(BOOL)isFirstCell asLastCell:(BOOL)isLastCell{
    self.plan = plan;
    
    self.leftBottomLine.hidden = NO;
    self.leftTopLine.hidden = NO;
    if (isFirstCell) {
        self.leftTopLine.hidden = YES;
    }
    if (isLastCell) {
        self.leftBottomLine.hidden = YES;
    }
    
    [self updateFootPrintImageView:self.plan.isCheckedIn];
    self.planCoverImageVIew.backgroundColor = [LCImageUtil getColorFromColorStr:self.plan.coverColor];
    [self.planCoverImageVIew setImageWithURL:[NSURL URLWithString:self.plan.imageCoverThumb]];
    self.planDestinationLabel.text = self.plan.destinationName;
    self.planTimeLabel.text = [NSString stringWithFormat:@"%@", [LCDateUtil getDotDateFromHorizontalLineStr:self.plan.startTime]];
    //[self.planDescriptionTextView setText:self.plan.descriptionStr withLineSpace:4 withFont:[UIFont fontWithName:FONT_LANTINGBLACK size:13] color:UIColorFromR_G_B_A(155, 152, 148, 1)];
    [self.planDescriptionLabel setText:self.plan.descriptionStr withLineSpace:6];
    self.planSlogonLabel.text = self.plan.declaration;
    if (self.plan && self.plan.memberList && self.plan.memberList.count>0) {
        LCUserInfo *user = [self.plan.memberList objectAtIndex:0];
        self.createrAvatarImageView.imageURL = [NSURL URLWithString:user.avatarThumbUrl];
    }
}

- (void)updateFootPrintImageView:(BOOL)hasSigned{
    if (!hasSigned) {
        self.footPrintImage.image = [UIImage imageNamed:@"UserFootprintOff"];
    }else{
        self.footPrintImage.image = [UIImage imageNamed:@"UserFootprintOn"];
    }
}
@end
