//
//  NetworkChecker.h
//  EbatesCC_StoryBoard
//
//  Created by Mike Mullin on 1/9/19.
//  Copyright © 2019 EbatesInterview. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkChecker : NSObject

//network reachability
-(void) onInternetStatusChanged;
-(bool) hasInternetConnection;

-(void) checkForNetwork;
//network reachability
@property (nonatomic)         NetworkStatus m_wifiStatus;
@property (nonatomic)         NetworkStatus m_wwanStatus;
@property (nonatomic)         NetworkStatus m_hostStatus;
@property (nonatomic)         Reachability *hostReachability;
@property (nonatomic)         Reachability *internetReachability;
@property (nonatomic)         Reachability *wifiReachability;

@end

NS_ASSUME_NONNULL_END
