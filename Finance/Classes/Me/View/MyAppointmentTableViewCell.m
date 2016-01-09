//
//  MyAppointmentTableViewCell.m
//  Finance
//
//  Created by Okay Hoo on 15/4/29.
//  Copyright (c) 2015年 HuMin. All rights reserved.
//

#import "MyAppointmentTableViewCell.h"
@interface MyAppointmentTableViewCell ()
//股票配资
@property (nonatomic, strong) IBOutlet UIView *product1;
@property (nonatomic, strong) IBOutlet UILabel *product1Time;
@property (nonatomic, strong) IBOutlet UILabel *product1Name;
@property (nonatomic, strong) IBOutlet UILabel *product1Rate;
@property (nonatomic, strong) IBOutlet UILabel *product1Status;
@property (weak, nonatomic) IBOutlet UIView *viewLine1;


//打新股
@property (nonatomic , strong) IBOutlet UIView *product2;
@property (nonatomic, strong) IBOutlet UILabel *product2Time;
@property (nonatomic, strong) IBOutlet UILabel *product2Name;
@property (nonatomic, strong) IBOutlet UILabel *product2Rate;
@property (nonatomic, strong) IBOutlet UILabel *product2Cycle;
@property (nonatomic, strong) IBOutlet UILabel *product2Origin;
@property (nonatomic, strong) IBOutlet UILabel *product2Status;
@property (weak, nonatomic) IBOutlet UIView *viewLine2;


//定向增发
@property (nonatomic , strong) IBOutlet UIView *product3;
@property (nonatomic, strong) IBOutlet UILabel *product3Time;
@property (nonatomic, strong) IBOutlet UILabel *product3Name;
@property (nonatomic, strong) IBOutlet UILabel *product3Rate;
@property (nonatomic, strong) IBOutlet UILabel *product3DetailName;
@property (nonatomic, strong) IBOutlet UILabel *product3Code;
@property (nonatomic, strong) IBOutlet UILabel *product3Cycle;
@property (nonatomic, strong) IBOutlet UILabel *product3SinglePrice;
@property (nonatomic, strong) IBOutlet UILabel *product3Status;
@property (weak, nonatomic) IBOutlet UIView *viewLine3;

//新三板
@property (nonatomic , strong) IBOutlet UIView *product4;
@property (nonatomic, strong) IBOutlet UILabel *product4Time;
@property (nonatomic, strong) IBOutlet UILabel *product4Name;
@property (nonatomic, strong) IBOutlet UILabel *product4Rate;
@property (nonatomic, strong) IBOutlet UILabel *product4Cycle;
@property (nonatomic, strong) IBOutlet UILabel *product4Origin;
@property (nonatomic, strong) IBOutlet UILabel *product4IncreaseUnit;
@property (nonatomic, strong) IBOutlet UILabel *product4Status;
@property (weak, nonatomic) IBOutlet UIView *viewLine4;



@end

