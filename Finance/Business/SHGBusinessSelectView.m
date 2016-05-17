//
//  SHGBusinessSelectView.m
//  Finance
//
//  Created by weiqiankun on 16/4/7.
//  Copyright © 2016年 HuMin. All rights reserved.
//

#import "SHGBusinessSelectView.h"
#import "SHGBusinessMargin.h"
#import "SHGBusinessButtonContentView.h"
@interface SHGBusinessSelectView ()
@property (nonatomic, strong) UIButton *quitButton;
@property (nonatomic, strong) SHGBusinessButtonContentView *buttonView;
@property (nonatomic, strong) SHGBusinessButtonContentView *radioButtonView;
@property (nonatomic, strong) NSArray *businessArry;
@property (nonatomic, strong) NSString *businessName;
@property (nonatomic, assign) BOOL statu;
@property (nonatomic, strong) UIButton *currentButton;
@property (nonatomic, strong) NSString *buttonString;
@property (nonatomic, strong) NSMutableArray *buttonStrongArray;
@property (nonatomic, strong) NSArray *strongArray;


@end

@implementation SHGBusinessSelectView

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array statu:(BOOL)statu industryArray:(NSArray *)industryArray
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.businessArry = array;
        self.strongArray = industryArray;
        self.statu = statu;
        if (statu) {
            [self addSubview:self.buttonView];
        } else{
            [self addSubview:self.radioButtonView];
        }
        
        [self addSubview:self.quitButton];
        [self addSdlayout];
    }
    return self;
}

- (NSArray *)strongArray
{
    if (!_strongArray) {
        _strongArray = [[NSArray alloc] init];
    }
    return _strongArray;
}
- (NSMutableArray *)buttonStrongArray
{
    if (!_buttonStrongArray) {
        _buttonStrongArray = [[NSMutableArray alloc] init];
    }
    return _buttonStrongArray;
}
- (SHGBusinessButtonContentView *)buttonView
{
    if (!_buttonView) {
        
             _buttonView = [[SHGBusinessButtonContentView alloc] initWithMode:SHGBusinessButtonShowModeExclusiveChoice];
        
    }
    return _buttonView;
}

- (SHGBusinessButtonContentView *)radioButtonView
{
    if (!_radioButtonView) {
        _radioButtonView = [[SHGBusinessButtonContentView alloc] initWithMode:SHGBusinessButtonShowModeSingleChoice];
        
    }
    return _radioButtonView;
}

- (UIButton *)quitButton
{
    if (!_quitButton) {
        _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitButton setImage:[UIImage imageNamed:@"business_quit"] forState:UIControlStateNormal];
        [_quitButton addTarget:self action:@selector(quiteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitButton;
}

- (void)buttonClick:(UIButton *)btn
{
    SHGBusinessButtonContentView *superView =(SHGBusinessButtonContentView *)btn.superview;
    [superView didClickButton:btn];
    //self.buttonStrongArray = superView.selectedArray;
    if (self.statu) {
        if (superView.selectedArray.count > 0) {
            self.buttonString = [superView.selectedArray objectAtIndex:0];
            for (NSInteger i = 1; i < superView.selectedArray.count; i ++ ) {
                self.buttonString = [NSString stringWithFormat:@"%@/%@",self.buttonString,[superView.selectedArray objectAtIndex:i]];
            }
            
        } else{
            self.buttonString = @"";
        }
        
    } else{
        if (superView.selectedArray.count > 0) {
            self.buttonString = [superView.selectedArray objectAtIndex:0];
        } else{
            self.buttonString = @"";
        }
       

  }
}

- (void)quiteClick:(UIButton *)btn
{
    if (self.statu) {
        self.buttonStrongArray = self.buttonView.selectedArray;
    } else{
        self.buttonStrongArray = self.radioButtonView.selectedArray;
    }
    if (self.buttonStrongArray.count > 0) {
        self.buttonString = [self.buttonStrongArray objectAtIndex:0];
        for (NSInteger i = 1; i < self.buttonStrongArray.count; i ++ ) {
            self.buttonString = [NSString stringWithFormat:@"%@/%@",self.buttonString,[self.buttonStrongArray objectAtIndex:i]];
        }
        
    } else{
        self.buttonString = @"";
    }
    if (self.returnTextBlock) {
        self.returnTextBlock(self.buttonString,self.buttonStrongArray);
    }
    [self removeFromSuperview];
    
}

- (void)addSdlayout
{
    UIImage *image = [UIImage imageNamed:@"business_quit"];
    CGSize size = image.size;
    
    self.quitButton.sd_layout
    .bottomSpaceToView(self, MarginFactor(40.0f))
    .centerXIs(SCREENWIDTH / 2.0f)
    .widthIs(size.width)
    .heightIs(size.height);
    
    self.buttonView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self, MarginFactor(165.0f))
    .bottomSpaceToView(self.quitButton, MarginFactor(10.0f));
    
    self.radioButtonView.sd_layout
    .leftSpaceToView(self, 0.0f)
    .rightSpaceToView(self, 0.0f)
    .topSpaceToView(self, MarginFactor(165.0f))
    .bottomSpaceToView(self.quitButton, MarginFactor(10.0f));
    
    for (int i = 0; i < self.businessArry.count; i ++ ) {
        UIImage *buttonBgImage = [UIImage imageNamed:@"business_unSelected"];
        buttonBgImage = [buttonBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f) resizingMode:UIImageResizingModeStretch];
        UIImage *buttonSelectBgImage = [UIImage imageNamed:@"business_selected"];
        buttonSelectBgImage = [buttonSelectBgImage resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 20.0f) resizingMode:UIImageResizingModeStretch];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = FontFactor(15.0f);
        [button setTitle:[self.businessArry objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitle:[self.businessArry objectAtIndex:i] forState:UIControlStateSelected];
        [button setTitleColor:Color(@"161616") forState:UIControlStateNormal];
        [button setTitleColor:Color(@"ff8d65") forState:UIControlStateSelected];
        [button setBackgroundImage:buttonBgImage forState:UIControlStateNormal];
        [button setBackgroundImage:buttonSelectBgImage forState:UIControlStateSelected];
        if (self.strongArray.count > 0) {
            for (NSInteger i = 0; i < self.strongArray.count; i ++) {
                if ([button.titleLabel.text isEqualToString:[self.strongArray objectAtIndex:i]]) {
                    button.selected = YES;
                }
            }
        }

        
        button.frame = CGRectMake(kLeftToView + i%3 * (kThreeButtonWidth + MarginFactor(9.0f)), i/3 * (kButtonHeight + MarginFactor(30.0f)), kThreeButtonWidth, kCategoryButtonHeight);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.statu) {
            [self.buttonView.selectedArray addObjectsFromArray:self.strongArray];
            [self.buttonView addSubview:button];
        } else{
            [self.radioButtonView.selectedArray addObjectsFromArray:self.strongArray];
            [self.radioButtonView addSubview:button];
        }
        

    }
}

@end
