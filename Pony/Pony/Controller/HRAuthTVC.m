//
//  HRAuthTVC.m
//  Pony
//
//  Created by 杜文 on 16/7/20.
//  Copyright © 2016年 peterstudio. All rights reserved.
//

#import "HRAuthTVC.h"
#import "PProfessionVC.h"
#import <QiniuSDK.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+LangExt.h"
#import "HRAuthM.h"
#import "UIButton+WebCache.h"

#define IMAGE_AUTH_TITLE        @"此应用程序对您的相册没有访问权限"
#define IMAGE_AUTH_MESSAGE      @"请在iPhone的“设置-隐私-照片”选项中，允许晓马过河访问你的手机相册"
#define IMAGE_AUTH_CANCEL       @"好"
#define CAMERA_AUTH_TITLE       @"此应用程序对您的相机没有访问权限"
#define CAMERA_AUTH_MESSAGE     @"请在iPhone的“设置-隐私-相机”选项中，允许晓马过河访问你的手机相机"
#define CAMERA_AUTH_CANCEL      @"好"

@interface HRAuthTVC ()<UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>{
    NSString * key1;
    NSString * key2;
}
@property (copy, nonatomic) NSString * token;
@property (weak, nonatomic) IBOutlet UILabel *hangYeLab;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *workTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *companyTF;
@property (weak, nonatomic) IBOutlet UITextField *jobTF;
@property (strong, nonatomic) UIDatePicker * datePicker;
@property (strong, nonatomic) ProfessionM * professionM;

@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn1;
@property (weak, nonatomic) IBOutlet UIButton *imgBtn2;
@property (strong, nonatomic) UIButton * tempBtn;

@property (nonatomic, strong) HRAuthM * hrAuthM;
@end

@implementation HRAuthTVC

- (void)doneClick{
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"yyyy-MM-dd"; // 设置时间和日期的格式
    NSString *dateStr = [selectDateFormatter stringFromDate:self.datePicker.date]; // 把date类型转为设置好格式的string类型
    self.workTimeTF.text = dateStr;//[NSString stringWithFormat:@"%@ 00:00:00",dateStr];
    [self.view endEditing:YES];
}

- (void)cancelClick{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.professionM = [[ProfessionM alloc] init];
    [self getQiniuToken];
    [self getUserAuthInfo];
    UIToolbar *toolbar	= [[UIToolbar alloc] init];
    [toolbar sizeToFit];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain  target:self action:@selector(doneClick)];
    [toolbar setItems:@[cancelItem,spacer, doneItem]];
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.frame = CGRectMake(0, 0, SCREEN_WIDTH, 216); // 设置显示的位置和大小
    self.datePicker.date = [NSDate date]; // 设置初始时间
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    self.workTimeTF.inputView = self.datePicker;
    self.workTimeTF.inputAccessoryView = toolbar;
}

- (void)getUserAuthInfo{
    @weakify(self)
    [MBProgressHUD showMessage:nil];
    [APIHTTP wwPost:kAPIUserjobsGet parameters:@{} success:^(NSDictionary * responseObject) {
        @strongify(self)
        self.hrAuthM = [[HRAuthM alloc] initWithDictionary:responseObject error:nil];
        [self refrashUI];
        DDLogInfo(@"token == %@",self.token);
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"请求失败，请稍后再试" toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
    }];
}

- (void)refrashUI{
    if (self.hrAuthM.industry) {
        self.professionM.id = self.hrAuthM.industryId;
        self.professionM.industry = self.hrAuthM.industry;
        
        self.hangYeLab.text = self.hrAuthM.industry;
        self.nameTF.text = self.hrAuthM.realName;
        self.workTimeTF.text = self.hrAuthM.startTime;
        self.companyTF.text =self.hrAuthM.company;
        self.jobTF.text = self.hrAuthM.job;
        
        key1 = self.hrAuthM.userAuthorityImg;
        key2 = self.hrAuthM.userAgeImg;
        
        [self.imgBtn1 setImageWithURL:[NSURL URLWithString:key1] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"upload1"]];
        [self.imgBtn2 setImageWithURL:[NSURL URLWithString:key2] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"upload2"]];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        // 行业选择
        UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Pony" bundle:[NSBundle mainBundle]];
        PProfessionVC * vc = [sb instantiateViewControllerWithIdentifier:@"PProfessionVC"];
        @weakify(self)
        vc.successBlock = ^(ProfessionM * obj){
            @strongify(self)
            self.professionM = obj;
            self.hangYeLab.text = obj.industry;
            self.hangYeLab.textColor = [UIColor blackColor];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)getQiniuToken{
    @weakify(self)
    [APIHTTP wwPost:kAPIUploadToken parameters:@{@"bucketname":@"xiaomaapp"} success:^(NSDictionary * responseObject) {
        @strongify(self)
        self.token = responseObject[@"uploadToken"];
        DDLogInfo(@"token == %@",self.token);
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"请求失败，请稍后再试" toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
    }];
}

