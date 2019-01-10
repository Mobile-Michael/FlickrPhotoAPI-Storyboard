//
//  PhotoManager.h
//  EbatesCC_StoryBoard
//
//  Created by Mike Mullin on 1/9/19.
//  Copyright © 2019 EbatesInterview. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NetworkChecker;

NS_ASSUME_NONNULL_BEGIN

@class RecentPhotoInfo;
@interface PhotoManager : NSObject
@property(atomic, strong) NetworkChecker *m_pNetworkChecker;

//singleton accessor
+ (instancetype)sharedInstance;

//mutators
-(void) createNewPhoto:(nonnull NSMutableDictionary*)pResults;
-(void) addObject:(RecentPhotoInfo*)photoInfo;
-(BOOL) removeObjectAtIndex:(NSInteger)index;

-(void) reset;//this will clear the entire cache

//accessors
-(NSInteger) getNumPhotos;
-(RecentPhotoInfo*)getPhotoAtIndex:(NSInteger)index;


typedef void (^FlickrCallback) (NSString *error);
-(void) flickrAPIGetRecentFlickrImages:(FlickrCallback)callback;

@end

NS_ASSUME_NONNULL_END
