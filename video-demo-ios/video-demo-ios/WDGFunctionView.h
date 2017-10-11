//
//  WDGFunctionView.h
//  video-demo-ios
//
//  Created by han wp on 2017/10/10.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDGInfoView;
@class WDGFunctionView;
@protocol WDGFunctionViewDelegate <NSObject>

-(void)functionViewShowSmallWindowBtnDidClick:(WDGFunctionView *)functionView ;
-(BOOL)functionViewRecordSuccessStart:(WDGFunctionView *)functionView recordState:(BOOL)recording;

@end

@interface WDGFunctionView : UIView
@property (nonatomic,assign) id<WDGFunctionViewDelegate> delegate;
@property (nonatomic,strong) WDGInfoView *infoView;
@property (nonatomic,strong) UILabel *timeLabel;
-(void)showInfoView;
-(void)hideInfoView;
@end
