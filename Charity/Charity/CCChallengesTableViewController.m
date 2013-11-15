//
//  CCChallengesTableViewController.m
//  Charity
//
//  Created by John Hammerlund on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import "CCChallengesTableViewController.h"

@interface CCChallengesTableViewController ()

@end

@implementation CCChallengesTableViewController

- (void)viewDidLoad {
    [self setParseClassName:kChallengePFObject];
    [self setPullToRefreshEnabled:YES];
    [self setPaginationEnabled:NO];
    [self setObjectsPerPage:25];
    [super viewDidLoad];
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query includeKey:@"charity"];
    [query whereKey:@"donors" equalTo:[PFUser currentUser].objectId];


    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        [query setCachePolicy:kPFCachePolicyCacheThenNetwork];
    }

    //TODO - Contant-ize table columns
    [query orderByDescending:@"endDate"];

    return query;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"challengeCell";

    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }

    unsigned long numberOfDonors = [(NSArray *)object[@"donors"] count];
    [cell.textLabel setText:[NSString stringWithFormat:@"%lu %@ donated!", numberOfDonors, (numberOfDonors > 1 ? @"people have" : @"person has")]];

    NSDate *endDate = object[@"endDate"];

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:[NSDate date] toDate:endDate options:0];

    NSInteger daysLeft = components.day;
    NSInteger hoursLeft = components.hour;
    NSInteger minutesLeft = components.minute;

    NSString *daysLeftString = daysLeft > 0 ? daysLeft == 1 ? @"1 day, " : [NSString stringWithFormat:@"%ld days, ", daysLeft] : @"";
NSString *hoursLeftString = hoursLeft > 0 ? hoursLeft == 1 ? @"1 hour, " : [NSString stringWithFormat:@"%ld hours, ", daysLeft] : @"";
NSString *minutesLeftString = minutesLeft > 0 ? minutesLeft == 1 ? @"1 minute" : [NSString stringWithFormat:@"%ld minutes", daysLeft] : @"";


    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@%@%@ remaining!", daysLeftString, hoursLeftString, minutesLeftString]];
    
    [cell.imageView setFile:object[@"charity"][@"image"]];

    return cell;
}



@end
