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
#import "SHGItemChooseView.h"
#import "UIButton+EnlargeEdge.h"
#import "EMTextView.h"

typedef NS_ENUM(NSInteger, SHGMarketSendType){
    SHGMarketSendTypeNew = 0,
    SHGMarketSendTypeReSet = 1
};

@interface SHGMarketSendViewController ()<UITextFieldDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, SHGComBoxViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SHGItemChooseDelegate>

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet SHGComBoxView *firstCategoryBox;
@property (weak, nonatomic) IBOutlet SHGComBoxView *secondCategoryBox;

@property (weak, nonatomic) IBOutlet UITextField *marketNameField;
@property (weak, nonatomic) IBOutlet UITextField *acountField;
@property (weak, nonatomic) IBOutlet UITextField *contactField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UIImageView *starView1;
@property (weak, nonatomic) IBOutlet UIImageView *starView2;
@property (weak, nonatomic) IBOutlet UIImageView *starView3;
@property (weak, nonatomic) IBOutlet UILabel *yuanLabel;

@property (weak, nonatomic) IBOutlet UILabel *modelLabel;
@property (weak, nonatomic) IBOutlet UIView *modelContentView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIView *breakView;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@property (weak, nonatomic) IBOutlet EMTextView *introduceView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) id currentContext;
@property (assign, nonatomic) CGFloat keyBoardOrginY;
@property (assign, nonatomic) SHGMarketSendType sendType;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UILabel *addImageLabel;
@property (weak, nonatomic) IBOutlet UIButton *anonymousButton;
@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSString *imageName;
@property (assign, nonatomic) BOOL hasImage;

@property (strong, nonatomic) NSString *mode;

@end

@implementation SHGMarketSendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"发布业务信息";
    self.sendType = SHGMarketSendTypeNew;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [tapGes setCancelsTouchesInView:NO];
    [self.bgView addGestureRecognizer:tapGes];
    __weak typeof(self)weakSelf = self;
    [[SHGMarketManager shareManager] userListArray:^(NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.categoryArray = [NSMutableArray arrayWithArray:array];
            NSMutableArray *titleArray = [NSMutableArray array];
            [weakSelf.categoryArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SHGMarketFirstCategoryObject *object = (SHGMarketFirstCategoryObject *)obj;
                [titleArray addObject:object.firstCatalogName];
            }];
            weakSelf.firstCategoryBox.titlesList = titleArray;
            [weakSelf.firstCategoryBox reloadData];

            if (weakSelf.object) {
                weakSelf.title = @"编辑业务信息";
                [weakSelf editObject:self.object];
                weakSelf.sendType = SHGMarketSendTypeReSet;
            }
        });
    }];

    [self initView];
    [self addAutoLayout];

    [self.bgView layoutSubviews];
    [self.tableView setTableHeaderView:self.bgView];
}

