//
//  DaiFahuoViewController.m
//  wly
//
//  Created by luolihacker on 16/4/12.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "DaiFahuoViewController.h"
#import "DaifahuoTableViewCell.h"
#import "HttpTask.h"
#import "FaHuoDanViewController.h"
#import "Daishouhuo.h"

@implementation DaiFahuoViewController
{
    NSMutableArray *daifahuoArr;
    UIButton *sendedBtn; // 已发
    UIButton *unsendBtn; //未发
    NSString *type; // 类型参数
    BOOL isSended;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    type = @"0";
    isSended = NO;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height - 104);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.backgroundColor = UIColorFromRGB(0xE6E6E6);
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    unsendBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 69 ,self.view.bounds.size.width / 2.0 - 20 ,30 )];
    unsendBtn.layer.borderWidth = 1.0;
    unsendBtn.layer.borderColor = [UIColor blackColor].CGColor;
    unsendBtn.layer.cornerRadius = 5.0;
    unsendBtn.clipsToBounds = YES;
    [unsendBtn setTitle:@"未发" forState:UIControlStateNormal];
    [unsendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [unsendBtn addTarget:self action:@selector(clickUnsendBtn) forControlEvents:UIControlEventTouchUpInside];
    unsendBtn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:unsendBtn];
    
    sendedBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width / 2.0, 69,unsendBtn.bounds.size.width, 30)];
    sendedBtn.layer.borderWidth = 1.0;
    sendedBtn.layer.borderColor = [UIColor blackColor].CGColor;
    [sendedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendedBtn.layer.cornerRadius = 5.0;
    sendedBtn.clipsToBounds = YES;
    [sendedBtn setTitle:@"已发" forState:UIControlStateNormal];
    [sendedBtn addTarget:self action:@selector(clicSendedBtn) forControlEvents:UIControlEventTouchUpInside];
    sendedBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sendedBtn];
    
    [self configUI];
}
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"待发货列表";
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
    daifahuoArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self invokeData];
}
// 获取网络数据
- (void)invokeData{
    
    [daifahuoArr removeAllObjects];
    [self.tableView reloadData];
    [HttpTask waitsend:[GlobleData sharedInstance].userid type:type sucessBlock:^(NSString *responseStr) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSString *status = [dictionary objectForKey:@"status"];
        NSString *msg = [dictionary objectForKey:@"msg"];
        if ([status isEqualToString:@"1"]) {
            NSArray *orderlistArr = [dictionary objectForKey:@"orderList"];
            for (NSDictionary *dic in orderlistArr) {
                Daishouhuo *daishouhuo = [[Daishouhuo alloc] init];
                daishouhuo.status = [dic objectForKey:@"status"];
                daishouhuo.describe = [dic objectForKey:@"describe"];
                daishouhuo.ordername = [dic objectForKey:@"orderName"];
                daishouhuo.commodity_id = [dic objectForKey:@"billid"];
                [daifahuoArr addObject:daishouhuo];
            }
            [self.tableView reloadData];
        }else{
            NSLog(@"%@",msg);
        }

    } failBlock:^(NSDictionary *error) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return daifahuoArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DaifahuoTableViewCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DaifahuoTableViewCell *Scell = (DaifahuoTableViewCell *)cell;
        Daishouhuo *daishouhuo = [[Daishouhuo alloc] init];
        daishouhuo = [daifahuoArr objectAtIndex:indexPath.section];
        if ([daishouhuo.status isEqualToString:@"0"]) {
            Scell.stateLabel.text = @"未发";
            [Scell.stateImgView setImage:[UIImage imageNamed:@"notGet"]];
        }else{
            Scell.stateLabel.text = @"已发";
            [Scell.stateImgView setImage:[UIImage imageNamed:@"didGet"]];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        Scell.idLabel.text = daishouhuo.ordername;
        Scell.timeLabel.text = daishouhuo.describe;
        Scell.billid = daishouhuo.commodity_id;
        Scell.backView.layer.cornerRadius = 5;
        Scell.backView.clipsToBounds = 5;
        
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 87;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DaifahuoTableViewCell *Scell = (DaifahuoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [GlobleData sharedInstance].daishouhuoCommodity_id = Scell.billid;
    if ([Scell.stateLabel.text isEqualToString:@"未发"]) {
        [GlobleData sharedInstance].isDidSend = NO;
    }else{
        [GlobleData sharedInstance].isDidSend = YES;
    }
    [GlobleData sharedInstance].type = type;
    FaHuoDanViewController *Vc = [[FaHuoDanViewController alloc] init];
    [self presentViewController:Vc animated:YES completion:nil];
    
}
// 点击未发
- (void)clickUnsendBtn{
    type = @"0";
    [self invokeData];
    isSended = NO;
    sendedBtn.backgroundColor = [UIColor whiteColor];
    unsendBtn.backgroundColor = [UIColor grayColor];

}

// 点击已发
- (void)clicSendedBtn{
    type = @"1";
    [self invokeData];
    isSended = YES;

    unsendBtn.backgroundColor = [UIColor whiteColor];
    sendedBtn.backgroundColor = [UIColor grayColor];
}

- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
