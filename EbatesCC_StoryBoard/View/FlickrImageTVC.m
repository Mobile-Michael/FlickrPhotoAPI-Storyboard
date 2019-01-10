//
//  FlickrImageTVC.m
//  EbatesCC_StoryBoard
//
//  Created by Mike Mullin on 1/9/19.
//  Copyright © 2019 EbatesInterview. All rights reserved.
//

#import "FlickrImageTVC.h"
#import "UIConstants.h"

@implementation FlickrImageTVC
@synthesize m_uiTheImage, m_lblTheTitle;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor blackColor];
    self.m_lblTheTitle.textColor = [UIColor whiteColor];
    self.m_lblTheTitle.font = OUR_FONT;
    self.m_lblTheTitle.numberOfLines = 0;
    self.m_lblTheTitle.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
