//
//  ViewController.m
//  Weex_Test
//
//  Created by Joky Lee on 2017/10/12.
//  Copyright © 2017年 Joky Lee. All rights reserved.
//

#import "ViewController.h"
#import <WeexSDK/WXSDKInstance.h>
@interface ViewController ()
@property (nonatomic, strong) WXSDKInstance *instance;
@property (weak, nonatomic) UIView *weexView;
@property (nonatomic, strong) NSURL *url;
@end

@implementation ViewController
- (NSURL *)url {
    if (!_url) {
        //服务器
//        _url = [NSURL URLWithString:@"https://weex-plugins.github.io/weex-svg/pages/com-path.js"];
        //本地
        _url =  [[NSBundle mainBundle] URLForResource:@"com-path"   withExtension:@"js"];
    }
    return _url;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 创建WXSDKInstance对象
    _instance = [[WXSDKInstance alloc] init];
    // 设置weexInstance所在的控制器
    _instance.viewController = self;
    //设置weexInstance的frame
    _instance.frame = self.view.frame;
    //设置weexInstance用于渲染的`js`的URL路径(后面说明)
    [_instance renderWithURL:self.url options:@{@"bundleUrl":[self.url absoluteString]} data:nil];
    //为了避免循环引用声明一个弱指针的`self`
    __weak typeof(self) weakSelf = self;
    //设置weexInstance创建完毕回调
    _instance.onCreate = ^(UIView *view) {
        weakSelf.weexView = view;
        [weakSelf.weexView removeFromSuperview];
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    // 设置`weexInstance`出错的回调
    _instance.onFailed = ^(NSError *error) {
        //process failure
        NSLog(@"处理失败:%@",error);
    };
    //设置渲染完成的回调
    _instance.renderFinish = ^ (UIView *view) {
        //process renderFinish
        NSLog(@"渲染完成");
    };
}

- (void)dealloc {
    //  销毁WXSDKInstance实例
    [self.instance destroyInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
