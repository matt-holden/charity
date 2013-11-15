//
//  CCCreateChallengeViewController.m
//  Charity
//
//  Created by Matthew Holden on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import "CCCreateChallengeViewController.h"
#import "CCFBRequestManager.h"
#import "CCCreateChallenge2ViewController.h"

@interface CCCreateChallengeViewController ()
@property (nonatomic) PFObject *selectedObject;
@end

@implementation CCCreateChallengeViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // This table displays items in the Todo class
        self.parseClassName = @"Charity";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = YES;
        self.objectsPerPage = 25;
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];

    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

    [query orderByDescending:@"createdAt"];

    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    static NSString *identifier = @"Cell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = object[@"name"];

    PFFile *thumbnail = object[@"image"];
    cell.imageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    cell.imageView.file = thumbnail;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedObject = self.objects[indexPath.row];
    [self performSegueWithIdentifier:@"showCreateChallenege2" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CCCreateChallenge2ViewController *vc = (CCCreateChallenge2ViewController*)segue.destinationViewController;
    [vc setSelectedCharity:self.selectedObject];
}
@end
