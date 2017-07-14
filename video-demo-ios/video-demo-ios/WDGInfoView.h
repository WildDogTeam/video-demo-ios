//
//  WDGInfoView.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,PresentViewStyle){
    PresentViewStyleSend,
    PresentViewStyleReceive
};
@interface WDGInfoView : UIView
-(void)updateInfoWithSize:(NSString *)size fps:(NSString *)fps rate:(NSString *)rate memory:(NSString *)memory style:(PresentViewStyle)style;
@end
