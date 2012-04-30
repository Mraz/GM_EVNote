//
//  NoteViewController.h
//  EvernoteSample
//
//  Created by Moon Jiyoun on 12. 3. 14..
//  Copyright (c) 2012년 Greenmonster, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ENManager.h"

@interface NoteViewController : UIViewController <UITextViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    EDAMNote *currentNote;
    
    BOOL initViewFlag;
    BOOL textFieldFlag;
    
    UIImagePickerController *picker;
    
    NSString *attributesAuthor;
    NSString *attributesTag;
}

@property (strong, nonatomic) EDAMNote *currentNote;
@property (strong, nonatomic) UIImagePickerController *picker;

- (void)createView;
- (void)createContentView;

@end
