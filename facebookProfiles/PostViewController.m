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

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor colorWithRed:0.79 green:0.85 blue:0.97 alpha:1.0];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 60, self.view.frame.size.width - 40, self.view.frame.size.width - 40)];
    [self.view addSubview:self.imageView];
    
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.view.frame.size.width + 20, self.view.frame.size.width - 40, self.view.frame.size.height - self.view.frame.size.width - 80)];
    self.messageLabel.numberOfLines = 0;
    [self.view addSubview:self.messageLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.post.imageUrl]]];
    self.messageLabel.text = self.post.message;
}

@end
