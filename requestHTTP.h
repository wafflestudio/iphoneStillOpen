//
//  requestHTTP.h
//  freeRiders
//
//  Created by Jae Ho Jeon on 5/1/12.
//  Copyright (c) 2012 Seoul National University. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface requestHTTP : NSObject<NSURLConnectionDataDelegate>
{
    NSMutableString * postString;
    NSMutableData * receivedData;
    NSHTTPURLResponse* response;
    NSString * resultData;
    NSURL * requestUrl;
    NSData * data;
}

@property (nonatomic, assign) BOOL shouldRedirect;
@property (nonatomic, assign) NSDictionary * headers;
@property (nonatomic, assign) NSArray * receivedCookies;
@property (nonatomic, assign) NSArray * requestCookies;

- (requestHTTP*) initWithURL: (NSURL *) inputURL;
- (BOOL) synchronousRequestWithGet;
- (BOOL) synchronousRequestWithPost;
- (void) setPostValue:(NSString *)postValue forKey:(NSString *) key;
- (void) setStoreValue:(NSString *)value forKey:(NSString *) key;
@end

