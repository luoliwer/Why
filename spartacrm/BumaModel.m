//
//  BumaModel.m
//  wly
//
//  Created by luolihacker on 16/5/8.
//  Copyright © 2016年 vojo. All rights reserved.
//

#import "BumaModel.h"

@implementation BumaModel
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.wlm forKey:@"wlm"];
    [aCoder encodeObject:self.cpmc forKey:@"cpmc"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.wlm = [aDecoder decodeObjectForKey:@"wlm"];
        self.cpmc = [aDecoder decodeObjectForKey:@"cpmc"];
    }
    return self;
}
@end
