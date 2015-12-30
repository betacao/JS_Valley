//
//  SHGMarketSecondCategoryTableViewCell.m
//  Finance
//
//  Created by 魏虔坤 on 15/12/28.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGMarketSecondCategoryTableViewCell.h"
#import "SHGMarketObject.h"
//@interface SHGMarketSecondCategoryTableViewCell()
////@property (nonatomic , strong)SHGMarketFirstCategoryObject *obj;
//@property (nonatomic , strong)UIView * bgView;
//@end

@implementation SHGMarketSecondCategoryTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
         _bgView = [[UIView alloc]init];
        [self.contentView addSubview:_bgView];
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"EFEFEF"];
        [self.contentView addSubview:_lineView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
  
    
}
- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
