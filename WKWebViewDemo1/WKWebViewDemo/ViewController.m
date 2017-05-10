//
//  ViewController.m
//  WKWebViewDemo
//
//  Created by hujunhua on 2016/11/17.
//  Copyright © 2016年 hujunhua. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "OCJSHelper.h"

#define ScreenWidth   [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight  [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()
<
    WKNavigationDelegate,
    WKUIDelegate
>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) OCJSHelper *ocjsHelper;
@property (nonatomic, assign) CGFloat delayTime;
@property (nonatomic, assign) CGFloat contentHeight;

@end

@implementation ViewController

#pragma mark - Life Cycle

// 用来测试的一些url链接
- (NSURL *)testurl {
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"test" withExtension:@"html"];
//    NSURL *url = [NSURL URLWithString:@"https://h5.autojfun.com/activity/activityDetail.html?id=100015"];
    
//    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
//    NSURL *url = [NSURL URLWithString:@"https://github.com/"];
//    NSURL *url = [NSURL URLWithString:@"https://z.yeemiao.com/share/share.html"]; // 自建证书，在iOS8下面，无法通过验证
    
    return url;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    // 交互对象设置 
    [config.userContentController addScriptMessageHandler:(id)self.ocjsHelper name:@"qooroo"];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.ocjsHelper.webView = self.webView;
    [self.view addSubview:self.webView];
    
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    // 开始右滑返回手势
    
    NSURL *url = [self testurl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)dealloc {
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"qooroo"];
}


#pragma mark - WKUIDelegate
// 提示框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示框" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认框" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入框" message:prompt preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
        textField.placeholder = defaultText;
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(nil);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - Setter & Getter

- (OCJSHelper *)ocjsHelper {
    if (!_ocjsHelper) {
        _ocjsHelper = [[OCJSHelper alloc] initWithDelegate:(id)self vc:self];
    }
    return _ocjsHelper;
}

@end
