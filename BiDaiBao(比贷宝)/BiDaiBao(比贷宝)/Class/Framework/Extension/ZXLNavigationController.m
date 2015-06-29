//
//  ZXLNavigationController.m
//  BiDaiBao(比贷宝)
//
//  Created by zhang xianglu on 15/6/7.
//  Copyright (c) 2015年 zhang xianglu. All rights reserved.
//

#import "ZXLNavigationController.h"
#import "ZXLNavigationBar.h"


@interface ZXLNavigationController ()

@end

@implementation ZXLNavigationController

/**
 *  第一次发送消息时调用
 */
+ (void)initialize {
	
}

- (instancetype)initWithCoder:(NSCoder *)coder{
	if (self = [super initWithCoder:coder]) {
		[self setValue:[[ZXLNavigationBar alloc] init] forKey:@"navigationBar"];
	}
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
	//if (self.viewControllers.count > 0) {
		viewController.hidesBottomBarWhenPushed = YES;
		
		ZXLLOG(@"调用了");
		
		__weak typeof(self) thisInstance = self;
		viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:UIImageWithName(@"navigationbar_back") highlightedImage:UIImageWithName(@"navigationbar_back") clickedHandler:^{
			[thisInstance popViewControllerAnimated:YES];
		}];
	//}

	//要在压栈之前设置
	[super pushViewController:viewController animated:animated];
}


@end
