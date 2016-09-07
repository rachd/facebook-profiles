//
//  PostViewController.m
//  facebookProfiles
//
//  Created by Rachel Dorn on 9/6/16.
//  Copyright © 2016 RachelDorn. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()

@property (nonatomic, strong) Post *post;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation PostViewController

- (instancetype)initWithPost:(Post *)post {
    self = [super init];
    if (self) {
        self.post = post;
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    self.view.backgroundColor = [UIColor colorWithRed:0.79 green:0.85 blue:0.97 alpha:1.0];
    
    if (self.post.imageUrl) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.post.imageUrl]]]];
        self.imageView.center = CGPointMake(self.view.frame.size.width / 2, 140);
        [self.view addSubview:self.imageView];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, self.view.frame.size.width - 40, 60)];
    } else {
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, self.view.frame.size.width - 40, 100)];
    }
    
    self.messageLabel.numberOfLines = 0;
    if (self.post.message) {
        self.messageLabel.text = self.post.message;
    } else {
        self.messageLabel.text = self.post.story;
    }
    [self.view addSubview:self.messageLabel];
    
}

@end
