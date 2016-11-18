//
//  DaiShouHuoViewController.m
//  wly
//
//  Created by luolihacker on 16/1/24.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "DaiShouHuoViewController.h"
#import "ReceiveViewController.h"
#import "HttpTask.h"
#import "Daishouhuo.h"
@interface DaiShouHuoViewController ()
{
    NSMutableArray *daishouhuoArr;
    UIButton *unreceivedBtn;
    UIButton *receivedBtn;
    NSString *type;
    BOOL isreceived;
}
@end

@implementation DaiShouHuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isreceived = NO;
    type = @"0";
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height - 104);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xE6E6E6);
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    unreceivedBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 69 ,self.view.bounds.size.width / 2.0 - 20 ,30 )];
    unreceivedBtn.layer.borderWidth = 1.0;
    unreceivedBtn.layer.borderColor = [UIColor blackColor].CGColor;
    unreceivedBtn.layer.cornerRadius = 5.0;
    unreceivedBtn.clipsToBounds = YES;
    [unreceivedBtn setTitle:@"未收" forState:UIControlStateNormal];
    [unreceivedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [unreceivedBtn addTarget:self action:@selector(clickUnreceivedBtn) forControlEvents:UIControlEventTouchUpInside];
    unreceivedBtn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:unreceivedBtn];
    
    receivedBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2.0, 69,unreceivedBtn.bounds.size.width, 30)];
    receivedBtn.layer.borderWidth = 1.0;
    receivedBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [receivedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    receivedBtn.layer.cornerRadius = 5.0;
    receivedBtn.clipsToBounds = YES;
    [receivedBtn setTitle:@"已收" forState:UIControlStateNormal];
    [receivedBtn addTarget:self action:@selector(clicReceivedBtn) forControlEvents:UIControlEventTouchUpInside];
    receivedBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:receivedBtn];
    
    [self configUI];
    // Do any additional setup after loading the view.
}
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"待收货列表";
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
    daishouhuoArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self invokeData];
}

- (void)invokeData{
    [daishouhuoArr removeAllObjects];
    [self.tableView reloadData];
    [HttpTask waitreceive:[GlobleData sharedInstance].userid type:type sucessBlock:^(NSString *responseStr) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        
        NSString *status = [dictionary objectForKey:@"status"];
        NSString *msg = [dictionary objectForKey:@"msg"];
        NSNumberFormatter *numberformatter = [[NSNumberFormatter alloc] init];
        if ([status isEqualToString:@"1"]) {
            NSArray *orderlistArr = [dictionary objectForKey:@"orderList"];
            for (NSDictionary *dic in orderlistArr) {
                Daishouhuo *daishouhuo = [[Daishouhuo alloc] init];
                daishouhuo.status = [numberformatter stringFromNumber:[dic objectForKey:@"status"]];
                daishouhuo.describe = [dic objectForKey:@"describe"];
                daishouhuo.ordername = [dic objectForKey:@"orderName"];
                daishouhuo.commodity_id = [dic objectForKey:@"commodity_id"];
                daishouhuo.createDate = [dic objectForKey:@"createdate"];
                [daishouhuoArr addObject:daishouhuo];
            }
            [self.tableView reloadData];
        }else{
            NSLog(@"%@",msg);
        }
        
    } failBlock:^(NSDictionary *errDic) {
        
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- tableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return daishouhuoArr.count;
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"daiShouhuoCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        daiShouhuoCell *Scell = (daiShouhuoCell *)cell;
        Daishouhuo *daishouhuo = [daishouhuoArr objectAtIndex:indexPath.section];
        
        if ([daishouhuo.status isEqualToString:@"0"]) {
            Scell.shouQuLabel.text = @"未收";
            [Scell.shouQuImg setImage:[UIImage imageNamed:@"notGet"]];
        }else{
            Scell.shouQuLabel.text = @"已收";
            [Scell.shouQuImg setImage:[UIImage imageNamed:@"didGet"]];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        Scell.dingDanLabel.text = daishouhuo.ordername;
        Scell.pingTaiLabel.text = daishouhuo.describe;
        Scell.timeLabel.text = daishouhuo.createDate;
        Scell.commodity_id = daishouhuo.commodity_id;
        Scell.backGroundView.layer.cornerRadius = 5;
        Scell.backGroundView.clipsToBounds = 5;
        
    }
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 133;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    daiShouhuoCell *Scell = (daiShouhuoCell *)[tableView cellForRowAtIndexPath:indexPath];
    [GlobleData sharedInstance].daishouhuoCommodity_id = Scell.commodity_id;
    if ([Scell.shouQuLabel.text isEqualToString:@"未收"]) {
        [GlobleData sharedInstance].isDidGet = NO;
    }else{
        [GlobleData sharedInstance].isDidGet = YES;
    }
    [GlobleData sharedInstance].type = type;
    ReceiveViewController *Vc = [[ReceiveViewController alloc] init];
    [self presentViewController:Vc animated:YES completion:nil];

}
// 点击未发按钮
- (void)clickUnreceivedBtn{
    type = @"0";
    [self invokeData];
    isreceived = NO;
    receivedBtn.backgroundColor = [UIColor whiteColor];
    unreceivedBtn.backgroundColor = [UIColor grayColor];
    
}
// 点击已收按钮
- (void)clicReceivedBtn{
    type = @"1";
    [self invokeData];
    isreceived = YES;

    unreceivedBtn.backgroundColor = [UIColor whiteColor];
    receivedBtn.backgroundColor = [UIColor grayColor];
}
- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
