//
//  CircleSendViewController.m
//  Finance
//
//  Created by HuMin on 15/4/16.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//


#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#import "CircleSendViewController.h"
#import "CCLocationManager.h"
#import "TWEmojiKeyBoard.h"

#define MAX_TEXT_LENGTH         2000

@interface CircleSendViewController ()
{
    UIButton *leftButton;
    UIButton *rightButton;
    UITextField *tf;
    
    UIButton *btnTakePic1;
    UIButton *addbtnTakePic;//添加图片
    
    BOOL isEmojiKeyBoard;
    TWEmojiKeyBoard *keyBoard;//自定义键盘
}
@property (strong, nonatomic)  UILabel *lblRemain;
@property (strong, nonatomic)  UILabel *lblRemain1;

@property (weak, nonatomic) IBOutlet UIView *imageBackView;
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (weak, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet CPTextViewPlaceholder *textEdit;

@property (strong, nonatomic) NSMutableArray *imageArr;
@property (strong, nonatomic) NSString *cityName;
@property (assign, nonatomic) CGFloat imageWidth;
@property (assign, nonatomic) CGFloat imageMargin;
@end


@implementation CircleSendViewController
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        self.title = @"发帖";
    }
    return  self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    isEmojiKeyBoard = NO;
    
    self.listTable.tag = 1001;
    self.textEdit.tag = 1002;
    
    [self registerForKeyboardNotifications];
    self.listTable.tableHeaderView = self.tableHeaderView;
    [CommonMethod setExtraCellLineHidden:self.listTable];
    
    self.cityName = [SHGGloble sharedGloble].cityName;
}


- (void)registerForKeyboardNotifications
{
    //使用NSNotificationCenter 键盘出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    //使用NSNotificationCenter 键盘隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    
}
-(void)keyboardWasShown:(NSNotification *)noti
{
    NSDictionary *info = [noti userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGPoint keyboardOrigin = [value CGRectValue].origin;
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSLog(@"keyBoard:%f", keyboardSize.height);

    [UIView beginAnimations:nil context:nil];
    self.textEdit.height = 80;
    if(!kIsScreen3_5Inch){
        self.imageBackView.origin = CGPointMake(self.imageBackView.origin.x, CGRectGetMaxY(self.textEdit.frame)) ;
    }else{
        self.imageBackView.origin = CGPointMake(self.imageBackView.origin.x, keyboardOrigin.y - 100.0f) ;
    }
    [UIView setAnimationDuration:0.2];
    
    [UIView commitAnimations];
}

-(void)keyboardWillBeHidden:(NSNotification *)noti
{
    [UIView beginAnimations:nil context:nil];
    self.imageBackView.origin = CGPointMake(CGRectGetMinX(self.imageBackView.frame), CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.imageBackView.frame) - 40.0f);
    
    self.textEdit.height = CGRectGetMinY(self.imageBackView.frame);
    [UIView setAnimationDuration:0.2];
    
    [UIView commitAnimations];
    
}

-(void)loadImageView
{
    for(UIView *view in self.imageBackView.subviews){
        if([view isKindOfClass:[UIImageView class]]){
            [view removeFromSuperview];
        }
    }
    
    NSInteger orginY = 0.0f;
    if (self.imageArr.count == 0){
        addbtnTakePic.hidden = NO;
        UIImage *crossImage = [UIImage imageNamed:@"添加图片1"];
        CGSize crossImageSize = crossImage.size;
        btnTakePic1.frame = CGRectMake(self.imageMargin, self.imageMargin + self.imageWidth, crossImageSize.width, crossImageSize.height);
        return;
    }
    addbtnTakePic.hidden = YES;
    for (int i = 0; i < self.imageArr.count ; i ++){
        if (i < 4) {
            orginY = self.imageMargin + self.imageWidth;
        } else{
            orginY = self.imageMargin / 2.0f;
        }
        
        RecommendTypeObj *obj = self.imageArr[i];
        if ([obj isKindOfClass:[RecommendTypeObj class]]){
            UIImageView *viewRecommend = [[UIImageView alloc] init];
            CGRect frame = CGRectZero;
            viewRecommend.frame = frame;
            viewRecommend.tag = 200 + i;
            viewRecommend.image = obj.image;
            UILongPressGestureRecognizer *longTapGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTap:)];
            longTapGes.minimumPressDuration = 0.4;
            viewRecommend.userInteractionEnabled = YES;
            [viewRecommend addGestureRecognizer:longTapGes];
            [self.imageBackView addSubview:viewRecommend];
            if(self.imageArr.count < 4){
                frame = CGRectMake((self.imageMargin + self.imageWidth) * (i % 4) + self.imageMargin, orginY, self.imageWidth, self.imageWidth);
                viewRecommend.frame = frame;
            } else{
                frame = CGRectMake((self.imageMargin + self.imageWidth) * (i % 4) + self.imageMargin, i < 4?self.imageMargin / 2.0f:self.imageMargin + self.imageWidth, self.imageWidth, self.imageWidth);
                viewRecommend.frame = frame;
            }
            
            //更改+号位置
            frame = btnTakePic1.frame;
            frame.origin.x = (self.imageMargin + self.imageWidth) * ((i + 1) % 4) + self.imageMargin;
            btnTakePic1.frame = frame;
            
        }
        
    }
}

