//
//  EditInfoViewController.m
//  JTalk
//
//  Created by Mr.Yang on 15/8/5.
//  Copyright (c) 2015年 Mr.Yang. All rights reserved.
//

#import "EditInfoViewController.h"
#import "HTEditCell.h"
#import "HTInfoCell.h"
#import "ZHPickView.h"
#import "UserLocationViewController.h"
#import "VPImageCropperViewController.h"
#import "UIBarButtonExtern.h"
#import "HTBaseRequest+Requests.h"
#import <SDWebImage/UIImageView+WebCache.h>


#define ORIGINAL_MAX_WIDTH 640.0f

@interface EditInfoViewController () <UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate,
                                    UITextFieldDelegate,
                                    UITextViewDelegate,
                                    ZHPickViewDelegate,
                                    VPImageCropperDelegate, UIActionSheetDelegate>

@property (nonatomic, strong)       UIImageView *headerImageView;
@property (nonatomic, weak)         HTEditCell *selectionCell;
@property (nonatomic, weak)         HTInfoCell *selectionInfoCell;
@property (nonatomic, strong)       ZHPickView *pickerView;

@property (nonatomic, weak)     UIView *selectionView;

@property (nonatomic, copy)     NSString *locationCity;
@property (nonatomic, strong)   UserLocationViewController *userLocationController;



@end

@implementation EditInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_pickerView remove];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    User *user = [User sharedUser];
    
    if (user.isLogin) {
        
        //  如果已经登陆，则在修改用户信息之前清除掉 临时的用户信息文件
        user.userInfoModelTmp = nil;
        user.userInfoModelTmp = [user.userInfo copy];
        
    }else {
        //  用户没有登录，需要定位
        __weakSelf;
        _userLocationController = [[UserLocationViewController alloc] init];
        [_userLocationController getCityNameWithBlock:^(NSString *cityName) {
            weakSelf.locationCity = cityName;
            
            user.userInfoModelTmp.userLocation = _locationCity;
            
            [weakSelf.tableView reloadData];
        }];
    }

    UserInfoModel *userInfo = user.userInfoModelTmp;
    if (user.isLogin) {
        [self.headerImageView sd_setImageWithURL:HTURL(userInfo.userPhoto) placeholderImage:HTImage(@"app_icon")];
        
    }else if (userInfo.userPhotoImage){
        self.headerImageView.image = userInfo.userPhotoImage;
        
    }else {
        self.headerImageView.image = HTImage(@"app_icon");
    }
    
    self.tableView.tableHeaderView = [self headerView];
    
    [self addKeyboardNotifaction];

    
    self.navigationItem.rightBarButtonItem = [UIBarButtonExtern buttonWithTitle:@"完成" target:self andSelector:@selector(finishButtonClicked)];
}


// MARK: 注册请求
- (void)doRegeitRequest
{
    HTBaseRequest *request = [HTBaseRequest regeditNewAccount];
    
    User *user = [User sharedUser];
    UserInfoModel *userInfo = user.userInfo;
    
    __weakSelf;
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        NSDictionary *dict = request.responseJSONObject;
        
        NSInteger responseCode = [[dict stringForKey:@"code"] integerValue];
        if (responseCode == 200) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:__USER_LOGIN_SUCCESS object:nil];
            
            [weakSelf showHudSuccessView:@"注册成功"];
            
            userInfo.userToken = [dict stringForKey:@"token"];
            userInfo.userID = [dict stringForKey:@"user_id"];
            [[User sharedUser] exchangeUserInfo];
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failure:^(YTKBaseRequest *request) {
        [weakSelf showHudErrorView:PromptTypeError];
        
    }];
}

