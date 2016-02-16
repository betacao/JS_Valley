//
//  SHGMarketAdvancedSearchViewController.m
//  Finance
//
//  Created by changxicao on 16/2/4.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGMarketAdvancedSearchViewController.h"
#import "SHGComBoxView.h"
#import "SHGMarketManager.h"
#import "SHGItemChooseView.h"

@interface SHGMarketAdvancedSearchViewController ()<SHGComBoxViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UIView *firstContentView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIView *leftBreakLine;
@property (weak, nonatomic) IBOutlet UIButton *middleButton;
@property (weak, nonatomic) IBOutlet UIView *rightBreakLine;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIImageView *bottomArrowImage1;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;

@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet SHGComBoxView *leftComBox;
@property (weak, nonatomic) IBOutlet SHGComBoxView *rightCombox;

@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UIView *fourthContentView;
@property (weak, nonatomic) IBOutlet UIView *bottomBreakLine;
@property (weak, nonatomic) IBOutlet UIButton *bottomLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *bottomRightButton;
@property (weak, nonatomic) IBOutlet UIImageView *bottomArrowImage2;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (strong, nonatomic) NSMutableArray *categoryArray;

@end

@implementation SHGMarketAdvancedSearchViewController

- (void)viewDidLoad
{
    self.title = @"更多搜索条件";
    self.leftItemtitleName = @"取消";
    self.rightItemtitleName = @"重置";
    [self initView];
    [self addAutoLayout];

    [super viewDidLoad];
    __weak typeof(self)weakSelf = self;
    [[SHGMarketManager shareManager] userListArray:^(NSArray *array) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.categoryArray = [NSMutableArray arrayWithArray:array];
            NSMutableArray *titleArray = [NSMutableArray array];
            [weakSelf.categoryArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SHGMarketFirstCategoryObject *object = (SHGMarketFirstCategoryObject *)obj;
                [titleArray addObject:object.firstCatalogName];
            }];
            weakSelf.leftComBox.titlesList = titleArray;
            [weakSelf.leftComBox reloadData];
        });
    }];
}