-(void)longTap:(UILongPressGestureRecognizer *)ges
{
    if([self.textEdit isFirstResponder]){
        [self.textEdit resignFirstResponder];
    }
    if(ges.state == UIGestureRecognizerStateBegan){
        UIView *view = ges.view;
        UIActionSheet *deleteAction = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
        deleteAction.tag = view.tag;
        [deleteAction showInView:self.view];
    }
}
-(void)initUI
{
    self.textEdit.placeholder = @"来说点什么吧…";
    self.textEdit.placeholderColor = RGB(207, 207, 207);
    
    //键盘出来
    //背景view
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 40)];
    customView.backgroundColor = [UIColor whiteColor];
    self.textEdit.inputAccessoryView = customView;
    
    //添加图片
    UIImage *crossImage = [UIImage imageNamed:@"添加图片1"];
    CGSize crossImageSize = crossImage.size;
    self.imageWidth = crossImageSize.width;
    self.imageMargin = (SCREENWIDTH - 4.0f * self.imageWidth) / 5.0f;
    
    btnTakePic1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTakePic1.frame = CGRectMake(self.imageMargin, self.imageMargin + self.imageWidth, crossImageSize.width, crossImageSize.height);
    [btnTakePic1 setBackgroundImage: crossImage forState:UIControlStateNormal];
    [btnTakePic1 addTarget:self action:@selector(tabkePic) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBackView addSubview:btnTakePic1];
    
    //文字描述“添加图片”
    addbtnTakePic = [UIButton buttonWithType:UIButtonTypeCustom];
    [addbtnTakePic setTitle:@"添加图片" forState:UIControlStateNormal];
    [addbtnTakePic.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [addbtnTakePic sizeToFit];
    CGRect frame = addbtnTakePic.frame;
    frame.origin.x = self.imageMargin + CGRectGetMaxX(btnTakePic1.frame);
    frame.origin.y = (crossImageSize.height - frame.size.height) / 2.0f + self.imageMargin + self.imageWidth;
    addbtnTakePic.frame = frame;
    
    [addbtnTakePic setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [addbtnTakePic addTarget:self action:@selector(tabkePic) forControlEvents:UIControlEventTouchUpInside];
    [self.imageBackView addSubview:addbtnTakePic];
    //表情
    UIButton *butExpression = [UIButton buttonWithType:UIButtonTypeCustom];
    [butExpression setBackgroundImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
    [butExpression addTarget:self action:@selector(Expression:) forControlEvents:UIControlEventTouchUpInside];
    [butExpression sizeToFit];
    butExpression.origin = CGPointMake(20.0f, (CGRectGetHeight(customView.frame) - CGRectGetHeight(butExpression.frame)) / 2.0f);
    [customView addSubview:butExpression];
    //链接
    UIButton *butLink = [UIButton buttonWithType:UIButtonTypeCustom];
    [butLink setBackgroundImage:[UIImage imageNamed:@"url"] forState:UIControlStateNormal];
    [butLink addTarget:self action:@selector(Link) forControlEvents:UIControlEventTouchUpInside];
    [butLink sizeToFit];
    butLink.origin = CGPointMake(60.0f, (CGRectGetHeight(customView.frame) - CGRectGetHeight(butLink.frame)) / 2.0f);
    [customView addSubview:butLink];
    //计算数字
    self.lblRemain = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-15-80, 10, 80, 20)];
    [self.lblRemain setFont:[UIFont systemFontOfSize:13]];
    [self.lblRemain setTextColor:TEXT_COLOR];
    [self.lblRemain setText:@"0/2000"];
    [self.lblRemain sizeToFit];
    self.lblRemain.origin = CGPointMake(SCREENWIDTH - 95.0f, (CGRectGetHeight(customView.frame) - CGRectGetHeight(self.lblRemain.frame)) / 2.0f);
    self.lblRemain.textAlignment = NSTextAlignmentRight;
    self.lblRemain.backgroundColor = [UIColor whiteColor];
    [customView addSubview:self.lblRemain];
    
    //topline
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(customView.frame), 1.0f)];
    topLine.backgroundColor = RGBA(60.0f, 60.0f, 60.0f, 0.2f);
    [customView addSubview:topLine];
    
    //bottomline
    UILabel *bottomline = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, CGRectGetHeight(customView.frame) - 1.0f, CGRectGetWidth(customView.frame), 1.0f)];
    bottomline.backgroundColor = RGBA(60.0f, 60.0f, 60.0f, 0.2f);
    [customView addSubview:bottomline];
    
    
    
    //键盘消失
    UIView *customView1 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT-64-40, SCREENWIDTH, 40)];
    customView1.backgroundColor = [UIColor whiteColor];
    //顶端横线
    UILabel *topLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(customView1.frame), 1.0f)];
    topLine1.backgroundColor = RGBA(60.0f, 60.0f, 60.0f, 0.2f);
    [customView1 addSubview:topLine1];
    //表情
    UIButton *butExpression1 = [UIButton buttonWithType:UIButtonTypeCustom];
    butExpression1.frame = CGRectMake(20, 5, 30, 30);
    [butExpression1 setBackgroundImage:[UIImage imageNamed:@"表情"] forState:UIControlStateNormal];
    [butExpression1 addTarget:self action:@selector(Expression:) forControlEvents:UIControlEventTouchUpInside];
    [customView1 addSubview:butExpression1];
    //链接
    UIButton *butLink1 = [UIButton buttonWithType:UIButtonTypeCustom];
    butLink1.frame = CGRectMake(60, 5, 30, 30);
    [butLink1 setBackgroundImage:[UIImage imageNamed:@"url"] forState:UIControlStateNormal];
    [butLink1 addTarget:self action:@selector(Link) forControlEvents:UIControlEventTouchUpInside];
    [customView1 addSubview:butLink1];
    //计算字数
    self.lblRemain1 = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH-15-80, 10, 80, 20)];
    self.lblRemain1.textAlignment = NSTextAlignmentRight;
    self.lblRemain1.backgroundColor = [UIColor whiteColor];
    [self.lblRemain1 setFont:[UIFont systemFontOfSize:13]];
    [self.lblRemain1 setTextColor:TEXT_COLOR];
    [self.lblRemain1 setText:@"0/2000"];
    [customView1 addSubview:self.lblRemain1];
    [self.view addSubview:customView1];
    
    //左侧导航按钮
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 44, 44)];
    [leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [leftButton setTitleColor:RGB(255, 0, 40) forState:UIControlStateNormal];
    [leftButton.titleLabel setFont:[UIFont fontWithName:@"Palatino" size:17]];
    [leftButton addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    //右侧导航按钮
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [rightButton setTitleColor:RGB(255, 0, 40) forState:UIControlStateNormal];
    [rightButton.titleLabel setFont:[UIFont fontWithName:@"Palatino" size:17]];
    [rightButton addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

    
}

#pragma mark -- sdc
#pragma mark -- 取消按钮
-(void)btnBackClick:(id)sender
{
    [self.textEdit resignFirstResponder];
    DXAlertView *alertView = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"退出此次编辑?" leftButtonTitle:@"取消" rightButtonTitle:@"退出"];
    alertView.rightBlock = ^{
        [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:@(YES) afterDelay:0.25f];
    };
    [alertView show];
}
#pragma mark -- sdc
#pragma mark -- 表情
- (void)Expression:(UIButton *)sender{
    NSLog(@"表情包");
    [self.textEdit resignFirstResponder];
    
    if (!isEmojiKeyBoard)
    {
        isEmojiKeyBoard=YES;
        if (!keyBoard)
        {
            keyBoard=[[TWEmojiKeyBoard alloc]init];
            [keyBoard createEmojiKeyBoard];
        }
        [keyBoard bindKeyBoardWithTextField:self.textEdit];
    } else{
        [keyBoard unbindKeyBoard];
        isEmojiKeyBoard = NO;
    }
    
    [self.textEdit becomeFirstResponder];
}
#pragma mark -- sdc
#pragma mark -- 链接
- (void)Link{
    NSLog(@"链接");
    [self.textEdit resignFirstResponder];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"将您复制的信息粘贴在此" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    
    tf = [alertView textFieldAtIndex:0];
    tf.placeholder = @"粘贴地址";
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        return;
    } else {
        [self.textEdit insertText:tf.text];
    }
    if (alertView.tag == 100){
        if (buttonIndex == 1){
            NSLog(@"1");
        }
    }
}
#pragma mark -- sdc
#pragma mark -- 选择图片
-(void)tabkePic
{
    int imageCount = 0;
    if (self.imageArr.count > 0)
    {
        for (RecommendTypeObj *obj in self.imageArr)
        {
            if (obj.type == RECOMMENDPICOBJTYPEPIC)
            {
                imageCount ++;
            }
        }
        if (imageCount >= 6)
        {
            [Hud showMessageWithText:@"图片不能超过6张"];
            
            return;
        }
    }
    [self.textEdit resignFirstResponder];
    UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"选图", nil];
    takeSheet.tag = 1000;
    [takeSheet showInView:self.view];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1001)
    {
        [self.textEdit resignFirstResponder];
    }
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGes.cancelsTouchesInView = YES;
}

