//
//  FahuoListViewController.m
//  wly
//
//  Created by luolihacker on 16/5/5.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "FahuoListViewController.h"
#import "DiaohuofahuoTableViewCell.h"
#import "DiaohuoFahuodanViewController.h"
#import "Diaohuofahuomodel.h"

@interface FahuoListViewController ()
{
    UIButton *unreceivedBtn; //未收Btn
    UIButton *receivedBtn; //已收Btn
    NSMutableArray *diaohuoFahuoArr;
    NSString *type;
    BOOL isreceived;
}
@end

@implementation FahuoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isreceived = NO;
    type = @"0";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.fahuotalbeView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.fahuotalbeView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    self.fahuotalbeView.backgroundColor = UIColorFromRGB(0xE6E6E6);
    self.fahuotalbeView.delegate=self;
    self.fahuotalbeView.dataSource=self;
    self.fahuotalbeView.tableFooterView = [[UIView alloc] init];
    self.fahuotalbeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.fahuotalbeView];
    
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self configUI];

}

- (void)viewWillAppear:(BOOL)animated{
    diaohuoFahuoArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self invokeData];
}

- (void)invokeData{
    [diaohuoFahuoArr removeAllObjects];
    [self.fahuotalbeView reloadData];
    [HttpTask getDiaohuofahuoList:[GlobleData sharedInstance].userid type:type sucessBlock:^(NSString *responseStr) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSString *status = [dictionary objectForKey:@"status"];
        if ([status isEqualToString:@"1"]) {
            NSArray *biilsArr = [dictionary objectForKey:@"bills"];
            for (NSDictionary *dic in biilsArr) {
                Diaohuofahuomodel *model = [[Diaohuofahuomodel alloc] init];
                model.creatTime = dic[@"createdate"];
                model.ptsName = dic[@"DiaoHuoPtsName"];
                model.billCode = dic[@"BILLCODE"];
                model.state = [self nsnumberTranstTostring:dic[@"status"]];
                model.billid = dic[@"BILLid"];
                [diaohuoFahuoArr addObject:model];
            }
            [self.fahuotalbeView reloadData];
        }
    } failBlock:^(NSDictionary *errDic) {
        
    }];
}
// 配置UI
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"调货发货列表";
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

#pragma mark -- tableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return diaohuoFahuoArr.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [self.fahuotalbeView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DiaohuofahuoTableViewCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DiaohuofahuoTableViewCell *Scell = (DiaohuofahuoTableViewCell *)cell;
        Scell.frame = CGRectMake(0, 0, self.fahuotalbeView.frame.size.width, 111);
        Diaohuofahuomodel *fahuoModel = [diaohuoFahuoArr objectAtIndex:indexPath.section];
        if ([fahuoModel.state isEqualToString:@"0"]) {
            Scell.stateLabel.text = @"未收";
            [Scell.stateImgView setImage:[UIImage imageNamed:@"notGet"]];
        }else{
            Scell.stateLabel.text = @"已收";
            [Scell.stateImgView setImage:[UIImage imageNamed:@"didGet"]];
        }
        Scell.billidLabel.text = fahuoModel.billCode;
        Scell.billid = fahuoModel.billid;
        Scell.ptsNameLabel.text = fahuoModel.ptsName;
        Scell.timeLabel.text = fahuoModel.creatTime;
        Scell.backview.layer.cornerRadius = 5;
        Scell.backview.clipsToBounds = 5;
        
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DiaohuofahuoTableViewCell *Scell = (DiaohuofahuoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [GlobleData sharedInstance].billid = Scell.billid;
    [GlobleData sharedInstance].type = type;
    [GlobleData sharedInstance].isdiaohuofahuocommodity = YES;
    DiaohuoFahuodanViewController  *Vc = [[DiaohuoFahuodanViewController alloc] init];
    [self presentViewController:Vc animated:YES completion:nil];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
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
