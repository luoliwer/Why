//
//  ScanPhoneSendViewController.m
//  wly
//
//  Created by luolihacker on 15/12/16.
//  Copyright © 2015年 vojo. All rights reserved.
//

#import "ScanPhoneSendViewController.h"
#import "HuanCunListViewController.h"
#import "VerifySuccessTableViewCell.h"
#import "VJUtil.h"
#import "MBProgressHUD.h"
#import "MainTabBarViewController.h"
#import "HttpTask.h"
#import "BumaModel.h"
#import "GlobleData.h"

@interface ScanPhoneSendViewController ()<UITextFieldDelegate>
{
    NSString *remark;
    NSString *number;
    BOOL isScanPhoneBtn;
    UILabel *title;
    UIButton *clickScanBtn;
    UITextField *textfield;
    UILabel *yingfanumLabel;
    UILabel *label1;
    NSMutableArray *pingmaArr;
    NSMutableArray *jianmaArr;
    NSString *key;
}

@end

@implementation ScanPhoneSendViewController

@synthesize listData=_listData;
@synthesize tableView = _tableView;
@synthesize tableViewCell =_tableViewCell;
@synthesize scanGunBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    remark = [[NSString alloc] init];
    number = [[NSString alloc] init];
    pingmaArr = [[NSMutableArray alloc] init];
    jianmaArr = [[NSMutableArray alloc] init];
    self.fahuoType = [GlobleData sharedInstance].dealtype;
    // 添加键盘响应的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    // 创建自定义的触摸手势来实现对键盘的隐藏
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    // 设置成 NO 表示当前控件响应后会传播那个到其他控件上，默认为YES
    tapGestureRecognizer.cancelsTouchesInView = NO;
    // 将触摸事件添加到当前的View
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    self.listData = [[NSMutableArray alloc] init];
    NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
    if ([self.fahuoType isEqualToString:@"0"]) {
        
        NSString *billid = [GlobleData sharedInstance].fahuobillid;
        NSString *billidKey = [NSString stringWithFormat:@"%@",billid];
        NSString *userid = [GlobleData sharedInstance].userid;
        NSString *fahuoKey = [[userid stringByAppendingString:billidKey] stringByAppendingString:self.fahuoType];

        NSDictionary *dic = [userdefault objectForKey:fahuoKey];
        if (dic.count != 0) {
            if ([[dic objectForKey:@"type"] isEqualToString:self.fahuoType]) {
                self.listData = [dic objectForKey:@"listData"];
            }
        }
    }else if([self.fahuoType isEqualToString:@"1"]){
        
        NSString *userid = [GlobleData sharedInstance].userid;
        NSString *receieveId = [NSString stringWithFormat:@"%@",[GlobleData sharedInstance].receiveCompanyId];
        NSString *diaohuofahuoKey = [[userid stringByAppendingString:receieveId] stringByAppendingString:self.fahuoType];
        self.listData = [userdefault objectForKey:diaohuofahuoKey];
        
        
    }else{
        NSString *saleKey = [[GlobleData sharedInstance].userid stringByAppendingString:self.fahuoType]; // 调货发货key，销售key都用saleKey来标示
        self.listData = [userdefault objectForKey:saleKey];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 104);
    self.tableView.delegate=self;
    //    self.scanViewController.delegate = self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    
    [self configUI];
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

