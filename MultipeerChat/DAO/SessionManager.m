//
//  SessionManager.m
//  MultipeerChat
//
//  Created by Shawn Hung on 8/31/15.
//  Copyright (c) 2015 Paganini Plus. All rights reserved.
//

#import "SessionManager.h"

NSString * const ServiceType = @"PP-P2PService1";

@interface SessionManager ()<MCNearbyServiceAdvertiserDelegate, MCAdvertiserAssistantDelegate>

@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) MCAdvertiserAssistant *assistant;
@property (strong, nonatomic) MCNearbyServiceAdvertiser *advertiser;
@property (strong, nonatomic) MCPeerID *localPeerID;

@end

@implementation SessionManager

+ (instancetype)sharedManager {
    static SessionManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    if(self = [super init]){
        self.localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
        self.session = [[MCSession alloc] initWithPeer:self.localPeerID
                                      securityIdentity:nil
                                  encryptionPreference:MCEncryptionNone];
        
        self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID discoveryInfo:nil serviceType:ServiceType];
        self.advertiser.delegate = self;
        
        self.assistant = [[MCAdvertiserAssistant alloc] initWithServiceType:ServiceType discoveryInfo:nil session:self.session];
        
        self.assistant.delegate = self;

    }
    
    return self;
}

- (void)start{
    [self.assistant start];
}

- (MCBrowserViewController *)browserViewController {
    MCBrowserViewController *browserViewController = [[MCBrowserViewController alloc] initWithServiceType:ServiceType session:self.session];
    browserViewController.delegate = self.delegate;
    
    [[SessionManager sharedManager] start];
    
    return browserViewController;
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

}

- (void)sendMessage:(NSString *)message{
    [self.session sendData:[message dataUsingEncoding:NSUTF8StringEncoding] toPeers:self.session.connectedPeers withMode:MCSessionSendDataReliable error:nil];
}

// Received data from remote peer
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.delegate && [self.delegate respondsToSelector:@selector(manager:didReceiveMessage:)]){
            [self.delegate manager:self didReceiveMessage:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
        }
    });
}


@end
