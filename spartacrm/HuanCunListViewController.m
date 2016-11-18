//
//  HuanCunListViewController.m
//  wly
//
//  Created by luolihacker on 16/5/20.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "HuanCunListViewController.h"
#import "CacheTableViewCell.h"

@interface HuanCunListViewController ()<UIAlertViewDelegate>
{
    NSInteger focusSection;
    NSInteger focusRow;
}

@end

@implementation HuanCunListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    // 给Cell加长按手势
    UILongPressGestureRecognizer *gestureLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureLongPress:)];
    gestureLongPress.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:gestureLongPress];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    self.tableView.delegate=self;
    self.tableView.backgroundColor = UIColorFromRGB(0xE6E6E6);
    //    self.scanViewController.delegate = self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
    [self configUI];
}
- (void)initData{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    self.dataArray = [userDefault objectForKey:@"cacheData"];
    
    // 筛选
    if ([self.type isEqualToString:@"5"]) {
        
    }else{
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray];
        if ([self.type isEqualToString:@"0"]) {
            for (NSDictionary *dic in self.dataArray) {
                if (dic && [[dic objectForKey:@"type"] isEqualToString:self.type]) {
                }else{
                    [tempArray removeObject:dic];
                }
            }
            self.dataArray = [NSArray arrayWithArray:tempArray];
        }else if ([self.type isEqualToString:@"1"]){
            for (NSDictionary *dic in self.dataArray) {
                if (dic && [[dic objectForKey:@"type"] isEqualToString:self.type]) {
                }else{
                    [tempArray removeObject:dic];
                }
            }
            self.dataArray = [NSArray arrayWithArray:tempArray];
        }else if ([self.type isEqualToString:@"2"]){
            for (NSDictionary *dic in self.dataArray) {
                if (dic && [[dic objectForKey:@"type"] isEqualToString:self.type]) {
                }else{
                    [tempArray removeObject:dic];
                }
            }
            self.dataArray = [NSArray arrayWithArray:tempArray];
        }else if ([self.type isEqualToString:@"3"]){
            for (NSDictionary *dic in self.dataArray) {
                if (dic && [[dic objectForKey:@"type"] isEqualToString:self.type]) {
                }else{
                    [tempArray removeObject:dic];
                }
            }
            self.dataArray = [NSArray arrayWithArray:tempArray];
        }else if ([self.type isEqualToString:@"4"]){
            for (NSDictionary *dic in self.dataArray) {
                if (dic && [[dic objectForKey:@"type"] isEqualToString:self.type]) {
                }else{
                    [tempArray removeObject:dic];
                }
            }
            self.dataArray = [NSArray arrayWithArray:tempArray];
        }
    }
}

- (void)configUI{
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
    title.textColor = UIColorFromRGB(0x545454);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"离线缓存列表";
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CacheTableViewCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CacheTableViewCell *Scell = (CacheTableViewCell *)cell;
        Scell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 201);
        Scell.backView.layer.cornerRadius = 5.0;
        Scell.backView.clipsToBounds = YES;
        NSDictionary *danjuDic = [self.dataArray objectAtIndex:indexPath.row];
        if ([self.type isEqualToString:@"5"]) {
            if (danjuDic) {
                NSString *remarkString = [danjuDic objectForKey:@"remark"];
                Scell.remarkLabel.text = remarkString;
                Scell.timeLabel.text = [danjuDic objectForKey:@"currentDate"];
                Scell.typeString = [danjuDic objectForKey:@"type"];
                NSDictionary *thingsDic = [danjuDic objectForKey:@"huowuType"];
                NSArray *array = [danjuDic objectForKey:@"data"];
                NSString *numStr = [NSString stringWithFormat:@"总共%d件",array.count];
                Scell.wlmDataArray = array;
                Scell.totalNum.text = numStr;
                
                if (thingsDic) {
                    if (thingsDic.count == 1) {
                        [thingsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            NSString *textStr = [NSString stringWithFormat:@"%@:%@件",key,obj];
                            Scell.cpName.text = textStr;
                        }];
                        
                    }else{
                        [thingsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            NSString *str = [NSString stringWithFormat:@"%@:%@件\n",key,obj];
                            [str stringByAppendingString:str];
                            Scell.cpName.text = str;
                        }];
                    }
                }
            }
        }else if(danjuDic && [self.type isEqualToString:[danjuDic objectForKey:@"type"]])
            {
                NSString *remarkString = [danjuDic objectForKey:@"remark"];
                Scell.remarkLabel.text = remarkString;
                Scell.timeLabel.text = [danjuDic objectForKey:@"currentDate"];
                NSDictionary *thingsDic = [danjuDic objectForKey:@"huowuType"];
                NSArray *array = [danjuDic objectForKey:@"data"];
                Scell.wlmDataArray = array;
                NSString *numStr = [NSString stringWithFormat:@"总共%d件",array.count];
                Scell.totalNum.text = numStr;
                if (thingsDic) {
                    if (thingsDic.count == 1) {
                        [thingsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            NSString *textStr = [NSString stringWithFormat:@"%@:%@件",key,obj];
                            Scell.cpName.text = textStr;
                        }];
                        
                    }else{
                        [thingsDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                            NSString *str = [NSString stringWithFormat:@"%@:%@件\n",key,obj];
                            [str stringByAppendingString:str];
                            Scell.cpName.text = str;
                            CGSize size = CGSizeMake(Scell.frame.size.width - 24, 100);
                            NSDictionary *attribute = @{NSFontAttributeName:Scell.cpName.font};
                            CGSize labelSize = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
                            Scell.cpName.frame = CGRectMake(Scell.cpName.frame.origin.x, Scell.cpName.frame.origin.y, labelSize.width, labelSize.height);
                            CGRect rect = Scell.frame;
                            rect.size.height = Scell.frame.size.height + labelSize.height - 43;
                            Scell.frame = rect;
                        }];
                    }
                }
            }
        }
    return cell;
}
#pragma mark -- UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CacheTableViewCell *SCell = (CacheTableViewCell *)cell;
        if (_transArray) {
            _transArray(SCell.wlmDataArray);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backforward{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 长按删除
- (void)gestureLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    CGPoint tmpPonit = [gestureRecognizer locationInView:self.tableView];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tmpPonit];
        if (indexPath == nil) {
            NSLog(@"not TableView");
        }else{
            UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示！" message:@"是否确认删除？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alerView.tag = 2009;
            focusSection = [indexPath section];
            focusRow = [indexPath row];
            NSLog(@"%d",focusSection);
            NSLog(@"%d",focusRow);
            [alerView show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 2009) {
        switch (buttonIndex) {
            case 0:
            {
                //删除
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:focusRow inSection:focusSection];
                // 从数据源中删除
              
                NSMutableArray *array = [self.dataArray mutableCopy];
                [array removeObjectAtIndex:indexPath.row];
                self.dataArray = [array copy];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:self.dataArray forKey:@"cacheData"];
                // 从列表中删除
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
                break;
            default:
                break;
        }
    }
}
@end
