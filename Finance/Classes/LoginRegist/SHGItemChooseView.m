//
//  SHGIndustryChoiceView.m
//  Finance
//
//  Created by changxicao on 15/11/24.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGItemChooseView.h"

#define kCellHeight MarginFactor(56.0f)
#define kBgViewLeftMargin MarginFactor(35.0f)
#define kCellLabelLeftMargin 15.0f

@interface SHGItemChooseView ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *modelsArray;

@end

@implementation SHGItemChooseView

- (instancetype)initWithFrame:(CGRect)frame lineNumber:(NSInteger)number
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        self.bgView = [[UIView alloc] initWithFrame:CGRectInset(frame, kBgViewLeftMargin, (CGRectGetHeight(frame) - (number > 6 ? 6 : number) * kCellHeight) / 2.0f)];
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.cornerRadius = 5.0f;
        self.tableView = [[UITableView alloc] initWithFrame:self.bgView.bounds];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.scrollEnabled = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.tableView];
    }
    return self;
}

- (NSMutableArray *)modelsArray
{
    if (!_modelsArray) {
        _modelsArray = [NSMutableArray array];
        for (NSInteger i = 0; i < self.dataArray.count; i++) {
            SHGGlobleModel *model = [[SHGGlobleModel alloc] initWithText:[self.dataArray objectAtIndex:i] lineViewHidden:NO accessoryViewHidden:NO];
            model.accessoryViewHidden = YES;
            [_modelsArray addObject:model];
        }
    }
    return _modelsArray;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identfier = @"SHGGlobleTableViewCell";
    SHGGlobleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];

    if (!cell) {
        cell = [[SHGGlobleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfier];
    }
    cell.model = [self.modelsArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectItem:)]) {
        NSString *industry = [self.dataArray objectAtIndex:indexPath.row];
        [self.delegate didSelectItem:industry];
        [self removeFromSuperview];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self.tableView cellHeightForIndexPath:indexPath model:self.modelsArray[indexPath.row] keyPath:@"model" cellClass:[SHGGlobleTableViewCell class] contentViewWidth:SCREENWIDTH];
    return height;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
