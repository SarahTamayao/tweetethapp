//
//  User.m
//  twitter
//
//  Created by Laura Yao on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.screenName = dictionary[@"screen_name"];
        self.profilePicture = dictionary[@"profile_image_url_https"];
        self.tagline = dictionary[@"description"];
        self.location = dictionary[@"location"];
        self.followerCount = [dictionary[@"followers_count"] intValue];
        self.followingCount = [dictionary[@"friends_count"] intValue];
        self.statusCount = [dictionary[@"statuses_count"] intValue];
        self.bannerPicture = dictionary[@"profile_banner_url"];
        
    // Initialize any other properties
    }
    return self;
}

@end
