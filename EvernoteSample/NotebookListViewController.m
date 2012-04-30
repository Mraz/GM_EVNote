//
//  NotebookListViewController.m
//  EvernoteSample
//
//  Created by Moon Jiyoun on 12. 3. 14..
//  Copyright (c) 2012년 Greenmonster, Inc. All rights reserved.
//

#import "NotebookListViewController.h"
#import "AppDelegate.h"
#import "Global.h"
#import "CustomCell.h"
#import "NoteListViewController.h"

@implementation NotebookListViewController
@synthesize notebookListArray;

- (void)dealloc
{
    [notebookListArray release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (initViewFlag) {
        [NSThread detachNewThreadSelector:@selector(initThread) toTarget:self withObject:nil];
        
        initViewFlag = FALSE;
    }
}

- (void)initThread
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];

    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[self.view viewWithTag:kNotebookActivityViewTag];
    UITableView *notebookTableView = (UITableView *)[self.view viewWithTag:kNotebookTableViewTag];
    
    [self arraySetting];

    appDelegate.publicNotebooks = [NSArray arrayWithArray:[[ENManager sharedInstance] notebooks]];
    self.notebookListArray = appDelegate.publicNotebooks;
    
    if (!appDelegate.loginSuccessFlag) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login Fail" message:@"Please validate your account or validate your api key."  delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        alert.tag = kLoginSuccessAlertTag;
        [alert show];
        [alert release];
    }
    else {
        [notebookTableView reloadData];
        [activityView stopAnimating];
    }

    [pool release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    initViewFlag = TRUE;
    addNotebookFlag = FALSE;
    
    [self createView];
    [self createNotebookTableView];
    [self createActivityView];
}

- (void)arraySetting
{
    NSArray *_notebookListArray = [[NSArray alloc]init];
    self.notebookListArray = _notebookListArray;
    [_notebookListArray release];
}

- (void)createView
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Notebook List";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.9f];
    titleLabel.shadowOffset = CGSizeMake(0, -1);
    titleLabel.shadowColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.3f];
    [titleLabel sizeToFit];
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
    UIBarButtonItem *addBarButton = [[UIBarButtonItem alloc]initWithTitle:@"New" style:UIBarButtonItemStyleBordered target:self action:@selector(addBarButtonEvent)];
	self.navigationItem.rightBarButtonItem = addBarButton;
    [addBarButton release];
}

- (void)addBarButtonEvent
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    UIView *addNotebookView = [[UIView alloc]init];
    addNotebookView.tag = kAddNotebookViewTag;
    addNotebookView.frame = CGRectMake(0, 480, 320, 460);
    addNotebookView.backgroundColor = [UIColor whiteColor];
    [appDelegate.window addSubview:addNotebookView];
    [addNotebookView release];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEvent)];
    tapGesture.delegate = self;
    [tapGesture setCancelsTouchesInView:NO];
    [addNotebookView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    UIToolbar *topMenuBar = [[UIToolbar alloc]init];
    topMenuBar.frame = CGRectMake(0, 0, 320, 44);
    [addNotebookView addSubview:topMenuBar];
    [topMenuBar release];
    
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonEvent)] autorelease];
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(makeButtonEvent)] autorelease];
    UIBarButtonItem *flexibleButton = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil] autorelease];
    flexibleButton.width = 188;
    
    NSArray *buttonArray = [NSArray arrayWithObjects:cancelButton, flexibleButton, doneButton, nil];
    
    [topMenuBar setItems:buttonArray];
        
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, 320, 48);
    titleLabel.text = @"Make Notebook";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.9f];
    titleLabel.shadowOffset = CGSizeMake(0, -1);
    titleLabel.shadowColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.3f];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [topMenuBar addSubview:titleLabel];
    [titleLabel release];
 
    UITextField *addNotebookTextField = [[UITextField alloc]init];
    addNotebookTextField.tag = kAddNotebookTextFieldTag;
    addNotebookTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    addNotebookTextField.frame = CGRectMake(20, 130, 280, 40);
    addNotebookTextField.adjustsFontSizeToFitWidth = YES;
    addNotebookTextField.placeholder = @"Please enter a title for create Notebook.";
    [addNotebookView addSubview:addNotebookTextField];
    [addNotebookTextField release];
                              
    [UIView beginAnimations:nil context:nil];		
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    addNotebookView.frame = CGRectMake(0, 19, 320, 460);
    [UIView commitAnimations];  
}

- (void)tapGestureEvent
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *addNotebookView = (UIView *)[appDelegate.window viewWithTag:kAddNotebookViewTag];
    UITextField *addNotebookTextField = (UITextField *)[addNotebookView viewWithTag:kAddNotebookTextFieldTag];
    
    [addNotebookTextField resignFirstResponder];
}

