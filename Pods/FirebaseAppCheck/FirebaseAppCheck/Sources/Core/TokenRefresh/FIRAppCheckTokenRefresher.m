/*
 * Copyright 2021 Google LLC
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

#import "FirebaseAppCheck/Sources/Core/TokenRefresh/FIRAppCheckTokenRefresher.h"

#import "FirebaseAppCheck/Sources/Core/FIRAppCheckSettings.h"
#import "FirebaseAppCheck/Sources/Core/TokenRefresh/FIRAppCheckTimer.h"

NS_ASSUME_NONNULL_BEGIN

static const NSTimeInterval kInitialBackoffTimeInterval = 30;
static const NSTimeInterval kMaximumBackoffTimeInterval = 16 * 60;

@interface FIRAppCheckTokenRefresher ()

@property(nonatomic, readonly) dispatch_queue_t refreshQueue;

@property(nonatomic, readonly) id<FIRAppCheckSettingsProtocol> settings;

@property(nonatomic, readonly) FIRTimerProvider timerProvider;
@property(atomic, nullable) id<FIRAppCheckTimerProtocol> timer;
@property(atomic) NSUInteger retryCount;

@property(nonatomic, nullable) NSDate *initialTokenExpirationDate;
@property(nonatomic, readonly) NSTimeInterval tokenExpirationThreshold;

@end

@implementation FIRAppCheckTokenRefresher

@synthesize tokenRefreshHandler = _tokenRefreshHandler;

- (instancetype)initWithTokenExpirationDate:(NSDate *)tokenExpirationDate
                   tokenExpirationThreshold:(NSTimeInterval)tokenExpirationThreshold
                              timerProvider:(FIRTimerProvider)timerProvider
                                   settings:(id<FIRAppCheckSettingsProtocol>)settings {
  self = [super init];
  if (self) {
    _refreshQueue =
        dispatch_queue_create("com.firebase.FIRAppCheckTokenRefresher", DISPATCH_QUEUE_SERIAL);
    _tokenExpirationThreshold = tokenExpirationThreshold;
    _initialTokenExpirationDate = tokenExpirationDate;
    _timerProvider = timerProvider;
    _settings = settings;
  }
  return self;
}

- (instancetype)initWithTokenExpirationDate:(NSDate *)tokenExpirationDate
                   tokenExpirationThreshold:(NSTimeInterval)tokenExpirationThreshold
                                   settings:(id<FIRAppCheckSettingsProtocol>)settings {
  return [self initWithTokenExpirationDate:tokenExpirationDate
                  tokenExpirationThreshold:tokenExpirationThreshold
                             timerProvider:[FIRAppCheckTimer timerProvider]
                                  settings:settings];
}

- (void)dealloc {
  [self cancelTimer];
}

- (void)setTokenRefreshHandler:(FIRAppCheckTokenRefreshBlock)tokenRefreshHandler {
  @synchronized(self) {
    _tokenRefreshHandler = tokenRefreshHandler;

    // Check if handler is being set for the first time and if yes then schedule first refresh.
    if (tokenRefreshHandler && self.initialTokenExpirationDate &&
        self.settings.isTokenAutoRefreshEnabled) {
      NSDate *initialTokenExpirationDate = self.initialTokenExpirationDate;
      self.initialTokenExpirationDate = nil;
      [self scheduleWithTokenExpirationDate:initialTokenExpirationDate];
    }
  }
}

- (FIRAppCheckTokenRefreshBlock)tokenRefreshHandler {
  @synchronized(self) {
    return _tokenRefreshHandler;
  }
}

- (void)updateTokenExpirationDate:(NSDate *)tokenExpirationDate {
  if (self.settings.isTokenAutoRefreshEnabled) {
    [self scheduleWithTokenExpirationDate:tokenExpirationDate];
  }
}

- (void)refresh {
  if (self.tokenRefreshHandler == nil) {
    return;
  }

  if (!self.settings.isTokenAutoRefreshEnabled) {
    return;
  }

  __auto_type __weak weakSelf = self;
  self.tokenRefreshHandler(^(BOOL success, NSDate *_Nullable tokenExpirationDate) {
    __auto_type strongSelf = weakSelf;
    [strongSelf tokenRefreshedWithSuccess:success tokenExpirationDate:tokenExpirationDate];
  });
}

- (void)tokenRefreshedWithSuccess:(BOOL)success tokenExpirationDate:(NSDate *)tokenExpirationDate {
  if (success) {
    self.retryCount = 0;
  } else {
    self.retryCount += 1;
  }

  [self scheduleWithTokenExpirationDate:tokenExpirationDate ?: [NSDate date]];
}

- (void)scheduleWithTokenExpirationDate:(NSDate *)tokenExpirationDate {
  NSDate *refreshDate = [self nextRefreshDateWithTokenExpirationDate:tokenExpirationDate];
  [self scheduleRefreshAtDate:refreshDate];
}

- (void)scheduleRefreshAtDate:(NSDate *)refreshDate {
  [self cancelTimer];

  NSTimeInterval scheduleInSec = [refreshDate timeIntervalSinceNow];

  __auto_type __weak weakSelf = self;
  dispatch_block_t refreshHandler = ^{
    __auto_type strongSelf = weakSelf;
    [strongSelf refresh];
  };

  // Refresh straight away if the refresh time is too close.
  if (scheduleInSec <= 0) {
    dispatch_async(self.refreshQueue, refreshHandler);
    return;
  }

  self.timer = self.timerProvider(refreshDate, self.refreshQueue, refreshHandler);
}

- (void)cancelTimer {
  [self.timer invalidate];
}

#pragma mark - Backoff

- (NSDate *)nextRefreshDateWithTokenExpirationDate:(NSDate *)tokenExpirationDate {
  NSDate *targetRefreshDate =
      [tokenExpirationDate dateByAddingTimeInterval:-self.tokenExpirationThreshold];
  NSTimeInterval scheduleIn = [targetRefreshDate timeIntervalSinceNow];

  NSTimeInterval backoffTime = [[self class] backoffTimeForRetryCount:self.retryCount];
  if (scheduleIn >= backoffTime) {
    return targetRefreshDate;
  } else {
    return [NSDate dateWithTimeIntervalSinceNow:backoffTime];
  }
}

+ (NSTimeInterval)backoffTimeForRetryCount:(NSInteger)retryCount {
  if (retryCount == 0) {
    // No backoff for the first attempt.
    return 0;
  }

  NSTimeInterval exponentialInterval =
      kInitialBackoffTimeInterval * pow(2, retryCount - 1) + [self randomMilliseconds];
  return MIN(exponentialInterval, kMaximumBackoffTimeInterval);
}

+ (NSTimeInterval)randomMilliseconds {
  int32_t random_millis = ABS(arc4random() % 1000);
  return (double)random_millis * 0.001;
}

@end

NS_ASSUME_NONNULL_END
