//
//  GroupListManager.h
//  YLZG
//
//  Created by Chan_Sir on 16/9/29.
//  Copyright © 2016年 陈振超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLGroup.h"

/********** 群组列表缓存管理者 **********/


typedef void(^GroupModelBlock)(YLGroup *groupModel);

@interface GroupListManager : NSObject

/**
 群组信息
 
 @param model 一个群组信息
 */
+ (BOOL)saveGroupInfo:(YLGroup *)model;

/**
 获取全部群组信息
 
 @return 群组数组
 */
+ (NSMutableArray *)getAllGroupInfo;


/**
 通过群组名称获取群组信息
 
 @param groupName 群组名称
 
 @return 群组信息
 */
+ (YLGroup *)getGroupInfoByGroupName:(NSString *)groupName;


/**
 根据群组ID来获取一个群组的详细信息

 @param gID        群组ID。环信
 @param modelBlock 群组信息回调
 */
+ (void)getGroupInfoByGroupID:(NSString *)gID Block:(GroupModelBlock)modelBlock;

/**
 清空群组数据库的数据
 
 @return 成功与否
 */
+ (BOOL)deleteAllGroupInfo;

@end
