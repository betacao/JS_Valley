//
//  ProductListTableViewCell.m
//  Finance
//
//  Created by HuMin on 15/4/21.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "ProductListTableViewCell.h"
@interface ProductListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lblCommision;
@property (weak, nonatomic) IBOutlet UILabel *lblRIght2;
@property (weak, nonatomic) IBOutlet UILabel *lblRight1;
@property (weak, nonatomic) IBOutlet UILabel *lblLeft2;
@property (weak, nonatomic) IBOutlet UILabel *lblLeft1;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIImageView *imageIshot;


@end

@implementation ProductListTableViewCell

- (void)awakeFromNib {
    self.selectionStyle =  UITableViewCellSelectionStyleNone;

    // Initialization code
}

-(void)loadDatasWithObj:(ProdListObj *)obj
{
    _imageIshot.hidden = ![obj.isHot boolValue];
    _lblName.text = obj.name;
    _lblLeft1.text = obj.left1;
    _lblLeft2.text = obj.left2;
    _lblRight1.text = obj.right1;
    _lblRIght2.text = obj.right2;
    
    if (!IsStrEmpty(obj.commision))
    {
        NSString *state = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_AUTHSTATE];
        if (![state boolValue]) {
            _lblCommision.text = @"认证可见";

        }
        else
        {
        _lblCommision.text = [NSString stringWithFormat:@"%@%@",obj.commision,@"%"];
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
