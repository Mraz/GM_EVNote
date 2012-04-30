//
//  NoteListViewController.m
//  EvernoteSample
//
//  Created by Moon Jiyoun on 12. 3. 14..
//  Copyright (c) 2012년 Greenmonster, Inc. All rights reserved.
//

#import "NoteListViewController.h"
#import "AppDelegate.h"
#import "Global.h"
#import "CustomCell.h"
#import "NoteViewController.h"

@implementation NoteListViewController
@synthesize currentNoteList;
@synthesize picker;

- (void)dealloc
{
    [currentNoteList release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (initViewFlag) {        
        [NSThread detachNewThreadSelector:@selector(initThread) toTarget:self withObject:nil];
        initViewFlag = FALSE;
    }
    
    if (appDelegate.updateNoteFlag) {        
        [NSThread detachNewThreadSelector:@selector(initThread) toTarget:self withObject:nil];
        appDelegate.updateNoteFlag = FALSE;
    }
}

- (void)initThread
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[self.view viewWithTag:kNoteActivityViewTag];
    UITableView *noteTableView = (UITableView *)[self.view viewWithTag:kNoteTableViewTag];
    
    self.currentNoteList = [[ENManager sharedInstance] noteListWithNotebookGuid:appDelegate.currentNotebookGuid];
        
    [noteTableView reloadData];
    [activityView stopAnimating];
    [pool release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    initViewFlag = TRUE;
    addNoteFlag = FALSE;
    modifyTextViewFlag = FALSE;
    textFieldFlag = FALSE;
    
    [self initPickerView];
    [self createView];
    [self createNoteTableView];
    [self createActivityView];
}

- (void)initPickerView
{
    UIImagePickerController *_picker = [[UIImagePickerController alloc] init];
    self.picker = _picker;
    [_picker release];
}

- (void)createView
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"Note List";
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
    
    UIView *addNoteView = [[UIView alloc]init];
    addNoteView.tag = kAddNoteViewTag;
    addNoteView.frame = CGRectMake(0, 480, 320, 460);
    addNoteView.backgroundColor = [UIColor whiteColor];
    [appDelegate.window addSubview:addNoteView];
    [addNoteView release];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEvent)];
    tapGesture.delegate = self;
    [tapGesture setCancelsTouchesInView:NO];
    [addNoteView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    UIView *backView = [[UIView alloc]init];
    backView.tag = kBackViewTag;
    backView.frame = CGRectMake(0, 44, 320, 416);
    [addNoteView addSubview:backView];
    [backView release];
    
    UIView *addNoteContentView = [[UIView alloc]init];
    addNoteContentView.tag = kAddNoteContentViewTag;
    addNoteContentView.frame = CGRectMake(0, 50, 320, 245);
    [backView addSubview:addNoteContentView];
    [addNoteContentView release];
    
    UITextView *noteContentTextView = [[UITextView alloc]init];
    noteContentTextView.frame = CGRectMake(0, 0, 320, 245);
    noteContentTextView.tag = kAddNoteTextViewTag;
    noteContentTextView.delegate = self;
    noteContentTextView.showsVerticalScrollIndicator = NO;
    noteContentTextView.backgroundColor = [UIColor clearColor];
    noteContentTextView.textColor = [UIColor lightGrayColor];
    noteContentTextView.font = [UIFont systemFontOfSize:14.0f];
    noteContentTextView.text = @"Please enter contents for create Note.";
    [addNoteContentView addSubview:noteContentTextView];
    [noteContentTextView release];  
    
    UIView *addNoteTitleView = [[UIView alloc]init];
    addNoteTitleView.tag = kAddNoteTitleViewTag;
    addNoteTitleView.frame = CGRectMake(0, 0, 320, 50);
    [backView addSubview:addNoteTitleView];
    [addNoteTitleView release];
    
    UIImageView *addNoteTitleViewBgImageView = [[UIImageView alloc]init];
    addNoteTitleViewBgImageView.frame = CGRectMake(0, 0, 320, 50);
    addNoteTitleViewBgImageView.image = [UIImage imageNamed:@"titleLabelBg.png"];
    [addNoteTitleView addSubview:addNoteTitleViewBgImageView];
    [addNoteTitleViewBgImageView release];
    
    UITextField *noteTitleTextField = [[UITextField alloc]init];
    noteTitleTextField.tag = kAddNoteTextFieldTag;
    noteTitleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    noteTitleTextField.frame = CGRectMake(25, 5, 240, 40);
    noteTitleTextField.placeholder = @"Please enter a title.";
    [addNoteTitleView addSubview:noteTitleTextField];
    [noteTitleTextField release];
    
    UIButton *photoButton = [[UIButton alloc]init];
    photoButton.frame = CGRectMake(270, 5, 40, 40);
    [photoButton setImage:[UIImage imageNamed:@"cameraBtn_n.png"] forState:UIControlStateNormal];
    [photoButton setImage:[UIImage imageNamed:@"cameraBtn_s.png"] forState:UIControlStateHighlighted];
    [photoButton addTarget:self action:@selector(photoButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [addNoteTitleView addSubview:photoButton];
    [photoButton release];
    
    UIImageView *addPhotoImageView = [[UIImageView alloc]init];
    addPhotoImageView.tag = kAddPhotoImageViewTag;
    addPhotoImageView.image = [UIImage imageNamed:@"thumbnail_dummy.png"];
    addPhotoImageView.frame = CGRectMake(10, 300, 100, 100);
    [backView addSubview:addPhotoImageView];
    [addPhotoImageView release];
    
    UIImageView *addPhotoMaskImageView = [[UIImageView alloc]init];
    addPhotoMaskImageView.frame = CGRectMake(10, 300, 100, 100);
    addPhotoMaskImageView.image = [UIImage imageNamed:@"thumbnailMask.png"];
    [backView addSubview:addPhotoMaskImageView];
    [addPhotoMaskImageView release];
    
    NSArray *footerLabelArray = [NSArray arrayWithObjects:@"Writer", @"Tag", nil];
    NSArray *footerTextFieldArray = [NSArray arrayWithObjects:@"Greenmonster", @"Test Tag", nil];

    for (int i=0; i<2; i++) {
        UILabel *footerLabel = [[UILabel alloc]init];
        footerLabel.text = [footerLabelArray objectAtIndex:i];
        footerLabel.frame = CGRectMake(130, 305+i*55, 180, 15);
        footerLabel.textColor = [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1.0f];
        footerLabel.font = [UIFont systemFontOfSize:12.0f];
        [backView addSubview:footerLabel];
        [footerLabel release];
        
        UITextField *footerTextField = [[UITextField alloc]init];
        footerTextField.tag = kFooterTextFieldTag + i;
        footerTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        footerTextField.frame = CGRectMake(130, 325+i*55, 180, 20);
        footerTextField.font = [UIFont systemFontOfSize:16.0f];
        footerTextField.delegate = self;
        footerTextField.placeholder = [footerTextFieldArray objectAtIndex:i];
        [backView addSubview:footerTextField];
        [footerTextField release];
    }
    
    UIToolbar *topMenuBar = [[UIToolbar alloc]init];
    topMenuBar.frame = CGRectMake(0, 0, 320, 44);
    [addNoteView addSubview:topMenuBar];
    [topMenuBar release];
    
    UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonEvent)] autorelease];
    UIBarButtonItem *doneButton = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(makeButtonEvent)] autorelease];
    UIBarButtonItem *flexibleButton = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil] autorelease];
    flexibleButton.width = 188;
    
    NSArray *buttonArray = [NSArray arrayWithObjects:cancelButton, flexibleButton, doneButton, nil];
    
    [topMenuBar setItems:buttonArray];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(0, 0, 320, 48);
    titleLabel.text = @"Make Note";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.9f];
    titleLabel.shadowOffset = CGSizeMake(0, -1);
    titleLabel.shadowColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.3f];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    [topMenuBar addSubview:titleLabel];
    [titleLabel release];
    
    [UIView beginAnimations:nil context:nil];		
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    addNoteView.frame = CGRectMake(0, 20, 320, 460);
    [UIView commitAnimations];  
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{   
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *addNoteView = (UIView *)[appDelegate.window viewWithTag:kAddNoteViewTag];
    UIView *backView = (UIView *)[addNoteView viewWithTag:kBackViewTag];

    if (textField.tag == kFooterTextFieldTag) {
        textFieldFlag = TRUE;
        [UIView beginAnimations:nil context:nil];		
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        backView.frame = CGRectMake(0, -170, 320, 416);
        [UIView commitAnimations]; 
    }
    else if (textField.tag == kFooterTextFieldTag+1) {
        textFieldFlag = TRUE;
        [UIView beginAnimations:nil context:nil];		
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        backView.frame = CGRectMake(0, -170, 320, 416);
        [UIView commitAnimations]; 
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *addNoteView = (UIView *)[appDelegate.window viewWithTag:kAddNoteViewTag];
    UIView *backView = (UIView *)[addNoteView viewWithTag:kBackViewTag];
    
    if (textField.tag == kFooterTextFieldTag) {
        if (!textFieldFlag) {
            [UIView beginAnimations:nil context:nil];		
            [UIView setAnimationDuration:0.25f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            backView.frame = CGRectMake(0, 44, 320, 416);
            [UIView commitAnimations]; 
        }
    }
    else if (textField.tag == kFooterTextFieldTag+1) {
        if (!textFieldFlag) {
            [UIView beginAnimations:nil context:nil];		
            [UIView setAnimationDuration:0.25f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            backView.frame = CGRectMake(0, 44, 320, 416);
            [UIView commitAnimations]; 
        } 
    }
}

- (void)photoButtonEvent
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *addNoteView = (UIView *)[appDelegate.window viewWithTag:kAddNoteViewTag];

    [UIView beginAnimations:nil context:nil];		
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    addNoteView.frame = CGRectMake(0, 480, 320, 460);
    [UIView commitAnimations]; 
    
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.allowsEditing = YES;
    self.picker.delegate = self;
    
    [self presentModalViewController:self.picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)info {   
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *addNoteView = (UIView *)[appDelegate.window viewWithTag:kAddNoteViewTag];
    UIView *backView = (UIView *)[addNoteView viewWithTag:kBackViewTag];
    UIImageView *addPhotoImageView = (UIImageView *)[backView viewWithTag:kAddPhotoImageViewTag];
    
    addPhotoImageView.image = img;
    
    [UIView beginAnimations:nil context:nil];		
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    addNoteView.frame = CGRectMake(0, 20, 320, 460);
    [UIView commitAnimations];
    
    [self.picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *addNoteView = (UIView *)[appDelegate.window viewWithTag:kAddNoteViewTag];
    
    [UIView beginAnimations:nil context:nil];		
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    addNoteView.frame = CGRectMake(0, 20, 320, 460);
    [UIView commitAnimations];
    
    [self.picker dismissModalViewControllerAnimated:YES];    
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *addNoteView = (UIView *)[appDelegate.window viewWithTag:kAddNoteViewTag];
    UIView *backView = (UIView *)[addNoteView viewWithTag:kBackViewTag];

    if (textView.tag == kAddNoteTextViewTag) {
        textFieldFlag = FALSE;
        
        if (!modifyTextViewFlag) {
            textView.textColor = [UIColor blackColor];
            textView.text = nil; 
            
            modifyTextViewFlag = TRUE;
        }
        
        [UIView beginAnimations:nil context:nil];		
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        backView.frame = CGRectMake(0, 44, 320, 416);
        textView.frame = CGRectMake(0, 0, 320, 150);
        [UIView commitAnimations];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == kAddNoteTextViewTag) {
        [UIView beginAnimations:nil context:nil];		
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        textView.frame = CGRectMake(0, 0, 320, 245);
        [UIView commitAnimations];
    }
}

- (void)tapGestureEvent
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *addNoteView = (UIView *)[appDelegate.window viewWithTag:kAddNoteViewTag];
    UIView *backView = (UIView *)[addNoteView viewWithTag:kBackViewTag];
    UIView *noteTitleView = (UIView *)[backView viewWithTag:kAddNoteTitleViewTag];
    UITextField *addNoteTextField = (UITextField *)[noteTitleView viewWithTag:kAddNoteTextFieldTag];
    UIView *addNoteContentView = (UIView *)[backView viewWithTag:kAddNoteContentViewTag];
    UITextView *addNoteTextView = (UITextView *)[addNoteContentView viewWithTag:kAddNoteTextViewTag];
    UITextField *writerTextField = (UITextField *)[backView viewWithTag:kFooterTextFieldTag];
    UITextField *tagTextField = (UITextField *)[backView viewWithTag:kFooterTextFieldTag+1];
    
    [UIView beginAnimations:nil context:nil];		
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    backView.frame = CGRectMake(0, 44, 320, 416);
    [UIView commitAnimations]; 

    [addNoteTextField resignFirstResponder];
    [addNoteTextView resignFirstResponder];
    [writerTextField resignFirstResponder];
    [tagTextField resignFirstResponder];
}

- (void)cancelButtonEvent
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *addNoteView = (UIView *)[appDelegate.window viewWithTag:kAddNoteViewTag];
    
    [UIView beginAnimations:nil context:nil];		
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationDidStopSelector:@selector(removeAddNoteView)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    addNoteView.frame = CGRectMake(0, 480, 320, 460);
    [UIView commitAnimations]; 
}

- (void)makeButtonEvent
{
    UIAlertView *createNoteAlert = [[UIAlertView alloc]initWithTitle:@"Create note?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes", nil];
    createNoteAlert.tag = kCreateNoteAlertTag;
    [createNoteAlert show];
    [createNoteAlert release];
}

- (void)removeAddNoteView
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView *addNoteView = (UIView *)[appDelegate.window viewWithTag:kAddNoteViewTag];
    UITableView *noteTableView = (UITableView *)[self.view viewWithTag:kNoteTableViewTag];
    
    [addNoteView removeFromSuperview];
    
    if (addNoteFlag) {
        [noteTableView reloadData];
        
        addNoteFlag = FALSE;
    }
}

- (void)createNoteTableView
{
    UITableView *noteTableView = [[UITableView alloc]init];
    noteTableView.tag = kNoteTableViewTag;
    noteTableView.frame = CGRectMake(0, 0, 320, 416);
    noteTableView.delegate = self;
    noteTableView.dataSource = self;
    [self.view addSubview:noteTableView];
    [noteTableView release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.currentNoteList notes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableView *noteTableView = (UITableView *)[self.view viewWithTag:kNoteTableViewTag];
    
    static NSString *CellIdentifier = @"CustomCell";
    CustomCell *cell = (CustomCell *)[noteTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil]; 
        cell = (CustomCell *)[nib objectAtIndex:0];    
    }
    
    id obj = [[self.currentNoteList notes] objectAtIndex:indexPath.row];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[obj created] / 1000];   
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM dd, YYYY hh:mm a"];
    NSString *dateString = [formatter stringFromDate:date];
    [formatter release];
    
    cell.nameLabel.text = [obj title];
    cell.createLabel.text = [NSString stringWithFormat:@"Created %@", dateString];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    selectTableIndex = indexPath.row;
    
    id obj = [[self.currentNoteList notes] objectAtIndex:indexPath.row];
    appDelegate.currentNoteGuid = [obj guid];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NoteViewController *noteViewController = [[NoteViewController alloc]init];
    [self.navigationController pushViewController:noteViewController animated:YES];
    [noteViewController release];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == kNoteTableViewTag) {
        selectTableIndex = indexPath.row;
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Do you want delete this note?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes", nil];
            alert.tag = kDeleteNoteAlertTag;
            [alert show];
            [alert release];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kDeleteNoteAlertTag) {
        AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UITableView *noteTableView = (UITableView *)[self.view viewWithTag:kNoteTableViewTag];

        if (buttonIndex == 1) {
            [[ENManager sharedInstance] removeNote:[[[self.currentNoteList notes] objectAtIndex:selectTableIndex] guid]];
            
            self.currentNoteList = [[ENManager sharedInstance] noteListWithNotebookGuid:appDelegate.currentNotebookGuid];
            
            [noteTableView reloadData];
        }
    }
    else if (alertView.tag == kCreateNoteAlertTag) {
        if (buttonIndex == 1) {
            AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UIView *addNoteView = (UIView *)[appDelegate.window viewWithTag:kAddNoteViewTag];
            UIView *backView = (UIView *)[addNoteView viewWithTag:kBackViewTag];
            UIView *noteTitleView = (UIView *)[backView viewWithTag:kAddNoteTitleViewTag];
            UITextField *addNoteTextField = (UITextField *)[noteTitleView viewWithTag:kAddNoteTextFieldTag];
            UIView *addNoteContentView = (UIView *)[backView viewWithTag:kAddNoteContentViewTag];
            UITextView *addNoteTextView = (UITextView *)[addNoteContentView viewWithTag:kAddNoteTextViewTag];
            UIImageView *addPhotoImageView = (UIImageView *)[backView viewWithTag:kAddPhotoImageViewTag];
            UITextField *writerTextField = (UITextField *)[backView viewWithTag:kFooterTextFieldTag];
            UITextField *tagTextField = (UITextField *)[backView viewWithTag:kFooterTextFieldTag+1];

            NSMutableString *saveContents = [NSMutableString string];
            [saveContents setString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
            [saveContents appendString:@"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">"];
            [saveContents appendString:@"<en-note>"];
            [saveContents appendString:addNoteTextView.text];
            
            if (addPhotoImageView.image != nil) {
				UIImage *image = addPhotoImageView.image;
                NSData *imageData = UIImageJPEGRepresentation(image, 0.7);
                
                NSMutableArray *resources = [NSMutableArray array];

                EDAMData *data = [[EDAMData alloc] initWithBodyHash:[imageData md5Hash] size:[imageData length] body:imageData];
                EDAMResource *resource = [[EDAMResource alloc] init];
                [resource setData:data];
                [resource setMime:@"image/jpg"];
                [resources addObject:resource];

                [saveContents appendFormat:@"<en-media type=\"image/jpg\" hash=\"%@\"/><br/>", [imageData md5HexHash]];
                [saveContents appendString:@"</en-note>"];
                
                NSString *tagNames = @"None";
                NSString *author = @"None";
                
                if ([writerTextField.text length] != 0) {
                    author = writerTextField.text;
                }
                if ([tagTextField.text length] != 0) {
                    tagNames = tagTextField.text;
                }
                
                [[ENManager sharedInstance] createNote:appDelegate.currentNotebookGuid title:addNoteTextField.text content:saveContents resources:resources tagNames:tagNames author:author];
                
                [data release];
            }
            else {
                [saveContents appendString:@"</en-note>"];
                
                NSString *tagNames = @"None";
                NSString *author = @"None";
                
                if ([writerTextField.text length] != 0) {
                    author = writerTextField.text;
                }
                if ([tagTextField.text length] != 0) {
                    tagNames = tagTextField.text;
                }
                
                [[ENManager sharedInstance] createNote:appDelegate.currentNotebookGuid title:addNoteTextField.text content:saveContents resources:nil tagNames:tagNames author:author];
            }
            

            
            addNoteFlag = TRUE;
            
            self.currentNoteList = [[ENManager sharedInstance] noteListWithNotebookGuid:appDelegate.currentNotebookGuid];
            
            [UIView beginAnimations:nil context:nil];		
            [UIView setAnimationDuration:0.35f];
            [UIView setAnimationDidStopSelector:@selector(removeAddNoteView)];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            addNoteView.frame = CGRectMake(0, 480, 320, 460);
            [UIView commitAnimations];
        }
    }
}

- (void)createActivityView
{
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.tag = kNoteActivityViewTag;
    activityView.center = CGPointMake(160, 208);
    [self.view addSubview:activityView];
    [activityView release];
    
    [activityView startAnimating];
}

@end
