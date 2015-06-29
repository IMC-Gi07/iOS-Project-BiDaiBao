//
//  BDBQuestionContentCell.m
//  BiDaiBao(比贷宝)
//
//  Created by Tomoxox on 15/6/29.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "BDBQuestionContentCell.h"

@implementation BDBQuestionContentCell
- (void)layoutSubviews {
    UIView *grayBar = [[UIView alloc] initWithFrame:CGRectMake(24, 0, 2, self.bounds.size.height)];
    grayBar.backgroundColor = [UIColor lightGrayColor];
    [self.leadingView addSubview:grayBar];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
