//
//  CCMakePaymentViewController.m
//  Charity
//
//  Created by Matthew Holden on 11/14/13.
//  Copyright (c) 2013 CharityChallenge. All rights reserved.
//

#import "CCMakePaymentViewController.h"
#import <PaymentKit/PKView.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "CCFBRequestManager.h"

@interface CCMakePaymentViewController () <PKViewDelegate>
@property IBOutlet PKView* paymentView;
@end

@implementation CCMakePaymentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.paymentView.delegate = self;
//    [self.view addSubview:self.paymentView];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)paymentView:(PKView *)paymentView withCard:(PKCard *)card isValid:(BOOL)valid
{
}
- (IBAction)confirmPressed:(id)sender {
    double delayInSeconds = 2.5;
    [SVProgressHUD showWithStatus:@"Great! You paid! Now invite some frineds."];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressHUD dismiss];

        [self showFacebookRequest];
    });
}

-(void)showFacebookRequest
{
    [[[CCFBRequestManager alloc] init] sendRequest];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChooseFriends) name:@"CCFBRequestSent" object:nil];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)didChooseFriends
{
    [SVProgressHUD showWithStatus:@"Done!"];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressHUD  dismiss];
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

@end
