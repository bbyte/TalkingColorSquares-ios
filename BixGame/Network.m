//
//  Network.m
//  Thuzio_Pro
//
//  Created by Nikola Kotarov on 1/17/13.
//  Copyright (c) 2013 Xogito. All rights reserved.
//

#import "Network.h"



@implementation Network

@synthesize responseData, connection, isLocked, statusCode, responseDataArray;
@synthesize callbackMessage;
@synthesize stringBoundary;
@synthesize tasksQueue;
@synthesize uploadProgress;
@synthesize isFileUploading, uploadType, currentUploadingId;
@synthesize currentURL;

+ (id)sharedInstance
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (id) init
{
  self = [super init];
  if (self != nil) {
    
    // initializations go here.
    isLocked = NO;
    responseDataArray = [[NSMutableDictionary alloc] init];
    
    tasksQueue = [[NSMutableArray alloc] init];
    
    uploadProgress = [NSNumber numberWithInteger: 0];
    
    self.currentURL = @"";
    
    [self checkTaskQueueInBackground];
  }
  return self;
}

- (void) executeTask: (NSDictionary *) taskData
{
#ifdef NETWORK_DEBUG
  NSLog(@"Taskdata: %@", taskData);
#endif

#ifdef NO_NETWORK
  return;
#endif
  
  self.callbackMessage = [taskData objectForKey: @"callbackMessage"];
  
  if ([taskData objectForKey: @"FILEDATA"]) {
    
    self.currentUploadingId = (NSInteger)[taskData objectForKey: @"request_id"];
    
    [self postDataTo: [taskData objectForKey: @"URL"] postData: [taskData objectForKey: @"POSTDATA"] fileData: [taskData objectForKey: @"FILEDATA"]];
  } else {
    
    [self getDataFrom: [taskData objectForKey: @"URL"] method: [taskData objectForKey: @"METHOD"] body: [taskData objectForKey: @"BODY"]];
  }
}

- (void) checkTaskQueueInBackground
{
  
  //  NSLog(@"Network: checking for tasks...");
  while ([self tasksInQueue]) {

#ifdef NETWORK_DEBUG
    NSLog(@"There is task in the queue");
#endif
    
    // if is locked, we'll try again on next pass... no hurry :)
    
    if (self.isLocked)
      break;
    
    [self executeTask: [self  popFromQueue]];
  }
  
  int64_t delayInSeconds = 1;
  dispatch_time_t updateTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(updateTime, dispatch_get_main_queue(), ^(void){
    
    [self checkTaskQueueInBackground];
  });
}

- (BOOL) tasksInQueue
{
  if ([self.tasksQueue count] > 0) {
    
    return YES;
  } else {
    
    return NO;
  }
}

- (BOOL) addToQueue: (NSDictionary *) taskData
{
  // Need to imeplement some checking code
  
#ifdef NETWORK_DEBUG
  NSLog(@"taskData: %@", taskData);
#endif
  
  [self.tasksQueue addObject: taskData];
  
  return YES;
}

- (NSDictionary *) popFromQueue
{
  if([self.tasksQueue objectAtIndex: 0]){
    
    NSDictionary *taskData = [self.tasksQueue objectAtIndex: 0];
    [self.tasksQueue removeObjectAtIndex: 0];
    
    return taskData;
  } else {
    
    return [[NSDictionary alloc] init];
  }
}

- (void) getDataFrom: (NSString *) url
{
  //instialize status
  self.statusCode = 400;
  [self getDataFrom: url method: @"POST" body: @""];
}

