//
//  LMComBoxView.m
//  ComboBox
//
//  Created by tkinghr on 14-7-9.
//  Copyright (c) 2014年 Eric Che. All rights reserved.
//


#import "SHGComBoxView.h"

@interface SHGComBoxView ()

@property(assign,nonatomic) BOOL isOpen;
@property(strong,nonatomic) UITableView *listTable;
@property(assign,nonatomic) NSInteger selectIndex;
@property(strong,nonatomic) UILabel *titleLabel;
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
    [self initSubViews];
}

- (void)initSubViews
{
    [super layoutSubviews];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = self.bounds;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3.0f;
    [btn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];

    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgW, 0.0f, CGRectGetWidth(self.frame) - 3 * imgW, CGRectGetHeight(self.frame))];
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;

    self.titleLabel.textColor = [UIColor colorWithHexString:@"606060"];
    [btn addSubview:self.titleLabel];

    self.arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - 2 * imgW, (CGRectGetHeight(self.frame) - imgH)/2.0, imgW, imgH)];
    self.arrowView.image = [UIImage imageNamed:@"down_dark0.png"];
    [btn addSubview:self.arrowView];

    //默认不展开
    self.isOpen = NO;
    self.listTable = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame), CGRectGetWidth(self.frame), 0.0f) style:UITableViewStylePlain];
    self.listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
    self.listTable.layer.masksToBounds = YES;
    self.listTable.layer.cornerRadius = 3.0f;
    self.listTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.parentView addSubview:self.listTable];

    [self moveToIndex:self.defaultIndex];
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
    [self.listTable reloadData];
    if (self.titlesList.count > 0) {
        self.titleLabel.text = [self.titlesList firstObject];
    } else{
        self.titleLabel.text = @"";
    }
}

//关闭父视图上面的其他combox
- (void)closeOtherCombox
{
    for(UIView *subView in self.parentView.subviews){
        if([subView isKindOfClass:[SHGComBoxView class]] && subView != self){
            SHGComBoxView *otherCombox = (SHGComBoxView *)subView;
            if(otherCombox.isOpen){
                [UIView animateWithDuration:0.3 animations:^{
                    CGRect frame = otherCombox.listTable.frame;
                    frame.size.height = 0;
                    [otherCombox.listTable setFrame:frame];
                } completion:^(BOOL finished){
                    [otherCombox.listTable removeFromSuperview];
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
            CGRect frame = self.listTable.frame;
            frame.size.height = 0.0f;
            self.listTable.frame = frame;
        } completion:^(BOOL finished){
            self.isOpen = NO;
            [self.listTable removeFromSuperview];
            self.arrowView.transform = CGAffineTransformRotate(self.arrowView.transform, DEGREES_TO_RADIANS(180));
            }];
    } else{
        [UIView animateWithDuration:0.3f animations:^{
            if(self.titlesList.count > 0){
                //注意：如果不加这句话，下面的操作会导致_listTable从上面飘下来的感觉：
                //_listTable展开并且滑动到底部 -> 点击收起 -> 再点击展开
                [self.listTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            [self.parentView addSubview:self.listTable];
            CGRect frame = self.listTable.frame;
            frame.size.height = self.titlesList.count * CGRectGetHeight(self.frame);
            if(CGRectGetMaxY(frame) > SCREENHEIGHT){
                //避免超出屏幕外
                frame.size.height -= CGRectGetMaxY(frame) - SCREENHEIGHT;
            }
            self.listTable.frame = frame;
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
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = kTextColor;
    }
    cell.textLabel.text = [self.titlesList objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.titleLabel.text = [self.titlesList objectAtIndex:indexPath.row];
    self.isOpen = YES;
    [self tapAction];
    self.selectIndex = indexPath.row;
    if([self.delegate respondsToSelector:@selector(selectAtIndex:inCombox:)]){
        [self.delegate selectAtIndex:indexPath.row inCombox:self];
    }
}

@end
