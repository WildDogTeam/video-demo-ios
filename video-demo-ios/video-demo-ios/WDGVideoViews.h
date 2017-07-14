//
//  WDGVideoView.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDGVideoLocalStream;
@class WDGVideoRemoteStream;
@interface WDGVideoViews : UIView
-(void)rendarViewWithLocalStream:(WDGVideoLocalStream *)localStream remoteStream:(WDGVideoRemoteStream *)remoteStream;
-(BOOL)isPresentViewLocalView;
-(instancetype)initWithViewChange:(void(^)(BOOL isLocalViewPresent))viewChange;
@end