@implementation MyAppointmentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.viewLine1.size = CGSizeMake(self.viewLine1.width, 0.5f);
    self.viewLine2.size = CGSizeMake(self.viewLine2.width, 0.5f);
    self.viewLine3.size = CGSizeMake(self.viewLine3.width, 0.5f);
    self.viewLine4.size = CGSizeMake(self.viewLine4.width, 0.5f);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithDic:(NSDictionary *)dic
{
	NSString *ptype = [dic valueForKey:@"ptype"];
	if ([ptype isEqualToString:@"股票配资"]) {
		self.product1Time.text = [dic valueForKey:@"time"];
		self.product1Name.text = [dic valueForKey:@"pname"];
		self.product1Rate.text = [NSString stringWithFormat:@"%@％",[dic valueForKey:@"crate"]];
		NSString *status = [dic valueForKey:@"pstate"];
		if ([status isEqualToString:@"0"]) {
			self.product1Status.text = @"未支付";
		}else if ([status isEqualToString:@"1"]){
			self.product1Status.text = @"已支付";
		}else{
			self.product1Status.text = @"";
		}
		
		self.product1Status.textColor = [UIColor redColor];
		
		self.height = self.product1.height + 10;
		self.product1.origin = CGPointMake(13, 5);
		self.product1.width = self.width -26;

		self.product1.layer.masksToBounds = YES;
		self.product1.layer.cornerRadius = 5;
		[self.contentView addSubview:self.product1];
	}else if ([ptype isEqualToString:@"打新股"]){
		self.product2Time.text = [dic valueForKey:@"time"];
		self.product2Name.text = [dic valueForKey:@"pname"];
		self.product2Rate.text = [NSString stringWithFormat:@"%@％",[dic valueForKey:@"crate"]];
		self.product2Cycle.text = [dic valueForKey:@"holding"];
		self.product2Origin.text = [dic valueForKey:@"bline"];
		NSString *status = [dic valueForKey:@"pstate"];
		if ([status isEqualToString:@"0"]) {
			self.product2Status.text = @"未支付";
		}else if ([status isEqualToString:@"1"]){
			self.product2Status.text = @"已支付";
		}else{
			self.product2Status.text = @"";
		}

		self.product2Status.textColor = [UIColor redColor];

		self.height = self.product2.height + 10;
		self.product2.origin = CGPointMake(13, 5);
		self.product2.width = self.width -26;

		self.product2.layer.masksToBounds = YES;
		self.product2.layer.cornerRadius = 5;
		[self.contentView addSubview:self.product2];
	}else if ([ptype isEqualToString:@"定向增发"]){
		self.product3Time.text = [dic valueForKey:@"time"];
		self.product3Name.text = [dic valueForKey:@"pname"];
		self.product3Rate.text = [NSString stringWithFormat:@"%@％",[dic valueForKey:@"crate"]];
		NSString *status = [dic valueForKey:@"pstate"];
		if ([status isEqualToString:@"0"]) {
			self.product3Status.text = @"未支付";
		}else if ([status isEqualToString:@"1"]){
			self.product3Status.text = @"已支付";
		}else{
			self.product3Status.text = @"";
		}
		self.product3DetailName.text = [dic valueForKey:@"sname"];
		self.product3Code.text = [dic valueForKey:@"recordno"];
		self.product3Cycle.text = [dic valueForKey:@"holding"];
		self.product3SinglePrice.text = [dic valueForKey:@"sprice"];

		self.product3Status.textColor = [UIColor redColor];
		
		self.height = self.product3.height + 10;
		self.product3.origin = CGPointMake(13, 5);
		self.product3.width = self.width -26;

		self.product3.layer.masksToBounds = YES;
		self.product3.layer.cornerRadius = 5;
		[self.contentView addSubview:self.product3];
	}else if ([ptype isEqualToString:@"新三板"]){
		self.product4Time.text = [dic valueForKey:@"time"];
		self.product4Name.text = [dic valueForKey:@"pname"];
		self.product4Rate.text = [NSString stringWithFormat:@"%@％",[dic valueForKey:@"crate"]];
		NSString *status = [dic valueForKey:@"pstate"];
		if ([status isEqualToString:@"0"]) {
			self.product4Status.text = @"未支付";
		}else if ([status isEqualToString:@"1"]){
			self.product4Status.text = @"已支付";
		}else{
			self.product4Status.text = @"";
		}
		self.product4Cycle.text = [dic valueForKey:@"holding"];
		self.product4Origin.text = [dic valueForKey:@"bline"];
		self.product4IncreaseUnit.text = [dic valueForKey:@"add"];

		self.product4Status.textColor = [UIColor redColor];
		
		self.height = self.product4.height + 10;
		self.product4.origin = CGPointMake(13, 5);
		self.product4.width = self.width -26;

		self.product4.layer.masksToBounds = YES;
		self.product4.layer.cornerRadius = 5;
		[self.contentView addSubview:self.product4];
	}
	
}

@end
