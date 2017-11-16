//
//  WDGVideoManager.h
//  WDGVideoKit
//
//  Created by han wp on 2017/10/12.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDGVideoUser.h"
#import "WDGVideoCallOption.h"

@class WDGVideoConversation;
@interface WDGVideoManager : NSObject
+(instancetype)sharedManager;
-(void)configWithOption:(WDGVideoCallOption *)option;
-(void)makeCallToUser:(WDGVideoUser *)user;
@property (nonatomic,weak) WDGVideoConversation *videoConversation;
@end
