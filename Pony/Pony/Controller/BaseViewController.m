//
//  BaseViewController.m
//  Pony
//
//  Created by Baby on 16/1/27.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "BaseViewController.h"
#import <objc/runtime.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initializeProperty];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeProperty];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self configureView];
    [self bindViewModel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - View Lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // 改变UI位置
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 确定UI位置关系后设置AutoLayout
}

#pragma mark - Override

#pragma mark - Delegate

#pragma mark - Notification

#pragma mark - Public

#pragma mark - Private
- (void)initializeProperty {
    NSMutableString *currentClassName = NSStringFromClass([self class]).mutableCopy;
    [currentClassName replaceCharactersInRange:NSMakeRange(currentClassName.length - 1, 1)
                                    withString:@"M"];
    NSString *viewModelName = currentClassName;
    unsigned int propertyCount = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i < propertyCount; i++){
        objc_property_t property = propertys[i];
        const char *propertyChar = property_getName(property);
        NSString *propertyString = [NSString stringWithUTF8String:propertyChar];
        if ([propertyString caseInsensitiveCompare:viewModelName] == NSOrderedSame) {
            Class someClass = NSClassFromString(viewModelName);
            id obj = [[someClass alloc] init];
            [self setValue:obj
                    forKey:propertyString];
            break;
        }
    }
    free(propertys);
}

- (void)configureView {}

- (void)bindViewModel {}

- (void)configureData {}

#pragma mark - Event Response

#pragma mark - Custom Accessors

#pragma mark - Dealloc
- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
