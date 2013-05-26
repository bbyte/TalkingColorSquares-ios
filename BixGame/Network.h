//
//  Network.h
//  Thuzio_Pro
//
//  Created by Nikola Kotarov on 1/17/13.
//  Copyright (c) 2013 Xogito. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height - 568) ? NO : YES)


#define NETWORK_ADDTOQUEUE(callbackMessage, url, body) [self.network addToQueue: [[NSDictionary alloc] initWithObjects: @[callbackMessage,url,@"POST",body] \
forKeys: @[@"callbackMessage", @"URL", @"METHOD", @"BODY"]]];

#define baseurl @"http://bixgame.exclus.org/mobile/"
#define URL_FOR(action) [baseurl stringByAppendingString: @#action]

#define SETUP_STRING [NSString stringWithFormat: @"deviceId=%@&deviceType=%@&deviceOs=%@", [OpenUDID value], [[UIDevice currentDevice] model], [UIDevice currentDevice].systemVersion]
#define SEND_SETUP NETWORK_ADDTOQUEUE(@"networkCallback", URL_FOR(setup), ([NSString stringWithFormat: @"deviceId=%@&deviceType=%@&deviceOs=%@", [OpenUDID value], [[UIDevice currentDevice] model], [UIDevice currentDevice].systemVersion]));
#define SEND_TOKEN_UPDATE(token) NETWORK_ADDTOQUEUE(@"networkCallback", URL_FOR(setToken), ([NSString stringWithFormat: @"deviceId=%@&deviceToken=%@", [OpenUDID value], token]));

#define SEND_EVENT(eventType) NETWORK_ADDTOQUEUE(@"networkCallback", URL_FOR(update), ([NSString stringWithFormat: @"deviceId=%@&event=%@", [OpenUDID value], eventType]));

#define SEND_EVENT_STARTED SEND_EVENT(@"STARTED")
#define SEND_EVENT_SUSPENDED SEND_EVENT(@"SUSPENDED")
#define SEND_EVENT_RESUMED SEND_EVENT(@"RESUMED");
#define SEND_EVENT_QUIT SEND_EVENT(@"QUIT")
#define SEND_EVENT_NUMBERS SEND_EVENT(@"NUMBERS")
#define SEND_EVENT_MORE_NUMBERS SEND_EVENT(@"MORE_NUMBERS")
#define SEND_EVENT_COLORS SEND_EVENT(@"COLORS")
#define SEND_EVENT_PAID_CANCEL SEND_EVENT(@"PAID_CANCEL")
#define SEND_EVENT_PAID_OK SEND_EVENT(@"PAID_OK")
#define SEND_EVENT_SONG1 SEND_EVENT(@"SONG1")
#define SEND_EVENT_SONG2 SEND_EVENT(@"SONG2")

//#define NETWORK_DEBUG YES


@interface Network : NSObject <NSURLConnectionDataDelegate>

@property (retain, nonatomic) NSMutableData *responseData;
@property (retain, nonatomic) NSMutableDictionary *responseDataArray;
@property (retain, nonatomic) NSURLConnection *connection;
@property (assign, atomic) BOOL isLocked;
@property (assign, atomic) int statusCode;
//@property (assign) SEL callback;
//@property (assign) id caller;

@property (retain, nonatomic) NSString *currentURL;

#pragma mark TODO: Need to check while is locked, someone is chaning callbackmessage
@property (retain, nonatomic) NSString *callbackMessage;

@property (retain, nonatomic) NSString *postBodyFilePath;
@property (assign, nonatomic) long long postBodyFileSize;
@property (retain, nonatomic) NSOutputStream *postBodyWriteStream;
@property (retain, nonatomic) NSInputStream *postBodyReadStream;
@property (retain, nonatomic) NSString *stringBoundary;

@property (retain, nonatomic) NSMutableArray *tasksQueue;

@property (retain, nonatomic) NSNumber *uploadProgress;

// reserved for l8r use if we have other type of uploads except files
@property (assign, nonatomic) NSInteger uploadType;
@property (assign, nonatomic) BOOL isFileUploading;
@property (assign, nonatomic) NSInteger currentUploadingId;

@property (retain, nonatomic) NSString *deviceToken;

+ (id) sharedInstance;

- (void) getDataFrom: (NSString *) url;
- (void) getDataFrom: (NSString *) url method: (NSString *) method body: (NSString *) body;

#pragma mark - POST data functions

//- (void) postDataTo: (NSString *) url data: (NSData *) data;
- (void) postDataTo: (NSString *) url postData: (NSArray *) data fileData: (NSArray *) fileData;
- (void) buildMultipartFormDataPostBody: (NSArray *) postData fileData: (NSArray *) fileData;


#pragma mark - NSURL Delegate
- (void) connection: (NSURLConnection *) connection didReceiveResponse:(NSURLResponse *)response;
- (void) connection: (NSURLConnection *) connection didReceiveData:(NSData *)data;
- (void) connection: (NSURLConnection *) connection didFailWithError:(NSError *)error;
- (void) connectionDidFinishLoading: (NSURLConnection *)connection;


- (NSMutableData*) popResponse: (NSString*) url;

- (BOOL) addToQueue: (NSDictionary *) taskData;

- (void) connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

@end
