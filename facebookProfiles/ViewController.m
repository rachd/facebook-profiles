//
//  ViewController.m
//  facebookProfiles
//
//  Created by Rachel Dorn on 9/5/16.
//  Copyright © 2016 RachelDorn. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@import WebKit;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *data;
@property (nonatomic, strong) NSArray *posts;
@property (nonatomic, strong) NSString *name;

@end
    
@implementation ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions = @[@"email", @"public_profile", @"user_posts"];
    // Optional: Place the button in the center of your view.
    loginButton.center = CGPointMake(self.view.frame.size.width / 2, 60);
    [self.view addSubview:loginButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"user_posts"]) {
        FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]
                                        initWithGraphPath:@"me" parameters:nil];
        FBSDKGraphRequest *requestPosts = [[FBSDKGraphRequest alloc]
                                           initWithGraphPath:@"me/posts" parameters:nil];
        FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
        [connection addRequest:requestMe
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //process me information
                 if (!error) {
                     self.name = [NSString stringWithFormat:@"%@", [result objectForKey:@"name"]];
                     NSLog(@"me: %@", self.name);
                     [self.tableView reloadData];
                     
                 }
             }];
        [connection addRequest:requestPosts
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //process posts information
                 if (!error) {
                     self.posts = [result objectForKey:@"data"];
                     NSLog(@"posts: %lu", (unsigned long)self.posts.count);
                     [self.tableView reloadData];
        
                 }
             }];
        [connection start];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Name";
            break;
        case 1:
            return @"Posts";
            break;
        default:
            return @"";
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.posts.count;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (cell) {
        if (indexPath.section == 0) {
            cell.textLabel.text = self.name;
        } else {
            cell.textLabel.text = [[self.posts objectAtIndex:indexPath.row] objectForKey:@"message"];
        }
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
