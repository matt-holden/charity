//
//  CCLoginViewController.m
//  Charity
//
//  Created by Matthew Holden on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import "CCLoginViewController.h"
#import <Parse/Parse.h>

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

    if ([PFUser currentUser]) {
//        [self performSegueWithIdentifier:@"didLogIn" sender:nil];
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"foo");
       PFLogInView *view = (PFLogInView*)self.view;

    CGSize newSize = CGSizeMake(320.f, 568.f);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    NSLog(@"size: %@", NSStringFromCGSize(newSize));
    UIImage *image = [UIImage imageNamed:@"CharityChallenge"];
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"newImage: %@", NSStringFromCGSize(newImage.size));

    [view setBackgroundColor:[UIColor colorWithPatternImage:newImage]];
    NSLog(@"view: %@", view);
	// Do any additional setup after loading the view.
}


-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
//    BOOL newUser = [user isNew];
    // user has logged in - we need to fetch all of their Facebook data before we let them in
//    if (!newUser) {
//        [self performSegueWithIdentifier:@"didLogIn" sender:nil];
//    }

    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id<FBGraphUser> user, NSError *error) {
        if (!error) {
            // Set user's information
            // For contest entry display
            if (user[@"name"]) {
                [PFUser currentUser][@"displayName"] = user[@"name"];
            }
            // For optionally showing the user's profile view
            if (user.id && user.id != 0) {
                [PFUser currentUser][@"facebookId"] = user[@"id"];
            }
            // For re-engagement
            if (user[@"email"]) {
                [PFUser currentUser][@"email"] = user[@"email"];
            }
            // For analytics
            if (user[@"locale"]) {
                [PFUser currentUser][@"country"] = user[@"locale"];
            }
            // Save the user's info on Parse
            [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                // Can now let new users in.

                [self dismissViewControllerAnimated:YES completion:nil];
//                if (newUser) {
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }
            }];
        } else {
            NSLog(@"Error getting user info");
        }
    }];
}
@end
