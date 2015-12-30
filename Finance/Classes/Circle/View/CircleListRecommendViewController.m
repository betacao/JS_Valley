//
//  CircleListRecommendViewController.m
//  Finance
//
//  Created by changxicao on 15/8/20.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "CircleListRecommendViewController.h"
#import "popObj.h"

const CGFloat kFirstRecommendCellHeight = 73.0f;
const CGFloat kOtherRecommendCellHeight = 58.0f;
#define kLabelMargin  7.0f * XFACTOR

@interface CircleListRecommendViewController ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
//topView的subView
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *topNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *topCompantyLabel;
@property (weak, nonatomic) IBOutlet UILabel *topDepartLabel;
@property (weak, nonatomic) IBOutlet UILabel *topDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *topViewLine;
@property (weak, nonatomic) IBOutlet UIButton *topFocusButton;
@property (weak, nonatomic) IBOutlet UIView *topBreakLine;

//middleView的subView
@property (weak, nonatomic) IBOutlet UIImageView *middleImageView;
@property (weak, nonatomic) IBOutlet UILabel *middleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleCompantyLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleDepartLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *middleViewLine;
@property (weak, nonatomic) IBOutlet UIButton *middleFocusButton;
@property (weak, nonatomic) IBOutlet UIView *middleBreakLine;
//bottomView的subView
@property (weak, nonatomic) IBOutlet UIImageView *bottomImageView;
@property (weak, nonatomic) IBOutlet UILabel *bottomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomCompantyLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomDepartLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomBreakLine;
@property (weak, nonatomic) IBOutlet UIButton *bottomFocusButton;
@property (weak, nonatomic) IBOutlet UIImageView *markView;


@property (assign, nonatomic) NSInteger arrayCount;
@property (weak, nonatomic) NSArray *dataArray;


@end

@implementation CircleListRecommendViewController

