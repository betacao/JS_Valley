//
//  LMComBoxView.m
//  ComboBox
//
//  Created by tkinghr on 14-7-9.
//  Copyright (c) 2014年 Eric Che. All rights reserved.
//


#import "SHGComBoxView.h"
#import "SHGGlobleTableViewCell.h"
#define kCellLineLeftMargin MarginFactor(12.0f)
@interface SHGComBoxView ()

@property (assign, nonatomic) BOOL isOpen;
@property (strong, nonatomic) UIButton *bgButton;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *bgView;
@property (assign, nonatomic) NSInteger selectIndex;
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation SHGComBoxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 3.0f;
    self.backgroundColor = [UIColor clearColor];
    self.isOpen = NO;
}

- (UIButton *)bgButton
{
    if (!_bgButton) {
        _bgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgButton.layer.masksToBounds = YES;
        _bgButton.layer.cornerRadius = 3.0f;
        [_bgButton addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bgButton];
    }
    return _bgButton;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, SCREENWIDTH, SCREENHEIGHT)];
        _bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];;
        
    }
    return _bgView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = FontFactor(14.0f);
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithHexString:@"606060"];
        [_titleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self.bgButton addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView *)arrowView
{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc] init];
        _arrowView.image = [UIImage imageNamed:@"down_dark0.png"];
        [_arrowView sizeToFit];
        [self.bgButton addSubview:_arrowView];
    }
    return _arrowView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.cornerRadius = 3.0f;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgButton.frame = self.bounds;
    CGSize size = self.arrowView.image.size;
    self.titleLabel.frame = CGRectMake(size.width, 0.0f, CGRectGetWidth(self.frame) - 3 * size.width, CGRectGetHeight(self.frame));
    self.arrowView.frame = CGRectMake(CGRectGetWidth(self.frame) - 2 * size.width, (CGRectGetHeight(self.frame) - size.height)/2.0, size.width, size.height);
    self.tableView.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), 0.0f);
}

- (void)moveToIndex:(NSInteger)index
{
    self.selectIndex = index;
    self.titleLabel.text = [self.titlesList objectAtIndex:index];
    if([self.delegate respondsToSelector:@selector(selectAtIndex:inCombox:)]){
        [self.delegate selectAtIndex:index inCombox:self];
    }
}

- (void)setDefaultIndex:(NSInteger)defaultIndex
{
    if (defaultIndex == NSNotFound) {
        return;
    }
    _defaultIndex = defaultIndex;
    [self moveToIndex:defaultIndex];
}

//刷新视图
- (void)reloadData
{
    [self.tableView reloadData];
    if (self.titlesList.count > 0) {
        self.titleLabel.text = [self.titlesList firstObject];
        self.defaultIndex = 0;
    } else{
        self.titleLabel.text = @"";
    }
}

//关闭父视图上面的其他combox
- (void)closeOtherCombox
{
    for(UIView *subView in self.parentView.subviews){
        if([subView isKindOfClass:[SHGComBoxView class]] && subView != self){
            [self.bgView removeFromSuperview];
            SHGComBoxView *otherCombox = (SHGComBoxView *)subView;
            if(otherCombox.isOpen){
                [UIView animateWithDuration:0.3 animations:^{
                    CGRect frame = otherCombox.tableView.frame;
                    frame.size.height = 0;
                    [otherCombox.tableView setFrame:frame];
                } completion:^(BOOL finished){
                    [otherCombox.tableView removeFromSuperview];
                    otherCombox.isOpen = NO;
                    otherCombox.arrowView.transform = CGAffineTransformRotate(otherCombox.arrowView.transform, DEGREES_TO_RADIANS(180));
                }];
            }
        }
    }
}

//点击事件
- (void)tapAction
{
    //关闭其他combox
    [self closeOtherCombox];
    if(self.isOpen){
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = self.tableView.frame;
            frame.size.height = 0.0f;
            self.tableView.frame = frame;
        } completion:^(BOOL finished){
            self.isOpen = NO;
            [self.tableView removeFromSuperview];
            self.arrowView.transform = CGAffineTransformRotate(self.arrowView.transform, DEGREES_TO_RADIANS(180));
            }];
    } else{
        
        [UIView animateWithDuration:0.3f animations:^{
            if(self.titlesList.count > 0){
                //注意：如果不加这句话，下面的操作会导致_tableView从上面飘下来的感觉：
                //_tableView展开并且滑动到底部 -> 点击收起 -> 再点击展开
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            [self.parentView addSubview:self.bgView];
            [self.parentView addSubview:self.tableView];
            CGRect frame = self.tableView.frame;
            frame.size.height = self.titlesList.count * CGRectGetHeight(self.frame);
            frame.size.height = MIN(SCREENHEIGHT - kNavigationBarHeight - kStatusBarHeight - CGRectGetMinY(frame), CGRectGetHeight(frame));
            self.tableView.frame = frame;
        } completion:^(BOOL finished){
            self.isOpen = YES;
            self.arrowView.transform = CGAffineTransformRotate(self.arrowView.transform, DEGREES_TO_RADIANS(180));
        }];
    }
}

- (NSInteger)currentIndex
{
    return self.selectIndex;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([object isEqual:self.titleLabel]) {
        NSString *new = [change objectForKey:@"new"];
        if ([new isEqualToString:@"不限"]) {
            self.titleLabel.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        } else{
            self.titleLabel.textColor = [UIColor colorWithHexString:@"606060"];
        }
    }
}

#pragma mark -tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titlesList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath
{
    return CGRectGetHeight(self.frame);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = FontFactor(14.0f);
        cell.textLabel.textColor = kTextColor;
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(kCellLineLeftMargin, CGRectGetHeight(self.frame) - 0.5f, SCREENWIDTH , 0.5f)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"E6E7E8"];
        [cell.contentView addSubview:lineView];
    }
    cell.textLabel.text = [self.titlesList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.isOpen = YES;
    [self tapAction];
    [self moveToIndex:indexPath.row];
}


- (void)dealloc
{
    [self.titleLabel removeObserver:self forKeyPath:@"text"];
}

@end
