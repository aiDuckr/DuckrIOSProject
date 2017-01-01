//
//  LCTextView.m
//  LinkCity
//
//  Created by 张宗硕 on 11/3/14.
//  Copyright (c) 2014 linkcity. All rights reserved.
//

#import "LCTextView.h"

@interface UITextView ()

- (id)styleString;

@end

@implementation LCTextView
@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    placeHolderLabel = nil;
    placeholderColor = nil;
    placeholder = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.placeHolderLabel.font = [UIFont fontWithName:APP_CHINESE_FONT size:14.0f];
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setup {
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame {
    if( (self = [super initWithFrame:frame]) ) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification {
    if([[self placeholder] length] == 0) {
        return;
    }

    if([[self text] length] == 0) {
        [[self viewWithTag:999] setAlpha:1];
    } else {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect {
    if( [[self placeholder] length] > 0 ) {
        if ( placeHolderLabel == nil ) {
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
            placeHolderLabel.lineBreakMode = UILineBreakModeWordWrap;
            placeHolderLabel.numberOfLines = 0;
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            [self addSubview:placeHolderLabel];
        }
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 ) {
        [[self viewWithTag:999] setAlpha:1];
    }
    [super drawRect:rect];
    
}

- (id)styleString {
    return [[super styleString] stringByAppendingString:@"; line-height: 5.5em"];
}


@end
