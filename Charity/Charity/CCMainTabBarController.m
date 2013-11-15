//
//  CCMainTabBarController.m
//  Charity
//
//  Created by Matthew Holden on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import "CCMainTabBarController.h"
#import <Parse/Parse.h>

@interface CCMainTabBarController () <PFLogInViewControllerDelegate>
@end

@implementation CCMainTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated
{
    if (![PFUser currentUser]) {
    [self performSegueWithIdentifier:@"showLogIn" sender:nil];
    }
}

@end
