//
//  ADSMQTTTool.m
//  tools
//
//  Created by wcc on 2018/4/9.
//  Copyright © 2018年 ads. All rights reserved.
//

#import "ADSMQTTTool.h"


@interface ADSMQTTTool()<MQTTSessionDelegate>

@end

static ADSMQTTTool * instance;
static MQTTSession * session;
@implementation ADSMQTTTool
+ (ADSMQTTTool *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[ADSMQTTTool alloc]init];
            session = [[MQTTSession alloc]init];
        }
    });
    return instance;
}
- (instancetype)init
{
    [NSException exceptionWithName:@"对象 init 失败" reason:@"单利对象不允许直接 init 使用，请使用单例方法" userInfo:nil];
    return nil;
}
- (instancetype)copyWithZone:(NSZone *)zone
{
    [NSException exceptionWithName:@"对象 copywithzone 失败" reason:@"单利对象不允许直接 copywithzone 使用，请使用单例方法" userInfo:nil];
    return nil;
}

- (void)connectToHost:(NSString *)host port:(UInt32)port timeout:(CGFloat)timeout
{
    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc]init];
    transport.host = host;
    transport.port = port;
    session.transport = transport;
    session.delegate = self;
    [session connectAndWaitTimeout:30];
}
- (void)subscribeToTopic:(NSString *)topic atLevel:(NSUInteger)level
{
    [session subscribeToTopic:@"" atLevel:2 subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        if (error) {
            NSLog(@"Subscription failed %@", error.localizedDescription);
        }else{
            NSLog(@"Subscription sucessfull! Granted Qos: %@", gQoss);
        }
    }];
}
- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid
{
    
}

- (void)connected:(MQTTSession *)session
{
    
}

/** gets called when a connection has been successfully established
 @param session the MQTTSession reporting the connect
 @param sessionPresent represents the Session Present flag sent by the broker
 
 */
- (void)connected:(MQTTSession *)session sessionPresent:(BOOL)sessionPresent
{
    
}

/** gets called when a connection has been refused
 @param session the MQTTSession reporting the refusal
 @param error an optional additional error object with additional information
 */
- (void)connectionRefused:(MQTTSession *)session error:(NSError *)error
{
    
}

/** gets called when a connection has been closed
 @param session the MQTTSession reporting the close
 
 */
- (void)connectionClosed:(MQTTSession *)session
{
    
}

/** gets called when a connection error happened
 @param session the MQTTSession reporting the connect error
 @param error an optional additional error object with additional information
 */
- (void)connectionError:(MQTTSession *)session error:(NSError *)error
{
    
}

/** gets called when an MQTT protocol error happened
 @param session the MQTTSession reporting the protocol error
 @param error an optional additional error object with additional information
 */
- (void)protocolError:(MQTTSession *)session error:(NSError *)error
{
    
}

/** gets called when a published message was actually delivered
 @param session the MQTTSession reporting the delivery
 @param msgID the Message Identifier of the delivered message
 @note this method is called after a publish with qos 1 or 2 only
 */
- (void)messageDelivered:(MQTTSession *)session msgID:(UInt16)msgID
{
    
}


- (void)publishData:(NSData *)data toTopic:(NSString *)topic retain:(BOOL)retain MQTTQosLevel:(MQTTQosLevel)level
{
    [session publishData:data onTopic:topic retain:retain qos:level];
}
@end
