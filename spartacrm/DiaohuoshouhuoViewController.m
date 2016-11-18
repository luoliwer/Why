//
//  DiaohuoshouhuoViewController.m
//  wly
//
//  Created by luolihacker on 16/4/23.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "DiaohuoshouhuoViewController.h"
#import "HttpTask.h"
#import "ReceiveViewController.h"
#import "Diaohuoshouhuomodel.h"

@interface DiaohuoshouhuoViewController ()
{
    NSMutableArray *diaohuoshouhuoArr;
    UIButton *unreceivedBtn; //未收Btn
    UIButton *receivedBtn; //已收Btn
    NSString *type;
    BOOL isreceived;
}
@end

@implementation DiaohuoshouhuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isreceived = NO;
    type = @"0";
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xE6E6E6);
    self.tableView.frame = CGRectMake(0, 104, self.view.frame.size.width, self.view.frame.size.height - 104);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
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
    
}

- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"调货收货列表";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    diaohuoshouhuoArr = [[NSMutableArray alloc] initWithCapacity:0];
    [self invokeData];
}

- (void)invokeData{
    [diaohuoshouhuoArr removeAllObjects];
    [self.tableView reloadData];
    
    [HttpTask diaohuoshouhuo:[GlobleData sharedInstance].userid type:type sucessBlock:^(NSString *responseStr) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        
        NSNumberFormatter *numberformatter = [[NSNumberFormatter alloc] init];
        
        NSString *status = [dictionary objectForKey:@"status"];
        NSString *msg = [dictionary objectForKey:@"msg"];
        if ([status isEqualToString:@"1"]) {
            NSArray *billArr = [dictionary objectForKey:@"bills"];
            for (NSDictionary *dic in billArr) {
                Diaohuoshouhuomodel *diaohuoshouhuo = [[Diaohuoshouhuomodel alloc] init];
                diaohuoshouhuo.diaohuoflg = [dic objectForKey:@"flg"];
                diaohuoshouhuo.diaoHuoDate = [dic objectForKey:@"createdate"];
                diaohuoshouhuo.diaohuodanhao = [dic objectForKey:@"BILLCODE"];
                diaohuoshouhuo.diaohuoPingtaishangName = [dic objectForKey:@"DiaoHuoPtsName"];
                diaohuoshouhuo.diaohuobillid = [numberformatter stringFromNumber:[dic objectForKey:@"BILLid"]];
                [diaohuoshouhuoArr addObject:diaohuoshouhuo];
            }
            [self.tableView reloadData];
        }else{
            NSLog(@"%@",msg);
        }
        
    } failBlock:^(NSDictionary *errDic) {
        
    }];
    
}
#pragma mark -- tableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return diaohuoshouhuoArr.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DiaohuoshouhuoTableViewCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DiaohuoshouhuoTableViewCell *Scell = (DiaohuoshouhuoTableViewCell *)cell;
        Scell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 110);
        Diaohuoshouhuomodel *diaohuo = [diaohuoshouhuoArr objectAtIndex:indexPath.section];
        
        if ([diaohuo.diaohuoflg isEqualToString:@"0"]) {
             Scell.shouquLabel.text = @"未收";
            [Scell.diaohuostate setImage:[UIImage imageNamed:@"notGet"]];
        }else{
             Scell.shouquLabel.text = @"已收";
            [Scell.diaohuostate setImage:[UIImage imageNamed:@"didGet"]];
        }
        Scell.diaohuopingtaishang.text = diaohuo.diaohuoPingtaishangName;
        Scell.diaohuodanhao.text = diaohuo.diaohuodanhao;
        Scell.diaohuodate.text = diaohuo.diaoHuoDate;
        Scell.billid = diaohuo.diaohuobillid;
        Scell.backView.layer.cornerRadius = 5;
        Scell.backView.clipsToBounds = 5;
        
    }
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DiaohuoshouhuoTableViewCell *Scell = (DiaohuoshouhuoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [GlobleData sharedInstance].daishouhuoCommodity_id = Scell.billid;
    if ([Scell.shouquLabel.text isEqualToString:@"未收"]) {
        [GlobleData sharedInstance].isDidGet = NO;
    }else{
        [GlobleData sharedInstance].isDidGet = YES;
    }
    [GlobleData sharedInstance].daishouhuoCommodity_id = Scell.billid;
    [GlobleData sharedInstance].type = type;
    [GlobleData sharedInstance].isdiaohuofahuocommodity = YES;
    ReceiveViewController *Vc = [[ReceiveViewController alloc] init];
    [self presentViewController:Vc animated:YES completion:nil];
    
}

// 点击未发按钮
- (void)clickUnreceivedBtn{
    type = @"0";
    [self invokeData];
    isreceived = NO;
    unreceivedBtn.backgroundColor = [UIColor grayColor];
    receivedBtn.backgroundColor = [UIColor whiteColor];
}
// 点击已收按钮
- (void)clicReceivedBtn{
    type = @"1";
    [self invokeData];
    isreceived = YES;
    receivedBtn.backgroundColor = [UIColor grayColor];
    unreceivedBtn.backgroundColor = [UIColor whiteColor];
}


@end
