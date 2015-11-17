//
//  SHGSelectTagsViewController.m
//  Finance
//
//  Created by changxicao on 15/11/17.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGSelectTagsViewController.h"
#import "SHGUserTagModel.h"
//为标签弹出框定义的值
#define kItemTopMargin  18.0f * XFACTOR
#define kItemMargin 14.0f * XFACTOR
#define kItemHeight 25.0f * XFACTOR
@interface SHGSelectTagsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UIButton *tagsButton;
@property (strong, nonatomic) SHGHomeTagsView *tagsView;

@end

@implementation SHGSelectTagsViewController

+ (instancetype)shareTagsViewController
{
    static SHGSelectTagsViewController *shareController = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareController = [[self alloc] init];
    });
    return shareController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self downloadUserSelectedInfo];
}


//偏好设置点击事件
- (IBAction)selectTags:(id)sender
{
    if(self.tagsView){
        __weak typeof(self) weakSelf = self;
        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"选择喜欢的标签方向" customView:self.tagsView leftButtonTitle:@"取消" rightButtonTitle:@"确定"];
        alert.rightBlock = ^{
            NSArray *array = [weakSelf.tagsView userSelectedTags];
            [[SHGGloble sharedGloble] uploadUserSelectedInfo:array completion:^(BOOL finished) {
                [[SHGGloble sharedGloble] downloadUserSelectedInfo:^{
                    [weakSelf loadUserTags];
                }];
            }];
        };
        [alert customShow];
    } else{
        [Hud showMessageWithText:@"正在拉取标签列表"];
    }

}

- (void)downloadUserSelectedInfo
{
    __weak typeof(self)weakSelf = self;
    [[SHGGloble sharedGloble] downloadUserTagInfo:^{
        //宽度设置和弹出框的线一样宽
        if (!weakSelf.tagsView) {
            weakSelf.tagsView = [[SHGHomeTagsView alloc] initWithFrame:CGRectMake(kLineViewLeftMargin, 0.0f, kAlertWidth - 2 * kLineViewLeftMargin, 0.0f)];
        }
        [[SHGGloble sharedGloble] downloadUserSelectedInfo:^{
            [weakSelf.tagsView updateSelectedArray];
            [weakSelf loadUserTags];
        }];
    }];
}

- (void)loadUserTags
{
    NSString *tags = @"";
    for (SHGUserTagModel *model in [SHGGloble sharedGloble].selectedTagsArray){
        tags = [tags stringByAppendingFormat:@"%@,",model.tagName];
    }
    if (tags.length > 0) {
        self.tagsLabel.text = [@"当前标签：" stringByAppendingString:[tags substringToIndex:tags.length - 1]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

@interface SHGHomeTagsView ()

@property (strong, nonatomic) NSMutableArray *selectedArray;
@property (strong, nonatomic) NSMutableArray *buttonArray;

@end



@implementation SHGHomeTagsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.selectedArray = [NSMutableArray array];
        self.buttonArray = [NSMutableArray array];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    NSArray *tagsArray = [SHGGloble sharedGloble].tagsArray;
    CGFloat width = (CGRectGetWidth(self.frame) - 2 * kItemMargin) / 3.0f;
    for(SHGUserTagModel *model in tagsArray){
        NSInteger index = [tagsArray indexOfObject:model];
        NSInteger row = index / 3;
        NSInteger col = index % 3;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = [UIColor colorWithHexString:@"D6D6D6"].CGColor;
        button.titleLabel.font = [UIFont systemFontOfSize:12.0f];

        [button setTitle:model.tagName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHexString:@"8c8c8c"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

        [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f95c53"]] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"f95c53"]] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(didSelectCategory:) forControlEvents:UIControlEventTouchUpInside];
        CGRect frame = CGRectMake((kItemMargin + width) * col, kItemTopMargin + (kItemMargin + kItemHeight) * row, width, kItemHeight);
        button.frame = frame;
        [self addSubview:button];
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(button.frame);
        self.frame = frame;
        [self.buttonArray addObject:button];
    }
}

- (void)updateSelectedArray
{
    NSArray *selectedArray = [SHGGloble sharedGloble].selectedTagsArray;
    NSArray *tagsArray = [SHGGloble sharedGloble].tagsArray;
    [self.selectedArray removeAllObjects];
    [self clearButtonState];
    for(SHGUserTagModel *model in selectedArray){
        NSInteger index = [tagsArray indexOfObject:model];
        NSLog(@"......%ld",(long)index);
        [self.selectedArray addObject:@(index)];
        UIButton *button = [self.buttonArray objectAtIndex:index];
        if(button){
            [button setSelected:YES];
        }
    }
}

- (void)didSelectCategory:(UIButton *)button
{
    BOOL isSelecetd = button.selected;
    NSInteger index = [self.buttonArray indexOfObject:button];
    if(!isSelecetd){
        if(self.selectedArray.count >= 3){
            [Hud showMessageWithText:@"最多选3项"];
        } else{
            button.selected = !isSelecetd;
            [self.selectedArray addObject:@(index)];
        }
    } else{
        button.selected = !isSelecetd;
        [self.selectedArray removeObject:@(index)];
    }
}

- (void)clearButtonState
{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj isKindOfClass:[UIButton class]]){
            UIButton *button = (UIButton *)obj;
            [button setSelected:NO];
        }
    }];
}

- (NSArray *)userSelectedTags
{
    return self.selectedArray;
}


@end