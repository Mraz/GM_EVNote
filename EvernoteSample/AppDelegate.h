//
//  AppDelegate.h
//  EvernoteSample
//
//  Created by Moon Jiyoun on 12. 3. 14..
//  Copyright (c) 2012년 Greenmonster, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>
{
    NSString *userName;
    NSString *passWord;
    
    NSArray *publicNotebooks;
    
    NSString *currentNotebookGuid;
    NSString *currentNoteGuid;
    
    BOOL loginSuccessFlag;
    BOOL updateNoteFlag;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *passWord;

@property (strong, nonatomic) NSArray *publicNotebooks;

@property (strong, nonatomic) NSString *currentNotebookGuid;
@property (strong, nonatomic) NSString *currentNoteGuid;

@property (assign, nonatomic) BOOL loginSuccessFlag;
@property (assign, nonatomic) BOOL updateNoteFlag;

- (void)arraySetting;

- (void)applicationWillEnterForeground:(UIApplication *)application;
- (void)updateEvernoteAccountInfo;

@end