- (void)initView
{
    self.marketNameField.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    self.marketNameField.layer.masksToBounds = YES;
    self.marketNameField.layer.cornerRadius = 3.0f;
    self.marketNameField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 0.0f)];
    self.marketNameField.leftViewMode = UITextFieldViewModeAlways;
    [self.marketNameField setValue:[UIColor colorWithHexString:@"D3D3D3"] forKeyPath:@"_placeholderLabel.textColor"];

    self.acountField.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    self.acountField.layer.masksToBounds = YES;
    self.acountField.layer.cornerRadius = 3.0f;
    self.acountField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 0.0f)];
    self.acountField.leftViewMode = UITextFieldViewModeAlways;
    [self.acountField setValue:[UIColor colorWithHexString:@"D3D3D3"] forKeyPath:@"_placeholderLabel.textColor"];

    self.yuanLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    [self.yuanLabel sizeToFit];

    self.contactField.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    self.contactField.layer.masksToBounds = YES;
    self.contactField.layer.cornerRadius = 3.0f;
    self.contactField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 0.0f)];
    self.contactField.leftViewMode = UITextFieldViewModeAlways;
    [self.contactField setValue:[UIColor colorWithHexString:@"D3D3D3"] forKeyPath:@"_placeholderLabel.textColor"];

    self.locationField.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    self.locationField.layer.masksToBounds = YES;
    self.locationField.layer.cornerRadius = 3.0f;
    self.locationField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 0.0f)];
    self.locationField.leftViewMode = UITextFieldViewModeAlways;
    [self.locationField setValue:[UIColor colorWithHexString:@"D3D3D3"] forKeyPath:@"_placeholderLabel.textColor"];

    [self.starView1 sizeToFit];
    [self.starView2 sizeToFit];
    [self.starView3 sizeToFit];

    self.modelLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];

    self.modelContentView.layer.masksToBounds = YES;
    self.modelContentView.layer.cornerRadius = 3.0f;
    self.modelContentView.layer.borderColor = [UIColor colorWithHexString:@"e1e1e6"].CGColor;
    self.modelContentView.layer.borderWidth = 0.5f;
    self.breakView.backgroundColor = [UIColor colorWithHexString:@"e1e1e6"];
    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:FontFactor(13.0f)];
    [self.leftButton setTitleColor:[UIColor colorWithHexString:@"b3b3b3"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor colorWithHexString:@"d43c33"] forState:UIControlStateSelected];
    self.leftButton.selected = YES;
    self.mode = self.leftButton.titleLabel.text;

    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:FontFactor(13.0f)];
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"b3b3b3"] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"d43c33"] forState:UIControlStateSelected];

    self.introduceLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];

    self.introduceView.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    self.introduceView.placeholder = @" 描述您的业务详细信息";
    self.introduceView.placeholderColor = [UIColor colorWithHexString:@"d3d3d3"];
    self.introduceView.layer.masksToBounds = YES;
    self.introduceView.layer.cornerRadius = 3.0f;

    [self.addImageButton sizeToFit];

    self.addImageLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];

    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:FontFactor(15.0f)];

    self.anonymousButton.titleLabel.font = [UIFont systemFontOfSize:FontFactor(11.0f)];
    [self.anonymousButton setEnlargeEdge: 20.0f];
    [self.anonymousButton setImage:[UIImage imageNamed:@"market_select"] forState:UIControlStateSelected];
    [self.anonymousButton setImage:[UIImage imageNamed:@"market_unselect"] forState:UIControlStateNormal];
    [self.anonymousButton sizeToFit];

    [self initBoxView];
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

