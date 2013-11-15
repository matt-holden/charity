//
//  CCCreateChallengeViewController.m
//  Charity
//
//  Created by Matthew Holden on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import "CCCreateChallengeViewController.h"
#import "CCFBRequestManager.h"

@interface CCCreateChallengeViewController ()

@end

@implementation CCCreateChallengeViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

}

-(void)viewDidAppear:(BOOL)animated
{
    [[CCFBRequestManager new] sendRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
