//
//  AppDelegate.m
//  MultipeerChat
//
//  Created by Shawn Hung on 8/24/15.
//  Copyright (c) 2015 Paganini Plus. All rights reserved.
//

#import "AppDelegate.h"

NSString * const ServiceType = @"PP-P2PService1";

@interface AppDelegate ()<MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, MCAdvertiserAssistantDelegate>

@property (strong, nonatomic)  MCNearbyServiceAdvertiser *advertiser;
@property (strong, nonatomic)  MCPeerID *localPeerID;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    self.session = [[MCSession alloc] initWithPeer:self.localPeerID
                                  securityIdentity:nil
                              encryptionPreference:MCEncryptionNone];
    self.session.delegate = self;
    
    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID discoveryInfo:nil serviceType:ServiceType];
    self.advertiser.delegate = self;
    
    self.assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:ServiceType discoveryInfo:nil session:self.session];
    
    self.assistant.delegate = self;
    
    [self.assistant start];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser
didReceiveInvitationFromPeer:(MCPeerID *)peerID
       withContext:(NSData *)context
 invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString localizedStringWithFormat:@"Received Invitation from %@", peerID.displayName] message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        invitationHandler(YES, self.session);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        invitationHandler(NO, nil);
    }]];
    
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}


// An invitation will be presented to the user
- (void)advertiserAssistantWillPresentInvitation:(MCAdvertiserAssistant *)advertiserAssistant{
    
}

// An invitation was dismissed from screen
- (void)advertiserAssistantDidDismissInvitation:(MCAdvertiserAssistant *)advertiserAssistant{
    
}

@end