- (void)viewTapped:(UITapGestureRecognizer *)tapGes
{
    [self.view endEditing:YES];
    [self.textEdit removeGestureRecognizer:tapGes];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ( ![text isEqualToString:@""] && textView.text.length + text.length > MAX_TEXT_LENGTH){
        [Hud showMessageWithText:@"帖子过长，不能超过2000个字"];
        return NO;
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    self.lblRemain.text = [NSString stringWithFormat:@"%lu/2000",(unsigned long)textView.text.length ];
    if (textView.text.length > 2000)
    {
        self.lblRemain.textColor = RGB(255, 57, 67);
        self.lblRemain1.textColor = RGB(255, 57, 67);
        
    }
    else
    {
        self.lblRemain.textColor = TEXT_COLOR;
        self.lblRemain1.textColor = TEXT_COLOR;
        
    }
    self.lblRemain1.text = [NSString stringWithFormat:@"%lu/2000",(unsigned long)textView.text.length];
    [self.lblRemain sizeToFit];
    [self.lblRemain1 sizeToFit];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1000) {
        if (buttonIndex == 0)
        {
            NSLog(@"拍照");
            [self cameraClick];
        }
        else if (buttonIndex == 1)
        {
            NSLog(@"选图");
            [self photosClick];
        }
        else if (buttonIndex == 2)
        {
            NSLog(@"取消");
        }
    }
    else
    {
        if (buttonIndex == 0) {
            [self.imageArr removeObjectAtIndex:actionSheet.tag -200];
            [self loadImageView];
        }
    }
}

