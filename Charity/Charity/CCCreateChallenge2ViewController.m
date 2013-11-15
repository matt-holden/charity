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

@end

@implementation CCCreateChallenge2ViewController

- (IBAction)chooseTenTapped:(id)sender {
    [[CCFBRequestManager new] sendRequest];
}
- (IBAction)nextTapped:(id)sender {
    [[[UIAlertView alloc] initWithTitle:@"Done" message:@"Created" delegate:self cancelButtonTitle:@"Cool" otherButtonTitles:nil] show];
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resignFirstResponder];
    return YES;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self resignFirstResponder];
}
@end
