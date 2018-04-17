//
//  ADSMQTTTool.h
//  tools
//
//  Created by wcc on 2018/4/9.
//  Copyright © 2018年 ads. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MQTTClient.h>

@interface ADSMQTTTool : NSObject<NSCopying>
+ (ADSMQTTTool *)shareInstance;

- (void)connectToHost:(NSString *)host port:(UInt32)port timeout:(CGFloat)timeout;

- (void)subscribeToTopic:(NSString *)topic atLevel:(NSUInteger)level;

- (void)publishData:(NSData *)data toTopic:(NSString *)topic retain:(BOOL)retain MQTTQosLevel:(MQTTQosLevel)level;
@end
