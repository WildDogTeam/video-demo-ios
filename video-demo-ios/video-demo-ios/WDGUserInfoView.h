//
//  WDGUserInfoView.h
//  video-demo-ios
//
//  Created by han wp on 2017/8/11.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,WDGUserType){
    WDGUserTypeCaller,
    WDGUserTypeCallee
};
@interface WDGUserInfoView : UIView
+(instancetype)viewWithName:(NSString *)name imageUrl:(NSString *)imageUrl userType:(WDGUserType)type;
@end