- (void)addAutoLayout
{
    CGSize starSize = self.starView1.frame.size;

    self.tableView.sd_layout
    .leftSpaceToView(self.view, 0.0f)
    .rightSpaceToView(self.view, 0.0f)
    .bottomSpaceToView(self.view, 0.0f)
    .topSpaceToView(self.view, 0.0f);

    self.firstCategoryBox.sd_layout
    .topSpaceToView(self.bgView, MarginFactor(15.0f))
    .leftSpaceToView(self.bgView, MarginFactor(12.0f))
    .heightIs(MarginFactor(35.0f))
    .widthIs(MarginFactor(155.0f));

    self.marketNameField.sd_layout
    .leftEqualToView(self.firstCategoryBox)
    .topSpaceToView(self.firstCategoryBox, MarginFactor(15.0f))
    .widthIs(MarginFactor(320.0f))
    .heightIs(MarginFactor(35.0f));

    self.secondCategoryBox.sd_layout
    .topSpaceToView(self.bgView, MarginFactor(15.0f))
    .rightEqualToView(self.marketNameField)
    .heightIs(MarginFactor(35.0f))
    .widthIs(MarginFactor(155.0f));
    
    self.starView1.sd_layout
    .centerYEqualToView(self.marketNameField)
    .centerXIs((SCREENWIDTH - CGRectGetMaxX(self.marketNameField.frame)) / 2.0f + CGRectGetMaxX(self.marketNameField.frame))
    .widthIs(starSize.width)
    .heightIs(starSize.height);

    self.acountField.sd_layout
    .leftEqualToView(self.firstCategoryBox)
    .topSpaceToView(self.marketNameField, MarginFactor(15.0f))
    .widthRatioToView(self.marketNameField, 1.0f)
    .heightRatioToView(self.marketNameField, 1.0f);

    CGSize labelSize = self.yuanLabel.frame.size;
    self.yuanLabel.sd_layout
    .centerYEqualToView(self.acountField)
    .centerXEqualToView(self.starView1)
    .widthIs(labelSize.width)
    .heightIs(labelSize.height);

    self.contactField.sd_layout
    .leftEqualToView(self.firstCategoryBox)
    .topSpaceToView(self.acountField, MarginFactor(15.0f))
    .widthRatioToView(self.marketNameField, 1.0f)
    .heightRatioToView(self.marketNameField, 1.0f);

    self.starView2.sd_layout
    .centerYEqualToView(self.contactField)
    .centerXEqualToView(self.starView1)
    .widthIs(starSize.width)
    .heightIs(starSize.height);

    self.locationField.sd_layout
    .leftEqualToView(self.firstCategoryBox)
    .topSpaceToView(self.contactField, MarginFactor(15.0f))
    .widthRatioToView(self.marketNameField, 1.0f)
    .heightRatioToView(self.marketNameField, 1.0f);

    self.starView3.sd_layout
    .centerYEqualToView(self.locationField)
    .centerXEqualToView(self.starView1)
    .widthIs(starSize.width)
    .heightIs(starSize.height);
    
    [self.modelLabel sizeToFit];
    CGSize modelSize = self.modelLabel.frame.size;
    self.modelLabel.sd_layout
    .topSpaceToView(self.locationField, MarginFactor(24.0f))
    .leftEqualToView(self.locationField)
    .widthIs(modelSize.width)
    .heightIs(modelSize.height);

    self.modelContentView.sd_layout
    .leftEqualToView(self.firstCategoryBox)
    .topSpaceToView(self.modelLabel, MarginFactor(12.0f))
    .rightSpaceToView(self.bgView, MarginFactor(12.0f))
    .heightIs(MarginFactor(35.0f));

    self.breakView.sd_layout
    .heightIs(MarginFactor(25.0f))
    .widthIs(0.5f)
    .centerYEqualToView(self.modelContentView)
    .centerXEqualToView(self.modelContentView);

    self.leftButton.sd_layout
    .leftSpaceToView(self.modelContentView, 0.0f)
    .topSpaceToView(self.modelContentView, 0.0f)
    .rightSpaceToView(self.breakView, 0.0f)
    .heightRatioToView(self.modelContentView, 1.0f);

    self.rightButton.sd_layout
    .leftSpaceToView(self.breakView, 0.0f)
    .topSpaceToView(self.modelContentView, 0.0f)
    .rightSpaceToView(self.modelContentView, 0.0f)
    .heightRatioToView(self.modelContentView, 1.0f);

    [self.introduceLabel sizeToFit];
    CGSize introduceSize = self.introduceLabel.frame.size;
    self.introduceLabel.sd_layout
    .topSpaceToView(self.modelContentView, MarginFactor(24.0f))
    .leftEqualToView(self.modelLabel)
    .widthIs(introduceSize.width)
    .heightIs(introduceSize.height);

    self.introduceView.sd_layout
    .leftEqualToView(self.firstCategoryBox)
    .topSpaceToView(self.introduceLabel, MarginFactor(12.0f))
    .rightEqualToView(self.modelContentView)
    .heightIs(MarginFactor(137.0f));

    CGSize plusSize = self.addImageButton.frame.size;
    self.addImageButton.sd_layout
    .topSpaceToView(self.introduceView, MarginFactor(12.0f))
    .leftSpaceToView(self.bgView, MarginFactor(15.0f))
    .widthIs(plusSize.width)
    .heightIs(plusSize.height);

    self.addImageLabel.sd_layout
    .leftSpaceToView(self.addImageButton, MarginFactor(12.0f))
    .centerYEqualToView(self.addImageButton)
    .autoHeightRatio(0.0f);
    [self.addImageLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.nextButton.sd_layout
    .leftEqualToView(self.firstCategoryBox)
    .topSpaceToView(self.addImageButton, MarginFactor(12.0f))
    .rightEqualToView(self.modelContentView)
    .heightIs(MarginFactor(40.0f));

    CGSize anonymousSize = self.anonymousButton.frame.size;
    self.anonymousButton.sd_layout
    .topSpaceToView(self.nextButton, MarginFactor(12.0f))
    .leftEqualToView(self.firstCategoryBox)
    .widthIs(anonymousSize.width)
    .heightIs(anonymousSize.height);


    [self.bgView setupAutoHeightWithBottomView:self.anonymousButton bottomMargin:MarginFactor(65.0f)];
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
    if ([object.anonymous isEqualToString:@"1"]){
        self.anonymousButton.selected = YES;
    } else{
        self.anonymousButton.selected = NO;
    }
    if ([object.mode isEqualToString:self.leftButton.titleLabel.text]) {
        self.leftButton.selected = YES;
        self.rightButton.selected = NO;
    } else if ([object.mode isEqualToString:self.rightButton.titleLabel.text]) {
        self.leftButton.selected = NO;
        self.rightButton.selected = YES;
    }
    if (object.url && object.url.length > 0) {
        self.hasImage = YES;
        __weak typeof(self) weakSelf = self;
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",rBaseAddressForImage,object.url]] options:SDWebImageRetryFailed|SDWebImageLowPriority progress:^(NSInteger receivedSize, NSInteger expectedSize) {

        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [weakSelf.addImageButton setImage:image forState:UIControlStateNormal];
        }];
    }

}

