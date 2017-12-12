//
//  MyNetOc.m
//  PlaneCartoon
//
//  Created by 高子雄 on 2017/9/4.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

#import "MyNetOc.h"

@implementation MyNetOc
/**
 *  根据名称 归档对象
 */
+(BOOL)ArchiverAnObjectWithFileName:(NSString*)fileName andAchiverObject:(id)archiverObj
{
    return  [NSKeyedArchiver archiveRootObject:archiverObj toFile:[self getAbsolutePathWithFileName:fileName]];
}
/**
 *  根据名称解档对象
 */
+(id)UnArchiverAnObjectWithFileName:(NSString*)fileName
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self getAbsolutePathWithFileName:fileName]];
}
/**
 *   根据传过来的文件名  拼接到cache文件夹路径后 此处只传入文件名
 */
+(NSString*)getAbsolutePathWithFileName:(NSString*)fileName
{
    NSString *cache=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    
    NSString *filePath=[cache stringByAppendingPathComponent:fileName];
    
    filePath=[filePath stringByAppendingString:@".data"];
    return filePath;
}
@end
