//
//  WDTableViewController.h
//  video-demo-ios
//
//  Created by han wp on 2017/8/10.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WDGTableViewController : UITableViewController
-(void)showEmptyViewNamed:(NSString *)imageName size:(CGSize)size title:(NSString *)title;
-(void)hideEmptyView;
@end
