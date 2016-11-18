//
//  VerifyAccountViewController.m
//  wly
//
//  Created by luolihacker on 16/6/13.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "VerifyAccountViewController.h"
#import "VerifyAccountTableViewCell.h"
#import "Terminnalmodel.h"
#import "AccountVerifyViewController.h"

@interface VerifyAccountViewController ()
{
    NSMutableArray *dataArray;
}
@end

@implementation VerifyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.recordTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.recordTable.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    self.recordTable.delegate=self;
    self.recordTable.dataSource=self;
    self.recordTable.tableFooterView = [[UIView alloc] init];
    self.recordTable.backgroundColor = UIColorFromRGB(0xE6E6E6);
    self.recordTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.recordTable];
    [self configUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUI{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"账号审核列表";
    title.font = [UIFont fontWithName:@"Helvetica-Bold"  size:15];
    
    // 创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [[UINavigationBar appearance]setBarTintColor:UIColorFromRGB(0xf2f2f2)];
    navBar.translucent = YES;
    
    //创建一个导航栏集合
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.titleView = title;
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backward"] style:UIBarButtonItemStylePlain target:self action:@selector(backforward)];
    [navBar pushNavigationItem:navItem animated:NO];
    [navItem setLeftBarButtonItem:leftBtn];
    [self.view addSubview:navBar];
}

- (void)viewWillAppear:(BOOL)animated{
    dataArray = [[NSMutableArray alloc] init];
    [self invokeData];
}

- (void)viewDidDisappear:(BOOL)animated{
    dataArray = nil;
}

- (void)invokeData{
    [HttpTask verifyAccountList:[GlobleData sharedInstance].userid sucessBlock:^(NSString *resposeStr) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[resposeStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSString *status = [dictionary objectForKey:@"status"];
        if ([status isEqualToString:@"1"]) {
            NSArray *array = [dictionary objectForKey:@"bills"];
            for (NSDictionary *dic in array) {
                Terminnalmodel *model = [[Terminnalmodel alloc] init];
                model.billid = [self nsnumberTranstTostring:[dic objectForKey:@"billid"]];
                model.terminalName = [dic objectForKey:@"zdsmc"];
                model.status = [self nsnumberTranstTostring:[dic objectForKey:@"status"]];
                model.teleNum = [dic objectForKey:@"dh"];
                model.address = [dic objectForKey:@"dz"];
                model.createDate = [dic objectForKey:@"createdate"];
                model.linkMan = [dic objectForKey:@"lxr"];
                model.pingtaiName = [dic objectForKey:@"khmc"];
                model.terminalType = [dic objectForKey:@"type"];
                [dataArray addObject:model];
            }
            [self.recordTable reloadData];
        }else{
            return;
        }
    } failBlock:^(NSDictionary *error) {
        
    }];
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 选中后立即取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Terminnalmodel *model = [dataArray objectAtIndex:indexPath.row];
    AccountVerifyViewController *Vc = [[AccountVerifyViewController alloc] init];
    Vc.billid = model.billid;
    [self presentViewController:Vc animated:YES completion:nil];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentity = @"cell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"VerifyAccountTableViewCell" owner:nil options:nil].lastObject;
        VerifyAccountTableViewCell *scell = (VerifyAccountTableViewCell *)cell;
        scell.backView.layer.cornerRadius = 5.0;
        scell.backView.clipsToBounds = YES;
        Terminnalmodel *terminalModel = [dataArray objectAtIndex:indexPath.row];

        scell.terminalNameLabel.text = terminalModel.terminalName;
        scell.terminalTypeLabel.text = terminalModel.terminalType;
        scell.timeLabel.text = terminalModel.createDate;
        scell.addressLabel.text = terminalModel.address;
        scell.linkManLabel.text = terminalModel.linkMan;
        scell.phoneLabel.text = terminalModel.teleNum;
        if ([terminalModel.status isEqualToString:@"1"]) {
            scell.showSuccessLabel.text = @"【已审核】";
        }else{
            scell.showSuccessLabel.text = @"【未审核】";
        }        
    }
    return cell;
}

// NSNumber转换成NSString
- (NSString *)nsnumberTranstTostring:(NSNumber *)number
{
    NSNumberFormatter *numberformatter = [[NSNumberFormatter alloc] init];
    NSString *string = [numberformatter stringFromNumber:number];
    return string;
}

- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
