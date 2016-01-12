//
//  SHGMarketSendViewController.m
//  Finance
//
//  Created by changxicao on 15/12/10.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketSendViewController.h"
#import "SHGComBoxView.h"
#import "SHGMarketManager.h"
#import "UIButton+WebCache.h"

#define kTextViewOriginalHeight 80.0f
#define kTextViewTopBlank 100.0f * XFACTOR

typedef NS_ENUM(NSInteger, SHGMarketSendType){
    SHGMarketSendTypeNew = 0,
    SHGMarketSendTypeReSet = 1
};

@interface SHGMarketSendViewController ()<UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, SHGComBoxViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *marketNameField;
@property (weak, nonatomic) IBOutlet SHGComBoxView *firstCategoryBox;
@property (weak, nonatomic) IBOutlet SHGComBoxView *secondCategoryBox;
@property (weak, nonatomic) IBOutlet UITextField *acountField;
@property (weak, nonatomic) IBOutlet UITextField *contactField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextView *introduceView;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIView *nextBgView;
@property (strong, nonatomic) IBOutlet UITableViewCell *introduceCell;
@property (strong, nonatomic) id currentContext;
@property (assign, nonatomic) CGFloat keyBoardOrginY;
@property (assign, nonatomic) SHGMarketSendType sendType;
@property (weak, nonatomic) IBOutlet UIView *addImageBgView;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSString *imageName;
@property (assign, nonatomic) BOOL hasImage;
@end

@implementation SHGMarketSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布业务信息";
    [self.tableView setTableHeaderView:self.bgView];
    [self.tableView setTableFooterView:self.nextBgView];
    [self initView];
    self.sendType = SHGMarketSendTypeNew;
    //设置textField文字与左边存在一点间距
    self.marketNameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f, 0.0f)];
    self.marketNameField.leftViewMode = UITextFieldViewModeAlways;
    [self.marketNameField setValue:[UIColor colorWithHexString:@"D3D3D3"] forKeyPath:@"_placeholderLabel.textColor"];

    self.acountField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f, 0.0f)];
    self.acountField.leftViewMode = UITextFieldViewModeAlways;
    [self.acountField setValue:[UIColor colorWithHexString:@"D3D3D3"] forKeyPath:@"_placeholderLabel.textColor"];

    self.contactField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f, 0.0f)];
    self.contactField.leftViewMode = UITextFieldViewModeAlways;
    [self.contactField setValue:[UIColor colorWithHexString:@"D3D3D3"] forKeyPath:@"_placeholderLabel.textColor"];

    self.locationField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f, 0.0f)];
    self.locationField.leftViewMode = UITextFieldViewModeAlways;
    [self.locationField setValue:[UIColor colorWithHexString:@"D3D3D3"] forKeyPath:@"_placeholderLabel.textColor"];

    [self initBoxView];

    __weak typeof(self)weakSelf = self;
    [[SHGMarketManager shareManager] loadMarketCategoryBlock:^(NSArray *array) {
        weakSelf.categoryArray = [NSMutableArray arrayWithArray:array];
        [weakSelf.categoryArray removeObjectAtIndex:0];
        NSMutableArray *titleArray = [NSMutableArray array];
        [weakSelf.categoryArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SHGMarketFirstCategoryObject *object = (SHGMarketFirstCategoryObject *)obj;
            [titleArray addObject:object.firstCatalogName];
        }];
        weakSelf.firstCategoryBox.titlesList = titleArray;
        [weakSelf.firstCategoryBox reloadData];
    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];

    if (self.object) {
        self.title = @"编辑业务信息";
        [self editObject:self.object];
        self.sendType = SHGMarketSendTypeReSet;
    }
}

- (void)initView
{
    self.marketNameField.layer.masksToBounds = YES;
    self.marketNameField.layer.cornerRadius = 3.0f;
    self.acountField.layer.masksToBounds = YES;
    self.acountField.layer.cornerRadius = 3.0f;
    self.contactField.layer.masksToBounds = YES;
    self.contactField.layer.cornerRadius = 3.0f;
    self.introduceView.layer.masksToBounds = YES;
    self.introduceView.layer.cornerRadius = 3.0f;
    self.locationField.layer.masksToBounds = YES;
    self.locationField.layer.cornerRadius = 3.0f;
}

