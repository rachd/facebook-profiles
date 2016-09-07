//
//  Post.m
//  facebookProfiles
//
//  Created by Rachel Dorn on 9/6/16.
//  Copyright © 2016 RachelDorn. All rights reserved.
//

#import "Post.h"

@implementation Post

- (instancetype)initWithDate:(NSString *)date image:(NSString *)imageUrl story:(NSString *)story message:(NSString *)message {
    self = [super init];
    if (self) {
        self.date = date;
        self.imageUrl = imageUrl;
        self.story = story;
        self.message = message;
    }
    return self;
}

@end
