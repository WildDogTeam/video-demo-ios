//
//  WDGRecordFilesViewController.h
//  WDGVideoDemo
//
//  Created by han wp on 2017/7/6.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGTableViewController.h"

typedef NS_ENUM(NSUInteger,SettingDetailType){
    SettingDetailTypeRecordFiles,
    SettingDetailTypeBlackList
};
@interface WDGSettingDetailViewController : WDGTableViewController
-(instancetype)initForTyoe:(SettingDetailType)type;
@property (nonatomic, assign) SettingDetailType detailType;

@end
