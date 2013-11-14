//
//  CCLoginViewController.m
//  Charity
//
//  Created by Matthew Holden on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import "CCLoginViewController.h"

@interface CCLoginViewController () <PFLogInViewControllerDelegate>

@end

@implementation CCLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setDelegate:self];
    [self setFields:PFLogInFieldsFacebook];
    [self setFacebookPermissions:@[@"email"]];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
