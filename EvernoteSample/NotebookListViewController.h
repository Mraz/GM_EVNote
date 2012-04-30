//
//  NotebookListViewController.h
//  EvernoteSample
//
//  Created by Moon Jiyoun on 12. 3. 14..
//  Copyright (c) 2012년 Greenmonster, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotebookListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
{
    NSArray *notebookListArray;
    
    BOOL initViewFlag;
    BOOL addNotebookFlag;
    
    
    NSInteger selectTableIndex;
}

@property (strong, nonatomic) NSArray *notebookListArray;

- (void)arraySetting;
- (void)createView;
- (void)createNotebookTableView;
- (void)createActivityView;

@end