- (IBAction)clickAnonymousButton:(UIButton *)button
{
    button.selected = !button.selected;
}

- (IBAction)leftButtonClick:(UIButton *)sender
{
    sender.selected = YES;
    self.rightButton.selected = NO;
    self.mode = sender.titleLabel.text;
}

- (IBAction)rightButtonClick:(UIButton *)sender
{
    sender.selected = YES;
    self.leftButton.selected = NO;
    self.mode = sender.titleLabel.text;
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
    if ([textField isEqual:self.locationField]) {
        [self.currentContext resignFirstResponder];
        [self chooseCity:textField];
        return NO;
    }
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView setContentOffset:point animated:YES];
    });

}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.currentContext = textView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.currentContext resignFirstResponder];
    [self.firstCategoryBox closeOtherCombox];
    [self.secondCategoryBox closeOtherCombox];
}

- (void)textFieldDidChange:(NSNotification *)notification
{
    UITextField *textField = notification.object;
    if ([textField isEqual:self.marketNameField]) {
        if (textField.text.length > 40) {
            textField.text = [textField.text substringToIndex:40];
        }
    } else if ([textField isEqual:self.acountField]) {
        if (textField.text.length > 20){
            textField.text = [textField.text substringToIndex:20];
        }
    } else if ([textField isEqual:self.contactField]) {
        if (textField.text.length > 50) {
            textField.text = [textField.text substringToIndex:50];
        }
    } else if ([textField isEqual:self.locationField]) {
        if (textField.text.length > 50) {
            textField.text = [textField.text substringToIndex:50];
        }
    }
}

- (void)chooseCity:(UITextField *)textField
{

    __weak typeof(self) weakSelf = self;
    [[SHGMarketManager shareManager] loadHotCitys:^(NSArray *array) {
        NSMutableArray *cityArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(SHGMarketCityObject *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [cityArray addObject:obj.cityName];
        }];
        SHGItemChooseView *view = [[SHGItemChooseView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT) lineNumber:cityArray.count];
        view.delegate = weakSelf;
        view.dataArray = cityArray;
        [weakSelf.view.window addSubview:view];
    }];
    
}

- (IBAction)addNewImage:(id)sender
{
    [self.currentContext resignFirstResponder];
    if (!self.hasImage) {
        UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"选图", nil];
        [takeSheet showInView:self.view];
    } else{
        UIActionSheet *takeSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
        [takeSheet showInView:self.view];
    }
}

