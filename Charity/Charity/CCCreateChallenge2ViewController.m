//
//  CCCreateChallenge2ViewController.m
//  Charity
//
//  Created by Matthew Holden on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import "CCCreateChallenge2ViewController.h"
#import "CCFBRequestManager.h"

@interface CCCreateChallenge2ViewController () <UIAlertViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic) UIBarButtonItem *nextBBI;
@end

@implementation CCCreateChallenge2ViewController

- (IBAction)chooseTenTapped:(id)sender {
    [[CCFBRequestManager new] sendRequest];
}
- (IBAction)nextTapped:(id)sender {
    [self performSegueWithIdentifier:@"makePayment" sender:nil];
}

-(void)viewDidLoad
{
    self.nextBBI = self.navigationItem.rightBarButtonItem;
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
