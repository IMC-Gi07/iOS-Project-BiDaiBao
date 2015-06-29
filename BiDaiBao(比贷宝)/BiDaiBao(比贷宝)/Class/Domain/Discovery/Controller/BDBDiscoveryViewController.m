//
//  ViewController.m
//  BDB_Discovery
//
//  Created by Tomoxox on 15/6/11.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import "BDBDiscoveryViewController.h"
#import "BDBScrollViewCell.h"
#import "BDBCollectionCell.h"
#import "BDBImformationCell.h"
#import "MJExtension.h"
#import "AFNetworking.h"
#import "BDBDiscoveryModel.h"
#import "BDBDiscoveryResponseModel.h"
#import "GlobalConfigurations.h"
#import "BDBTableViewRefreshHeader.h"
#import "BDBTableViewRefreshFooter.h"
#import "MJRefresh.h"

@interface BDBDiscoveryViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,BDBCollectionCellDelegate>

@property (nonatomic,assign) BOOL isSegmentFirst;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *writeArticleButton;
@property (strong, nonatomic) UIButton *index_0;
@property (strong, nonatomic) UIButton *index_1;
//资讯数据
@property(nonatomic,strong) NSMutableArray *newsModels;
//资讯页数
@property(nonatomic,assign) NSUInteger pageIndex;
//每页显示数量
@property(nonatomic,assign) NSUInteger pageSize;

- (void)searchButtonClickedAction:(UIBarButtonItem *)search;
- (IBAction)writeArticleButtonClickedAction:(UIButton *)sender;
- (void)refreshDatas;
- (void)loadMoreDatas;
- (void)initHeaderAndFooter;
@end

@implementation BDBDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NSUnderlineStyleNone;
    
    self.isSegmentFirst = YES;
    self.pageSize = 5;
    //获取网络数据
    [self refreshDatas];
    [self initHeaderAndFooter];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows;
    if (_isSegmentFirst) {
        rows = _newsModels.count + 1;
    }else {
        return 2;
    }
    return rows;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat heightForRow;
    if (indexPath.row == 0) {
        return 200.0f;
    }
    if (_isSegmentFirst) {
        if ([UIScreen mainScreen].bounds.size.height == 736) {
            if (indexPath.row >0) {
                return 130;
            }
        }else {
            if (indexPath.row > 0) {
                return 120;
            }
        }
    }else {
        if ([UIScreen mainScreen].bounds.size.height == 736) {
            if (indexPath.row == 1) {
                return 420;
            }
        }
        else {
            if (indexPath.row == 1) {
                return 360;
            }
        }
    }
    return heightForRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        BDBScrollViewCell *scrollViewCell = [[NSBundle mainBundle] loadNibNamed:@"BDBScrollViewCell" owner:nil options:nil][0];
        scrollViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return scrollViewCell;
    }
    if (_isSegmentFirst) {
        
        if (indexPath.row >= 1) {
            BDBDiscoveryModel *news = _newsModels[indexPath.row - 1];
            
            static NSString *cellIdentifier = @"informationCell";
            
            BDBImformationCell *informationCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (informationCell == nil) {
                informationCell = [[NSBundle mainBundle] loadNibNamed:@"BDBImformationCell" owner:nil options:nil][0];
            }
            informationCell.selectionStyle = UITableViewCellSelectionStyleNone;
            informationCell.title.text = news.Title;
            informationCell.publisher.text = news.Publisher;
            informationCell.DT.text = news.DT;
            informationCell.firstSection.text = news.FirstSection;
            informationCell.commentNum.text = news.CommentNum;
            informationCell.PopularIndex.text = news.PopularIndex;
            NSString *picUrl = news.PicURL;
            NSURL *picURL = [NSURL URLWithString:picUrl];
            NSData *picData = [NSData dataWithContentsOfURL:picURL];
            UIImage *pic = [UIImage imageWithData:picData];
            informationCell.pic.image = pic;
            return informationCell;
        }
    }else {
        if (indexPath.row == 1) {
            BDBCollectionCell *collectionCell = [[NSBundle mainBundle] loadNibNamed:@"BDBCollectionCell" owner:nil options:nil][0];
            collectionCell.selectionStyle = UITableViewCellSelectionStyleNone;
            collectionCell.delegate = self;
            return collectionCell;
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"选中...");
}