- (void)cancelButtonEvent
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *addNotebookView = (UIView *)[appDelegate.window viewWithTag:kAddNotebookViewTag];

    [UIView beginAnimations:nil context:nil];		
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDidStopSelector:@selector(removeAddNotebookView)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    addNotebookView.frame = CGRectMake(0, 480, 320, 460);
    [UIView commitAnimations]; 
}

- (void)makeButtonEvent
{
    UIAlertView *createNotebookAlert = [[UIAlertView alloc]initWithTitle:@"Create notebook?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes", nil];
    createNotebookAlert.tag = kCreateNotebookAlertTag;
    [createNotebookAlert show];
    [createNotebookAlert release];
}

- (void)removeAddNotebookView
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *addNotebookView = (UIView *)[appDelegate.window viewWithTag:kAddNotebookViewTag];
    UITableView *notebookTableView = (UITableView *)[self.view viewWithTag:kNotebookTableViewTag];

    [addNotebookView removeFromSuperview];
    
    if (addNotebookFlag) {
        [notebookTableView reloadData];
        
        addNotebookFlag = FALSE;
    }
}

- (void)createNotebookTableView
{
    UITableView *notebookTableView = [[UITableView alloc]init];
    notebookTableView.tag = kNotebookTableViewTag;
    notebookTableView.frame = CGRectMake(0, 0, 320, 416);
    notebookTableView.delegate = self;
    notebookTableView.dataSource = self;
    [self.view addSubview:notebookTableView];
    [notebookTableView release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.notebookListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *notebookTableView = (UITableView *)[self.view viewWithTag:kNotebookTableViewTag];

    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = (CustomCell *)[notebookTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil]; 
        cell = (CustomCell *)[nib objectAtIndex:0];    
    }
    
    id obj = [self.notebookListArray objectAtIndex:indexPath.row];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[obj serviceCreated] / 1000];   
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM dd, YYYY hh:mm a"];
    NSString *dateString = [formatter stringFromDate:date];
    [formatter release];
    
    cell.nameLabel.text = [obj name];
    cell.createLabel.text = [NSString stringWithFormat:@"Created %@", dateString];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    selectTableIndex = indexPath.row;
    id obj = [self.notebookListArray objectAtIndex:indexPath.row];
    appDelegate.currentNotebookGuid = [obj guid];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NoteListViewController *noteListViewController = [[NoteListViewController alloc]init];
    [self.navigationController pushViewController:noteListViewController animated:YES];
    [noteListViewController release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kNotebookTableViewTag) {
        selectTableIndex = indexPath.row;
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Do you want delete this notebook?" message:@"Delete all note in this notebook." delegate:self cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes", nil];
            alert.tag = kDeleteNotebookAlertTag;
            [alert show];
            [alert release];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITableView *notebookTableView = (UITableView *)[self.view viewWithTag:kNotebookTableViewTag];

    if (alertView.tag == kDeleteNotebookAlertTag) {
        if (buttonIndex == 1) {            
            [[ENManager sharedInstance] removeNotebook:[[self.notebookListArray objectAtIndex:selectTableIndex] guid]];
            
            appDelegate.publicNotebooks = [NSArray arrayWithArray:[[ENManager sharedInstance] notebooks]];
            self.notebookListArray = appDelegate.publicNotebooks;

            [notebookTableView reloadData];
        }
    }
    else if (alertView.tag == kLoginSuccessAlertTag) {
        [[ENManager sharedInstance] releaseAuthorization];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (alertView.tag == kCreateNotebookAlertTag) {
        if (buttonIndex == 1) {
            AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UIView *addNotebookView = (UIView *)[appDelegate.window viewWithTag:kAddNotebookViewTag];
            UITextField *addNotebookTextField = (UITextField *)[addNotebookView viewWithTag:kAddNotebookTextFieldTag];
            
            [[ENManager sharedInstance] createNewNotebookWithTitle:addNotebookTextField.text];
            
            addNotebookFlag = TRUE;
            
            appDelegate.publicNotebooks = [NSArray arrayWithArray:[[ENManager sharedInstance] notebooks]];
            self.notebookListArray = appDelegate.publicNotebooks;
            
            [UIView beginAnimations:nil context:nil];		
            [UIView setAnimationDuration:0.35f];
            [UIView setAnimationDidStopSelector:@selector(removeAddNotebookView)];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            addNotebookView.frame = CGRectMake(0, 480, 320, 460);
            [UIView commitAnimations]; 
        }
    }
}

- (void)createActivityView
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.tag = kNotebookActivityViewTag;
    activityView.center = CGPointMake(160, 208);
    [self.view addSubview:activityView];
    [activityView release];
    
    [activityView startAnimating];
}

@end
