//
//  requestHTTP.m
//  freeRiders
//
//  Created by Jae Ho Jeon on 5/1/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import "requestHTTP.h"


@implementation requestHTTP
@synthesize shouldRedirect, headers, receivedCookies, requestCookies;


- (requestHTTP*) initWithURL: (NSURL *) inputURL 
{    
    self = [super init];
    
    if (self) { 
        requestUrl = inputURL;
        shouldRedirect = YES;
    }
    
    return self;
}

- (BOOL) synchronousRequestWithGet{
    
    // URL 접속 초기화
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:15.0];
    
    // GET 방식
    [request setHTTPMethod:@"GET"];

    NSHTTPURLResponse* thisResponse;
    NSError * error;
    
    data = [NSURLConnection sendSynchronousRequest:request returningResponse:&thisResponse error:&error];
    headers = [thisResponse allHeaderFields];
    receivedCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSLog(@"headers = %@",headers);
    
    NSLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSLog(@"cookies = %@", receivedCookies);
    
    return YES;

}

-(BOOL) synchronousRequestWithPost{
    
    // URL 접속 초기화
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:15.0];
    
    
    if (requestCookies != nil)
    {
        NSDictionary * cookieHeader = [NSHTTPCookie requestHeaderFieldsWithCookies:requestCookies];
        [request setAllHTTPHeaderFields:cookieHeader];
    }
    
    // POST 방식
    [request setHTTPMethod:@"POST"]; // POST로 선언하고
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]]; // 전송할 데이터를 변수명=값&변수명=값 형태의 문자열로 등록
    
    // 헤더  추가가 필요하면 아래 메소드를 이용
    // [request setValue:value forHTTPHeaderField:key];
    
    NSHTTPURLResponse* thisResponse;
    NSError * error;
    
    NSLog(@"%@", postString);
    [NSURLConnection sendSynchronousRequest:request returningResponse:&thisResponse error:&error];
    headers = [thisResponse allHeaderFields];
    receivedCookies= [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
//    NSLog(@"headers = %@",headers);
    NSLog(@"data = %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
//    NSLog(@"cookies = %@", receivedCookies);
    
    return NO;
    
}

- (void) setPostValue:(NSString *)postValue forKey:(NSString *) key
{
    if (postString == nil)
        postString = [NSMutableString stringWithFormat:@"%@=%@", key, postValue];
    
    else
        [postString stringByAppendingFormat:@"&%@=%@", key, postValue];
}

- (void) setStoreValue:(NSString *)value forKey:(NSString *) key
{
    if (postString == nil)
        postString = [NSMutableString stringWithFormat:@"store[%@]=%@", key, value];
    
    else
        [postString appendFormat:@"&store[%@]=%@", key, value];
}

@end
