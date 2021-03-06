//
//  ColleaguesModel.m
//  YLZG
//
//  Created by Chan_Sir on 16/9/7.
//  Copyright © 2016年 郑振东. All rights reserved.
//

#import "ColleaguesModel.h"
#import "ContactersModel.h"
#import <MJExtension.h>

@implementation ColleaguesModel


+ (NSMutableArray *)mj_objectArrayWithKeyValuesArray:(id)keyValuesArray
{
    if (![keyValuesArray isKindOfClass:[NSArray class]]) return nil;
    NSMutableArray *modelArray = [super mj_objectArrayWithKeyValuesArray:keyValuesArray];
    for (ColleaguesModel *model in modelArray) {
        NSMutableArray *array1 = [NSMutableArray array];
        
        NSArray *result1 = [model.member copy];
        for (NSDictionary *dic in result1) {
            ContactersModel *contacts = [ContactersModel mj_objectWithKeyValues:dic];
            
            [array1 addObject:contacts];
        }
        model.member = array1;
    }
    
    return modelArray;
    
}

@end
