//
//  RecentPhotoInfo.m
//  EbatesCC_StoryBoard
//
//  Created by Mike Mullin on 1/9/19.
//  Copyright © 2019 EbatesInterview. All rights reserved.
//

#import "RecentPhotoInfo.h"
#import "Constants.h"


@implementation RecentPhotoInfo
@synthesize m_nFarm, m_nID, m_nIsFamily, m_nIsFriend, m_nIsPublic, m_sOwner, m_sSecret, m_nServer, m_sTitle, m_sURLToImageJPG;


-(instancetype) initPhotoInfoWithJSONData:(NSMutableDictionary*)pResults
{
    self = [super init];
    if( self)
    {
        m_nFarm     = [pResults[FLICKR_OBJ_FARM_KEY] integerValue];
        m_nID       = [pResults[FLICKR_OBJ_ID_KEY] longLongValue];
        m_nIsFamily = [pResults[FLICKR_OBJ_FAMILY_KEY] boolValue];
        m_nIsFriend = [pResults[FLICKR_OBJ_ISFRIEND_KEY] boolValue];
        m_nIsPublic = [pResults[FLICKR_OBJ_ISPUBLIC_KEY] boolValue];
        m_sOwner    = pResults[FLICKR_OBJ_ISOWNER_KEY];
        m_sSecret   = pResults[FLICKR_OBJ_SECRET_KEY];
        m_nServer   = [pResults[FLICKR_OBJ_SERVER_KEY] integerValue];
        m_sTitle    = pResults[FLICKR_OBJ_TITLE_KEY];
        
        if( [m_sTitle isEqualToString: @""])
        {
            m_sTitle = NSLocalizedString(@"NA", "No Title For Flickr Image");
        }
        m_sURLToImageJPG = [self constructImageURL];
    }
    
    return self;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@:%p %@>",
            @"RecentPhotoInfo",
            self,
            @{ @"farm"      : [NSNumber numberWithInteger:  self.m_nFarm],
               @"id"        : [NSNumber numberWithLongLong: self.m_nID],
               @"isfamily"  : [NSNumber numberWithBool: self.m_nIsFamily],
               @"isfriend"  : [NSNumber numberWithBool: self.m_nIsFriend],
               @"ispublic"  : [NSNumber numberWithBool: self.m_nIsPublic],
               @"secret"    : self.m_sSecret,
               @"server"    : [NSNumber numberWithInteger: self.m_nServer],
               @"title"     : self.m_sTitle,
               @"url"       : self.m_sURLToImageJPG
            }];
}

-(NSString*) constructImageURL
{
    //example https://farm6.staticflickr.com/7802/31736728027_a87b7007ea.jpg   <url>/<server>/<id>_<secret>.jpg
    return [NSString stringWithFormat: @"%@/%ld/%lld_%@.jpg", FLICKR_IMG_URL_PATH, (long)self.m_nServer, self.m_nID, self.m_sSecret];
}

@end
