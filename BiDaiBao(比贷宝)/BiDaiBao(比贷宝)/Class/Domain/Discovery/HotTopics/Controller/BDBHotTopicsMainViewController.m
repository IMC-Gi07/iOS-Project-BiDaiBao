//
//  ViewController.m
//  BDB_HotTopics
//
//  Created by Tomoxox on 15/6/15.
//  Copyright (c) 2015年 Tommyman. All rights reserved.
//

#import "BDBHotTopicsMainViewController.h"
#import "BDBHotTopicIntroductionCell.h"
#import "BDBQuestionContentCell.h"
#import "BDBHotTopicsModel.h"
#import "BDBHotTopicsResponseModel.h"
#import "GlobalConfigurations.h"
#import "BDBTableViewRefreshHeader.h"
#import "BDBTableViewRefreshFooter.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "AFNetworking.h"
@interface BDBHotTopicsMainViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic, assign) BOOL cellHeightCacheEnabled;
//问题列表
@property(nonatomic,strong) NSMutableArray *questionListModels;
//问题页数
@property(nonatomic,assign) NSUInteger pageIndex;
//每页显示数量
@property(nonatomic,assign) NSUInteger pageSize;
- (void)refreshDatas;
- (void)loadMoreDatas;
@end

@implementation BDBHotTopicsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 100;
    [self generateQuestionButton];
    self.pageSize = 5;
    [self initHeaderAndFooter];
    
}


#pragma mark - UITableViewDelegate,UITableViewDataSource Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    if (indexPath.row == 0) {
        return 120;
    }
    if (indexPath.row >= 1) {

        return 100;
        
    }
    return height;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        BDBHotTopicIntroductionCell *introductionCell = [[NSBundle mainBundle] loadNibNamed:@"BDBHotTopicIntroductionCell" owner:nil options:nil][0];
        return introductionCell;
    }
    if (indexPath.row > 0) {
        BDBQuestionContentCell *questionContentCell = [[NSBundle mainBundle] loadNibNamed:@"BDBQuestionContentCell" owner:nil options:nil][0];
        
        return questionContentCell;
    }
    
    return cell;
}



#pragma mark - QuestionButton Clicked Action
- (void)questionButtonClickedAction {
    NSLog(@"questionButtonClicked..");
}


#pragma mark - Privite Methods
- (void)generateQuestionButton {
    UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    questionBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [questionBtn setImage:[UIImage imageNamed:@"hotTopics_questionBtn_img"] forState:UIControlStateNormal];
    [self.view addSubview:questionBtn];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:questionBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:60];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:questionBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:60];
    [questionBtn addConstraints:@[width,height]];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:questionBtn attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:questionBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    [self.view addConstraints:@[trailing,bottom]];
    
    [questionBtn addTarget:self action:@selector(questionButtonClickedAction) forControlEvents:UIControlEventTouchUpInside];
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
        
        BDBHotTopicsResponseModel *responseModel = [BDBHotTopicsResponseModel objectWithKeyValues:responseObject];
        self.questionListModels = responseModel.QuestionList;
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
    
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"GetQuestions"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"PageIndex"] = [NSString stringWithFormat:@"%lu",_pageIndex];
    parameters[@"PageSize"] = [NSString stringWithFormat:@"%lu",_pageSize];
    
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //ZXLLOG(@"success response: %@",responseObject);
        
        BDBHotTopicsResponseModel *questionResponseModel = [BDBHotTopicsResponseModel objectWithKeyValues:responseObject];
        
        //将更多的数据，追加到数组后面
        [self.questionListModels addObjectsFromArray:questionResponseModel.QuestionList];
        
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
@end