- (void)initBoxView
{
    self.firstCategoryBox.backgroundColor = [UIColor whiteColor];
    self.firstCategoryBox.delegate = self;
    self.firstCategoryBox.parentView = self.bgView;

    self.secondCategoryBox.backgroundColor = [UIColor whiteColor];
    self.secondCategoryBox.delegate = self;
    self.secondCategoryBox.parentView = self.bgView;

}

- (void)editObject:(SHGMarketObject *)object
{
    NSInteger firstIndex = 0;
    SHGMarketFirstCategoryObject *firstObject = nil;
    for (SHGMarketFirstCategoryObject *obj in self.categoryArray) {
        if ([object.firstcatalogid isEqualToString:obj.firstCatalogId]) {
            firstIndex = [self.categoryArray indexOfObject:obj];
            firstObject = obj;
            break;
        }
    }

    self.firstCategoryBox.defaultIndex = firstIndex;
    self.marketNameField.text = object.marketName;
    self.acountField.text = object.price;
    self.contactField.text = object.contactInfo;
    self.locationField.text = object.position;
    self.introduceView.text = object.detail;
    [self.addImageButton sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,object.url]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"addImageButton"]];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentContext = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)keyBoardDidShow:(NSNotification *)notificaiton
{
    NSDictionary *info = [notificaiton userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGPoint keyboardOrigin = [value CGRectValue].origin;
    self.keyBoardOrginY = keyboardOrigin.y;
    UIView *view = (UIView *)self.currentContext;
    CGPoint point = CGPointMake(0.0f, CGRectGetMinY(view.frame));
    if ([self.currentContext isEqual:self.introduceView]) {
        if (CGRectGetHeight(self.introduceView.frame) > kTextViewOriginalHeight) {
            point = CGPointMake(0.0f, CGRectGetMaxY(view.frame));
        }
        point = [self.introduceCell convertPoint:point toView:self.tableView];
        point.y -= kTextViewTopBlank;
    }
    [self.tableView setContentOffset:point animated:YES];
}

- (void)keyBoardDidHide:(NSNotification *)notificaiton
{

}



- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.currentContext = textView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.currentContext isEqual: self.introduceView]) {
        CGSize size = [self.introduceView sizeThatFits:CGSizeMake(CGRectGetWidth(self.introduceView.frame), MAXFLOAT)];
        CGRect frame = self.introduceView.frame;
        frame.size.height = size.height;
        if (!CGRectEqualToRect(self.introduceView.frame, frame) && CGRectGetHeight(frame) > kTextViewOriginalHeight) {
            self.introduceView.frame = frame;
            [self.tableView reloadData];
        } else{
            [self.currentContext resignFirstResponder];
        }
    } else{
        [self.currentContext resignFirstResponder];
        [self.firstCategoryBox closeOtherCombox];
        [self.secondCategoryBox closeOtherCombox];
    }
}

- (IBAction)addNewImage:(id)sender
{
    [self.currentContext resignFirstResponder];
    UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选图", nil];
    [takeSheet showInView:self.view];
}

