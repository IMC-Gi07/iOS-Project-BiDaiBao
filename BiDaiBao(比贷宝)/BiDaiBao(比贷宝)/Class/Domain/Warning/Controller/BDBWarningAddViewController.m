//
//  ViewController.m
//  BDB_WarningAdd
//
//  Created by moon on 15/6/9.
//  Copyright (c) 2015年 moon. All rights reserved.
//

#import "BDBWarningAddViewController.h"
#import "BDB_TableViewCell_One.h"
#import "BDB_TableViewCell_Two.h"

#import "MJDIYHeader.h"
#import "MJDIYAutoFooter.h"
#import "BDB_Model.h"
#import "MJExtension.h"
#import "AFNetworking.h"
static const CGFloat MJDuration = 2.0;
/**
 * 随机数据
 */
#define MJRandomData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]


@interface BDBWarningAddViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *packUp;

@property (nonatomic, assign)NSInteger row;
@property (nonatomic, assign)NSInteger rowrow;
@property (nonatomic, assign)NSInteger rowNumber;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;
@property (nonatomic, strong) NSMutableArray *noticeModels;
@property (nonatomic, copy) NSString *UID;
@property (nonatomic, copy) NSString *PSW;
@property (nonatomic, copy) NSString *Action;
@property (nonatomic, strong) BDB_Model *model;


@end

@implementation BDBWarningAddViewController


- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if(self = [super initWithCoder:aDecoder]){
        
        self.rowNumber = 1;
        self.rowrow = 1;
    }
    return self;
}

- (IBAction)packup:(UIButton *)sender {
    
    
    if (self.rowrow % 2 == 0) {
        self.rowNumber = 1;
       
    } else  {
        self.rowNumber = 2;
    }
    
    
    [_tableView reloadData];
    self.rowrow ++;
}

- (void)loadNewData
{
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        [self.data insertObject:MJRandomData atIndex:0];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // 拿到当前的下拉刷新控件，结束刷新状态
        [self.tableView.header endRefreshing];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    [header setImages:<#(NSArray *)#> forState:MJRefreshStateIdle];
//    [header setImages:<#(NSArray *)#> forState:MJRefreshStatePulling];
//    [header setImages:<#(NSArray *)#> forState:MJRefreshStateRefreshing];
    self.tableView.header = header;
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    tableView不响应
//    self.tableView.bounces = NO;
    [self loadMoreDatas];
}

- (void)loadMoreDatas {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *requestUrl = [BDBGlobal_HostAddress stringByAppendingPathComponent:@"SetAlarmEarnings"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters [@"UID"] = [NSString stringWithFormat:@"%@",_UID];
//    parameters [@"PSW"] = [NSString stringWithFormat:@"%@",_PSW];
    parameters [@"Action"] = [NSString stringWithFormat:@"%@",_Action];
    [manager POST:requestUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        self.model  = [[BDB_Model alloc] init];
        _model.Msg = responseObject[@"Msg"];
        _model.Result = (long)responseObject[@"Result"];
        
            NSLog(@"%@",responseObject[@"Msg"]);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
}
    


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //self.rowNumber = 1;
    return self.rowNumber;
}


//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0:
            self.row = 190;
            break;
        case 1:
            self.row = 128;
            break;
       
    }
    return self.row;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    //    id cell;
    NSUInteger rowOn = indexPath.row;
//    根据行数判断return哪个自定义cell
    if (self.rowNumber == 1) {
        if (rowOn == 0) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"BDB_TableViewCell_Two" owner:nil options:nil][0];
        }
    
    }else if (self.rowNumber == 2){
        if (rowOn == 0) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"BDB_TableViewCell_One" owner:nil options:nil][0];
        } else if (rowOn == 1){
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"BDB_TableViewCell_Two" owner:nil options:nil][0];
        }
    
    }

    
    return cell;
}


@end