- (void)loadViewWithData:(NSArray *)dataArray
{
    self.dataArray = dataArray;
    self.arrayCount = self.dataArray.count;
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

    [self.markView sizeToFit];
    CGRect frame = self.markView.frame;
    frame.origin.x = 0.0f;
    frame.origin.y = 0.0f;
    self.markView.frame = frame;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.topBreakLine.hidden = YES;
    self.middleBreakLine.hidden = YES;
    self.bottomBreakLine.hidden = YES;
    
    CGRect frame = self.topViewLine.frame;
    frame.size.height = 0.5f;
    self.topViewLine.frame = frame;
    self.topViewLine.hidden = YES;
    
    frame = self.middleViewLine.frame;
    frame.size.height = 0.5f;
    self.middleViewLine.frame = frame;
    self.middleViewLine.hidden = YES;
    
    for(RecmdFriendObj *obj in self.dataArray){
        NSInteger index = [self.dataArray indexOfObject:obj];
        UIView *view = nil;
        
        NSString *flag = obj.flag;
        NSString *detailString = @"";
        if([flag isEqualToString: @"city"]){
            detailString = [@"你们都在：" stringByAppendingString:obj.area];
        } else if ([flag isEqualToString:@"company"]){
            detailString = [@"你们都在：" stringByAppendingFormat:@"%@",obj.company];
        } else{
            detailString = [[NSString stringWithFormat:@"%@",obj.recomfri] stringByAppendingString:@"等人也关注了他"];
        }
        NSString *company = obj.company;
        if (obj.company.length > 5) {
            company = [obj.company substringToIndex:5];
            company = [NSString stringWithFormat:@"%@…",company];
        }

        NSString *department = obj.title;
        if (obj.title.length > 4) {
            department= [obj.title substringToIndex:4];
            department = [NSString stringWithFormat:@"%@…",department];
        }

        if(index == 0){
            view = self.topView;
            [self.topImageView sd_setImageWithURL:[NSURL URLWithString:obj.headimg] placeholderImage:[UIImage imageNamed:@"default_head"]];
            self.topNameLabel.text = obj.username;
            self.topCompantyLabel.text = company;
            self.topDepartLabel.text = department;
            self.topDetailLabel.text = detailString;
            if(!obj.isFocus){
                [self.topFocusButton setImage:[UIImage imageNamed:@"关注14"] forState:UIControlStateNormal];
            } else{
                [self.topFocusButton setImage:[UIImage imageNamed:@"已关注14"] forState:UIControlStateNormal];
            }
            CGRect frame = self.topNameLabel.frame;
            CGSize size = [self.topNameLabel sizeThatFits:CGSizeMake(MAXFLOAT, CGRectGetHeight(frame))];
            frame.size.width = size.width;
            self.topNameLabel.frame = frame;

            frame = self.topBreakLine.frame;
            frame.origin.x = CGRectGetMaxX(self.topNameLabel.frame) + kLabelMargin;
            self.topBreakLine.frame = frame;

            frame = self.topCompantyLabel.frame;
            size = [self.topCompantyLabel sizeThatFits:CGSizeMake(MAXFLOAT, CGRectGetHeight(frame))];
            frame.size.width = size.width;
            frame.origin.x = CGRectGetMaxX(self.topBreakLine.frame) + kLabelMargin;
            self.topCompantyLabel.frame = frame;

            frame = self.topDepartLabel.frame;
            frame.origin.x = CGRectGetMaxX(self.topCompantyLabel.frame) + kLabelMargin;
            self.topDepartLabel.frame = frame;
            
        } else if (index == 1){
            view = self.middleView;
            [self.middleImageView sd_setImageWithURL:[NSURL URLWithString:obj.headimg] placeholderImage:[UIImage imageNamed:@"default_head"]];
            self.middleNameLabel.text = obj.username;
            self.middleCompantyLabel.text = company;
            self.middleDepartLabel.text = department;
            self.middleDetailLabel.text = detailString;
            if(!obj.isFocus){
                [self.middleFocusButton setImage:[UIImage imageNamed:@"关注14"] forState:UIControlStateNormal];
            } else{
                [self.middleFocusButton setImage:[UIImage imageNamed:@"已关注14"] forState:UIControlStateNormal];
            }
            
            CGRect frame = self.middleNameLabel.frame;
            CGSize size = [self.middleNameLabel sizeThatFits:CGSizeMake(MAXFLOAT, CGRectGetHeight(frame))];
            frame.size.width = size.width;
            self.middleNameLabel.frame = frame;

            frame = self.middleBreakLine.frame;
            frame.origin.x = CGRectGetMaxX(self.middleNameLabel.frame) + kLabelMargin;
            self.middleBreakLine.frame = frame;

            frame = self.middleCompantyLabel.frame;
            size = [self.middleCompantyLabel sizeThatFits:CGSizeMake(MAXFLOAT, CGRectGetHeight(frame))];
            frame.size.width = size.width;
            frame.origin.x = CGRectGetMaxX(self.middleBreakLine.frame) + kLabelMargin;
            self.middleCompantyLabel.frame = frame;

            frame = self.middleDepartLabel.frame;
            frame.origin.x = CGRectGetMaxX(self.middleCompantyLabel.frame) + kLabelMargin;
            self.middleDepartLabel.frame = frame;


            self.topViewLine.hidden = NO;
        } else{
            view = self.bottomView;
            [self.bottomImageView sd_setImageWithURL:[NSURL URLWithString:obj.headimg] placeholderImage:[UIImage imageNamed:@"default_head"]];
            self.bottomNameLabel.text = obj.username;
            self.bottomCompantyLabel.text = company;
            self.bottomDepartLabel.text = department;
            self.bottomDetailLabel.text = detailString;
            if(!obj.isFocus){
                [self.bottomFocusButton setImage:[UIImage imageNamed:@"关注14"] forState:UIControlStateNormal];
            } else{
                [self.bottomFocusButton setImage:[UIImage imageNamed:@"已关注14"] forState:UIControlStateNormal];
            }
            
            CGRect frame = self.bottomNameLabel.frame;
            CGSize size = [self.bottomNameLabel sizeThatFits:CGSizeMake(MAXFLOAT, CGRectGetHeight(frame))];
            frame.size.width = size.width;
            self.bottomNameLabel.frame = frame;

            frame = self.bottomBreakLine.frame;
            frame.origin.x = CGRectGetMaxX(self.bottomNameLabel.frame) + kLabelMargin;

            self.bottomBreakLine.frame = frame;

            frame = self.bottomCompantyLabel.frame;
            size = [self.bottomCompantyLabel sizeThatFits:CGSizeMake(MAXFLOAT, CGRectGetHeight(frame))];
            frame.size.width = size.width;
            frame.origin.x = CGRectGetMaxX(self.bottomBreakLine.frame) + kLabelMargin;
            self.bottomCompantyLabel.frame = frame;

            frame = self.bottomDepartLabel.frame;
            frame.origin.x = CGRectGetMaxX(self.bottomCompantyLabel.frame) + kLabelMargin;
            self.bottomDepartLabel.frame = frame;

            self.middleViewLine.hidden = NO;
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

- (IBAction)didClickCloseButton:(id)sender
{
    if(self.closeBlock){
        self.closeBlock();
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
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectPerson:name:)]){
            [self.delegate didSelectPerson:uid name:name];
        }
        
    } else{
        uid = ((RecmdFriendObj *)[self.dataArray lastObject]).uid;
        name = ((RecmdFriendObj *)[self.dataArray lastObject]).username;
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectPerson:name:)]){
            [self.delegate didSelectPerson:uid name:name];
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
