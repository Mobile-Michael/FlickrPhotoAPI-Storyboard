//
//  RecentPhotoInfo.h
//  EbatesCC_StoryBoard
//
//  Created by Mike Mullin on 1/9/19.
//  Copyright © 2019 EbatesInterview. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RecentPhotoInfo : NSObject

-(instancetype) initPhotoInfoWithJSONData:(nonnull NSMutableDictionary*)pResults;
-(NSString*) description;

//I KNOW WE'RE NOT USING ALL THE ITEMS, BUT ITS SUCH A SMALL MEMORY FOOTPRINT IT MAKES SENSE IF WE WERE TO EXPAND OUR API THE FEW ITEMS MAY BE USED.
@property(nonatomic, readonly, assign) NSInteger m_nFarm;
@property(nonatomic, readonly, assign) long long m_nID;
@property(nonatomic, readonly, assign) BOOL m_nIsFamily;
@property(nonatomic, readonly, assign) BOOL m_nIsFriend;
@property(nonatomic, readonly, assign) BOOL m_nIsPublic;
@property(nonatomic, readonly, copy)   NSString *m_sOwner;
@property(nonatomic, readonly, copy)   NSString *m_sSecret;
@property(nonatomic, readonly, assign) NSInteger m_nServer;
@property(nonatomic, readonly, copy)   NSString *m_sTitle;

@property(nonatomic, copy)   NSString *m_sURLToImageJPG;
@property(nonatomic, strong) UIImage  *m_theImage;


@end

NS_ASSUME_NONNULL_END