- (void) getDataFrom: (NSString *) url method: (NSString *) method body: (NSString *) body
{
  if(isLocked){
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
    //                                                    message: @"Network connection is blocked"
    //                                                   delegate: self
    //                                          cancelButtonTitle: @"Close"
    //                                          otherButtonTitles: nil];
    //
    //    [alert performSelectorOnMainThread: @selector(show)
    //                            withObject: self
    //                         waitUntilDone: NO];
    return;
  }
  
  isLocked = YES;
  
  self.isFileUploading = NO;
  
#ifdef NETWORK_DEBUG
  NSLog(@"Requesting URL: %@", url);
  NSLog(@"With body: %@", body);
#endif

  self.responseData = [NSMutableData data];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
  
  [request setHTTPMethod: method];
  [request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
  
  connection = [[NSURLConnection alloc] initWithRequest: request
                                               delegate: self];
  
  self.currentURL = url;
}

#pragma mark - Multipart POST function

// idea stollen from ASIHTTPRequest: https://github.com/pokeb/asi-http-request/blob/master/Classes/ASIFormDataRequest.h

- (void) postDataTo: (NSString *) url postData: (NSArray *) postData fileData: (NSArray *) fileData
{
  if(isLocked){
    
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
    //                                                    message: @"Network connection is blocked"
    //                                                   delegate: self
    //                                          cancelButtonTitle: @"Close"
    //                                          otherButtonTitles: nil];
    //
    //    [alert performSelectorOnMainThread: @selector(show)
    //                            withObject: self
    //                         waitUntilDone: NO];
    return;
  }
  
  isLocked = YES;
  
#ifdef NETWORK_DEBUG
  NSLog(@"Requesting URL: %@", url);
#endif
  
  self.isFileUploading = YES;
//  self.uploadType = AV_UPLOAD;
  
  self.responseData = [NSMutableData data];
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: url]];
  
  NSString *charset = (NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
  CFUUIDRef uuid = CFUUIDCreate(nil);
  NSString *uuidString = (NSString*) CFBridgingRelease(CFUUIDCreateString(nil, uuid));
  CFRelease(uuid);
  
  self.stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
  
  [request setHTTPMethod: @"POST"];
  
  [self buildMultipartFormDataPostBody: postData fileData: fileData];
  
#ifdef NETWORK_DEBUG
  NSLog(@"filepath: %@", self.postBodyFilePath);
#endif
  
  self.postBodyReadStream = [NSInputStream inputStreamWithFileAtPath: self.postBodyFilePath];
  
  //  // dump stream
  //  [self.postBodyReadStream open];
  //  NSUInteger bytesRead;
  //
  //  while([self.postBodyReadStream hasBytesAvailable]){
  //
  //    unsigned char buffer[1024*256];
  //    bytesRead = [self.postBodyReadStream read: buffer maxLength: sizeof(buffer)];
  //    if (bytesRead == 0) {
  //
  //      break;
  //    }
  //
  //    NSLog(@"Read stream: %s", buffer);
  //  }
  //
  //  [self.postBodyReadStream close];
  //  self.postBodyReadStream = [NSInputStream inputStreamWithFileAtPath: self.postBodyFilePath];
  
  [request setHTTPBodyStream: self.postBodyReadStream];
  [request addValue: [NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, self.stringBoundary]
 forHTTPHeaderField: @"Content-Type"];
  
  connection = [[NSURLConnection alloc] initWithRequest: request
                                               delegate: self];
  
  self.currentURL = url;
}

- (void) setupPostBody
{
  if (! self.postBodyFilePath) {
    
    [self setPostBodyFilePath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]]];
    self.postBodyFileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath: self.postBodyFilePath
                                                                              error: nil]
                             [NSFileSize] longLongValue];
  }
  
  if (! self.postBodyWriteStream) {
    
    [self setPostBodyWriteStream: [[NSOutputStream alloc] initToFileAtPath:[self postBodyFilePath] append:NO]];
    [[self postBodyWriteStream] open];
  }
}

