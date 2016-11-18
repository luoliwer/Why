//
//  ScanPhoneViewController.m
//  wly
//
//  Created by luolihacker on 15/12/16.
//  Copyright © 2015年 vojo. All rights reserved.
//

#import "ScanPhoneViewController.h"
#import "MainTabBarViewController.h"
#import "ReceiveViewController.h"
#import "HuanCunListViewController.h"
#import "VerifySuccessTableViewCell.h"
#import "GlobleData.h"
#import "MBProgressHUD.h"
#import "BumaModel.h"
#import "BumaView.h"
#import "VJUtil.h"
#import "HttpTask.h"

@interface ScanPhoneViewController ()<UITextFieldDelegate>
{
    NSString *remark;
    NSString *number;
    BOOL isScanPhoneBtn;
    UILabel *title;
    UIButton *clickScanBtn;
    UITextField *textfield;
    UILabel *shishounumLabel;
    UILabel *label1;
    BOOL isbuma; //是否需要补码
    NSDictionary *danjuInfoDic; // 存放单据信息数组里的某条信息
    
    NSMutableArray *jianmaArr; // 件码
    NSMutableArray *pingmaArr; // 瓶码
}
@end

@implementation ScanPhoneViewController
@synthesize listData=_listData;
@synthesize tableView = _tableView;
@synthesize tableViewCell =_tableViewCell;
@synthesize scanGunBtn;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    jianmaArr = [[NSMutableArray alloc] init];
    pingmaArr = [[NSMutableArray alloc] init];
    isbuma = YES;
    self.shouhuoType = [GlobleData sharedInstance].dealtype;
    [GlobleData sharedInstance].isNormalCode = NO;
    danjuInfoDic = [NSDictionary dictionary];
    // 添加键盘响应的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // 创建自定义的触摸手势来实现对键盘的隐藏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    // 设置成 NO 表示当前控件响应后会传播那个到其他控件上，默认为YES
    tapGestureRecognizer.cancelsTouchesInView = NO;
    // 将触摸事件添加到当前的View
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.isFirstScanGunData = YES;
    self.listData = [[NSMutableArray alloc] init];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if ([self.shouhuoType isEqualToString:@"2"] || [self.shouhuoType isEqualToString:@"3"]) {
        NSString *billid = [GlobleData sharedInstance].daishouhuoCommodity_id;
        billid = [NSString stringWithFormat:@"%@",billid];
        NSString *usrid = [GlobleData sharedInstance].userid;
        NSString *shouhuoKey = [[usrid stringByAppendingString:billid] stringByAppendingString:self.shouhuoType];
        NSDictionary *dic = [userdefault objectForKey:shouhuoKey];
        if (dic.count != 0) {
            if ([[dic objectForKey:@"type"] isEqualToString:self.shouhuoType]) {
                self.listData = [dic objectForKey:@"listData"];
            }
        }
    }else if([self.shouhuoType isEqualToString:@"6"]){
        NSString *zdsid = [NSString stringWithFormat:@"%@",self.zdsId];
        NSString *usrid = [GlobleData sharedInstance].userid;
        NSString *keyId;
        NSString *usreKey;
        if (zdsid && zdsid.length > 0) {
            keyId = [NSString stringWithFormat:@"%@",zdsid];
            usreKey = [[usrid stringByAppendingString:keyId] stringByAppendingString:self.shouhuoType];
        }else{
            usreKey = [usrid stringByAppendingString:self.shouhuoType];
        }
        self.listData = [userdefault objectForKey:usreKey];
    }else if([self.shouhuoType isEqualToString:@"5"]){
        //离线缓存暂不处理
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 94, self.view.frame.size.width, self.view.frame.size.height- 104);
    self.tableView.delegate=self;
