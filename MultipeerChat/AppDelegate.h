//
//  AppDelegate.h
//  MultipeerChat
//
//  Created by Shawn Hung on 8/24/15.
//  Copyright (c) 2015 Paganini Plus. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MultipeerConnectivity;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) MCAdvertiserAssistant *assistant;


@end