- (void)viewWillAppear:(BOOL)animated{
    if ([GlobleData sharedInstance].clickScanGunFaHuoBtn) {
        [textfield becomeFirstResponder];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }else if([self.fahuoType isEqualToString:@"4"] || [self.fahuoType isEqualToString:@"1"]){
        
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
    if ([self.fahuoType isEqualToString:@"1"] || [self.fahuoType isEqualToString:@"4"]) {
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
        if (self.listData.count == ([[GlobleData sharedInstance].num intValue] + [[GlobleData sharedInstance].pingCount intValue])) {
            textfield.text = @"";
            [self showMessage:@"该批货物已扫满"];
            return YES;
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
    }
     [self.tableView reloadData];
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

- (void)configUI{
    
    title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    if ([self.fahuoType isEqualToString:@"4"]) {
        title.text = @"手机销售";
    }else{
        title.text = @"手机扫描发货";
    }
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
    
    clickScanBtn = [[UIButton alloc] initWithFrame:CGRectMake(58, scanGunBtn.frame.origin.y, 150, 30)];
    clickScanBtn.backgroundColor = [UIColor redColor];
    [clickScanBtn setTitle:@"点击扫描" forState:UIControlStateNormal];
    [clickScanBtn addTarget:self action:@selector(clickScan) forControlEvents:UIControlEventTouchUpInside];
    clickScanBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    textfield = [[UITextField alloc] init];
    textfield.keyboardType = UIKeyboardTypeNumberPad;
    textfield.delegate = self;
    textfield.frame = CGRectMake(58, scanGunBtn.frame.origin.y, 150, 30);
    textfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 0)];
    textfield.leftViewMode = UITextFieldViewModeAlways;
    textfield.font = [UIFont systemFontOfSize:14];
    textfield.layer.borderWidth = 1.5;
    textfield.layer.borderColor = [UIColor orangeColor].CGColor;
    textfield.hidden = YES;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(220, self.view.frame.size.height - 36, 92, 30)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(sureSendPro) forControlEvents:UIControlEventTouchUpInside];
    if ([self.fahuoType isEqualToString:@"4"]) {
        [button setTitle:@"确认销售" forState:UIControlStateNormal];
    }else{
        [button setTitle:@"确认发货" forState: UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    if ([self.fahuoType isEqualToString:@"4"]) {
        if ([GlobleData sharedInstance].clickScanGunFaHuoBtn) {
            clickScanBtn.hidden = YES;
            textfield.hidden = NO;
            title.text = @"扫描枪销售";
            isScanPhoneBtn = YES;
        }else{
            clickScanBtn.hidden = NO;
            textfield.hidden = YES;
            title.text = @"手机销售";
            isScanPhoneBtn = NO;
        }

    }else{
        if ([GlobleData sharedInstance].clickScanGunFaHuoBtn) {
            clickScanBtn.hidden = YES;
            textfield.hidden = NO;
            title.text = @"蓝牙枪扫描发货";
            isScanPhoneBtn = YES;
        }else{
            clickScanBtn.hidden = NO;
            textfield.hidden = YES;
            title.text = @"手机扫描发货";
            isScanPhoneBtn = NO;
        }
    }
    [self.view addSubview:bottomView];
    [self.view addSubview:button];
    [self.view addSubview:scanGunBtn];
    [self.view addSubview:clickScanBtn];
    [self.view addSubview:textfield];
}
#pragma mark -- tableView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
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
    if ([self.fahuoType isEqualToString:@"0"]) {
        NSString *JSONString;
        NSString *billid = [GlobleData sharedInstance].fahuobillid;
        billid = [NSString stringWithFormat:@"%@",billid];
        NSString *userid = [GlobleData sharedInstance].userid;
        NSString *fahuoKey = [[userid stringByAppendingString:billid] stringByAppendingString:self.fahuoType];

        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        NSDictionary *dic = [userdefault objectForKey:fahuoKey];
        NSMutableArray *dataArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"listData"]];
        for (NSData *data in dataArray) {
            BumaModel *datamodel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if ([Scell.numberLabel.text isEqualToString:datamodel.wlm]) {
                NSString *detailJson = [dic objectForKey:@"JSON"];
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
        
        NSString *type = self.fahuoType;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",billid,@"billid",self.listData,@"listData",JSONString,@"JSON", nil];
        NSUserDefaults *usrdefault = [NSUserDefaults standardUserDefaults];
        [usrdefault setObject:dictionary forKey:fahuoKey];
        [usrdefault synchronize];
        
    }else if ([self.fahuoType isEqualToString:@"1"]){
        
        NSString *userid = [GlobleData sharedInstance].userid;
        NSString *receieveId = [NSString stringWithFormat:@"%@",[GlobleData sharedInstance].receiveCompanyId];
        NSString *userkey = [[userid stringByAppendingString:receieveId] stringByAppendingString:self.fahuoType];
        NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
        [userdefault setObject:self.listData forKey:userkey];
        [userdefault synchronize];
    }else if ([self.fahuoType isEqualToString:@"4"]){
        
        NSString *userkey = [[GlobleData sharedInstance].userid stringByAppendingString:self.fahuoType];
        NSUserDefaults *defaulft = [NSUserDefaults standardUserDefaults];
        [defaulft setObject:self.listData forKey:userkey];
        [defaulft synchronize];
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

#pragma mark -- UITableViewDelegate

// 每个Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

// header的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

// 自定义header
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 4, 80, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"扫描清单";
    [label setFont:[UIFont systemFontOfSize:15]];
    [view addSubview:label];
    if ([self.fahuoType isEqualToString:@"0"]) // 只有发货才有应发
    {
        // 添加应发label
        UILabel *yinghfaLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 4, 50, 20)];
        yinghfaLabel.text = @"应发：";
        [yinghfaLabel setFont:[UIFont systemFontOfSize:15]];
        [view addSubview:yinghfaLabel];
        
        // 添加应发数量label
        yingfanumLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 4, 100, 20)];
        NSString *string = [NSString stringWithFormat:@"%@件%@瓶",[GlobleData sharedInstance].num,[GlobleData sharedInstance].pingCount];
        yingfanumLabel.text = string;
        [yingfanumLabel setFont:[UIFont systemFontOfSize:15]];
        [view addSubview:yingfanumLabel];
    }
    
    label1 = [[UILabel alloc] initWithFrame:CGRectMake(230, 4, 100, 20)];
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
    return view;
}

