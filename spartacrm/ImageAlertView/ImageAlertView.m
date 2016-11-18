//
//  ImageAlertView.m
//  CIBSafeBrowser
//
//  Created by luolihacker on 15/12/30.
//  Copyright © 2015年 cib. All rights reserved.
//

#import "ImageAlertView.h"

@implementation ImageAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}

- (void)viewShowWithImage:(UIImage *)loadingImage message:(NSString *)message
{
    self.isSelect = YES;
    UIView *backgroud = [[UIView alloc] initWithFrame:self.frame];
    backgroud.backgroundColor = [UIColor blackColor];
    backgroud.alpha = 0.48;
    [self addSubview:backgroud];
    
    CGPoint center = backgroud.center;
    NSArray *array = [[NSArray alloc] initWithObjects:@"酒水终端商",@"大型KA卖场",@"高端餐饮店", nil];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(center.x - (self.frame.size.width / 2 - 24), center.y - 100, self.frame.size.width - 24, 200)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.cornerRadius = 8.f;
    self.tableView.clipsToBounds = 8.0f;
    [self addSubview:self.tableView];
    
}
#pragma mark -- tableView data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell.textLabel.text = @"高端餐饮店";
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.frame.size.width - 33, cell.center.y - 12.5, 25, 25)];
        [imageView setImage:[UIImage imageNamed:@"menu_ok"]];
        [cell addSubview:imageView];
  
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
@end
