//
//  BumaView.m
//  wly
//
//  Created by luolihacker on 16/5/8.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "BumaView.h"
#import "VerifySuccessTableViewCell.h"
#import "BumaModel.h"
@interface BumaView()
{
    NSMutableArray *bumaArray;
}
@end
@implementation BumaView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        bumaArray = [[NSMutableArray alloc] init];
        self.frame = CGRectMake(0, 94, frame.size.width, frame.size.height / 2.0 - 94);
        self.backgroundColor = [UIColor redColor];
        [self invokeData];
        self.bumaTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        self.bumaTable.tableFooterView = [[UIView alloc] init];
        self.bumaTable.dataSource = self;
        self.bumaTable.delegate = self;
        [self addSubview:self.bumaTable];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cellIdentity";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"VerifySuccessTableViewCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        VerifySuccessTableViewCell *Scell = (VerifySuccessTableViewCell *)cell;
        BumaModel *bumamodel = [self.dataArr objectAtIndex:indexPath.row];
        Scell.backgroundColor = UIColorFromRGB(0xf2f2f2);
        Scell.numberLabel.text = bumamodel.wlm;
        Scell.wineNameLabel.text = bumamodel.cpmc;
    }
    
    return cell;
}
- (void)invokeData{
    [HttpTask buma:[GlobleData sharedInstance].userid wuliuma:[GlobleData sharedInstance].shouhuocomdities billid:[GlobleData sharedInstance].daishouhuoCommodity_id sucessBlock:^(NSString *responseStr) {
        NSError *error;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding: NSUTF8StringEncoding] options:kNilOptions error:&error];
        NSString *status = [dictionary objectForKey:@"is_abnormal"];
        if ([status isEqualToString:@"1"]) {
            NSArray *array = [dictionary objectForKey:@"items"];
            for (NSDictionary *dic in array) {
                BumaModel *model = [[BumaModel alloc] init];
                model.cpmc = dic[@"cpmc"];
                model.wlm = dic[@"wlm"];
                [bumaArray addObject:model];
            }
            self.dataArr = bumaArray;
            [self.bumaTable reloadData];
        }
    } failBlock:^(NSDictionary *errDic) {
        
    }];
}
@end