- (IBAction)nextButtonClick:(id)sender
{
    [self.currentContext resignFirstResponder];
    if ([self checkInputMessage]){
        __weak typeof(self) weakSelf = self;
        [self uploadImage:^(BOOL success) {
            if (success) {
                NSString *anonymous = weakSelf.anonymousButton.isSelected ? @"1" : @"0";
                switch (self.sendType) {
                    case SHGMarketSendTypeNew:{
                        //新建业务
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
                            secondId = secondObject.secondCatalogId;
                        }

                        NSDictionary *param = @{@"uid":uid, @"marketName": marketName, @"firstCatalogId": firstId, @"secondCatalogId": secondId, @"price": price, @"contactInfo": contactInfo, @"detail": detail, @"photo":self.imageName, @"city":city, @"anonymous":anonymous, @"mode":self.mode};
                        NSMutableDictionary *mParam = [NSMutableDictionary dictionaryWithDictionary:param];
                        if (!secondId || secondId.length == 0) {
                            [mParam removeObjectForKey:@"secondCatalogId"];
                        }
                        [SHGMarketManager createNewMarket:mParam success:^(BOOL success) {
                            if (success) {
                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didCreateNewMarket:)]) {
                                    [weakSelf.delegate didCreateNewMarket:firstObject];
                                }
                                [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.2f];
                            }
                        }];
                    }
                        break;

                    default:{
                        //修改业务
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
                            secondId = secondObject.secondCatalogId;
                        }
                        NSDictionary *param = @{@"uid":uid, @"marketName": marketName, @"firstCatalogId": firstId, @"secondCatalogId": secondId, @"price": price, @"contactInfo": contactInfo, @"detail": detail, @"photo":self.imageName, @"city":city, @"marketId":weakSelf.object.marketId, @"anonymous":anonymous, @"mode":self.mode};
                        NSMutableDictionary *mParam = [NSMutableDictionary dictionaryWithDictionary:param];
                        if (!secondId || secondId.length == 0) {
                            [mParam removeObjectForKey:@"secondCatalogId"];
                        }
                        [SHGMarketManager modifyMarket:mParam success:^(BOOL success) {
                            if (success) {
                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didModifyMarket:)]) {
                                    [weakSelf.delegate didModifyMarket:firstObject];
                                }
                                [weakSelf.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@(YES) afterDelay:1.2f];
                            }
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
        [[AFHTTPSessionManager manager] POST:[NSString stringWithFormat:@"%@/%@",rBaseAddressForHttp,@"image/uploadPhotoCompress"] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            NSData *imageData = UIImageJPEGRepresentation(self.addImageButton.imageView.image, 0.1);
            [formData appendPartWithFileData:imageData name:@"market.jpg" fileName:@"market.jpg" mimeType:@"image/jpeg"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {

        } success:^(NSURLSessionDataTask *operation, id responseObject) {
            NSLog(@"%@",responseObject);
            [Hud hideHud];
            NSDictionary *dic = [(NSString *)[responseObject valueForKey:@"data"] parseToArrayOrNSDictionary];
            weakSelf.imageName = [(NSArray *)[dic valueForKey:@"pname"] objectAtIndex:0];
            block(YES);
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            NSLog(@"%@",error);
            [Hud hideHud];
            [Hud showMessageWithText:@"上传图片失败"];
        }];
    } else{
        self.imageName = @"";
        block(YES);
    }

}

#pragma mark ------选择城市代理
- (void)didSelectItem:(NSString *)item
{
    self.locationField.text = item;
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark ------actionSheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"拍照"]) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;
            [self presentViewController:pickerImage animated:YES completion:nil];
        }
    } else if ([title isEqualToString:@"选图"]){
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;
            [self presentViewController:pickerImage animated:YES completion:nil];
        }
    } else if ([title isEqualToString:@"删除"]){
        self.hasImage = NO;
        [self.addImageButton setImage:[UIImage imageNamed:@"addImageButton"] forState:UIControlStateNormal];
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
            self.secondCategoryBox.hidden = YES;
        } else{
            self.secondCategoryBox.hidden = NO;
        }
        [secondArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SHGMarketSecondCategoryObject *object = (SHGMarketSecondCategoryObject *)obj;
            [titleArray addObject:object.secondCatalogName];
        }];
        self.secondCategoryBox.titlesList = titleArray;
        [self.secondCategoryBox reloadData];

        if (self.object) {
            NSInteger secondIndex = [titleArray indexOfObject:self.object.secondcatalog];
            self.secondCategoryBox.defaultIndex = secondIndex;
        }
    }
}

- (void)tapAction:(UITapGestureRecognizer *)gesture
{
        [self.firstCategoryBox closeOtherCombox];
        [self.secondCategoryBox closeOtherCombox];

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
