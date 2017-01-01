//
//  LCOnePicView.m
//  LinkCity
//
//  Created by 张宗硕 on 4/2/16.
//  Copyright © 2016 linkcity. All rights reserved.
//

#import "LCOnePicView.h"

@implementation LCOnePicView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)updateTourpicView:(LCTourpic *)tourpic withType:(LCTourpicCellViewType)type {
    [super updateTourpicView:tourpic withType:type];
    
    if (LCTourpicCellViewType_Cell == type) {
        self.imageWidthConstraint.constant = (DEVICE_WIDTH - 3.0f) / 2.0f;
    } else if (LCTourpicCellViewType_Detail == type) {
        self.imageWidthConstraint.constant = DEVICE_WIDTH;
    }
    self.imageHeightConstraint.constant = self.imageWidthConstraint.constant;
    
    if (tourpic.thumbPhotoUrls.count >= 1) {
        NSURL *thumbPhotoURL = [NSURL URLWithString:[tourpic.thumbPhotoUrls objectAtIndex:0]];
        
        if (LCTourpicCellViewType_Cell == type) {
            [self.imageView setImageWithURL:thumbPhotoURL placeholderImage:[UIImage imageNamed:LCDefaultTourpicImageName]];
        } else if (LCTourpicCellViewType_Detail == type) {
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:thumbPhotoURL];
            [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
            
            [self.imageView setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:LCDefaultImageName] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                self.imageHeightConstraint.constant = image.size.height * self.imageWidthConstraint.constant / image.size.width;
                self.imageView.image = image;
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                
            }];
        }
    }
    
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    [mutArr addObject:self.imageView];
    
    [self addImageViewToArray:mutArr];
}

@end