#pragma mark - Buttons Clicked Action
- (void)index_0ButtonClicked {
    _isSegmentFirst = YES;
    _index_0.selected = YES;
    _index_1.selected = NO;
    [_tableView reloadData];
}
- (void)index_1ButtonClicked {
    _isSegmentFirst = NO;
    _index_0.selected = NO;
    _index_1.selected = YES;
    [_tableView reloadData];
}

-(void)searchButtonClickedAction:(UIBarButtonItem *)search {
    NSLog(@"searchButtonClicked..");
}

- (IBAction)writeArticleButtonClickedAction:(UIButton *)sender {
    NSLog(@"writeArticleButtonClicked..");
}

//初始化导航栏样式
- (void)initNavigationBar {
    //给导航控制栏添加button
    UIButton *search = [[UIButton alloc] initWithFrame:(CGRect){0,0,44,44}];
    [search setImage:[UIImage imageNamed:@"Discovery_navigation_search"] forState:UIControlStateNormal];
    [search addTarget:self action:@selector(searchButtonClickedAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightView = [[UIBarButtonItem alloc] initWithCustomView:search];
    self.navigationItem.rightBarButtonItem = rightView;
    
    UIView *titleView = [[UIView alloc] initWithFrame:(CGRect){0,0,200,30}];
    _index_0 = [[UIButton alloc] initWithFrame:(CGRect){0,0,100,30}];
    [_index_0 setImage:[UIImage imageNamed:@"Discovery_index_0"] forState:UIControlStateNormal];
    [_index_0 setImage:[UIImage imageNamed:@"Discovery_index_0_highlighted"] forState:UIControlStateSelected];
    _index_0.selected = YES;
    _index_0.adjustsImageWhenHighlighted = NO;
    
    [_index_0 addTarget:self action:@selector(index_0ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:_index_0];
    
    _index_1 = [[UIButton alloc] initWithFrame:(CGRect){100,0,100,30}];
    [_index_1 setImage:[UIImage imageNamed:@"Discovery_index_1"] forState:UIControlStateNormal];
    [_index_1 setImage:[UIImage imageNamed:@"Discovery_index_1_highlighted"] forState:UIControlStateSelected];
    [_index_1 addTarget:self action:@selector(index_1ButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    _index_1.adjustsImageWhenHighlighted = NO;
    [titleView addSubview:_index_1];
    
    self.navigationItem.titleView = titleView;

}
#pragma mark - Getting Datas Methods

- (void)refreshDatas {
    self.pageIndex = 1;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *requestURL = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetNews"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",_pageIndex];
    parameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
    
    [manager POST:requestURL parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        BDBDiscoveryResponseModel *responseModel = [BDBDiscoveryResponseModel objectWithKeyValues:responseObject];
        self.newsModels = responseModel.NewsList;
        [_tableView reloadData];
        ZXLLOG(@"success..");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"获取数据失败" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    
}

- (void)loadMoreDatas {
    self.pageIndex ++;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetNews"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",_pageIndex];
    parameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //ZXLLOG(@"success response: %@",responseObject);
        
        BDBDiscoveryResponseModel *newsResponseModel = [BDBDiscoveryResponseModel objectWithKeyValues:responseObject];
        
        //将更多的数据，追加到数组后面
        [self.newsModels addObjectsFromArray:newsResponseModel.NewsList];
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ZXLLOG(@"error response: %@",error);
    }];
}

#pragma mark - Privite Methods
- (void)initHeaderAndFooter {
    __weak typeof(self) thisInstance = self;
    
    //初始化表头部
    thisInstance.tableView.header = [BDBTableViewRefreshHeader headerWithRefreshingBlock:^{
        //刷新数据
        [thisInstance refreshDatas];
        
        //刷新完数据后，回收头部
        [thisInstance.tableView.header endRefreshing];
    }];
    
    //初始化表尾部
    thisInstance.tableView.footer = [BDBTableViewRefreshFooter footerWithRefreshingBlock:^{
        //加载更多数据
        [thisInstance loadMoreDatas];
        
        //刷新完数据后，回收头部
        [thisInstance.tableView.footer endRefreshing];
    }];
  
}

#pragma mark - BDBCollectionCellDelegate Method
- (void)hotTopicsClicked {
    [self performSegueWithIdentifier:@"hotTopics" sender:self];
}

@end
