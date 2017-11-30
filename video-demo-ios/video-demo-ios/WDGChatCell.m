//
//  WDGChatCell.m
//  WDGRoomDemo
//
//  Created by han wp on 2017/11/3.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGChatCell.h"
#import "WDGChatMessageLayout.h"
#import <WilddogAuth/WilddogAuth.h>
@implementation WDGChatCell
{
    UILabel *_nameLabel;
    UILabel *_messageLabel;
    UIImageView *_messageImageV;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle =UITableViewCellSelectionStyleNone;
        [self createUI];
        
    }
    return self;
}

-(void)createUI
{
    UILabel *nameLabel = [[UILabel alloc] init];
    _nameLabel =nameLabel;
    nameLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:nameLabel];
    
    UIImageView *messageImageV =[[UIImageView alloc] init];
    [self.contentView addSubview:messageImageV];
    _messageImageV = messageImageV;
    
    UILabel *messageLabel = [UILabel new];
    _messageLabel = messageLabel;
    _messageLabel.textColor = [UIColor blackColor];
//    _messageLabel.backgroundColor = [UIColor whiteColor];
//    _messageLabel.layer.cornerRadius = 5;
//    _messageLabel.clipsToBounds =YES;
    _messageLabel.numberOfLines = 0;
    _messageLabel.preferredMaxLayoutWidth = 150;
    _messageLabel.font = [UIFont systemFontOfSize:16];
    [messageImageV addSubview:_messageLabel];
}

-(void)setLayout:(WDGChatMessageLayout *)layout
{
    _layout = layout;
    _nameLabel.text =layout.message.nickname;
    _messageLabel.text = layout.message.message;
    if([layout.message.uid isEqualToString:[WDGAuth auth].currentUser.uid]){
        self.type = WDGChatTypeMe;
    }else{
        self.type = WDGChatTypeOther;
    }
    
    _messageLabel.frame = CGRectMake(0, 0, WDGChatMessageMaxWidth, CGFLOAT_MAX);
    [_messageLabel sizeToFit];
    _messageLabel.frame = CGRectMake(10, 5, _messageLabel.frame.size.width, _messageLabel.frame.size.height);
    
    UIImage *image =[UIImage imageNamed:@"会话气泡"];
    if(_type == WDGChatTypeMe){
        _messageImageV.image =[image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height*.5, image.size.width*.2, image.size.height*.5, image.size.width*.8) resizingMode:UIImageResizingModeStretch];
        _nameLabel.textAlignment =NSTextAlignmentRight;
    }else{
        _messageImageV.image =[image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height*.5, image.size.width*.8, image.size.height*.5, image.size.width*.2) resizingMode:UIImageResizingModeStretch];
        _nameLabel.textAlignment =NSTextAlignmentLeft;
    }

}

-(void)setType:(WDGChatType)type
{
    _type=type;
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _nameLabel.frame = CGRectMake(20, 0, self.contentView.frame.size.width-40, 20);
    if(_type == WDGChatTypeMe){
        _messageImageV.frame = CGRectMake(self.contentView.frame.size.width -_messageLabel.frame.size.width-20-20, CGRectGetMaxY(_nameLabel.frame)+5, _messageLabel.frame.size.width+20, _messageLabel.frame.size.height+10);
    }else{
        _messageImageV.frame = CGRectMake(20, CGRectGetMaxY(_nameLabel.frame)+5, _messageLabel.frame.size.width+10*2, _messageLabel.frame.size.height+10);
    }

}
@end