//    self.scanViewController.delegate = self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self creatInfoView];
    [self configUI];
    if (![self.shouhuoType isEqualToString:@"5"] && ![self.shouhuoType isEqualToString:@"6"]) {
        UIButton *huanCunBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 80, 28, 70, 25)];
        huanCunBtn.layer.borderColor = [UIColor blackColor].CGColor;
        huanCunBtn.layer.borderWidth = 0.5;
        [huanCunBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [huanCunBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [huanCunBtn setTitle:@"导入缓存" forState:UIControlStateNormal];
        huanCunBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        huanCunBtn.layer.cornerRadius = 4.0;
        huanCunBtn.clipsToBounds = YES;
        [huanCunBtn addTarget:self action:@selector(enterHuanCunList) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:huanCunBtn];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated{
    if ([GlobleData sharedInstance].clickScanGunFaHuoBtn) {
        [textfield becomeFirstResponder];
    }
    [self.tableView reloadData];
}
- (void)configUI{
    
    title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
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

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    bottomView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    scanGunBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, self.view.frame.size.height -36, 34, 30)];
    [scanGunBtn addTarget:self action:@selector(changeToScanGun) forControlEvents:UIControlEventTouchUpInside];
    [scanGunBtn setBackgroundImage:[UIImage imageNamed:@"IMG_0029.jpg"] forState:UIControlStateNormal];
    
    textfield = [[UITextField alloc] init];
    textfield.keyboardType = UIKeyboardTypeNumberPad;
    textfield.delegate = self;
    textfield.frame = CGRectMake(58, scanGunBtn.frame.origin.y, 150, 30);
    textfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.font = [UIFont systemFontOfSize:14];
    textfield.layer.borderWidth = 1.5;
    textfield.layer.borderColor = [UIColor orangeColor].CGColor;
    
    clickScanBtn = [[UIButton alloc] initWithFrame:CGRectMake(58, scanGunBtn.frame.origin.y, 150, 30)];
    clickScanBtn.backgroundColor = [UIColor redColor];
    [clickScanBtn setTitle:@"点击扫描" forState:UIControlStateNormal];
    [clickScanBtn addTarget:self action:@selector(clickScan) forControlEvents:UIControlEventTouchUpInside];
    clickScanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    if ([GlobleData sharedInstance].clickScanGunFaHuoBtn) {
        clickScanBtn.hidden = YES;
         textfield.hidden = NO;
        if ([[GlobleData sharedInstance].dealtype isEqualToString:@"6"]) {
            title.text = @"蓝牙枪扫描";
        }else{
            title.text = @"蓝牙枪扫描情况";
        }
        isScanPhoneBtn = YES;
    }else{
        clickScanBtn.hidden = NO;
        textfield.hidden = YES;
        if ([[GlobleData sharedInstance].dealtype isEqualToString:@"6"]) {
            title.text = @"手机扫描";
        }else{
            title.text = @"手机签收";
        }
        isScanPhoneBtn = NO;
    }
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(220, self.view.frame.size.height - 36, 92, 30)];
    button.backgroundColor = [UIColor redColor];
    if ([[GlobleData sharedInstance].dealtype isEqualToString:@"6"]) {
        [button addTarget:self action:@selector(sureTuihuo) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"确定退货" forState: UIControlStateNormal];

    }else{
        if (self.isCacheScan) {
            [button addTarget:self action:@selector(saveCache) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"保存缓存" forState: UIControlStateNormal];
        }else{
            [button addTarget:self action:@selector(sureReceivePro) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"确认收货" forState: UIControlStateNormal];
        }
    }
    
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [self.view addSubview:bottomView];
    [self.view addSubview:button];
    [self.view addSubview:scanGunBtn];
    [self.view addSubview:clickScanBtn];
    [self.view addSubview:textfield];
    
}

- (void)creatInfoView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 30)];
    view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 7.5, 60, 20)];
    label.text = @"扫描清单";
    [label setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:label];
    
    // 创建应收label
    if (self.isCacheScan || [self.shouhuoType isEqualToString:@"6"]) {
        
    }else{
        UILabel *yingshouLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 7.5, 50, 20)];
        yingshouLabel.text = @"应收:";
        yingshouLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:yingshouLabel];
        // 创建应收数量label
        UILabel *yingshounumLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 7.5, 100, 20)];
        yingshounumLabel.text = [NSString stringWithFormat:@"%@件%@瓶",[GlobleData sharedInstance].num,[GlobleData sharedInstance].pingCount];
        yingshounumLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:yingshounumLabel];
    }

    label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, 7.5, 80, 20)];
    [pingmaArr removeAllObjects];
    [jianmaArr removeAllObjects];
    for (NSData *data in self.listData) {
        BumaModel *dataModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dataModel.wlm.length == 14) {
            [pingmaArr addObject:dataModel.wlm];
        }else{
            [jianmaArr addObject:dataModel.wlm];
        }
    }
    label1.text = [NSString stringWithFormat:@"已扫%d件%d瓶",jianmaArr.count,pingmaArr.count];
    [label1 setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:label1];
    [self.view addSubview:view];

}
// 键盘监听事件
- (void)keyboardWillShow:(NSNotification *)noti
{
    NSDictionary *userInfo = [noti userInfo];
    NSValue *avalue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = [avalue CGRectValue];
    CGFloat higth = rect.size.height;
    CGFloat y = textfield.frame.origin.y + 44 + higth - self.view.frame.size.height;
    self.view.frame = CGRectMake(0, - y, self.view.frame.size.width, self.view.frame.size.height);
}
- (void)keyboardWillHidden:(NSNotification *)noti
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
// 点击屏幕任何地方，键盘消失
- (void) keyboardHide:(UITapGestureRecognizer *)tap{
    [textfield resignFirstResponder];
}

#pragma mark -- UITextFieldDelegate

