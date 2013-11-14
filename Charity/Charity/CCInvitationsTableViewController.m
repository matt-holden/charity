//
//  CCInvitationsTableViewController.m
//  Charity
//
//  Created by John Hammerlund on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import "CCInvitationsTableViewController.h"

@interface CCInvitationsTableViewController ()

@end

@implementation CCInvitationsTableViewController

- (void)viewDidLoad {
    [self setParseClassName:kInvitationPFObject];
    [self setPullToRefreshEnabled:YES];
    [self setPaginationEnabled:NO];
    [self setObjectsPerPage:25];
    [super viewDidLoad];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query includeKey:@"challenge"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];


    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }

    //TODO - Contant-ize table columns
    [query orderByDescending:@"createdAt"];

    return query;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"invitationCell";

    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }

    PFObject *challengeObject = [object objectForKey:@"challenge"];
    NSString *challengeName = [challengeObject objectForKey:@"name"];
    PFFile *imageFile = [challengeObject objectForKey:@"image"];

    [cell.textLabel setText:challengeName];
    [cell.imageView setFile:imageFile];


    return cell;
}

@end
