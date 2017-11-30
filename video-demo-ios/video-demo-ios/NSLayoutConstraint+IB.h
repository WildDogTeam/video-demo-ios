//
//  NSLayoutConstraint+IB.h
//  video-demo-ios
//
//  Created by han wp on 2017/11/29.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger,AdapterScreen){
    AdapterScreenV=1,
    AdapterScreenH
};
@interface NSLayoutConstraint (IB)
@property(nonatomic) IBInspectable int adapterScreen;
@end