-(void)rightItemClick:(id)sender
{
    
    NSLog(@"send");
    [self.view endEditing:YES];
    [self.textEdit resignFirstResponder];
    if ((self.imageArr.count == 0 && self.textEdit.text.validLength.length == 0))
    {
        [Hud showMessageWithText:@"说点什么吧"];
        return;
    }
    if (self.textEdit.text.length > MAX_TEXT_LENGTH)
    {
        [Hud showMessageWithText:@"帖子过长，不能超过2000个字"];
        
        return;
    }
    //把发送按钮的变成不可点
    rightButton.userInteractionEnabled = NO;
    [Hud showLoadingWithMessage:@"正在发帖……"];
    
    if (self.imageArr.count == 0)
    {
        //无图片
        [self sendPostWithPohots:nil];
    }
    else
    {
        [[AFHTTPRequestOperationManager manager] POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/base"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            for (int i = 0; i < self.imageArr.count; i++)
            {
                RecommendTypeObj *obj = self.imageArr[i];
                NSData *imgData = obj.content;
                [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"%d.jpg",i+1] fileName:[NSString stringWithFormat:@"%d.jpg",i] mimeType:@"image/jpeg"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"p");
            id data = [responseObject valueForKey:@"data"];
            NSData *datas =    [data dataUsingEncoding:NSASCIIStringEncoding];
            id json = [self toArrayOrNSDictionary:datas];
            
            id pname = [json valueForKey:@"pname"];
            // 将JSON串转化为字典或者数组
            // NSString *str1 = [responseObject JSONString];
            [self sendPostWithPohots:pname];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"f");
            [Hud hideHud];
            [Hud showMessageWithText:error.domain];
        }];
    }
}

