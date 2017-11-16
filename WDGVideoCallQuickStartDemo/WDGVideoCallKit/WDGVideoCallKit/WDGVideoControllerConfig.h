//
//  WDGVideoControllerConfig.h
//  WDGVideoKit
//
//  Created by han wp on 2017/11/13.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,WDGVideoControllerType){
    WDGVideoControllerTypeCaller =1,
    WDGVideoControllerTypeReceiver
};
@class WDGVideoConversation;
@interface WDGVideoControllerConfig :NSObject
@property (nonatomic,strong) WDGVideoConversation *videoConversation;
@property (nonatomic,assign) WDGVideoControllerType videoControllerType;
@end
