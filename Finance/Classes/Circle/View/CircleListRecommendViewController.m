//
//  CircleListRecommendViewController.m
//  Finance
//
//  Created by changxicao on 15/8/20.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "CircleListRecommendViewController.h"
#import "popObj.h"

const CGFloat kFirstRecommendCellHeight = 70.0f;
const CGFloat kOtherRecommendCellHeight = 65.0f;
const CGFloat kLabelMargin = 10.0f;

@interface CircleListRecommendViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
//topView的subView
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *topNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *topCompantyLabel;
@property (weak, nonatomic) IBOutlet UILabel *topDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *topViewLine;
@property (weak, nonatomic) IBOutlet UIButton *topFocusButton;

//middleView的subView
@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;
@property (weak, nonatomic) IBOutlet UILabel *middleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleCompantyLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *middleViewLine;
@property (weak, nonatomic) IBOutlet UIButton *middleFocusButton;
//bottomView的subView
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomCompantyLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomViewLine;
@property (weak, nonatomic) IBOutlet UIButton *bottomFocusButton;

@property (assign, nonatomic) NSInteger arrayCount;
@property (weak, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSString *currentCity;


@end

@implementation CircleListRecommendViewController

- (void)loadViewWithData:(NSArray *)dataArray cityCode:(NSString *)currentCity
{
    self.dataArray = dataArray;
    self.arrayCount = self.dataArray.count;
    self.currentCity = currentCity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    DDTapGestureRecognizer *topRecognizer = [[DDTapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHeaderView:)];
    [self.topImageView addGestureRecognizer:topRecognizer];
    DDTapGestureRecognizer *middleRecognizer = [[DDTapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHeaderView:)];
    [self.middleImageView addGestureRecognizer:middleRecognizer];
    DDTapGestureRecognizer *bottomRecognizer = [[DDTapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHeaderView:)];
    [self.bottomImageView addGestureRecognizer:bottomRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGRect frame = self.topViewLine.frame;
    frame.size.height = 0.5f;
    self.topViewLine.frame = frame;
    
    frame = self.middleViewLine.frame;
    frame.size.height = 0.5f;
    self.middleViewLine.frame = frame;
    
    for(RecmdFriendObj *obj in self.dataArray){
        NSInteger index = [self.dataArray indexOfObject:obj];
        UIView *view = nil;
        
        NSString *flag = obj.flag;
        NSString *detailString = @"";
        if([flag isEqualToString: @"city"]){
            detailString = [@"你们都在：" stringByAppendingString:self.currentCity];
        } else if ([flag isEqualToString:@"company"]){
            detailString = [@"你们都在：" stringByAppendingFormat:@"%@",obj.company];
        } else{
            detailString = [[NSString stringWithFormat:@"%@",obj.recomfri] stringByAppendingString:@"等人也关注了他"];
        }
        if(index == 0){
            view = self.topView;
            [self.topImageView sd_setImageWithURL:[NSURL URLWithString:obj.headimg] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
            self.topNameLabel.text = obj.username;
            self.topCompantyLabel.text = obj.company;
            self.topDetailLabel.text = detailString;
            if(!obj.isFocus){
                [self.topFocusButton setImage:[UIImage imageNamed:@"关注14"] forState:UIControlStateNormal];
            } else{
                [self.topFocusButton setImage:[UIImage imageNamed:@"已关注14"] forState:UIControlStateNormal];
            }
            
            [self.topNameLabel sizeToFit];
            CGRect frame = self.topCompantyLabel.frame;
            frame.origin.x = CGRectGetMaxX(self.topNameLabel.frame) + kLabelMargin;
            self.topCompantyLabel.frame = frame;
            
        } else if (index == 1){
            view = self.middleView;
            [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:obj.headimg] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
            self.middleNameLabel.text = obj.username;
            self.middleCompantyLabel.text = obj.company;
            self.middleDetailLabel.text = detailString;
            if(!obj.isFocus){
                [self.middleFocusButton setImage:[UIImage imageNamed:@"关注14"] forState:UIControlStateNormal];
            } else{
                [self.middleFocusButton setImage:[UIImage imageNamed:@"已关注14"] forState:UIControlStateNormal];
            }
            
            [self.middleNameLabel sizeToFit];
            CGRect frame = self.middleCompantyLabel.frame;
            frame.origin.x = CGRectGetMaxX(self.middleNameLabel.frame) + kLabelMargin;
            self.middleCompantyLabel.frame = frame;
            
        } else{
            view = self.bottomView;
            [self.bottomImageView sd_setImageWithURL:[NSURL URLWithString:obj.headimg] placeholderImage:[UIImage imageNamed:@"默认头像.png"]];
            self.bottomNameLabel.text = obj.username;
            self.bottomCompantyLabel.text = obj.company;
            self.bottomDetailLabel.text = detailString;
            if(!obj.isFocus){
                [self.bottomFocusButton setImage:[UIImage imageNamed:@"关注14"] forState:UIControlStateNormal];
            } else{
                [self.bottomFocusButton setImage:[UIImage imageNamed:@"已关注14"] forState:UIControlStateNormal];
            }
            
            [self.bottomNameLabel sizeToFit];
            CGRect frame = self.bottomCompantyLabel.frame;
            frame.origin.x = CGRectGetMaxX(self.bottomNameLabel.frame) + kLabelMargin;
            self.bottomCompantyLabel.frame = frame;
            
        }
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, [self heightOfView] - kLabelMargin, SCREENWIDTH , kLabelMargin)];
    view.backgroundColor = RGBA(239, 238, 239, 1);
    [self.view addSubview:view];
    frame = self.view.frame;
    frame.size.height = CGRectGetMaxY(view.frame);
    frame.size.width = SCREENWIDTH;
    self.view.frame = frame;
}

- (CGFloat)heightOfView
{
    return kFirstRecommendCellHeight + (self.arrayCount - 1) * kOtherRecommendCellHeight + kLabelMargin;
}

- (IBAction)didClickFocusButton:(UIButton *)sender {
    NSInteger index = 0;
    if([sender isEqual:self.topFocusButton]){
        index = 0;
    } else if ([sender isEqual:self.middleFocusButton]){
        index = 1;
    } else{
        index = 2;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(attentionClicked:)]){
        [self.delegate attentionClicked:[self.dataArray objectAtIndex:index]];
    }
    
}

- (void)didTapHeaderView:(DDTapGestureRecognizer *)recognizer
{
    NSString *uid = @"";
    NSString *name = @"";
    if([recognizer.view isEqual:self.topImageView]){
        uid = ((RecmdFriendObj *)[self.dataArray firstObject]).uid;
        name = ((RecmdFriendObj *)[self.dataArray firstObject]).username;
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectPerson:name:)]){
            [self.delegate didSelectPerson:uid name:name];
        }
        
    } else if([recognizer.view isEqual:self.middleImageView]){
        uid = ((RecmdFriendObj *)[self.dataArray objectAtIndex:1]).uid;
        name = ((RecmdFriendObj *)[self.dataArray objectAtIndex:1]).username;
        if(self.delegate && [self.delegate respondsToSelector:@selector(attentionClicked:)]){
            [self.delegate didSelectPerson:uid name:name];
        }
        
    } else{
        uid = ((RecmdFriendObj *)[self.dataArray lastObject]).uid;
        name = ((RecmdFriendObj *)[self.dataArray lastObject]).username;
        if(self.delegate && [self.delegate respondsToSelector:@selector(attentionClicked:)]){
            [self.delegate didSelectPerson:uid name:name];
        }
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