// MARK: 编辑请求
- (void)doEditUserInfoRequest
{
    HTBaseRequest *request = [HTBaseRequest editUserInfo];
    
    __weakSelf;
    [request startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        NSInteger code = [[request.responseJSONObject stringForKey:@"code"] integerValue];
        
        if (code == 200) {
            [self showHudSuccessView:@"修改成功"];
            [[User sharedUser] exchangeUserInfo];
            [weakSelf performSelector:@selector(dismissViewController) withObject:nil afterDelay:1.0f];
        }
        
    } failure:^(YTKBaseRequest *request) {
        [weakSelf showHudErrorView:PromptTypeError];
        
    }];
}

- (void)dismissViewController
{
    [self dismissViewController:^{
        
    }];
}

// MARK: 完成注册
- (void)finishButtonClicked
{
    [self showHudWaitingView:PromptTypeWating];

    User *user = [User sharedUser];
    
    UserInfoModel *userInfo = user.userInfoModelTmp;
    
    if (!userInfo.userPhoto) {
        [self showHudErrorView:@"请设置头像"];
        return;
    }
    
    if (!userInfo.userName) {
        [self showHudErrorView:@"请设置用户名"];
        return;
    }
    
    if (user.isLogin) {
        
        //  修改个人信息
        [self doEditUserInfoRequest];
        
    }else {
        [self doRegeitRequest];
    }
 
}

//  头像视图
- (UIView *)headerView
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APPScreenWidth, 160)];
    self.headerImageView.center = backView.center;
    [backView addSubview:self.headerImageView];
    
    return backView;
}

//  头像
- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.cornerRadius = _headerImageView.width / 2.0f;
        _headerImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerImageViewTaped)];
        [_headerImageView addGestureRecognizer:tapGesture];
        
    }
    
    return _headerImageView;
}

//  单击了头像
- (void)headerImageViewTaped
{
    [self editPortrait];
}

#pragma mark -
#pragma mark keyBoardNotification

- (void)keyboardDidAppear:(NSNotification *)noti withKeyboardRect:(CGRect)rect
{
    //  如果有移除掉
    [_pickerView remove];
    
    CGRect location = [self.tableView convertRect:_selectionView.frame toView:self.view];
    CGFloat offset = (self.view.height - CGRectGetHeight(rect)) - CGRectGetMaxY(location);
    
    if (offset < 0) {
        [self.tableView setContentOffset:CGPointMake(0, -offset) animated:YES];
    }
}

- (void)keyboardWillDisappear:(NSNotification *)noti withKeyboardRect:(CGRect)rect
{
    [self.tableView setContentOffset:CGPointZero animated:YES];
}

#pragma mark - 

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_selectionView endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        return [self userInfoViewHeight];
    }
    
    return 67.5f;
}

- (CGFloat)userInfoViewHeight
{
    CGFloat height = self.view.height - 160 - 3 * 67.5;
    if (height < 100) {
        height = 100;
    }
    
    return height;
}

