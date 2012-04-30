//
//  NoteListViewController.h
//  EvernoteSample
//
//  Created by Moon Jiyoun on 12. 3. 14..
//  Copyright (c) 2012년 Greenmonster, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENManager.h"

@interface NoteListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    EDAMNoteList *currentNoteList;
    
    BOOL initViewFlag;
    BOOL addNoteFlag;
    BOOL modifyTextViewFlag;
    BOOL textFieldFlag;
        
    NSInteger selectTableIndex;
    
    UIImagePickerController *picker;
}

@property (strong, nonatomic) EDAMNoteList *currentNoteList;
@property (strong, nonatomic) UIImagePickerController *picker;

- (void)createView;
- (void)createNoteTableView;
- (void)createActivityView;

@end
