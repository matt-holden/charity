//
//  CCFBRequestManager.m
//  Charity
//
//  Created by Matthew Holden on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import "CCFBRequestManager.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation CCFBRequestManager
- (void)sendRequest {
    // Display the requests dialog
    [FBWebDialogs
     presentRequestsDialogModallyWithSession:[FBSession activeSession]
     message:@"Learn how to make your iOS apps social."
     title:@"herrrro"
     parameters:nil
     handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {

         [[NSNotificationCenter defaultCenter] postNotificationName:@"CCFBRequestSent" object:nil];

         if (error) {
             // Error launching the dialog or sending the request.
             NSLog(@"Error sending request.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled request.");
             } else {
                 // Handle the send request callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"request"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled request.");
                 } else {
                     // User clicked the Send button
                     NSString *requestID = [urlParams valueForKey:@"request"];
                     NSLog(@"Request ID: %@", requestID);

                     [self notificationGet:requestID];
                 }
             }
         }
     }];
}
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

- (void) notificationGet:(NSString *)requestid {
    [FBRequestConnection startWithGraphPath:requestid
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (!error) {
                                  NSString *title;
                                  NSString *message;
                                  if (result[@"data"]) {
                                      title = [NSString
                                               stringWithFormat:@"%@ sent you a gift",
                                               result[@"from"][@"name"]];
                                      NSString *jsonString = result[@"data"];
                                      NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                                      if (!jsonData) {
                                          NSLog(@"JSON decode error: %@", error);
                                          return;
                                      }
                                      NSError *jsonError = nil;
                                      NSDictionary *requestData =
                                      [NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:0
                                                                        error:&jsonError];
                                      if (jsonError) {
                                          NSLog(@"JSON decode error: %@", error);
                                          return;
                                      }
                                      message =
                                      [NSString stringWithFormat:@"Badge: %@, Karma: %@",
                                       requestData[@"badge_of_awesomeness"],
                                       requestData[@"social_karma"]];
                                  } else {
                                      title = [NSString
                                               stringWithFormat:@"%@ sent you a request",
                                               result[@"from"][@"name"]];
                                      message = result[@"message"];
                                  }

                                  // Delete the request notification
//                                  [self notificationClear:result[@"id"]];
//
//                                  [[NSNotificationCenter defaultCenter] postNotificationName:@"CCFBRequestSent" object:nil];
                              }
                          }];
}
@end