- (CGFloat)selectionCellHeight
{
    if (_selectionInfoCell) {
        return [self userInfoViewHeight];
    }
    
    return 67.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 3) {
        return [self editCell:tableView cellForRowAtIndexPath:indexPath];
    }
    
    return [self infoCell:tableView cellForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)editCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTEditCell *editCell = [HTEditCell newCell];
    editCell.tag = indexPath.row;
    editCell.titleLabel.text = [self titleAtIndexPath:indexPath];
    editCell.textField.placeholder = [self placeHolderAtIndexPath:indexPath];
    
    editCell.textField.delegate = self;
    editCell.tag = indexPath.row;
    
    UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
    
    if (indexPath.row == 0) {
        editCell.textField.text = userInfo.userName;
        editCell.textField.enabled = YES;
        editCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else if (indexPath.row == 1) {
        editCell.textField.text = userInfo.userSex;
        editCell.textField.enabled = NO;
        
    }else if (indexPath.row == 2) {
        
        if (userInfo.userLocation.length > 0) {
            editCell.textField.text = userInfo.userLocation;
        }else {
            if (!isEmpty(_locationCity)) {
                editCell.textField.text = _locationCity;
            }else {
                editCell.textField.text = @"定位中...";
            }
        }
        
        editCell.textField.enabled = NO;
        editCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return editCell;
}

- (UITableViewCell *)infoCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTInfoCell *infoCell = [HTInfoCell newCell];

    infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
    
    infoCell.titleLabel.text = [self titleAtIndexPath:indexPath];
    infoCell.placeHolderView.placeholder = [self placeHolderAtIndexPath:indexPath];
    infoCell.placeHolderView.text = userInfo.userPrompt;
    infoCell.placeHolderView.delegate = self;
   
    return infoCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
    
    if (indexPath.row != 3) {
        _selectionCell = (HTEditCell *)[tableView cellForRowAtIndexPath:indexPath];
    }else {
        _selectionInfoCell = (HTInfoCell *)[tableView cellForRowAtIndexPath:indexPath];
    }
    
    if (indexPath.row == 1) {
        // Sex PickerView
        // [self showSexPickerView];
        
        HTEditCell *cell = (HTEditCell *)[tableView cellForRowAtIndexPath:indexPath];
        NSString *sex = cell.textField.text;
        if ([sex isEqualToString:@"男"]) {
            cell.textField.text = @"女";
        }else {
            cell.textField.text = @"男";
        }
        
    }else if (indexPath.row == 2) {
        
        __weakSelf;
        UserLocationViewController *loaction = [[UserLocationViewController alloc] initWithTableViewStyle:UITableViewStylePlain];
        [loaction setUserSelectedBlock:^(NSString *cityName) {
            UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
            weakSelf.selectionCell.textField.text = cityName;
            userInfo.userLocation = cityName;
            
        }];
        
        loaction.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loaction animated:YES];
    }
}


#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
    NSString *willChange = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField.tag == 0) {
        userInfo.userName = willChange;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _selectionView = [self editCellForView:textField];
    
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _selectionView = [self findInfoCellForView:textView];
    
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
    NSString *willChange = [textView.text stringByReplacingCharactersInRange:range withString:text];
    userInfo.userPrompt = willChange;
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
    userInfo.userPrompt = textView.text;
}

- (HTEditCell *)editCellForView:(UIView *)view
{
    if ([view.superview isKindOfClass:[HTEditCell class]]) {
        return (HTEditCell *)view.superview;
    }
    
    return [self editCellForView:view.superview];
}

- (HTInfoCell *)findInfoCellForView:(UIView *)view
{
    if ([view.superview isKindOfClass:[HTInfoCell class]]) {
        return (HTInfoCell *)view.superview;
    }
    
    return [self findInfoCellForView:view.superview];
}

- (NSString *)placeHolderAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: return @"请输入您的昵称";
        case 1: return @"请选择您的性别";
        case 2: return @"请选择您的地区";
        case 3: return @"请输入您的简介";
    }
    return nil;
}

- (NSString *)titleAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: return @"名字";
        case 1: return @"性别";
        case 2: return @"地区";
        case 3: return @"简介";
    }
    
    return nil;
}

- (void)showSexPickerView
{
    NSArray *array=@[@[@"男", @"女"]];
    
    if (!_pickerView) {
        _pickerView =[[ZHPickView alloc] initPickviewWithArray:array isHaveNavControler:NO];
        [_pickerView setPickViewColer:[UIColor jt_lightGrayColor]];
        _pickerView.delegate = self;
    }

    [_pickerView show];
}

#pragma mark - ZHPickerViewDelegate
- (void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    _selectionCell.textField.text = resultString;
    UserInfoModel *userInfo = [User sharedUser].userInfoModelTmp;
    userInfo.userSex = resultString;
}

#pragma mark - 
#pragma mark ImageViewPicker

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.headerImageView.image = editedImage;
    
    User *user = [User sharedUser];
    UserInfoModel *userInfo = user.userInfoModelTmp;
    
    userInfo.userPhotoImage = _headerImageView.image;
    
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *)title
{
    return @"编辑名片";
}

@end
