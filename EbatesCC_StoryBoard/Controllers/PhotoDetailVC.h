//
//  DetailViewController.h
//  EbatesCC_StoryBoard
//
//  Created by Mike Mullin on 1/9/19.
//  Copyright © 2019 EbatesInterview. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecentPhotoInfo;

@interface PhotoDetailVC : UIViewController

@property (strong, nonatomic) RecentPhotoInfo *detailItem;
@property (strong, nonatomic) IBOutlet UIImageView *m_uiFullImage;

@end

