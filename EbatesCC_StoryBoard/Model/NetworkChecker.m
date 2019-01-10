//
//  NetworkChecker.m
//  EbatesCC_StoryBoard
//
//  Created by Mike Mullin on 1/9/19.
//  Copyright © 2019 EbatesInterview. All rights reserved.
//

#import "NetworkChecker.h"
#import "../ebates.pch"

@implementation NetworkChecker
@synthesize m_hostStatus, m_wifiStatus, m_wwanStatus;
@synthesize hostReachability;
@synthesize internetReachability;
@synthesize wifiReachability;


-(instancetype)init{
    self = [super init];
    if( self)
    {
        [self checkForNetwork];
    }
    return self;
}


-(bool) hasInternetConnection
{
    bool bNoInternet = m_wwanStatus == NotReachable && m_wifiStatus == NotReachable;
    return !bNoInternet;
}

-(void) onInternetStatusChanged
{
    if( [self hasInternetConnection])
    {
        LogEbates(@"Internet Has Connection Now");
    }
    else
    {
        LogEbates(@"Internet no longer has connection");
    }
}

- (void)checkForNetwork
{
    // check if we've got network connectivity
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    NSString *remoteHostName = @"www.apple.com";
    self.hostReachability = [Reachability reachabilityWithHostName:remoteHostName];
    [self.hostReachability startNotifier];
    m_hostStatus = [self.hostReachability currentReachabilityStatus];
    
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    m_wwanStatus = [self.internetReachability currentReachabilityStatus];
    
    self.wifiReachability = [Reachability reachabilityForLocalWiFi];
    [self.wifiReachability startNotifier];
    m_wifiStatus = [self.wifiReachability currentReachabilityStatus];
}

- (void) reachabilityChanged:(NSNotification *)note
{
    Reachability* reachability = [note object];
    NSParameterAssert([reachability isKindOfClass:[Reachability class]]);
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    
    if (reachability == self.hostReachability)
    {
        self.m_hostStatus = netStatus;
        NSString* baseLabelText = [[NSString alloc] init];
        if (connectionRequired)
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is available.\nInternet traffic will be routed through it after a connection is established.", @"Reachability text if a connection is required");
        }
        else
        {
            baseLabelText = NSLocalizedString(@"Cellular data network is active.\nInternet traffic will be routed through it.", @"Reachability text if a connection is not required");
        }
        
        LogEbates(@"%@", baseLabelText);
    }
    
    if( reachability == self.wifiReachability)
    {
        if(self.m_wifiStatus != netStatus)
        {
            self.m_wifiStatus = netStatus;
            [self onInternetStatusChanged];
        }
    }
    
    if( reachability == self.internetReachability)
    {
        if(self.m_wwanStatus != netStatus)
        {
            self.m_wwanStatus = netStatus;
            [self onInternetStatusChanged];
        }
    }
    
    NSString *statusString = nil;
    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = NSLocalizedString(@"Access Not Available", @"Text field text for access is not available");
            /*
             Minor interface detail- connectionRequired may return YES even when the host is unreachable. We cover that up here...
             */
            connectionRequired = NO;
            break;
        }
        case ReachableViaWWAN:
        {
            statusString = NSLocalizedString(@"Reachable WWAN", @"");
            break;
        }
        case ReachableViaWiFi:
        {
            statusString= NSLocalizedString(@"Reachable WiFi", @"");
            break;
        }
    }
    
    LogEbates(@"string 1: %@", statusString);
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString= [NSString stringWithFormat:connectionRequiredFormatString, statusString];
        LogEbates(@"string 2: %@", statusString);
    }
    
}
@end
