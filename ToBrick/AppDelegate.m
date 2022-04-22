#import "AppDelegate.h"
@import eggy_ios;

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    EggyConfig *config = [[EggyConfig alloc] initWithApiToken:@"YOUR_API_TOKEN"];
    EggyDevice *device = [[EggyDevice alloc] init];
    [EggyClient startWithConfig: config device: device];

    if (SYSTEM_VERSION_LESS_THAN(@"10.0")) {
        [[UIApplication sharedApplication] registerUserNotificationSettings: [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UNAuthorizationOptionProvidesAppNotificationSettings) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
                NSLog(@"Push registration successful");
            } else {
                NSLog(@"Push registration failure");
                NSLog(@"Error: %@ - %@", error.localizedFailureReason, error.localizedDescription);
                NSLog(@"Suggestions: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion);
            }
        }];
    }

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


# pragma mark - UNUserNotificationCenterDelegate

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [EggyClient registerWithDeviceApiWithDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"push notification failed to register %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // iOS 10 will handle notifications through other methods
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
      NSLog(@"iOS version >= 10; NotificationCenter will handle instead");
      return;
    }

    NSLog(@"HANDLE PUSH, didReceiveRemoteNotification < 10: %@", userInfo);

    if ([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
        NSLog(@"INACTIVE");
        completionHandler(UIBackgroundFetchResultNewData);
    } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        NSLog(@"BACKGROUND");
        completionHandler(UIBackgroundFetchResultNewData);
    } else {
        NSLog(@"FOREGROUND");
        completionHandler(UIBackgroundFetchResultNewData);
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog(@"Handle push from foreground");
    [EggyClient userNotificationCenter:center willPresentNotification:notification withCompletionHandler:completionHandler];
    NSLog(@"%@", notification.request.content.userInfo);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    
    NSLog(@"Handle push from background or when closed");
    [EggyClient userNotificationCenter:center didReceive:response withCompletionHandler:completionHandler];

    // check member variable from didReceiveRemoteNotification for source
    NSLog(@"%@", response.notification.request.content.userInfo);
}

@end
