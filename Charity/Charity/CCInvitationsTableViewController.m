//
//  CCInvitationsTableViewController.m
//  Charity
//
//  Created by John Hammerlund on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import "CCInvitationsTableViewController.h"
#import "CCInvitationDetailViewController.h"

@interface CCInvitationsTableViewController ()

@property (nonatomic) PFObject *selectedObject;

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
    [query includeKey:@"fromUser"];
    [query whereKey:@"toUser" equalTo:[PFUser currentUser]];


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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"invitationCell";

    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell.textLabel setNumberOfLines:2];
        [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    }

    PFObject *challengeObject = [object objectForKey:@"challenge"];

    NSString *challengeDescription = [challengeObject objectForKey:@"description"];
    NSNumber *challengeAmount = [challengeObject objectForKey:@"goalAmount"];
    PFUser *fromUser = [object objectForKey:@"fromUser"];
    NSString *fromUserName = fromUser[@"displayName"];

    NSString *challengeFullDescription = [NSString stringWithFormat:@"%@ will %@ for $%@!", fromUserName, challengeDescription, [challengeAmount stringValue]];

    NSString *urlString = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=normal", fromUser[@"facebookId"]];

    dispatch_queue_t imageQueue = dispatch_queue_create("user image downloader", NULL);
    dispatch_async(imageQueue, ^{
        UIImage *userImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (userImage) {
                [cell.imageView setImage:userImage];
            }
        });
    });
    [cell.textLabel setText:challengeFullDescription];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Ew, segues...
    [self setSelectedObject:self.objects[indexPath.row]];
    [self performSegueWithIdentifier:@"showInvitationDetails" sender:nil];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CCInvitationDetailViewController *destinationViewController = (CCInvitationDetailViewController *)segue.destinationViewController;
    [destinationViewController setInvitationPFObject:self.selectedObject];
}

@end