- (IBAction)nextButtonClick:(id)sender
{
    [self.currentContext resignFirstResponder];
    if ([self checkInputMessage]){
        [self uploadImage:^(BOOL success) {
            if (success) {
                __weak typeof(self) weakSelf = self;
                switch (self.sendType) {
                    case SHGMarketSendTypeNew:{
                        //新建活动
                        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
                        NSString *marketName = self.marketNameField.text;
                        NSString *price = self.acountField.text;
                        NSString *contactInfo = self.contactField.text;
                        NSString *city = self.locationField.text;
                        NSString *detail = self.introduceView.text;
                        SHGMarketFirstCategoryObject *firstObject = [self.categoryArray objectAtIndex:self.firstCategoryBox.currentIndex];
                        NSString *firstId = firstObject.firstCatalogId;

                        NSString *secondId = @"";
                        if (firstObject.secondCataLogs.count > 0) {
                            SHGMarketSecondCategoryObject *secondObject = [firstObject.secondCataLogs objectAtIndex:self.secondCategoryBox.currentIndex];
                            secondId = secondObject.rowId;
                        }

                        NSDictionary *param = @{@"uid":uid, @"marketName": marketName, @"firstCatalogId": firstId, @"secondCatalogId": secondId, @"price": price, @"contactInfo": contactInfo, @"detail": detail, @"photo":self.imageName, @"city":city};
                        [SHGMarketManager createNewMarket:param success:^(BOOL success) {
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }
                        break;

                    default:{
                        //修改活动
                        NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
                        NSString *marketName = self.marketNameField.text;
                        NSString *price = self.acountField.text;
                        NSString *contactInfo = self.contactField.text;
                        NSString *city = self.locationField.text;
                        NSString *detail = self.introduceView.text;
                        SHGMarketFirstCategoryObject *firstObject = [self.categoryArray objectAtIndex:self.firstCategoryBox.currentIndex];
                        NSString *firstId = firstObject.firstCatalogId;

                        NSString *secondId = @"";
                        if (firstObject.secondCataLogs.count > 0) {
                            SHGMarketSecondCategoryObject *secondObject = [firstObject.secondCataLogs objectAtIndex:self.secondCategoryBox.currentIndex];
                            secondId = secondObject.rowId;
                        }

                        NSDictionary *param = @{@"uid":uid, @"marketName": marketName, @"firstCatalogId": firstId, @"secondCatalogId": secondId, @"price": price, @"contactInfo": contactInfo, @"detail": detail, @"photo":self.imageName, @"city":city};
                        [SHGMarketManager modifyMarket:param success:^(BOOL success) {
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }
                        break;
                }
            }
        }];
        
    }
}

- (BOOL)checkInputMessage
{
    if (self.marketNameField.text.length == 0) {
        [Hud showMessageWithText:@"请输入业务名称"];
        return NO;
    }
    if (self.contactField.text.length == 0) {
        [Hud showMessageWithText:@"请输入联系方式"];
        return NO;
    }
    if (self.locationField.text.length == 0) {
        [Hud showMessageWithText:@"请输入业务地区"];
        return NO;
    }
    return YES;
}

- (void)uploadImage:(void(^)(BOOL success))block
{
    [Hud showLoadingWithMessage:@"请稍等..."];
    if (self.hasImage) {
        __weak typeof(self) weakSelf = self;
        [[AFHTTPRequestOperationManager manager] POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/uploadPhotoCompress"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *imageData = UIImageJPEGRepresentation(self.addImageButton.imageView.image, 0.1);
            [formData appendPartWithFileData:imageData name:@"market.jpg" fileName:@"market.jpg" mimeType:@"image/jpeg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            [Hud hideHud];
            NSDictionary *dic = [(NSString *)[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
            weakSelf.imageName = [(NSArray *)[dic valueForKey:@"pname"] objectAtIndex:0];
            block(YES);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [Hud hideHud];
            [Hud showMessageWithText:@"上传图片失败"];
        }];
    } else{
        self.imageName = @"";
        block(YES);
    }

}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CGRectGetMaxY(self.addImageBgView.frame);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.introduceCell;
}

#pragma mark ------actionSheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];

    switch (buttonIndex) {
        case 0:{
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                pickerImage.delegate = self;
                pickerImage.allowsEditing = YES;
                [self presentViewController:pickerImage animated:YES completion:nil];
            }
        }
            break;
        case 1:{
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                pickerImage.delegate = self;
                pickerImage.allowsEditing = YES;
                [self presentViewController:pickerImage animated:YES completion:nil];
            }
        }
        default:
            break;
    }

}

#pragma mark ------pickviewcontroller代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.addImageButton setImage:image forState:UIControlStateNormal];
    self.hasImage = YES;
}

#pragma mark ------combox代理
- (void)selectAtIndex:(NSInteger)index inCombox:(SHGComBoxView *)combox
{
    if ([combox isEqual:self.firstCategoryBox]) {
        NSMutableArray *titleArray = [NSMutableArray array];
        SHGMarketFirstCategoryObject *firstObject = [self.categoryArray objectAtIndex:index];
        NSArray *secondArray = firstObject.secondCataLogs;
        if (secondArray.count == 0) {
            self.secondCategoryBox.userInteractionEnabled = NO;
        } else{
            self.secondCategoryBox.userInteractionEnabled = YES;
        }
        [secondArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SHGMarketSecondCategoryObject *object = (SHGMarketSecondCategoryObject *)obj;
            [titleArray addObject:object.catalogName];
        }];
        self.secondCategoryBox.titlesList = titleArray;
        [self.secondCategoryBox reloadData];

        if (self.object) {
            NSInteger secondIndex = [titleArray indexOfObject:self.object.secondcatalog];
            self.secondCategoryBox.defaultIndex = secondIndex;
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
