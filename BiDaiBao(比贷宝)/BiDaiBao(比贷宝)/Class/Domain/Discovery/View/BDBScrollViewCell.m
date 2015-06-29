//
//  BDBScrollViewCell.m
//  BDB_Discovery
//
//  Created by Tomoxox on 15/6/12.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import "BDBScrollViewCell.h"
@interface BDBScrollViewCell()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic,strong) NSMutableArray *imagesArray;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;

@end
@implementation BDBScrollViewCell

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.imagesArray = [[NSMutableArray alloc] initWithObjects:@"display_img_1.png",@"display_img_2.png",@"display_img_3.png",@"display_img_4.png", nil];
        self.pageControl = [[UIPageControl alloc] init];
    }
    return self;


}

-(void)layoutSubviews {
    
    self.width = self.frame.size.width;
    self.height = self.frame.size.height;
    _scrollView.delegate = self;
    
    //生成4个UIImageView
    for (int i = 0;i < [_imagesArray count];i ++){
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake((_width * i) + _width, 0,_width, _height);
        imageView.image = [UIImage imageNamed:[_imagesArray objectAtIndex:i]];
        [_scrollView addSubview:imageView];
    }
    //再生成前后两个UIImageView
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0, _width,_height);
    imageView.image = [UIImage imageNamed:[_imagesArray objectAtIndex:([_imagesArray count]-1)]];
    [_scrollView addSubview:imageView];
    
    UIImageView *imageView_2 = [[UIImageView alloc] init];
    imageView_2.frame = CGRectMake((_width * ([_imagesArray count] + 1)) , 0, _width,_height);
    imageView_2.image = [UIImage imageNamed:[_imagesArray objectAtIndex:0]];
    [_scrollView addSubview:imageView_2];
    
    [_scrollView setContentSize:CGSizeMake(_width * ([_imagesArray count] + 2),_height)];
    
    [_scrollView setContentOffset:CGPointMake(_width, 0) animated:NO];

}
- (void)awakeFromNib {
    
    
}

#pragma mark - UIScrollViewDelegate Methods

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = 1;
    NSInteger tempPage = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    switch (tempPage) {
        case 1:
            currentPage = 0;
            break;
        case 2:
            currentPage = 1;
            break;
        case 3:
            currentPage = 2;
            break;
        case 4:
            currentPage = 3;
            break;
        case 5:
            currentPage = 0;
            break;
        case 0:
            currentPage = 3;
            break;
            
        default:
            break;
    }
    self.pageControl.currentPage = currentPage;
    if (currentPage == 0) {
        [_scrollView scrollRectToVisible:CGRectMake(_width, 0, _width, _height) animated:NO];
    }else if (currentPage == 3){
        [_scrollView scrollRectToVisible:CGRectMake(_width * 4, 0, _width, _height) animated:NO];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