- (void)uploadImageToQiNiu:(NSData *)_data{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];//转为字符型
    UserInfoM * m = [USERMANAGER userInfoM];
    if (self.imgBtn1 == self.tempBtn) {
        [self.imgBtn1 setImage:[UIImage imageWithData:_data] forState:UIControlStateNormal];
        [self.imgBtn1 setImage:[UIImage imageWithData:_data] forState:UIControlStateHighlighted];
        [self.imgBtn1 setImage:[UIImage imageWithData:_data] forState:UIControlStateSelected];
        [self.imgBtn1.imageView setContentMode:UIViewContentModeScaleAspectFill];
        self.imgBtn1.layer.masksToBounds = YES;
        self.imgBtn1.layer.cornerRadius = 5.0f;
        self.imgBtn1.layer.borderColor = [UIColor whiteColor].CGColor;
        self.imgBtn1.layer.borderWidth = 2.0;
        
        NSString * key = [NSString stringWithFormat:@"%@%@.png",m.user_name,timeString];
        [MBProgressHUD showMessage:nil];
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        [upManager putData:_data key:key token:self.token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      NSLog(@"%@", info);
                      NSLog(@"%@", resp);
                      key1 = key;
                      [MBProgressHUD hideHUD];
                  } option:nil];
    }else if (self.imgBtn2 == self.tempBtn){
        [self.imgBtn2 setImage:[UIImage imageWithData:_data] forState:UIControlStateNormal];
        [self.imgBtn2 setImage:[UIImage imageWithData:_data] forState:UIControlStateHighlighted];
        [self.imgBtn2 setImage:[UIImage imageWithData:_data] forState:UIControlStateSelected];
        [self.imgBtn2.imageView setContentMode:UIViewContentModeScaleAspectFill];
        self.imgBtn2.layer.masksToBounds = YES;
        self.imgBtn2.layer.cornerRadius = 5.0f;
        self.imgBtn2.layer.borderColor = [UIColor whiteColor].CGColor;
        self.imgBtn2.layer.borderWidth = 2.0;
        
        NSString * key = [NSString stringWithFormat:@"%@%@.png",m.user_name,timeString];
        [MBProgressHUD showMessage:nil];
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        [upManager putData:_data key:key token:self.token
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      NSLog(@"%@", info);
                      NSLog(@"%@", resp);
                      key2 = key;
                      [MBProgressHUD hideHUD];
                  } option:nil];
    }
}

- (IBAction)submitBtnClicked:(id)sender {
    if (!self.professionM) {
        [MBProgressHUD showError:@"请选择行业"];
        return;
    }
    
    if ([self.nameTF.text validBlank]) {
        [MBProgressHUD showError:@"请输入您的真实姓名"];
        return;
    }
    
    if ([self.workTimeTF.text validBlank]) {
        [MBProgressHUD showError:@"请输入您的起始工作时间"];
        return;
    }
    
    if ([self.companyTF.text validBlank]) {
        [MBProgressHUD showError:@"请输入您的公司名称"];
        return;
    }
    
    if ([self.jobTF.text validBlank]) {
        [MBProgressHUD showError:@"请输入您的岗位名称"];
        return;
    }
    
    if (!key1 || [key1 validBlank]) {
        [MBProgressHUD showError:@"请上传您的职业身份证明"];
        return;
    }

    if (!key2 || [key2 validBlank]) {
        [MBProgressHUD showError:@"请上传您的工作年限证明"];
        return;
    }

    NSString * startTime = [NSString stringWithFormat:@"%@ 00:00:00",self.workTimeTF.text];
    @weakify(self)
    NSDictionary * dic = @{@"industryId":self.professionM.id,@"industry":self.professionM.industry,@"realName":self.nameTF.text,@"startTime":startTime,@"company":self.companyTF.text,@"job":self.jobTF.text,@"userAuthorityImg":key1,@"userAgeImg":key2};
    [MBProgressHUD showMessage:nil];
    [APIHTTP wwPost:kAPISave parameters:dic success:^(NSDictionary * responseObject) {
        @strongify(self)
        [MBProgressHUD showSuccess:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } error:^(NSError *err) {
        [MBProgressHUD showError:err.localizedDescription toView:self.view];
    } failure:^(NSError *err) {
        [MBProgressHUD showError:@"请求失败，请稍后再试" toView:self.view];
    } completion:^{
        [MBProgressHUD hideHUD];
    }];
    
}


- (IBAction)uploadImgBtnClicked:(id)sender {
    [self.view endEditing:YES];
    self.tempBtn = sender;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选择",
                                  nil];
    [actionSheet showInView:self.navigationController.view];
}


/**
 *  打开相册或相机
 *
 *  @param sourceType
 */
- (void)openImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType) sourceType
{
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        // 相机
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            // 无权限
            [self addAlertViewWithMsg:CAMERA_AUTH_MESSAGE cancelTitle:CAMERA_AUTH_CANCEL];
            return;
        }
    }else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        // 相册
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
        {
            // 无权限
            [self addAlertViewWithMsg:IMAGE_AUTH_MESSAGE cancelTitle:IMAGE_AUTH_CANCEL];
            return;
        }
    }
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = sourceType;
    controller.mediaTypes = @[(NSString *)kUTTypeImage];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex) {
        // 拍照
        [self openImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    } else if (1 == buttonIndex) {
        // 从相册中选择
        [self openImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *srcImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage * fixImg = [srcImg fixOrientation:srcImg];
    NSData *imageData = UIImageJPEGRepresentation(fixImg, 0.2);//压缩图片
    [self uploadImageToQiNiu:imageData];
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _footView;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 300.0f;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.nameTF) {
        [self.workTimeTF becomeFirstResponder];
    }else if (textField == self.companyTF){
        [self.jobTF becomeFirstResponder];
    }else if (textField == self.jobTF){
        [self.jobTF resignFirstResponder];
    }
    return YES;
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