- (id)toArrayOrNSDictionary:(NSData *)jsonData{
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil)
    {
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
    
}
#pragma mark -- sdc
#pragma mark -- 发帖请求
-(void)sendPostWithPohots:(NSArray *)photos
{
    NSString *uid = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_UID];
    NSDictionary *param;
    if (!IsArrEmpty(photos))
    {
        NSString *photoStr = [photos componentsJoinedByString:@","];
        NSString *size = @"";
        for (RecommendTypeObj *obj in self.imageArr)
        {
            UIImage *image = [UIImage imageWithData:obj.content];
            int width = (int)image.size.width;
            int height = (int)image.size.height;
            
            NSString *imageSize = [NSString stringWithFormat:@"%d*%d",width,height];
            size = [NSString stringWithFormat:@"%@,%@",size,imageSize];
        }
        size = [size substringFromIndex:1];
        param  = @{@"uid":uid,
                   @"detail":self.textEdit.text,
                   @"photos":photoStr?:@"",
                   @"type":@"photo",
                   @"sizes":size,
                   @"currCity":self.cityName};
    }
    else
    {
        param = @{@"uid":uid,
                  @"detail":self.textEdit.text,
                  @"type":@"",
                  @"sizes":@"",
                  @"currCity":self.cityName};
    }
    
    [MOCHTTPRequestOperationManager postWithURL:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttpCircle,actioncircle] class:nil parameters:param success:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        id code = [response.data valueForKey:@"code"];
        NSLog(@"ss");
        if ([code intValue] == 0)
        {
            [Hud showMessageWithText:@"发帖成功"];
            [MobClick event:@"ActionPost" label:@"onClick"];
            [self performSelector:@selector(popView) withObject:nil afterDelay:1.0];
        }
    } failed:^(MOCHTTPResponse *response) {
        [Hud hideHud];
        [Hud showMessageWithText:response.errorMessage];
    }];
}

-(void)popView
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFI_SENDPOST object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  0.1;
}


- (void)btnDeleteFileClick:(UIButton *)sender
{
    [self.imageArr removeObjectAtIndex:sender.tag-200];
    [self.listTable reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(NSMutableArray *)imageArr
{
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

-(void)cameraClick
{
    
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
    }
    pickerImage.delegate = self;
    [self presentViewController:pickerImage animated:YES completion:nil];
}
-(void)photosClick
{
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 6-self.imageArr.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate=self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings)
    {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
        {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}
//相册
#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (NSInteger i=0; i < assets.count; i++){
            ALAsset *asset = assets[i];
            UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage scale:asset.defaultRepresentation.scale orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
            
            if (tempImg){
                CGSize size = CGSizeMake(70, 70);
                UIImage *imageNew = [tempImg reSizeImagetoSize:CGSizeMake(size.width*2, size.height*2)];
                NSData *dataImage = UIImageJPEGRepresentation(tempImg, 1.0);//压缩
                RecommendTypeObj *detailObj = [[RecommendTypeObj alloc] init];
                detailObj.image = imageNew;
                detailObj.type = RECOMMENDPICOBJTYPEPIC;
                detailObj.content = dataImage;
                [self.imageArr addObject:detailObj];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadImageView];
        });
        
    });
}

//点击相册中的图片 或照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //拍照对图片尺寸进行设置
    if(picker.sourceType==UIImagePickerControllerSourceTypeCamera)
    {
        CGSize imagesize = image.size;
        imagesize.width /=2;
        imagesize.height /=2;
        //对图片大小进行压缩
        image = [image reSizeImagetoFillWidth:imagesize];
    }
    
    if (image) {
        CGSize size = CGSizeMake(70, 70);
        UIImage *imageNew = [image reSizeImagetoSize:CGSizeMake(size.width*2, size.height*2)];
        
        UIImage *imageData = [UIImage fixOrientation:image];
        NSData *dataImage = UIImageJPEGRepresentation(imageData, 0.032);//压缩
        
        RecommendTypeObj *detailObj = [[RecommendTypeObj alloc] init];
        detailObj.image = [UIImage fixOrientation:imageNew];;
        detailObj.type = RECOMMENDPICOBJTYPEPIC;
        detailObj.content = dataImage;
        [self.imageArr addObject:detailObj];
        
        [self loadImageView];
    }
    
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
