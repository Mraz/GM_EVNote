//
//  AppDelegate.m
//  EvernoteSample
//
//  Created by Moon Jiyoun on 12. 3. 14..
//  Copyright (c) 2012년 Greenmonster, Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

@synthesize userName, passWord;
@synthesize publicNotebooks;
@synthesize currentNotebookGuid, currentNoteGuid;
@synthesize loginSuccessFlag, updateNoteFlag;

- (void)dealloc
{
    [userName release];
    [passWord release];
    [currentNotebookGuid release];
    [currentNoteGuid release];
    [publicNotebooks release];
    [_navigationController release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    LoginViewController *loginViewController = [[LoginViewController alloc]init];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.navigationController = [[[UINavigationController alloc]initWithRootViewController:loginViewController] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.navigationController.view];
    [self.window makeKeyAndVisible];
    
    [loginViewController release];

    userName = nil;
    passWord = nil;
    
    loginSuccessFlag = FALSE;
    updateNoteFlag = FALSE;

    return YES;
}

- (void)arraySetting
{
    NSArray *_publicNotebooks = [[NSArray alloc]init];
    self.publicNotebooks = _publicNotebooks;
    [_publicNotebooks release];
}

# pragma mark - Evernote Delegate

- (void)applicationWillEnterForeground:(UIApplication *)application {
	[self updateEvernoteAccountInfo];
}

- (void)updateEvernoteAccountInfo {
	NSString *str = nil;
	
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	[[ENManager sharedInstance] setUsername:nil];
	[[ENManager sharedInstance] setPassword:nil];
	
	str = [[NSUserDefaults standardUserDefaults] objectForKey:@"evernote_username"];
	if ([str length]) {
		[[ENManager sharedInstance] setUsername:str];
	}
	str = [[NSUserDefaults standardUserDefaults] objectForKey:@"evernote_password"];
	if ([str length]) {
		[[ENManager sharedInstance] setPassword:str];
	}
}

@end
