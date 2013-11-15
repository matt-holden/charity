//
//  CCInvitiationDetailViewController.m
//  Charity
//
//  Created by John Hammerlund on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import "CCInvitationDetailViewController.h"
#import <Parse/Parse.h>

@interface CCInvitationDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userFullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *challengeDetailsLabel;
@property (weak, nonatomic) IBOutlet UIButton *learnMoreLink;
@property (weak, nonatomic) IBOutlet UILabel *userBetLabel;
@property (nonatomic) PFUser *fromUser;

@property (weak, nonatomic) IBOutlet UIButton *noThanksButton;
@property (weak, nonatomic) IBOutlet UIButton *donateButton;
@end

@implementation CCInvitationDetailViewController

- (void)setInvitationPFObject:(PFObject *)invitationPFObject
{
    _invitationPFObject = invitationPFObject;
    [self setFromUser:invitationPFObject[@"fromUser"]];
    NSString *fullUserName = self.fromUser[@"displayName"];
    [self.userFullNameLabel setText:fullUserName];

    PFObject *unpopulatedCharity = self.invitationPFObject[@"challenge"][@"charity"];
    
    NSString *firstName = [fullUserName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]][0];

    [unpopulatedCharity fetchIfNeededInBackgroundWithBlock:^(PFObject *charity, NSError *error) {
        NSString *challengeDetails = [NSString stringWithFormat:@"Help %@ raise $%@ for %@ by donating $25 or more before 11/15!", firstName, [(NSNumber *)self.invitationPFObject[@"challenge"][@"goalAmount"] stringValue], charity[@"name"]];
        [self.challengeDetailsLabel setText:challengeDetails];
        [self.learnMoreLink setTitle:[NSString stringWithFormat:@"Learn more about %@", charity[@"name"]] forState:UIControlStateNormal];
    }];

    NSString *betString = [NSString stringWithFormat:@"If %@ reaches his goal, he will %@", firstName, self.invitationPFObject[@"challenge"][@"description"]];
    [self.userBetLabel setText:betString];

    NSString *urlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=large", self.fromUser[@"facebookId"]];

    dispatch_queue_t imageQueue = dispatch_queue_create("user image downloader", NULL);
    dispatch_async(imageQueue, ^{
        UIImage *userImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (userImage) {
                [self.userImageView setImage:userImage];
            }
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.donateButton setBackgroundColor:[UIColor colorWithRed:(53/255.0) green:(155/255.0) blue:(9/255.0) alpha:1]];

    [self.noThanksButton setBackgroundColor:[UIColor redColor]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)donateButtonTapped:(id)sender {
}

- (IBAction)noThanksButtonTapped:(id)sender {
}

@end