- (void)initView
{
    self.firstLabel.font = [UIFont systemFontOfSize:FontFactor(15.0f)];

    self.firstContentView.layer.masksToBounds = YES;
    self.firstContentView.layer.cornerRadius = 3.0f;
    self.firstContentView.layer.borderColor = [UIColor colorWithHexString:@"e1e1e6"].CGColor;
    self.firstContentView.layer.borderWidth = 0.5f;

    [self.bottomArrowImage1 sizeToFit];

    self.leftButton.titleLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    [self.leftButton setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
    [self.leftButton setTitleColor:[UIColor colorWithHexString:@"d43c33"] forState:UIControlStateSelected];
    self.leftButton.selected = YES;

    self.middleButton.titleLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    [self.middleButton setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
    [self.middleButton setTitleColor:[UIColor colorWithHexString:@"d43c33"] forState:UIControlStateSelected];

    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor colorWithHexString:@"d43c33"] forState:UIControlStateSelected];

    self.secondLabel.font = [UIFont systemFontOfSize:FontFactor(15.0f)];

    self.locationTextField.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    self.locationTextField.layer.masksToBounds = YES;
    self.locationTextField.layer.cornerRadius = 3.0f;
    self.locationTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 5.0f, 0.0f)];
    self.locationTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.locationTextField setValue:[UIColor colorWithHexString:@"D3D3D3"] forKeyPath:@"_placeholderLabel.textColor"];

    self.thirdLabel.font = [UIFont systemFontOfSize:FontFactor(15.0f)];

    self.leftComBox.backgroundColor = [UIColor whiteColor];
    self.leftComBox.delegate = self;
    self.leftComBox.parentView = self.view;

    self.rightCombox.backgroundColor = [UIColor whiteColor];
    self.rightCombox.delegate = self;
    self.rightCombox.parentView = self.view;

    self.fourthLabel.font = [UIFont systemFontOfSize:FontFactor(15.0f)];

    self.fourthContentView.layer.masksToBounds = YES;
    self.fourthContentView.layer.cornerRadius = 3.0f;
    self.fourthContentView.layer.borderColor = [UIColor colorWithHexString:@"e1e1e6"].CGColor;
    self.fourthContentView.layer.borderWidth = 0.5f;

    [self.bottomArrowImage2 sizeToFit];

    self.bottomLeftButton.titleLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    [self.bottomLeftButton setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
    [self.bottomLeftButton setTitleColor:[UIColor colorWithHexString:@"d43c33"] forState:UIControlStateSelected];
    self.bottomLeftButton.selected = YES;

    self.bottomRightButton.titleLabel.font = [UIFont systemFontOfSize:FontFactor(14.0f)];
    [self.bottomRightButton setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
    [self.bottomRightButton setTitleColor:[UIColor colorWithHexString:@"d43c33"] forState:UIControlStateSelected];

    self.searchButton.titleLabel.font = [UIFont systemFontOfSize:FontFactor(17.0f)];
}

- (void)addAutoLayout
{
    self.firstLabel.sd_layout
    .topSpaceToView(self.view, MarginFactor(25.0f))
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.firstLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.firstContentView.sd_layout
    .topSpaceToView(self.firstLabel, MarginFactor(15.0f))
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .heightIs(MarginFactor(35.0f));

    self.leftButton.sd_layout
    .topSpaceToView(self.firstContentView, 0.0f)
    .leftSpaceToView(self.firstContentView, 0.0f)
    .widthRatioToView(self.firstContentView, 1.0f / 3.0f)
    .heightRatioToView(self.firstContentView, 1.0f);

    self.leftBreakLine.sd_layout
    .centerYEqualToView(self.firstContentView)
    .leftSpaceToView(self.leftButton, 0.0f)
    .widthIs(0.5f)
    .heightIs(MarginFactor(20.0f));

    self.middleButton.sd_layout
    .topSpaceToView(self.firstContentView, 0.0f)
    .leftSpaceToView(self.leftBreakLine, 0.0f)
    .widthRatioToView(self.firstContentView, 1.0f / 3.0f)
    .heightRatioToView(self.firstContentView, 1.0f);

    self.rightBreakLine.sd_layout
    .centerYEqualToView(self.firstContentView)
    .leftSpaceToView(self.middleButton, 0.0f)
    .widthIs(0.5f)
    .heightIs(MarginFactor(20.0f));
    
    self.rightButton.sd_layout
    .topSpaceToView(self.firstContentView, 0.0f)
    .leftSpaceToView(self.rightBreakLine, 0.0f)
    .widthRatioToView(self.firstContentView, 1.0f / 3.0f)
    .heightRatioToView(self.firstContentView, 1.0f);

    CGSize size = self.bottomArrowImage1.frame.size;
    self.bottomArrowImage1.sd_layout
    .centerXEqualToView(self.leftButton)
    .bottomSpaceToView(self.firstContentView, MarginFactor(1.0f))
    .widthIs(size.width)
    .heightIs(size.height);

    self.secondLabel.sd_layout
    .topSpaceToView(self.firstContentView, MarginFactor(25.0f))
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.secondLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.locationTextField.sd_layout
    .leftSpaceToView(self.view, 12.0f)
    .topSpaceToView(self.secondLabel, MarginFactor(15.0f))
    .rightSpaceToView(self.view, 12.0f)
    .heightIs(MarginFactor(35.0f));

    self.thirdLabel.sd_layout
    .topSpaceToView(self.locationTextField, MarginFactor(25.0f))
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.thirdLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    CGFloat width = (SCREENWIDTH - 2 * MarginFactor(12.0f) - MarginFactor(18.0f)) / 2.0f;
    self.leftComBox.sd_layout
    .topSpaceToView(self.thirdLabel, MarginFactor(15.0f))
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .heightIs(MarginFactor(35.0f))
    .widthIs(width);

    self.rightCombox.sd_layout
    .topSpaceToView(self.thirdLabel, MarginFactor(15.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .heightIs(MarginFactor(35.0f))
    .widthIs(width);

    self.fourthLabel.sd_layout
    .topSpaceToView(self.leftComBox, MarginFactor(25.0f))
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .autoHeightRatio(0.0f);
    [self.fourthLabel setSingleLineAutoResizeWithMaxWidth:CGFLOAT_MAX];

    self.fourthContentView.sd_layout
    .topSpaceToView(self.fourthLabel, MarginFactor(15.0f))
    .leftSpaceToView(self.view, MarginFactor(12.0f))
    .rightSpaceToView(self.view, MarginFactor(12.0f))
    .heightIs(MarginFactor(35.0f));

    self.bottomBreakLine.sd_layout
    .centerYEqualToView(self.fourthContentView)
    .centerXEqualToView(self.fourthContentView)
    .widthIs(0.5f)
    .heightIs(MarginFactor(20.0f));

    self.bottomLeftButton.sd_layout
    .topSpaceToView(self.fourthContentView, 0.0f)
    .leftSpaceToView(self.fourthContentView, 0.0f)
    .rightSpaceToView(self.bottomBreakLine, 0.0f)
    .heightRatioToView(self.fourthContentView, 1.0f);

    self.bottomRightButton.sd_layout
    .topSpaceToView(self.fourthContentView, 0.0f)
    .leftSpaceToView(self.bottomBreakLine, 0.0f)
    .rightSpaceToView(self.fourthContentView, 0.0f)
    .heightRatioToView(self.fourthContentView, 1.0f);

    self.bottomArrowImage2.sd_layout
    .centerXEqualToView(self.bottomLeftButton)
    .bottomSpaceToView(self.fourthContentView, MarginFactor(1.0f))
    .widthIs(size.width)
    .heightIs(size.height);

    self.searchButton.sd_layout
    .bottomSpaceToView(self.view, 10.0f)
    .leftSpaceToView(self.view, 12.0f)
    .rightSpaceToView(self.view, 12.0f)
    .heightIs(MarginFactor(39.0f));
}

- (IBAction)topButtonsClick:(UIButton *)sender
{
    self.leftButton.selected = NO;
    self.middleButton.selected = NO;
    self.rightButton.selected = NO;
    sender.selected = YES;
    [UIView animateWithDuration:0.25f animations:^{
        self.bottomArrowImage1.sd_layout
        .centerXEqualToView(sender);
        [self.bottomArrowImage1 updateLayout];
    }];

}

- (IBAction)bottomButtonsClick:(UIButton *)sender
{
    self.bottomLeftButton.selected = NO;
    self.bottomRightButton.selected = NO;
    sender.selected = YES;
    [UIView animateWithDuration:0.25f animations:^{
        self.bottomArrowImage2.sd_layout
        .centerXEqualToView(sender);
        [self.bottomArrowImage2 updateLayout];
    }];
}


- (void)rightItemClick:(id)sender
{
    [self topButtonsClick:self.leftButton];
    self.locationTextField.text = @"";

    [self bottomButtonsClick:self.bottomLeftButton];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.locationTextField]) {
        [self chooseCity:textField];
        return NO;
    }
    return YES;
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

#pragma mark ------combox代理
- (void)selectAtIndex:(NSInteger)index inCombox:(SHGComBoxView *)combox
{
    if ([combox isEqual:self.leftComBox]) {
        NSMutableArray *titleArray = [NSMutableArray array];
        SHGMarketFirstCategoryObject *firstObject = [self.categoryArray objectAtIndex:index];
        NSArray *secondArray = firstObject.secondCataLogs;
        if (secondArray.count == 0) {
            self.rightCombox.hidden = YES;
        } else{
            self.rightCombox.hidden = NO;
        }
        [secondArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SHGMarketSecondCategoryObject *object = (SHGMarketSecondCategoryObject *)obj;
            [titleArray addObject:object.secondCatalogName];
        }];
        self.rightCombox.titlesList = titleArray;
        [self.rightCombox reloadData];
    }
}

#pragma mark ------选择城市代理
- (void)didSelectItem:(NSString *)item
{
    self.locationTextField.text = item;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
