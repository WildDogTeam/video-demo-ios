//
//  WDGChatMessageLayout.m
//  WDGRoomDemo
//
//  Created by han wp on 2017/11/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGChatMessageLayout.h"

@implementation WDGChatMessage

@end

@implementation WDGChatMessageLayout
+(instancetype)layoutWithmessage:(WDGChatMessage *)message
{
    return [[self alloc] initWithmessage:message];
}

-(instancetype)initWithmessage:(WDGChatMessage *)message
{
    if(self = [super init]){
        self.message =message;
        [self layoutMessage];
    }
    return self;
}

-(void)layoutMessage
{
    CGSize size = CGSizeMake(WDGChatMessageMaxWidth, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil];
    CGFloat curheight = [_message.message boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    self.height =ceil(curheight)+30+10;
}

@end
