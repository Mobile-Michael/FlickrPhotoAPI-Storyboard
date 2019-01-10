//
//  FlickrImageTVC.h
//  EbatesCC_StoryBoard
//
//  Created by Mike Mullin on 1/9/19.
//  Copyright © 2019 EbatesInterview. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FlickrImageTVC : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *m_uiTheImage;
@property (strong, nonatomic) IBOutlet UILabel *m_lblTheTitle;

@end

NS_ASSUME_NONNULL_END