- (void) buildMultipartFormDataPostBody: (NSArray *) postData fileData: (NSArray *) fileData
{
  [self appendPostData: [[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding: NSUTF8StringEncoding]];
  
  // Adds post data
  NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n", stringBoundary];
  NSUInteger counter = 0;
  
  for (NSDictionary *postElement in postData) {
    
#ifdef NETWORK_DEBUG
    NSLog(@"postData: %@", postElement);
#endif
    
    [self appendPostData: [[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",
                            [postElement objectForKey: @"key"]] dataUsingEncoding: NSUTF8StringEncoding]];
    [self appendPostData: [[postElement objectForKey:@"value"] dataUsingEncoding: NSUTF8StringEncoding]];
    
#ifdef NETWORK_DEBUG
    NSLog(@"VALUE: %@", [[postElement objectForKey:@"value"] dataUsingEncoding: NSUTF8StringEncoding]);
#endif
    
    counter++;
    
    if (counter != [postData count] || [fileData count] > 0) { //Only add the boundary if this is not the last item in the post body
      
      [self appendPostData: [endItemBoundary dataUsingEncoding: NSUTF8StringEncoding]];
    }
  }
  
  // Adds files to upload
  counter = 0;
  
  for (NSDictionary *fileElement in fileData) {
    
#ifdef NETWORK_DEBUG
    NSLog(@"fileElement: %@", fileElement);
#endif
    
    [self appendPostData: [[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",
                            [fileElement objectForKey:@"key"],
                            [fileElement objectForKey:@"key"]]
                           dataUsingEncoding: NSUTF8StringEncoding]];
    
    [self appendPostData: [[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",
                            [fileElement objectForKey:@"contentType"]] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *data = [fileElement objectForKey: @"filename"];
    
    [self appendPostDataFromFile: data];
    counter++;
    
    // Only add the boundary if this is not the last item in the post body
    if (counter != [fileData count]) {
      
      [self appendPostData: [endItemBoundary dataUsingEncoding: NSUTF8StringEncoding]];
    }
  }
  
  [self appendPostData: [[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding: NSUTF8StringEncoding]];
}

- (void) appendPostData: (NSData *) data
{
  [self setupPostBody];
  
#ifdef NETWORK_DEBUG
  NSLog(@"appendPostData: %@", data);
#endif
  
  if ([data length] == 0) {
    
    return;
  }
  
  [[self postBodyWriteStream] write:[data bytes] maxLength:[data length]];
}

- (void) appendPostDataFromFile: (NSString *)file
{
  
  [self setupPostBody];
  
#ifdef NETWORK_DEBUG
  NSLog(@"File to add: %@", file);
#endif
  
#ifdef NETWORK_DEBUG
  NSError *err = nil;

  unsigned long long fileSize = [[[[[NSFileManager alloc] init] attributesOfItemAtPath: file
                                                                                 error: &err]
                                  objectForKey: NSFileSize]
                                 unsignedLongLongValue];
  
  NSLog(@"DEBUG: adding postdata with file size: %llul", fileSize);
#endif
  
  
  NSInputStream *stream = [[NSInputStream alloc] initWithFileAtPath:file];
  [stream open];
  NSUInteger bytesRead;
  
  while ([stream hasBytesAvailable]) {
    
    unsigned char buffer[1024*256];
    bytesRead = [stream read: buffer maxLength: sizeof(buffer)];
    if (bytesRead == 0) {
      
      break;
    }
    
    [[self postBodyWriteStream] write:buffer maxLength:bytesRead];
  }
  [stream close];
}

#pragma mark - Delegate functions

- (void) connection: (NSURLConnection *) connection didReceiveResponse:(NSURLResponse *) response
{
  NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*) response;
  self.statusCode = [httpResponse statusCode];
  [self.responseData setLength:0];
}

- (void) connection: (NSURLConnection *) connection didReceiveData:(NSData *) data
{
  [self.responseData appendData:data];
  //  NSLog(@"Data: %@", [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding]);
}

- (void) connection: (NSURLConnection *) connection didFailWithError:(NSError *) error
{
  
  //  self.responseData = nil;
  
#ifdef NETWORK_DEBUG
  NSLog(@"Connection error: %@", [error localizedDescription]);
#endif
  
//  UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error"
//                                                  message: [error localizedDescription]
//                                                 delegate: self
//                                        cancelButtonTitle: @"Close"
//                                        otherButtonTitles: nil];
//  [alert show];
    
  self.isLocked = NO;
}

- (void) connectionDidFinishLoading: (NSURLConnection *) conn
{
//  NSURL *myURL = [[conn currentRequest] URL];
//  [self.responseDataArray setObject:self.responseData forKey: [myURL absoluteString]];
  
  [self.responseDataArray setObject: self.responseData forKey: self.currentURL];
  
#ifdef NETWORK_DEBUG
  NSString *responseString = [[NSString alloc] initWithData: self.responseData
                                                   encoding: NSUTF8StringEncoding];

  NSLog(@"responseString: %@", responseString);
#endif
  
  self.isLocked = NO;
  
  
  //  NSLog(@"callback is: %@", callbackMessage);
  [[NSNotificationCenter defaultCenter] postNotificationName: callbackMessage object: nil];
  
  //  self.responseData = nil;
}

- (void)connection: (NSURLConnection *)connection
   didSendBodyData: (NSInteger)bytesWritten
 totalBytesWritten: (NSInteger)totalBytesWritten
totalBytesExpectedToWrite: (NSInteger)totalBytesExpectedToWrite
{
  self.uploadProgress = [NSNumber numberWithInteger: totalBytesWritten];
  
  [[NSNotificationCenter defaultCenter] postNotificationName: @"updateUploadProgressBar" object: nil];
}

#pragma mark -

- (NSMutableData*) popResponse: (NSString*) url
{
  NSMutableData *response = [self.responseDataArray objectForKey:url ];
  [self.responseDataArray removeObjectForKey: url];
  return response;
}


@end
