/*
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "FirebaseAppCheck/Sources/Core/Errors/FIRAppCheckErrorUtil.h"

NSString *const kFIRAppCheckErrorDomain = @"com.firebase.appCheck";

@implementation FIRAppCheckErrorUtil

+ (NSError *)cachedTokenNotFound {
  NSString *failureReason = [NSString stringWithFormat:@"Cached token not found."];
  return [self appCheckErrorWithCode:FIRAppCheckErrorCodeUnknown
                       failureReason:failureReason
                     underlyingError:nil];
}

+ (NSError *)cachedTokenExpired {
  NSString *failureReason = [NSString stringWithFormat:@"Cached token expired."];
  return [self appCheckErrorWithCode:FIRAppCheckErrorCodeUnknown
                       failureReason:failureReason
                     underlyingError:nil];
}

+ (NSError *)APIErrorWithHTTPResponse:(NSHTTPURLResponse *)HTTPResponse
                                 data:(nullable NSData *)data {
  NSString *body = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ?: @"";
  NSString *failureReason =
      [NSString stringWithFormat:@"Unexpected API response. HTTP code: %ld, body: \n%@",
                                 (long)HTTPResponse.statusCode, body];
  return [self appCheckErrorWithCode:FIRAppCheckErrorCodeUnknown
                       failureReason:failureReason
                     underlyingError:nil];
}

+ (NSError *)APIErrorWithNetworkError:(NSError *)networkError {
  NSString *failureReason = [NSString stringWithFormat:@"API request error."];
  return [self appCheckErrorWithCode:FIRAppCheckErrorCodeUnknown
                       failureReason:failureReason
                     underlyingError:networkError];
}

+ (NSError *)appCheckTokenResponseErrorWithMissingField:(NSString *)fieldName {
  NSString *failureReason = [NSString
      stringWithFormat:@"Unexpected app check token response format. Field `%@` is missing.",
                       fieldName];
  return [self appCheckErrorWithCode:FIRAppCheckErrorCodeUnknown
                       failureReason:failureReason
                     underlyingError:nil];
}

+ (NSError *)JSONSerializationError:(NSError *)error {
  NSString *failureReason = [NSString stringWithFormat:@"JSON serialization error."];
  return [self appCheckErrorWithCode:FIRAppCheckErrorCodeUnknown
                       failureReason:failureReason
                     underlyingError:error];
}

+ (NSError *)errorWithFailureReason:(NSString *)failureReason {
  return [self appCheckErrorWithCode:FIRAppCheckErrorCodeUnknown
                       failureReason:failureReason
                     underlyingError:nil];
}

+ (NSError *)appCheckErrorWithCode:(FIRAppCheckErrorCode)code
                     failureReason:(nullable NSString *)failureReason
                   underlyingError:(nullable NSError *)underlyingError {
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
  userInfo[NSUnderlyingErrorKey] = underlyingError;
  userInfo[NSLocalizedFailureReasonErrorKey] = failureReason;

  return [NSError errorWithDomain:kFIRAppCheckErrorDomain code:code userInfo:userInfo];
}

@end

void FIRAppCheckSetErrorToPointer(NSError *error, NSError **pointer) {
  if (pointer != NULL) {
    *pointer = error;
  }
}