// 响应输入框的回车事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length != 14 && textField.text.length != 24) {
        [self showMessage:@"请录入正确的物流码"];
        textfield.text = @"";
        return YES;
    }else if([self.shouhuoType isEqualToString:@"6"] || [self.shouhuoType isEqualToString:@"5"]){
    
    }else{
        if (textField.text.length == 24) {
            if (jianmaArr.count > [[GlobleData sharedInstance].num intValue] || jianmaArr.count == [[GlobleData sharedInstance].num intValue]) {
                textfield.text = @"";
                [self showMessage:@"件码已扫描完成"];
                return YES;
            }
        }else{
            if (pingmaArr.count > [[GlobleData sharedInstance].pingCount intValue] || pingmaArr.count ==  [[GlobleData sharedInstance].pingCount intValue]) {
                textfield.text = @"";
                [self showMessage:@"瓶码已扫描完成"];
                return YES;
            }
        }
    }
    BOOL isexist = NO;
    if ([self.shouhuoType isEqualToString:@"6"] || [self.shouhuoType isEqualToString:@"5"]) {
        for (NSData *data in self.listData) {
            BumaModel *datamodel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if ([textField.text isEqualToString:datamodel.wlm]) {
                isexist = YES;
                break;
            }
        }
        if (isexist) {
            textfield.text = @"";
            [self showMessage:@"该物流码已经扫描过，不能重复扫描！"];
            return YES;
        }else{
            [self verifyCode:textField.text];
        }
    }else{
        if (self.listData.count == 0) {
            [self verifyCode:textField.text];
        }else{
            for (NSData *data in self.listData) {
                BumaModel *datamodel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if ([textField.text isEqualToString:datamodel.wlm]) {
                    isexist = YES;
                    break;
                }
            }
            if (isexist) {
                textfield.text = @"";
                [self showMessage:@"该物流码已经扫描过，不能重复扫描！"];
                return YES;
            }else{
                [self verifyCode:textField.text];
            }
        }
    }
    [self.tableView reloadData];
    
    [pingmaArr removeAllObjects];
    [jianmaArr removeAllObjects];
    
    for (NSData *data in self.listData) {
        BumaModel *dataModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dataModel.wlm.length == 14) {
            [pingmaArr addObject:dataModel.wlm];
        }else{
            [jianmaArr addObject:dataModel.wlm];
        }
    }
    label1.text = [NSString stringWithFormat:@"已扫%d件%d瓶",jianmaArr.count,pingmaArr.count];
    textfield.text = @"";
    return YES;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
        textField.text = @"";
 
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([[textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        textField.text = @"";
    }
}

// 只允许输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)numberStr {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < numberStr.length) {
        NSString * string = [numberStr substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

#pragma mark -- tableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}

// 使分割线顶到最左边
-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"VerifySuccessTableViewCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        VerifySuccessTableViewCell *Scell = (VerifySuccessTableViewCell *)cell;
        
        NSData *data = [self.listData objectAtIndex:indexPath.row];
        BumaModel *datamodel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        Scell.numberLabel.text = datamodel.wlm;
        Scell.wineNameLabel.text = datamodel.cpmc;

    }
    
    return cell;
    
}

//Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//定义编辑样式，出现重排按钮
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView setEditing:NO animated:NO];
//    return UITableViewCellEditingStyleDelete;
//}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获取对应的cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    VerifySuccessTableViewCell *Scell = (VerifySuccessTableViewCell *)cell;
    // 从数据源中删除
    self.listData = [NSMutableArray arrayWithArray:self.listData];
    [self.listData removeObjectAtIndex:indexPath.row];
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    if ([self.shouhuoType isEqualToString:@"2"] || [self.shouhuoType isEqualToString:@"3"]) {
        NSString *detailJson;
        NSString *JSONString;
     
        
        NSString *userid = [GlobleData sharedInstance].userid;
        NSString *billid = [NSString stringWithFormat:@"%@",[GlobleData sharedInstance].daishouhuoCommodity_id];
        NSString *shouhuoKey = [[userid stringByAppendingString:billid] stringByAppendingString:self.shouhuoType];

        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [userdefault objectForKey:shouhuoKey];
        detailJson = [dic objectForKey:@"JSON"];
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"listData"]];
        for (NSData *data in dataArray) {
            BumaModel *datamodel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if ([Scell.numberLabel.text isEqualToString:datamodel.wlm]) {
                NSError *error;
                NSMutableArray *dicDetailList= [NSJSONSerialization JSONObjectWithData:[detailJson dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
                NSDictionary *infodic = [VJUtil delCommodityCode:Scell.numberLabel.text dicDetailList:dicDetailList];
                NSMutableArray *array = [infodic objectForKey:@"dicDetailList"];
                
                // 将得到的数组转成JSON串再存入NSUserDefault
                NSData *JSONdata = [self toJSONData:array];
                JSONString = [[NSString alloc] initWithData:JSONdata encoding:NSUTF8StringEncoding];
                JSONString = [JSONString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // 到这个位置只能去掉字符串两端的空格，中间的还未去掉
                NSArray *components = [JSONString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                JSONString = [components componentsJoinedByString:@""];
                NSLog(@"JSONStr = %@",JSONString);
                
                break;
            }
        }
        
        NSString *type = self.shouhuoType;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",billid,@"billid",self.listData,@"listData",JSONString,@"JSON", nil];
        NSUserDefaults *usrdefault = [NSUserDefaults standardUserDefaults];
        [usrdefault setObject:dictionary forKey:shouhuoKey];
    }else if ([self.shouhuoType isEqualToString:@"6"]){
        
        NSString *zdsid = [NSString stringWithFormat:@"%@",self.zdsId];
        NSString *usrid = [GlobleData sharedInstance].userid;
        NSString *keyId;
        NSString *usreKey;
        if (zdsid && zdsid.length > 0) {
            keyId = [NSString stringWithFormat:@"%@",zdsid];
            usreKey = [[usrid stringByAppendingString:keyId] stringByAppendingString:self.shouhuoType];
        }else{
            usreKey = [usrid stringByAppendingString:self.shouhuoType];
        }
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setObject:self.listData forKey:usreKey];
        [userdefault synchronize];
        
    }
    [pingmaArr removeAllObjects];
    [jianmaArr removeAllObjects];
    for (NSData *data in self.listData) {
        BumaModel *dataModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dataModel.wlm.length == 14) {
            [pingmaArr addObject:dataModel.wlm];
        }else{
            [jianmaArr addObject:dataModel.wlm];
        }
    }
    label1.text = [NSString stringWithFormat:@"已扫%d件%d瓶",jianmaArr.count,pingmaArr.count];
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (void)sureReceivePro{
//    NSLog(@"%@",[GlobleData sharedInstance].num);
    if (self.listData.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先扫描货物" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.tag = 1003;
        [alert show];
    }else if([self.shouhuoType isEqualToString:@"2"]){
        if (jianmaArr.count < [[GlobleData sharedInstance].num intValue] && jianmaArr.count > 0 && isbuma) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示！" message:@"收货数量不匹配，是否进行补码？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
            alertView.tag = 1001;
            [alertView show];
            
        }else if((jianmaArr.count == [[GlobleData sharedInstance].num intValue] && pingmaArr.count == [[GlobleData sharedInstance].pingCount intValue]) || !isbuma){
            NSString *msg = [NSString stringWithFormat:@"本次应收货%@件%@瓶，您扫描了%d件%d瓶，是否确认收此批货物？",[GlobleData sharedInstance].num,[GlobleData sharedInstance].pingCount,jianmaArr.count,pingmaArr.count];
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag = 201602;
            [alert show];
        }else if([[GlobleData sharedInstance].num integerValue] == 0 && pingmaArr.count < [[GlobleData sharedInstance].pingCount integerValue]){
            NSInteger leaveNum = [[GlobleData sharedInstance].num intValue] - jianmaArr.count;
            NSString *msg = [NSString stringWithFormat:@"本次应收货%@件%@瓶，您扫描了%d件%d瓶，退货%d件，是否确认收此批货物？",[GlobleData sharedInstance].num,[GlobleData sharedInstance].pingCount,jianmaArr.count,pingmaArr.count,leaveNum];
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
             alert.tag = 201602;
            [alert show];
        }
    }else if ([self.shouhuoType isEqualToString:@"3"]){
        if (jianmaArr.count < [[GlobleData sharedInstance].num intValue] || pingmaArr.count <[[GlobleData sharedInstance].pingCount intValue]) {
            NSInteger leaveNum = [[GlobleData sharedInstance].num intValue] - jianmaArr.count;
            NSString *msg = [NSString stringWithFormat:@"本次应收货%@件%@瓶，您扫描了%d件%d瓶，退货%d件，是否确认收此批货物？",[GlobleData sharedInstance].num,[GlobleData sharedInstance].pingCount,jianmaArr.count,pingmaArr.count,leaveNum];
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag = 201601;
            [alert show];
            
        }else{
            NSString *msg = [NSString stringWithFormat:@"本次应收货%@件%@瓶，您扫描了%d件%d瓶，是否确认收此批货物？",[GlobleData sharedInstance].num,[GlobleData sharedInstance].pingCount,jianmaArr.count,pingmaArr.count];
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag = 201601;
            [alert show];
        }
    }
}
// 收货数据提交
- (void)commitData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    remark = [[NSString alloc] init];
    number = [[NSString alloc] init];
    [pingmaArr removeAllObjects];
    [jianmaArr removeAllObjects];
    for (NSData *data in self.listData) {
        BumaModel *dataModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dataModel.wlm.length == 14) {
            [pingmaArr addObject:dataModel.wlm];
        }else{
            [jianmaArr addObject:dataModel.wlm];
        }
    }
    NSString *userid = [GlobleData sharedInstance].userid;
    NSString *commodityStr = [[NSString alloc] init];
    NSString *pingmaStr = [[NSString alloc] init];
    if (jianmaArr.count == 0) {
        commodityStr = @"";
    }else{
        commodityStr = [jianmaArr componentsJoinedByString:@","];
        commodityStr = [commodityStr stringByAppendingString:@","];
    }
    if (pingmaArr.count == 0) {
        pingmaStr = @"";
    }else{
        pingmaStr = [pingmaArr componentsJoinedByString:@","];
        pingmaStr = [pingmaStr stringByAppendingString:@","];
    }
    [HttpTask receiveProcCommdity:commodityStr billid:[GlobleData sharedInstance].daishouhuoCommodity_id barcode_ids:pingmaStr userid:userid sucessBlock:^(NSString *responseStr) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        number = [dictionary objectForKey:@"is_abnormal"];
        remark = [dictionary objectForKey:@"remark"];
        if ([number isEqualToString:@"1"]) {
            NSString *billid = [GlobleData sharedInstance].daishouhuoCommodity_id;
            billid = [NSString stringWithFormat:@"%@",billid];
            NSString *shouhuoKey = [[userid stringByAppendingString:billid] stringByAppendingString:self.shouhuoType];
            NSUserDefaults *usrdefault = [NSUserDefaults standardUserDefaults];
            [usrdefault removeObjectForKey:shouhuoKey];
            [self showMessage:@"收货成功"];
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
            [GlobleData sharedInstance].isPhoneScanToScanView = NO;
            
        }else if([number isEqualToString:@"0"]){
            [self showMessage:@"收货失败"];
        }
    } failBlock:^(NSDictionary *dicErr) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

