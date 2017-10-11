//
//  WDGVideoView.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/4.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDGLocalStream;
@class WDGRemoteStream;
@interface WDGVideoViews : UIView<NSCopying>
-(void)rendarViewWithLocalStream:(WDGLocalStream *)localStream remoteStream:(WDGRemoteStream *)remoteStream;
-(void)rendarViewWithRemoteStream:(WDGRemoteStream *)remoteStream;
-(BOOL)isPresentViewLocalView;
-(void)showMirrorLocalView:(BOOL)showMirror;
@property (nonatomic,copy) void(^viewChange)(BOOL isLocalViewPresent);

-(instancetype)initWithViewChange:(void(^)(BOOL isLocalViewPresent))viewChange ;
@end
