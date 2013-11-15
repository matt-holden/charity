//
//  CCCreateChallenge2ViewController.h
//  Charity
//
//  Created by Matthew Holden on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCCreateChallenge2ViewController : UITableViewController
@property (nonatomic) PFObject *selectedCharity;
@property (weak, nonatomic) IBOutlet UILabel *charityName;
@property (weak, nonatomic) IBOutlet UILabel *charityDescription;
@property (weak, nonatomic) IBOutlet PFImageView *chartityImage;

@end
