//
//  BDBCollectionCell.m
//  BDB_Discovery
//
//  Created by Tomoxox on 15/6/13.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import "BDBCollectionCell.h"

@implementation BDBCollectionCell
- (IBAction)hotTopicsButtonClickedAction:(UIButton *)sender {
    NSLog(@"热门话题");
    [_delegate hotTopicsClicked];
}
- (IBAction)rookieButtonClickedAction:(UIButton *)sender {
    NSLog(@"新手上路");
}
- (IBAction)investmentGuideButtonClickedAction:(UIButton *)sender {
    NSLog(@"投资指南");
}

- (IBAction)securityAssuranceButtonClickedAction:(UIButton *)sender {
    NSLog(@"安全保障");
}
- (IBAction)operationModeButtonClickedAction:(UIButton *)sender {
    NSLog(@"运营模式");
}

- (IBAction)debitAndCreditButtonClickedAction:(UIButton *)sender {
    NSLog(@"借贷事宜");
}
- (IBAction)riskControlButtonClickedAction:(UIButton *)sender {
    NSLog(@"风险控制");
}

- (IBAction)infoOfLawButtonClickedAction:(UIButton *)sender {
    NSLog(@"法律相关");
}

- (IBAction)creditorsRightsTransferButtonClickedAction:(UIButton *)sender {
    NSLog(@"债权转让");
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