// 调货收货数据提交
- (void)commitdiaohuoshouhuodata{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *jianmaStr = [[NSString alloc] init];
    NSString *pingmaStr = [[NSString alloc] init];
    [pingmaArr removeAllObjects];
    [jianmaArr removeAllObjects];
    for (NSData *data in self.listData) {
        BumaModel *datamodel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (datamodel.wlm.length == 14) {
            [pingmaArr addObject:datamodel];
        }else{
            [jianmaArr addObject:datamodel.wlm];
        }
    }
    if (pingmaArr.count == 0) {
        pingmaStr = @"";
    }else{
        pingmaStr = [pingmaArr componentsJoinedByString:@","];
        pingmaStr = [pingmaStr stringByAppendingString:@","];
    }
    if (jianmaArr.count == 0) {
        jianmaStr = @"";
    }else{
        jianmaStr = [jianmaArr componentsJoinedByString:@","];
        jianmaStr = [jianmaStr stringByAppendingString:@","];
    }
    
    NSString *userid = [GlobleData sharedInstance].userid;
    [HttpTask diaohuoshouhuo:userid billid:[GlobleData sharedInstance].daishouhuoCommodity_id commodity:jianmaStr barcode_ids:pingmaStr sucessBlock:^(NSString *responseStr) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSString *status = [dictionary objectForKey:@"status"];
        if ([status isEqualToString:@"1"]) {
            
            NSString *billid = [GlobleData sharedInstance].daishouhuoCommodity_id;
            billid = [NSString stringWithFormat:@"%@",billid];
            NSString *shouhuoKey = [[userid stringByAppendingString:billid] stringByAppendingString:self.shouhuoType];
            NSUserDefaults *usrdefault = [NSUserDefaults standardUserDefaults];
            [usrdefault removeObjectForKey:shouhuoKey];
            [self showMessage:@"收货成功"];
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        }else{
            NSString *msg = [dictionary objectForKey:@"msg"];
            [self showMessage:msg];
        }

    } failBlock:^(NSDictionary *errorDic) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001 || alertView.tag == 1002 || alertView.tag == 1003) {
        if (alertView.tag == 1001) {
            if (buttonIndex == 0) {
                isbuma = NO;
                NSString *commodityString = [self.listData componentsJoinedByString:@","];
                [GlobleData sharedInstance].shouhuocomdities = commodityString;
                self.tableView.frame = CGRectMake(0, self.view.frame.size.height / 2.0 , self.view.frame.size.width, self.view.frame.size.height / 2.0 - 40);
                BumaView *view = [[BumaView alloc] initWithFrame:self.view.frame];
                [self.view addSubview:view];
            }else{
                NSInteger leaveNum = [[GlobleData sharedInstance].num intValue] - jianmaArr.count;
                NSString *msg = [NSString stringWithFormat:@"本次应收货%@件%@瓶，您扫描了%d件%d瓶，退货%d件，是否确认收货？",[GlobleData sharedInstance].num,[GlobleData sharedInstance].pingCount,jianmaArr.count,pingmaArr.count,leaveNum];
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                alert.tag = 2009;
                [alert show];
            }
        }
    }
    if (alertView.tag == 2008) {
        if (buttonIndex == 0) {
            [self saveTheCacheData];
        }
    }
    if (alertView.tag == 2009) {
        if (buttonIndex == 0) {
            [self commitData];
        }
    }
    if (alertView.tag == 201707) {
        if (buttonIndex == 0) {
            [self tuihuoCommit];
        }
    }
    if (alertView.tag == 201601) {
        if (buttonIndex == 0) {
            [self commitdiaohuoshouhuodata];
        }
    }
    if (alertView.tag == 201602) {
        if (buttonIndex == 0) {
            [self commitData];
        }
    }
}

// 保存离线缓存扫描的数据
- (void)saveTheCacheData{
    NSString *currentDate = [self createCurrentTime];
    NSMutableDictionary *huowuDic = self.huowuKindDic;
    NSMutableArray *dataArr = self.listData;
    NSString *describRemark = self.describremark;
    NSString *currentDateStr = currentDate;
    danjuInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self.thingsType,@"type",huowuDic,@"huowuType",dataArr,@"data",describRemark,@"remark",currentDateStr,@"currentDate", nil];
    NSLog(@"%@",danjuInfoDic);
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *infoArray = [userDefault objectForKey:@"cacheData"];
    if (infoArray && infoArray.count != 0) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:infoArray];
        [tempArray addObject:danjuInfoDic];
        self.danjuArray = [NSArray arrayWithArray:tempArray];
        [userDefault setObject:self.danjuArray forKey:@"cacheData"];
        [userDefault synchronize];
    }else{
        self.danjuArray = [NSArray arrayWithObjects:danjuInfoDic, nil];
        [userDefault setObject:self.danjuArray forKey:@"cacheData"];
    }

}

