//
//  MyNetOc.h
//  PlaneCartoon
//
//  Created by 高子雄 on 2017/9/4.
//  Copyright © 2017年 oMaoyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyNetOc : NSObject
/**
 *  根据名称 归档对象
 */
+(BOOL)ArchiverAnObjectWithFileName:(NSString*)fileName andAchiverObject:(id)archiverObj;
/**
 *  根据名称解档对象
 */
+(id)UnArchiverAnObjectWithFileName:(NSString*)fileName;
@end
