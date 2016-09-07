//
//  Post.h
//  facebookProfiles
//
//  Created by Rachel Dorn on 9/6/16.
//  Copyright © 2016 RachelDorn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Post : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *story;
@property (nonatomic, strong) NSString *message;

- (instancetype)initWithDate:(NSString *)date image:(NSString *)imageUrl story:(NSString *)story message:(NSString *)message;

@end