- (void)backToMainTabBar{
    
    MainTabBarViewController *MainVc = [[MainTabBarViewController alloc] init];
    [self presentViewController:MainVc animated:YES completion:nil];
    [GlobleData sharedInstance].isPhoneScanToScanView = NO;

}

- (void)passValue:(NSString *)value
{
    if (value.length != 14 && value.length != 24) {
        [self showMessage:@"请录入正确的物流码"];
        return;
    }else if([self.shouhuoType isEqualToString:@"6"] || [self.shouhuoType isEqualToString:@"5"]){
    
    }else{
        if (value.length == 24) {
            if (jianmaArr.count > [[GlobleData sharedInstance].num intValue] || jianmaArr.count == [[GlobleData sharedInstance].num intValue]) {
                [self showMessage:@"件码已扫描完成"];
                return;
            }
        }else{
            if (pingmaArr.count > [[GlobleData sharedInstance].pingCount intValue] || pingmaArr.count ==  [[GlobleData sharedInstance].pingCount intValue]) {
                [self showMessage:@"瓶码已扫描完成"];
                return;
            }
        }
    }
    BOOL isexist = NO;
    if ([self.shouhuoType isEqualToString:@"6"] || [self.shouhuoType isEqualToString:@"5"]) {
        for (NSData *data in self.listData) {
            BumaModel *datamodel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if ([value isEqualToString:datamodel.wlm]) {
                isexist = YES;
                break;
            }
        }
        if (isexist) {
            [self showMessage:@"该物流码已经扫描过，不能重复扫描！"];
            return;
        }else{
            [self verifyCode:value];
        }
    }else{
        if (self.listData.count == 0) {
            [self verifyCode:value];
        }else{
            for (NSData *data in self.listData) {
                BumaModel *datamodel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if ([value isEqualToString:datamodel.wlm]) {
                    isexist = YES;
                    break;
                }
            }
            if (isexist) {
                [self showMessage:@"该物流码已经扫描过，不能重复扫描！"];
                return;
            }else{
                [self verifyCode:value];
            }
        }
    }
    [self.tableView reloadData];
    [pingmaArr removeAllObjects];
    [jianmaArr removeAllObjects];
    for (NSData *data in self.listData) {
        BumaModel *dataModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dataModel.wlm.length == 14) {
            [pingmaArr addObject:dataModel.wlm];
        }else{
            [jianmaArr addObject:dataModel.wlm];
        }
    }
    label1.text = [NSString stringWithFormat:@"已扫%d件%d瓶",jianmaArr.count,pingmaArr.count];
}

- (void)clickScan{
    
    ScanViewController *viewVC = [[ScanViewController alloc] init];
    viewVC.delegate = self;
    [self presentViewController:viewVC animated:YES completion:nil];
}

- (void)changeToScanGun
{
    if (isScanPhoneBtn) {
        clickScanBtn.hidden = NO;
        textfield.hidden = YES;
        if ([self.shouhuoType isEqualToString:@"6"]) {
            title.text = @"手机扫描";
        }else{
            title.text = @"手机签收";
        }
        
       [scanGunBtn setBackgroundImage:[UIImage imageNamed:@"IMG_0029.jpg"] forState:UIControlStateNormal];
    }else{
        [textfield becomeFirstResponder];
        [scanGunBtn setBackgroundImage:[UIImage imageNamed:@"IMG_0028.jpg"] forState:UIControlStateNormal];
        if ([self.shouhuoType isEqualToString:@"6"]) {
            title.text = @"蓝牙枪扫描";
        }else{
            title.text = @"蓝牙枪扫描情况";
        }
        
        clickScanBtn.hidden = YES;
        textfield.hidden = NO;
    }
    isScanPhoneBtn = !isScanPhoneBtn;
    
}

// 保存缓存
- (void)saveCache{
    if (self.listData.count == 0 || self.listData == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先扫描货物" delegate:nil cancelButtonTitle:@"确定"otherButtonTitles: nil];
        [alert show];
    }else{
        NSString *msg = [NSString stringWithFormat:@"共扫描%d件，是否确认保存缓存？",self.listData.count];
        UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        aler.tag = 2008;
        [aler show];
    }
}

// 确定退货
- (void)sureTuihuo{
    if (self.listData.count == 0 || self.listData == nil){
        [self showMessage:@"请先扫描货物"];
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"共扫描%d件%d瓶,是否确定退货？",jianmaArr.count,pingmaArr.count];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag = 201707;
    [alertView show];
    
}

