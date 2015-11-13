//
//  SHGActionSignViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/13.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionSignViewController.h"
#import "SHGActionSignTableViewCell.h"
@interface SHGActionSignViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UITableView *signListTable;

@end

@implementation SHGActionSignViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已报名";
    self.signListTable.dataSource = self;
    self.signListTable.delegate = self;
    //[self.signListTable registerNib:[UINib nibWithNibName:@"SGHActionSignTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  10;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //SGHActionSignTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString *cellIdentifier = @"SGHActionSignTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SGHActionSignTableViewCell" owner:self options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeght = 53.0;
    return rowHeght;
}
@end
