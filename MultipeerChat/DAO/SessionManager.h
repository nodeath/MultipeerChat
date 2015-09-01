//
//  SessionManager.h
//  MultipeerChat
//
//  Created by Shawn Hung on 8/31/15.
//  Copyright (c) 2015 Paganini Plus. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MultipeerConnectivity;

extern NSString * const ServiceType;

@protocol SessionManagerDelegate;

@interface SessionManager : NSObject

+ (instancetype)sharedManager;

@property (weak, nonatomic) NSObject<SessionManagerDelegate> *delegate;

- (void)start;
- (MCBrowserViewController *)browserViewController;
- (void)sendMessage:(NSString *)message;

@end

@protocol SessionManagerDelegate <MCBrowserViewControllerDelegate>
@optional
- (void)manager:(SessionManager *)manager didReceiveMessage:(NSString *)message;


@end