// 退货提交
- (void)tuihuoCommit{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *userid = [GlobleData sharedInstance].userid;
    NSString *commodityStr = [[NSString alloc] init];
    NSString *pingmaStr = [[NSString alloc] init];
    if (jianmaArr.count == 0) {
        commodityStr = @"";
    }else{
        commodityStr = [jianmaArr componentsJoinedByString:@","];
        commodityStr = [commodityStr stringByAppendingString:@","];
    }
    if (pingmaArr.count == 0) {
        pingmaStr = @"";
    }else{
        pingmaStr = [pingmaArr componentsJoinedByString:@","];
        pingmaStr = [pingmaStr stringByAppendingString:@","];
    }
    [HttpTask sureTuihuo:commodityStr barcode_ids:pingmaStr userid:userid thdx:self.tuihuoType thzds:self.zdsId sucessBlock:^(NSString *responseStr) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSString *status = [dictionary objectForKey:@"status"];
        if ([status isEqualToString:@"1"]) {
            
            NSString *zdsid = [NSString stringWithFormat:@"%@",self.zdsId];
            NSString *usrid = [GlobleData sharedInstance].userid;
            NSString *keyId;
            NSString *usreKey;
            if (zdsid && zdsid.length > 0) {
                keyId = [NSString stringWithFormat:@"%@",zdsid];
                usreKey = [[usrid stringByAppendingString:keyId] stringByAppendingString:self.shouhuoType];
            }else{
                usreKey = [usrid stringByAppendingString:self.shouhuoType];
            }
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault removeObjectForKey:usreKey];
            
            [self showMessage:@"退货成功"];
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        }
    } failBlock:^(NSDictionary *errDic) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];

}
- (void)enterHuanCunList{
    
    HuanCunListViewController *Vc = [[HuanCunListViewController alloc] init];
    Vc.transArray= ^(NSArray *tempArray){
        self.tempArray = tempArray;
        for (NSData *data in self.tempArray) {
            BumaModel *dataModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            BOOL isexist = NO;
            if (self.listData.count == [[GlobleData sharedInstance].num intValue]) {
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示！" message:@"该批货物已扫满" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alerView show];
                return;
            }else{
                if (self.listData.count == 0) {
                    [self verifyCode:dataModel.wlm];
                }else{
                    NSLog(@"count2 = %d",self.listData.count);
                    for (NSData *data in self.listData) {
                        BumaModel *datamodel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        if ([dataModel.wlm isEqualToString:datamodel.wlm]) {
                            isexist = YES;
                            break;
                        }
                    }
                    if (isexist) {
                        NSString *msg = [NSString stringWithFormat:@"%@已经扫描过，不能重复扫描",dataModel.wlm];
                        UIAlertView *alertView = [[UIAlertView alloc]   initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [alertView show];
                        continue;
                    }else{
                        [self verifyCode:dataModel.wlm];
                    }
                }
            }
        }
        [self.tableView reloadData];
        for (NSData *data in self.listData) {
            BumaModel *dataModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (dataModel.wlm.length == 14) {
                [pingmaArr addObject:dataModel.wlm];
            }else{
                [jianmaArr addObject:dataModel.wlm];
            }
        }
        label1.text = [NSString stringWithFormat:@"已扫%d件%d瓶",jianmaArr.count,pingmaArr.count];
    };
    Vc.type = self.shouhuoType;
    [self presentViewController:Vc animated:YES completion:nil];
}

- (NSString *)createCurrentTime{
    
    self.createdate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [formatter stringFromDate:self.createdate];
    return dateStr;
    
}

- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 验证需要缓存的二维码
- (void)verifyCode:(NSString *)value{
    NSString *userid = [GlobleData sharedInstance].userid;
    NSString *billid = [NSString stringWithFormat:@"%@",[GlobleData sharedInstance].daishouhuoCommodity_id];
    NSString *shouhuoKey = [[userid stringByAppendingString:billid] stringByAppendingString:self.shouhuoType];
    NSUserDefaults *usrDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [usrDefault objectForKey:shouhuoKey];
    if (dic) {
        NSString *JSONStr = [dic objectForKey:@"JSON"];
        if (JSONStr && JSONStr.length > 0) {
            _detailJson = JSONStr;
            [self shouhuoCodeVerify:value];
        }else{
            if ([self.shouhuoType isEqualToString:@"2"]) {
                _detailJson = [GlobleData sharedInstance].shouhuoJSON;
                [self shouhuoCodeVerify:value];
                
            }else if([self.shouhuoType isEqualToString:@"3"]){
                _detailJson = [GlobleData sharedInstance].diaohuoshouhuoJSON;
                [self shouhuoCodeVerify:value];
            }
        }
    }else{
        if ([self.shouhuoType isEqualToString:@"2"]) {
            _detailJson = [GlobleData sharedInstance].shouhuoJSON;
            [self shouhuoCodeVerify:value];
            
        }else if([self.shouhuoType isEqualToString:@"3"]){
            _detailJson = [GlobleData sharedInstance].diaohuoshouhuoJSON;
            [self shouhuoCodeVerify:value];
            
        }else{
            [self unlineLoadingVerify:value];
        }
    }
}

// 收货，调货收货验证
- (void)shouhuoCodeVerify:(NSString *)value{
    
    
    NSError *error;
    NSMutableArray *dicDetailList= [NSJSONSerialization JSONObjectWithData:[_detailJson dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    NSMutableDictionary *dicInfo = [VJUtil checkCommodityCode:value dicDetailList:dicDetailList];
    
    // 如果扫描通过会返回相应的信息dicInfo
    if (dicInfo) {
        NSString *status = [dicInfo objectForKey:@"status"];
        if ([status isEqualToString:@"0"]) {
            NSString *msg = [dicInfo objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            
            NSArray *infoArray = [dicInfo objectForKey:@"dicDetailList"];
            // 将得到的数组转成JSON串再存入NSUserDefault
            NSData *JSONdata = [self toJSONData:infoArray];
            NSString *JSONString = [[NSString alloc] initWithData:JSONdata encoding:NSUTF8StringEncoding];
            JSONString = [JSONString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // 到这个位置只能去掉字符串两端的空格，中间的还未去掉
            NSArray *components = [JSONString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            JSONString = [components componentsJoinedByString:@""];
            NSLog(@"JSONStr = %@",JSONString);
            NSString *labelStr = [dicInfo objectForKey:@"cpmc"];
            BumaModel *model = [[BumaModel alloc] init];
            model.wlm = [dicInfo objectForKey:@"cpbm"];
            model.cpmc = labelStr;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
            self.listData = [NSMutableArray arrayWithArray:self.listData];
            [self.listData addObject:data];
            [GlobleData sharedInstance].listData = self.listData;
            NSString *type = self.shouhuoType;
            NSString *billid = [GlobleData sharedInstance].daishouhuoCommodity_id;
            billid = [NSString stringWithFormat:@"%@",billid];
            NSString *userid = [GlobleData sharedInstance].userid;
            NSString *key = [[userid stringByAppendingString:billid] stringByAppendingString:self.shouhuoType];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",billid,@"billid",self.listData,@"listData",JSONString,@"JSON", nil];
            NSUserDefaults *usrdefault = [NSUserDefaults standardUserDefaults];
            [usrdefault setObject:dic forKey:key];
            [usrdefault synchronize];
        }
    }
}

// 离线缓存扫码验证
- (void)unlineLoadingVerify:(NSString *)value{
    NSDictionary *dicInfo = [VJUtil saleCommodityCode:value];
    // 如果扫描通过会返回相应的信息dicInfo
    if (dicInfo) {
        NSString *status = [dicInfo objectForKey:@"status"];
        if ([status isEqualToString:@"0"]) {
            NSString *msg = [dicInfo objectForKey:@"msg"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            
            NSString *indexString = @"1";
            NSString *cpbm = [dicInfo objectForKey:@"cpbm"];
            NSString *cpmc = [dicInfo objectForKey:@"cpmc"];
            if (self.huowuKindDic.count != 0) {
                [self.huowuKindDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([key isEqualToString:cpmc]) {
                        obj = [NSString stringWithFormat:@"%d",[obj integerValue]+1];
                        [self.huowuKindDic setObject:obj forKey:cpmc];
                    }else{
                        [self.huowuKindDic setObject:indexString forKey:cpmc];
                    }
                }];
            }else{
                self.huowuKindDic = [NSMutableDictionary dictionaryWithObject:indexString forKey:cpmc];
            }
            
            BumaModel *model = [[BumaModel alloc] init];
            model.wlm = cpbm;
            model.cpmc = cpmc;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
            self.listData = [NSMutableArray arrayWithArray:self.listData];
            [self.listData addObject:data];
            if ([self.shouhuoType isEqualToString:@"6"]) {
                NSString *zdsid = [NSString stringWithFormat:@"%@",self.zdsId];
                NSString *usrid = [GlobleData sharedInstance].userid;
                NSString *keyId;
                NSString *usreKey;
                if (zdsid && zdsid.length > 0) {
                    keyId = [NSString stringWithFormat:@"%@",zdsid];
                    usreKey = [[usrid stringByAppendingString:keyId] stringByAppendingString:self.shouhuoType];
                }else{
                    usreKey = [usrid stringByAppendingString:self.shouhuoType];
                }
                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                [userdefault setObject:self.listData forKey:usreKey];
                [userdefault synchronize];
            }else{
                // 离线缓存暂时不处理
            }
        }
    }
}

// 将字典或者数组转化为JSON串
- (NSData *)toJSONData:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] != 0 && error == nil) {
        return jsonData;
    }else{
        return nil;
    }
}

//自定义提示框
- (void)showMessage:(NSString *)message
{
    CGSize size = [message sizeWithAttributes:@{NSFontAttributeName:K_FONT_14}];
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc] init];
    CGFloat w = size.width + 30;
    CGFloat h = size.height + 20;
    CGFloat x = (window.bounds.size.width - w) / 2;
    CGFloat y = window.bounds.size.height - h - 50;
    showview.frame = CGRectMake(x, y, w, h);
    showview.backgroundColor = RGB(0, 0, 0, 0.7);
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, w, h);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = K_FONT_14;
    label.text = message;
    [showview addSubview:label];
    [UIView animateWithDuration:2 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}
@end
