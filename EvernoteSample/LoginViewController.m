//
//  LoginViewController.m
//  EvernoteSample
//
//  Created by Moon Jiyoun on 12. 3. 14..
//  Copyright (c) 2012년 Greenmonster, Inc. All rights reserved.
//

#import "LoginViewController.h"
#import "Global.h"
#import "NotebookListViewController.h"
#import "AppDelegate.h"

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIView *loginView = (UIView *)[self.view viewWithTag:kLoginViewTag];
    UITextField *idTextField = (UITextField *)[loginView viewWithTag:kLoginTextFieldTag];
    UITextField *passwordTextField = (UITextField *)[loginView viewWithTag:kLoginTextFieldTag+1];

    idTextField.text = nil;
    passwordTextField.text = nil;
    
    [[ENManager sharedInstance] releaseAuthorization];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self createView];
    [self createTapView];
    [self createLoginView];
    [self createLogoView];
}

- (void)createView
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Login";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.9f];
    titleLabel.shadowOffset = CGSizeMake(0, -1);
    titleLabel.shadowColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.3f];
    [titleLabel sizeToFit];
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
}

- (void)createTapView
{
    UIView *tapView = [[UIView alloc]init];
    tapView.frame = self.view.bounds;
    [self.view addSubview:tapView];
    [tapView release];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEvent)];
    tapGesture.delegate = self;
    [tapGesture setCancelsTouchesInView:NO];
    [tapView addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (void)tapGestureEvent
{
    UIView *loginView = (UIView *)[self.view viewWithTag:kLoginViewTag];
    UITextField *idTextField = (UITextField *)[loginView viewWithTag:kLoginTextFieldTag];
    UITextField *passwordTextField = (UITextField *)[loginView viewWithTag:kLoginTextFieldTag+1];
    
    [idTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
}

- (void)createLoginView
{
    UIView *loginView = [[UIView alloc]init];
    loginView.tag = kLoginViewTag;
    loginView.frame = CGRectMake(20, 20, 280, 80);
    [self.view addSubview:loginView];
    [loginView release];
    
    UIImageView *loginBgImageView = [[UIImageView alloc]init];
    loginBgImageView.frame = CGRectMake(0, 0, 280, 80);
    loginBgImageView.image = [UIImage imageNamed:@"textLabelBg.png"];
    [loginView addSubview:loginBgImageView];
    [loginBgImageView release];
    
    NSArray *loginLabelArray = [NSArray arrayWithObjects:@"ID",@"Password", nil];
    NSArray *loginTextFieldArray = [NSArray arrayWithObjects:@"Greenmonster",@"Required", nil];

    for (int i=0; i<2; i++) {
        UILabel *loginLabel = [[UILabel alloc]init];
        loginLabel.frame = CGRectMake(0, 0+i*40, 88, 40);
        loginLabel.text = [loginLabelArray objectAtIndex:i];
        loginLabel.font = [UIFont systemFontOfSize:16.0f];
        loginLabel.backgroundColor = [UIColor clearColor];
        loginLabel.textAlignment = UITextAlignmentRight;
        loginLabel.userInteractionEnabled = NO;
        [loginView addSubview:loginLabel];
        [loginLabel release];
        
        UITextField *loginTextField = [[UITextField alloc]init];
        loginTextField.tag = kLoginTextFieldTag + i;
        loginTextField.font = [UIFont systemFontOfSize:16.0f];
        loginTextField.frame = CGRectMake(110, 0+i*40, 170, 40);
        loginTextField.placeholder = [loginTextFieldArray objectAtIndex:i];
        loginTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [loginView addSubview:loginTextField];
        [loginTextField release];
    }
    
    UITextField *passwordTextField = (UITextField *)[loginView viewWithTag:kLoginTextFieldTag+1];
    passwordTextField.secureTextEntry = YES;
    
    UIButton *loginButton = [[UIButton alloc]init];
    loginButton.tag = kLoginButtonTag;
    [loginButton setTitle:@"Sign In" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.8f] forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.8f] forState:UIControlStateHighlighted];
    loginButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [loginButton setTitleShadowColor:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"signInBtn_n.png"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"signInBtn_s.png"] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(loginButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    loginButton.frame = CGRectMake(40, 114, 240, 35);
    [self.view addSubview:loginButton];
    [loginButton release];
}


- (void)loginButtonEvent
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIView *loginView = (UIView *)[self.view viewWithTag:kLoginViewTag];
    UITextField *idTextField = (UITextField *)[loginView viewWithTag:kLoginTextFieldTag];
    UITextField *passwordTextField = (UITextField *)[loginView viewWithTag:kLoginTextFieldTag+1];

    appDelegate.userName = idTextField.text;
    appDelegate.passWord = passwordTextField.text;
    
    [idTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    NotebookListViewController *notebookListViewController = [[NotebookListViewController alloc]init];
    [self.navigationController pushViewController:notebookListViewController animated:YES];
    [notebookListViewController release];   
}

- (void)createLogoView
{
    UIImageView *logoImageView = [[UIImageView alloc]init];
    logoImageView.frame = CGRectMake(135, 345, 50, 50);
    logoImageView.image = [UIImage imageNamed:@"logo.png"];
    [self.view addSubview:logoImageView];
    [logoImageView release];
    
    UILabel *logoLabel = [[UILabel alloc]init];
    logoLabel.frame = CGRectMake(0, 396, 320, 20);
    logoLabel.text = @"Copyright ©2012 Greenmonster, Inc. All Rights Reserved.";
    logoLabel.textColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.4f];
    logoLabel.font = [UIFont systemFontOfSize:10.0f];
    logoLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:logoLabel];
    [logoLabel release];
}

@end
