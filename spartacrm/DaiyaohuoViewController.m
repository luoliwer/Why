//
//  DaiyaohuoViewController.m
//  wly
//
//  Created by luolihacker on 16/5/3.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "DaiyaohuoViewController.h"
#import "DaiyaohuoTableViewCell.h"
#import "Daiyaohuomodel.h"

@interface DaiyaohuoViewController ()
{
    NSMutableArray *daiyaohuoArr;
}

@end

@implementation DaiyaohuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xE6E6E6);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];

    [self configUI];
    // Do any additional setup after loading the view.
}
// 配置UI
- (void)configUI{
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"代要货列表";
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

-(void)viewWillAppear:(BOOL)animated{
    daiyaohuoArr = [NSMutableArray array];
    [self invokeData];
}

- (void)invokeData{
    [HttpTask waityaohuo:[GlobleData sharedInstance].userid sucessBlock:^(NSString *responseStr) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSString *statusStr = [dictionary objectForKey:@"status"];
        if ([statusStr isEqualToString:@"1"]) {
            NSArray *dataArr = [dictionary objectForKey:@"list"];
            for (NSDictionary *dic in dataArr) {
                Daiyaohuomodel *model = [[Daiyaohuomodel alloc] init];
                model.commodity = [dic objectForKey:@"dh"];
                model.cangkuName = [dic objectForKey:@"yhf"];
                model.time = [dic objectForKey:@"modedatacreatetime"];
                model.status = [dic objectForKey:@"status"];
                [daiyaohuoArr addObject:model];
            }
            [self.tableView reloadData];
        }
        
    } failBlock:^(NSDictionary *errDic) {
        
    }];
    
    
}
#pragma mark -- tableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return daiyaohuoArr.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DaiyaohuoTableViewCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        DaiyaohuoTableViewCell *Scell = (DaiyaohuoTableViewCell *)cell;
        Scell.backView.layer.cornerRadius = 5.0;
        Scell.backView.clipsToBounds = YES;
        Scell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 110);
        Daiyaohuomodel *daiyaohuomodel = [daiyaohuoArr objectAtIndex:indexPath.section];
        Scell.idlabel.text = daiyaohuomodel.commodity;
        Scell.cangkuNameLabel.text = daiyaohuomodel.cangkuName;
        Scell.timeLabel.text = daiyaohuomodel.time;
        if ([daiyaohuomodel.status isEqualToString:@"0"]) {
            Scell.sendStatusLabel.text = @"待发";
        }else{
            Scell.sendStatusLabel.text = @"已发";
        }
        
    }
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
