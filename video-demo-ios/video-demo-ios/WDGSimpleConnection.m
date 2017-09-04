//
//  WDGSimpleConnection.m
//  video-demo-ios
//
//  Created by han wp on 2017/8/22.
//  Copyright © 2017年 wilddog. All rights reserved.
//

#import "WDGSimpleConnection.h"

@interface WDGSimpleConnection()<NSURLConnectionDelegate>
@property (nonatomic,strong) NSMutableData *storageData;
@property (nonatomic,copy) void(^complete)(NSDictionary *);
@end

@implementation WDGSimpleConnection
+(void)connectionWithUrlString:(NSString *)urlString completion:(void (^)(NSDictionary *))completion
{
    NSURL *url =[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    WDGSimpleConnection *simCon = [WDGSimpleConnection new];
    simCon.complete=completion;
    NSURLConnection *con = [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:simCon];
    [con start];
}

+(NSURLConnection *)connectionWithPostUrlString:(NSString *)urlString requestHeader:(NSDictionary *)header body:(NSDictionary *)body completion:(void (^)(NSDictionary *))completion
{
    NSURL *url =[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    WDGSimpleConnection *simCon = [WDGSimpleConnection new];
    simCon.complete=completion;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:header];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:nil];
    request.HTTPMethod =@"POST";
    NSURLConnection *con = [NSURLConnection connectionWithRequest:request delegate:simCon];
    return con;
}

-(instancetype)init
{
    if(self = [super init]){
        _storageData = [NSMutableData data];
    }
    return self;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.storageData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:self.storageData options:NSJSONReadingMutableContainers error:nil];
    if(self.complete){
        self.complete(dict);
    }
}
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(self.complete){
        self.complete(nil);
    }
}
@end
