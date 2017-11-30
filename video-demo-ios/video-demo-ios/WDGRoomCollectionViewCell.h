//
//  WDGRoomCollectionViewCell.h
//  video-demo-ios
//
//  Created by han wp on 2017/11/23.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WDGStream;

@interface WDGRoomCollectionViewCellLayout : NSObject
@property (nonatomic,strong) WDGStream *stream;
@property (nonatomic,assign) BOOL needMirror;
@end

@interface WDGRoomCollectionViewCell : UICollectionViewCell
+(NSString *)identifier;
@property (nonatomic, strong) WDGRoomCollectionViewCellLayout *layout;
@end