//设置Cell可移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//当两个Cell对换位置后
- (void)tableView:(UITableView*)tableView moveRowAtIndexPath:(NSIndexPath*)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark -- 确定发货
- (void)sureSendPro{
    if (self.listData.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有扫描通过的货物" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }else if([self.fahuoType isEqualToString:@"0"]){
            NSString *string = [NSString stringWithFormat:@"本次应扫%@件%@瓶，您扫描了%d件%d瓶，是否确认发送此批货物？",[GlobleData sharedInstance].num, [GlobleData sharedInstance].pingCount,jianmaArr.count,pingmaArr.count];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认" message:string delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag = 10101;
            [alert show];
        
    }else if ([self.fahuoType isEqualToString:@"1"]){
        NSString *msg = [NSString stringWithFormat:@"您扫描了%d件%d瓶，是否确认发送此批货物？",jianmaArr.count,pingmaArr.count];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 2012;
        [alertView show];
    }else if([self.fahuoType isEqualToString:@"4"]){
        NSString *msg = [NSString stringWithFormat:@"共扫描%d件%d瓶,是否确认销售该商品？",jianmaArr.count,pingmaArr.count];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 2013;
        [alertView show];
    }
}

// 发货提交
-(void)commitData{
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
    NSString *commodityStr = [jianmaArr componentsJoinedByString:@","];
    commodityStr = [commodityStr stringByAppendingString:@","];
    NSString *pingmaStr = [pingmaArr componentsJoinedByString:@","];
    pingmaStr = [pingmaStr stringByAppendingString:@","];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpTask verifysendPro:userid commodity:commodityStr barcode_ids:pingmaStr yaohuodanid:[GlobleData sharedInstance].fahuobillid vehicle:[GlobleData sharedInstance].chePaiHao sucessBlock:^(NSString *responseStr) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSString *isnormal = [dictionary objectForKey:@"is_abnormal"];
        remark = [dictionary objectForKey:@"remark"];
        if ([isnormal isEqualToString:@"0"]) {
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"出现异常" message:remark delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
            
            [alerView show];
            
        }else if([isnormal isEqualToString:@"1"]){
            
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault removeObjectForKey:key];
            [userdefault synchronize];
            
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
            [self showMessage:@"发货成功"];
        }
        
    } failBlock:^(NSDictionary *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

// 调货发货提交
- (void)commitdiaohuofahuodata{
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
    NSString *commodityStr = [jianmaArr componentsJoinedByString:@","];
    commodityStr = [commodityStr stringByAppendingString:@","];
    NSString *pingmaStr = [pingmaArr componentsJoinedByString:@","];
    pingmaStr = [pingmaStr stringByAppendingString:@","];
    NSString *shouhuofang = [GlobleData sharedInstance].receiveCompanyId;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpTask diaohuofahuo:commodityStr barcode_ids:pingmaStr userid:userid cangkuid:shouhuofang chepaihao:self.chepaihao sucessBlock:^(NSString *responseStr) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSString *status = [dictionary objectForKey:@"status"];
        
        if ([status isEqualToString:@"1"]) {
            [self showMessage:@"发货成功"];
            NSString *receieveId = [NSString stringWithFormat:@"%@",[GlobleData sharedInstance].receiveCompanyId];
            NSString *userkey = [[userid stringByAppendingString:receieveId] stringByAppendingString:self.fahuoType];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            [userdefault removeObjectForKey:userkey];
            [userdefault synchronize];
            [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        }else{
            NSString *msg = [dictionary objectForKey:@"msg"];
            [self showMessage:msg];
        }
    } failBlock:^(NSDictionary *erroDic) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

// 销售
- (void)commitsaledata{
    [jianmaArr removeAllObjects];
    [pingmaArr removeAllObjects];
    for (NSData *data in self.listData) {
        BumaModel *dataModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (dataModel.wlm.length == 14) {
            [pingmaArr addObject:dataModel.wlm];
        }else{
            [jianmaArr addObject:dataModel.wlm];
        }
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *userid = [GlobleData sharedInstance].userid;
    NSString *commodityStr = [jianmaArr componentsJoinedByString:@","];
    commodityStr = [commodityStr stringByAppendingString:@","];
    NSString *pingmaStr = [pingmaArr componentsJoinedByString:@","];
    pingmaStr = [pingmaStr stringByAppendingString:@","];
    [HttpTask teminalsale:commodityStr barcode_ids:pingmaStr userid:userid sucessBlock:^(NSString *responseStr) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSString *status = [dictionary objectForKey:@"is_abnormal"];
        if ([status isEqualToString:@"1"]) {
            
            NSString *xiaoshouKey = [userid stringByAppendingString:self.fahuoType];
            NSUserDefaults *usrdefault = [NSUserDefaults standardUserDefaults];
            [usrdefault removeObjectForKey:xiaoshouKey];
            [usrdefault synchronize];
            [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
            [self showMessage:@"销售成功!"];
        }else{
            NSString *msg = [dictionary objectForKey:@"remark"];
            [self showMessage:msg];
        }

    } failBlock:^(NSDictionary *errorDic) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 10101) {
        if (buttonIndex == 0) {
            [self commitData];
        }
    }else if (alertView.tag == 2012){
        if (buttonIndex == 0) {
            [self commitdiaohuofahuodata];
        }
    }else if (alertView.tag == 2013){
        if (buttonIndex == 0) {
            [self commitsaledata];
        }else if(buttonIndex == 1){

        }
    }
}
- (void)passSendValue:(NSString *)value
{
    if (value.length != 14 && value.length != 24) {
        [self showMessage:@"请录入正确的物流码"];
        return;
    }else if([self.fahuoType isEqualToString:@"4"] || [self.fahuoType isEqualToString:@"1"]){
        
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
    if ([self.fahuoType isEqualToString:@"1"] || [self.fahuoType isEqualToString:@"4"]) {
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
        if (self.listData.count == ([[GlobleData sharedInstance].num intValue] + [[GlobleData sharedInstance].pingCount intValue])) {
            [self showMessage:@"该批货物已扫满"];
            return;
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
    }
    [self.tableView reloadData];
    
}
- (void)clickScan{
    
    sendScanViewControlller *viewVC = [[sendScanViewControlller alloc] init];
    viewVC.delegate = self;
    [self presentViewController:viewVC animated:YES completion:nil];
    
}
- (void)changeToScanGun
{
    if ([self.fahuoType isEqualToString:@"4"]) {
        if (isScanPhoneBtn) {
            clickScanBtn.hidden = NO;
            textfield.hidden = YES;
            title.text = @"手机销售";
            [scanGunBtn setBackgroundImage:[UIImage imageNamed:@"IMG_0029.jpg"] forState:UIControlStateNormal];
        }else{
            [textfield becomeFirstResponder];
            [scanGunBtn setBackgroundImage:[UIImage imageNamed:@"IMG_0028.jpg"] forState:UIControlStateNormal];
            title.text = @"蓝牙枪销售";
            clickScanBtn.hidden = YES;
            textfield.hidden = NO;
        }

    }else{
        if (isScanPhoneBtn) {
            clickScanBtn.hidden = NO;
            textfield.hidden = YES;
            title.text = @"手机扫描发货";
            [scanGunBtn setBackgroundImage:[UIImage imageNamed:@"IMG_0029.jpg"] forState:UIControlStateNormal];
        }else{
            
            [textfield becomeFirstResponder];
            [scanGunBtn setBackgroundImage:[UIImage imageNamed:@"IMG_0028.jpg"] forState:UIControlStateNormal];
            title.text = @"蓝牙枪扫描发货";
            clickScanBtn.hidden = YES;
            textfield.hidden = NO;
        }
    }
    isScanPhoneBtn = !isScanPhoneBtn;
}

// 验证二维码
- (void)verifyCode:(NSString *)value{
    NSString *detailJson = [[NSString alloc] init];
    if ([self.fahuoType isEqualToString:@"4"] || [self.fahuoType isEqualToString:@"1"]) {
        NSDictionary *dicInfo = [VJUtil saleCommodityCode:value];
        // 如果扫描通过会返回相应的信息dicInfo
        if (dicInfo) {
            NSString *status = [dicInfo objectForKey:@"status"];
            if ([status isEqualToString:@"0"]) {
                NSString *msg = [dicInfo objectForKey:@"msg"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }else{
                NSString *cpbm = [dicInfo objectForKey:@"cpbm"];
                NSString *cpmc = [dicInfo objectForKey:@"cpmc"];
                BumaModel *model = [[BumaModel alloc] init];
                model.wlm = cpbm;
                model.cpmc = cpmc;
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
                self.listData = [NSMutableArray arrayWithArray:self.listData];
                [self.listData addObject:data];
            }
            if ([self.fahuoType isEqualToString:@"1"]) {
                NSString *userid = [GlobleData sharedInstance].userid;
                NSString *receieveId = [NSString stringWithFormat:@"%@",[GlobleData sharedInstance].receiveCompanyId];
                NSString *userkey = [[userid stringByAppendingString:receieveId] stringByAppendingString:self.fahuoType];
                NSUserDefaults *defaulft = [NSUserDefaults standardUserDefaults];
                [defaulft setObject:self.listData forKey:userkey];
                [defaulft synchronize];
            }else{
                NSString *userkey = [[GlobleData sharedInstance].userid stringByAppendingString:self.fahuoType];
                NSUserDefaults *defaulft = [NSUserDefaults standardUserDefaults];
                [defaulft setObject:self.listData forKey:userkey];
                [defaulft synchronize];
            }
        }
    }else{
        if ([self.fahuoType isEqualToString:@"0"]) {
            
            NSString *billid = [GlobleData sharedInstance].fahuobillid;
            NSString *billidKey = [NSString stringWithFormat:@"%@",billid];
            NSString *userid = [GlobleData sharedInstance].userid;
            NSString *fahuoKey = [[userid stringByAppendingString:billidKey] stringByAppendingString:self.fahuoType];
            NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
            NSDictionary *dic = [userdefault objectForKey:fahuoKey];
            if (dic) {
                NSString *JSONStr = [dic objectForKey:@"JSON"];
                if (JSONStr && JSONStr.length > 0 ) {
                    detailJson = JSONStr;
                }else{
                    detailJson = [GlobleData sharedInstance].fahuoJSON;
                }
            }else{
                detailJson = [GlobleData sharedInstance].fahuoJSON;
            }
        }
        
        NSError *error;
        NSMutableArray *dicDetailList= [NSJSONSerialization JSONObjectWithData:[detailJson dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
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
                NSString *type = self.fahuoType;
                NSString *billid = [GlobleData sharedInstance].fahuobillid;
                NSString *billidKey = [NSString stringWithFormat:@"%@",billid];
                NSString *userid = [GlobleData sharedInstance].userid;
                key = [[userid stringByAppendingString:billidKey] stringByAppendingString:[GlobleData sharedInstance].dealtype];
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:type,@"type",billid,@"billid",self.listData,@"listData",JSONString,@"JSON", nil];
                NSUserDefaults *usrdefault = [NSUserDefaults standardUserDefaults];
                [usrdefault setObject:dic forKey:key];
                [usrdefault synchronize];
                
            }
        }
    }
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
    Vc.type = self.fahuoType;
    [self presentViewController:Vc animated:YES completion:nil];
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

- (void)backforward{
    [[GlobleData sharedInstance].listData removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:nil];
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
// NSNumber转换成NSString
- (NSString *)nsnumberTranstTostring:(NSNumber *)num
{
    NSNumberFormatter *numberformatter = [[NSNumberFormatter alloc] init];
    NSString *string = [numberformatter stringFromNumber:num];
    return string;
}
@end
