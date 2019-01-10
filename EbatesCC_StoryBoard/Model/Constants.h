//
//  Constants.h
//  EbatesCC_StoryBoard
//
//  Created by Mike Mullin on 1/9/19.
//  Copyright © 2019 EbatesInterview. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#pragma mark Flickr Results JSON Keys
//global results keys
#define FLICKR_PHOTO_DICT_KEY @"photos"
#define FLICKR_PHOTO_ARR_KEY  @"photo"

//photo info keys
#define FLICKR_OBJ_FARM_KEY     @"farm"
#define FLICKR_OBJ_ID_KEY       @"id"
#define FLICKR_OBJ_FAMILY_KEY   @"isfamily"
#define FLICKR_OBJ_ISFRIEND_KEY @"isfriend"
#define FLICKR_OBJ_ISPUBLIC_KEY @"ispublic"
#define FLICKR_OBJ_ISOWNER_KEY  @"owner"
#define FLICKR_OBJ_SECRET_KEY   @"secret"
#define FLICKR_OBJ_SERVER_KEY   @"server"
#define FLICKR_OBJ_TITLE_KEY    @"title"

//image location url
//https://farm6.staticflickr.com/5623/30145975463_02b8452545.jpg
#define FLICKR_IMG_URL_PATH @"https://farm6.staticflickr.com"
#endif /* Constants_h */
