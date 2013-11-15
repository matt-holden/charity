//
//  CCCreateChallenge2ViewController.m
//  Charity
//
//  Created by Matthew Holden on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import "CCCreateChallenge2ViewController.h"
#import "CCFBRequestManager.h"
#import "CCMakePaymentViewController.h"

@interface CCCreateChallenge2ViewController () <UIAlertViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic) UIBarButtonItem *nextBBI;
@property (nonatomic) PFObject *challenegeToSave;
@end

@implementation CCCreateChallenge2ViewController

- (IBAction)chooseTenTapped:(id)sender {
    [[CCFBRequestManager new] sendRequest];
}
- (IBAction)nextTapped:(id)sender {

    PFObject *challenge = [PFObject objectWithClassName:@"Challenge"];
    [challenge setObject:self.description.text forKey:@"description"];
    [challenge setObject:@([self.goalAmount.text doubleValue]) forKey:@"goalAmount"];

    int numDays = (self.dateControl.selectedSegmentIndex + 1);
    NSTimeInterval numSeconds =  numDays * 60 * 60 * 24;
    NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:numSeconds];
    [challenge setObject:endDate forKey:@"endDate"];

    [challenge setObject:self.selectedCharity forKey:@"charity"];
    [challenge setObject:[PFUser currentUser] forKey:@"creator"];
    [challenge setObject:@[[PFUser currentUser].objectId] forKey:@"donors"];

    self.challenegeToSave = challenge;

    [self performSegueWithIdentifier:@"makePayment" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CCMakePaymentViewController *vc = segue.destinationViewController;
    [vc setSelectedCharity:self.selectedCharity];
    [vc setSelectedChallenge:self.challenegeToSave];
}

-(void)viewDidLoad
{
    self.nextBBI = self.navigationItem.rightBarButtonItem;

    [self.charityDescription setText:self.selectedCharity[@"description"]];
    [self.charityName setText:self.selectedCharity[@"name"]];

    PFFile *image = self.selectedCharity[@"image"];
    [self.chartityImage setFile:image];
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    [self resignFirstResponder];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneWithTextView)];
    [self.navigationItem setRightBarButtonItem:bbi];
}

-(void)doneWithTextView
{
    [self.view endEditing:NO];
    [self.navigationItem setRightBarButtonItem:self.nextBBI];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}
@end
