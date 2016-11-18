//
//  ApplyRecordViewController.m
//  wly
//
//  Created by luolihacker on 16/4/26.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "ApplyRecordViewController.h"
#import "Terminnalmodel.h"
#import "TerminalListTableViewCell.h"
@interface ApplyRecordViewController ()
{
    NSMutableArray *dataArray;
}
@end

@implementation ApplyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [[NSMutableArray alloc] init];
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
- (void)viewWillAppear:(BOOL)animated{
    [self invokeData];
}

- (void)invokeData{
    [HttpTask terminalList:[GlobleData sharedInstance].userid sucessBlock:^(NSString *resposeStr) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[resposeStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSString *status = [dictionary objectForKey:@"status"];
        if ([status isEqualToString:@"1"]) {
            NSArray *array = [dictionary objectForKey:@"bills"];
            for (NSDictionary *dic in array) {
                Terminnalmodel *model = [[Terminnalmodel alloc] init];
                model.billid = [self nsnumberTranstTostring:[dic objectForKey:@"BILLid"]];
                model.terminalName = [dic objectForKey:@"zdsmc"];
                model.status = [self nsnumberTranstTostring:[dic objectForKey:@"status"]];
                model.teleNum = [dic objectForKey:@"dh"];
                model.address = [dic objectForKey:@"dz"];
                model.createDate = [dic objectForKey:@"createdate"];
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

- (void)configUI{
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"账号申请列表";
    title.font = [UIFont fontWithName:@"Helvetica-Bold"  size:15];
    
    // 创建一个导航栏
    UINavigationBar *navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    [[UINavigationBar appearance]setBarTintColor:UIColorFromRGB(0xf2f2f2)];
    navBar.translucent = YES;
    
    //创建一个导航栏集合
    
    UINavigationItem *navItem = [[UINavigationItem alloc]init];
    navItem.titleView = title;
    navItem.titleView.frame = CGRectMake(self.view.center.x - 100, navBar.center.y - 10, 60, 20);
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backward"] style:UIBarButtonItemStylePlain target:self action:@selector(backforward)];
    [navBar pushNavigationItem:navItem animated:NO];
    [navItem setLeftBarButtonItem:leftBtn];
    [self.view addSubview:navBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentity = @"cell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"TerminalListTableViewCell" owner:nil options:nil].lastObject;
        TerminalListTableViewCell *scell = (TerminalListTableViewCell *)cell;
        scell.backView.layer.cornerRadius = 5.0;
        scell.backView.clipsToBounds = YES;
        scell.selectionStyle = UITableViewCellSelectionStyleNone;
        Terminnalmodel *terminalModel = [dataArray objectAtIndex:indexPath.row];
        if ([terminalModel.status isEqualToString:@"0"]) {
            scell.stateImage.image = [UIImage imageNamed:@"notGet"];
        }else{
            scell.stateImage.image = [UIImage imageNamed:@"didGet"];
        }
        scell.billIdLabel.text = terminalModel.terminalName;
        scell.zdsNameLabel.text = terminalModel.pingtaiName;
        scell.timeLabel.text = terminalModel.createDate;
        scell.addressLabel.text = terminalModel.address;
        scell.teleLabel.text = terminalModel.teleNum;
        scell.typeLabel.text = terminalModel.terminalType;
        
    }
    return cell;
}

// 返回
- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// NSNumber转换成NSString
- (NSString *)nsnumberTranstTostring:(NSNumber *)number
{
    NSNumberFormatter *numberformatter = [[NSNumberFormatter alloc] init];
    NSString *string = [numberformatter stringFromNumber:number];
    return string;
}
@end
