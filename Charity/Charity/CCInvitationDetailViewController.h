//
//  CCInvitiationDetailViewController.h
//  Charity
//
//  Created by John Hammerlund on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

@interface CCInvitationDetailViewController : UIViewController

@property (nonatomic) PFObject *invitationPFObject;

@end
