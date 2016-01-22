//
//  SHGIndustryChoiceView.m
//  Finance
//
//  Created by changxicao on 15/11/24.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGItemChooseView.h"
#import "SHGUnderlineTableViewCell.h"
#define kBgViewLeftMargin 35.0f * XFACTOR
#define kCellHeight 37.0f
#define kCellLabelLeftMargin 15.0f
@interface SHGItemChooseView ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation SHGItemChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
        self.bgView = [[UIView alloc] initWithFrame:CGRectInset(frame, kBgViewLeftMargin, (CGRectGetHeight(frame) - 5.0f * kCellHeight) / 2.0f)];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identfier = @"SHGUnderlineTableViewCell";
    SHGUnderlineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identfier];

    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGUnderlineTableViewCell" owner:self options:nil]lastObject];
        }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    cell.underLine.frame = CGRectMake(kCellLabelLeftMargin, cell.height - 1.0f, cell.width - kCellLabelLeftMargin, 0.5f);
    cell.underLine.backgroundColor = [UIColor colorWithHexString:@"E6E7E8"];
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
    return kCellHeight;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}

@end
