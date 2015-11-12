//
//  SHGActionViewController.m
//  Finance
//
//  Created by 魏虔坤 on 15/11/12.
//  Copyright © 2015年 HuMin. All rights reserved.
//

#import "SHGActionViewController.h"
#import "SHGActionTableViewCell.h"
//#define kActionViewCellHeight 300.0 * XFACTOR
@interface SHGActionViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTable;

@end

@implementation SHGActionViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listTable.delegate = self;
    self.listTable.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SHGActionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
//    
  
    NSString *cellIdentifier = @"SHGActionTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SHGActionTableViewCell" owner:self options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 225.0;
}
@end
