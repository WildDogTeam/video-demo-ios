# video-demo-ios
17/9/4 : 用户在使用demo之前需填写WDGUserDefine.m里的信息 其中required为必填项 optional为选填项 optional如果不正确填写会丢失相应功能 但不影响video体验


Warning:
tag1.0.0之前的项目 适用WilddogVideo 2.0.0之前的版本
        之后的项目 适用WilddogVideo 2.0.0之后的版本

WilddogVideo 2.0.0版本和以前的版本有了很大的区别 内部没有集成SyncSDK 而且API做了相当的简化 便于用户更快接入项目 因API接口简化导致项目不通用 1.x版本项目需要适当修改代码才能接入2.x版
    项目较之前进行的修改：1.修改代码接入新版sdk
                      2.产品新需求

tag2.1.0 之后适用WilddogVideo2.1.0-beta之后的版本 
    因为新增WilddogRoom视频会议功能 之前的WilddogVideo进行了拆分重组 新增了一个videoBase基库为视频和会议服务 所以api略有变动 给您带来的不便敬请谅解 以后可以通过pod WilddogRoom 来集成视频会议功能 此demo以后也会更新这方面功能

demo新增了微信登录功能 
用户在使用demo之前请及时填写WDGUserDefine.m里的信息 
required为必填信息 否则demo不能正常运行 为野狗的syncid及videoid 在野狗开发平台注册后新建video项目即可取得 
注：1.如果没有申请微信登录权限请打开匿名登录选项(app现有两种登录方式 微信登录及匿名登录) 
   2.注意syncid及videoid的保密性 不要随意泄露给他人 
optional为选填信息 如果未填写则丢失涂图、camera360美颜功能以及微信登录功能 只提供匿名登录功能 但不影响其他功能体验 可根据上方各级开关单独添加相应功能


