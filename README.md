# video-demo-ios
用户在使用demo之前请及时填写WDGUserDefine.m里的信息 
required为必填信息 否则demo不能正常运行 为野狗的syncid及videoid 在野狗开发平台注册后新建video项目即可取得 具体方法见后面
###注意：
1. 如果没有申请微信登录权限请打开匿名登录选项(app现有两种登录方式 微信登录及匿名登录) 
2. 注意syncid及videoid的保密性 不要随意泄露给他人 
optional为选填信息 如果未填写则丢失涂图、camera360美颜功能以及微信登录功能 只提供匿名登录功能 但不影响其他功能体验 可根据上方各级开关单独添加相应功能

#WDGVideoCallQuickStart
用户在使用demo之前请及时填写ViewController.h里的信息 
此程序为一对一视频的快速集成版 其中包括<mark>**视频从开始到结束的各种状态、视频的持续时间、扬声器开启关闭的封装；(详见WDGVideoCallKit工程下WDGVideoConversation.h)**</mark> 帮助你更好更快的上手WilddogVideoCall的sdk；

#运行步骤
1. 在野狗官网申请账号并新建项目，拿到SyncId及VideoId；如果有匿名登录，需在后台身份认证下开启匿名登录；具体方法见后面
2. pod install；
3. 按照上方提示填写必要信息
4. run

#野狗项目新建
## 1. 创建应用

在 Wilddog [控制面板](https://www.wilddog.com/dashboard/) 中创建一个新应用或使用已有应用。 [如何创建应用？](https://docs.wilddog.com/console/creat.html)

## 2. 开启匿名登录认证方式

应用创建成功后，进入“管理应用-->身份认证-->登录方式”。开启匿名登录。

![](https://github.com/WildDogTeam/video-demo-android-conference/raw/master/images/openanonymous.png)

## 3. 开启实时视频通话

进入 管理应用-实时视频通话，开启视频通话功能。此处注意配置页面下方`config`中的`videoURL`

![](https://github.com/WildDogTeam/video-demo-android-conference/raw/master/images/video_quickstart_openVideo.png)

**提示：**
如果之前没有使用过sync服务的需要手动开启
![](https://github.com/WildDogTeam/video-demo-android-conference/raw/master/images/opensync.png)




