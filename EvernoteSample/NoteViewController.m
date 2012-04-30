//
//  NoteViewController.m
//  EvernoteSample
//
//  Created by Moon Jiyoun on 12. 3. 14..
//  Copyright (c) 2012년 Greenmonster, Inc. All rights reserved.
//

#import "NoteViewController.h"
#import "AppDelegate.h"
#import "Global.h"

@implementation NoteViewController
@synthesize currentNote;
@synthesize picker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.currentNote = [[ENManager sharedInstance] noteWithNoteGuid:appDelegate.currentNoteGuid];
    textFieldFlag = FALSE;
    
    [self initPickerView];
    [self createView];
    [self createContentView];
}

- (void)initPickerView
{
    UIImagePickerController *_picker = [[UIImagePickerController alloc] init];
    self.picker = _picker;
    [_picker release];
}

- (void)createContentView
{
    UIView *contentView = [[UIView alloc]init];
    contentView.tag = kContentViewTag;
    contentView.frame = CGRectMake(0, 0, 320, 416);
    [self.view addSubview:contentView];
    [contentView release];
    
    UIImageView *noteTitleBgImageView = [[UIImageView alloc]init];
    noteTitleBgImageView.frame = CGRectMake(0, 0, 320, 50);
    noteTitleBgImageView.image = [UIImage imageNamed:@"titleLabelBg.png"];
    [contentView addSubview:noteTitleBgImageView];
    [noteTitleBgImageView release];
    
    UITextField *noteTitleTextField = [[UITextField alloc]init];
    noteTitleTextField.tag = kNoteTitleTextFieldTag;
    noteTitleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    noteTitleTextField.frame = CGRectMake(25, 5, 240, 40);
    noteTitleTextField.text = [self.currentNote title];
    [contentView addSubview:noteTitleTextField];
    [noteTitleTextField release];
    
    UIButton *photoButton = [[UIButton alloc]init];
    photoButton.frame = CGRectMake(270, 5, 40, 40);
    [photoButton setImage:[UIImage imageNamed:@"cameraBtn_n.png"] forState:UIControlStateNormal];
    [photoButton setImage:[UIImage imageNamed:@"cameraBtn_s.png"] forState:UIControlStateHighlighted];
    [photoButton addTarget:self action:@selector(photoButtonEvent) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:photoButton];
    [photoButton release];
    
    UIImageView *photoImageView = [[UIImageView alloc]init];
    photoImageView.tag = kPhotoImageViewTag;
    photoImageView.image = [UIImage imageNamed:@"thumbnail_dummy.png"];
    photoImageView.frame = CGRectMake(10, 300, 100, 100);
    [contentView addSubview:photoImageView];
    [photoImageView release];
    
    UIImageView *photoMaskImageView = [[UIImageView alloc]init];
    photoMaskImageView.frame = CGRectMake(10, 300, 100, 100);
    photoMaskImageView.image = [UIImage imageNamed:@"thumbnailMask.png"];
    [contentView addSubview:photoMaskImageView];
    [photoMaskImageView release];
    
    NSString *contentString = [self.currentNote content];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<p>" withString:@"\n"];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<en-note><div><span>Freedom of assembly</span>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<div><br clear=\"none\"/></div>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<en-media type=\"application/octet-stream\" hash=\"%@\"/><br/>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"</div></en-note>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<span>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<en-note><div>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<div>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"</div>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"<en-note>" withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"</en-note>" withString:@""];    
    contentString = [contentString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Resource
    if ([[self.currentNote resources] count] != 0) {
        id obj = [[self.currentNote resources] objectAtIndex:0];
        
        if ([[obj mime] isEqualToString:@"image/jpg"]) {
            contentString = [contentString substringToIndex:[contentString length]-73];
            id obj2 = [[[self.currentNote resources] objectAtIndex:0] data];
            photoImageView.image = [UIImage imageWithData:[obj2 body]];
        }
    }

    UITextView *noteContentTextView = [[UITextView alloc]init];
    noteContentTextView.frame = CGRectMake(0, 50, 320, 245);
    noteContentTextView.tag = kNoteContentTextViewTag;
    noteContentTextView.delegate = self;
    noteContentTextView.showsVerticalScrollIndicator = NO;
    noteContentTextView.backgroundColor = [UIColor clearColor];
    noteContentTextView.textColor = [UIColor blackColor];
    noteContentTextView.font = [UIFont systemFontOfSize:14.0f];
    noteContentTextView.text = contentString;
    [contentView addSubview:noteContentTextView];
    [noteContentTextView release];
    
    NSArray *footerLabelArray = [NSArray arrayWithObjects:@"Writer", @"Tag", nil];
    
    for (int i=0; i<2; i++) {
        UILabel *footerLabel = [[UILabel alloc]init];
        footerLabel.text = [footerLabelArray objectAtIndex:i];
        footerLabel.frame = CGRectMake(130, 305+i*55, 180, 15);
        footerLabel.textColor = [UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:1.0f];
        footerLabel.font = [UIFont systemFontOfSize:12.0f];
        [contentView addSubview:footerLabel];
        [footerLabel release];
        
        UITextField *footerTextField = [[UITextField alloc]init];
        footerTextField.tag = kFooterTextFieldTag + i;
        footerTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        footerTextField.frame = CGRectMake(130, 325+i*55, 180, 20);
        footerTextField.font = [UIFont systemFontOfSize:16.0f];
        footerTextField.delegate = self;
        footerTextField.text = @"None";
        [contentView addSubview:footerTextField];
        [footerTextField release];
    }
    
    // Author
    if ([[self.currentNote attributes] author] != nil) {
        UITextField *footerTextField1 = (UITextField *)[contentView viewWithTag:kFooterTextFieldTag];
        footerTextField1.text = [[self.currentNote attributes] author];
    }
    
    // Tag
    if (![[[ENManager sharedInstance] getNoteTag:[self.currentNote guid]] isEqualToString:@"None"]) {
        UITextField *footerTextField2 = (UITextField *)[contentView viewWithTag:kFooterTextFieldTag+1];
        footerTextField2.text = [[ENManager sharedInstance] getNoteTag:[self.currentNote guid]];
    }
}

- (void)photoButtonEvent
{    
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.allowsEditing = YES;
    self.picker.delegate = self;
    
    [self presentModalViewController:self.picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)info {
    UIView *contentView = (UIView *)[self.view viewWithTag:kContentViewTag];
    UIImageView *photoImageView = (UIImageView *)[contentView viewWithTag:kPhotoImageViewTag];
    
    photoImageView.image = img;
    
    [self.picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [self.picker dismissModalViewControllerAnimated:YES];    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{   
    UIView *contentView = (UIView *)[self.view viewWithTag:kContentViewTag];
    
    if (textField.tag == kFooterTextFieldTag) {
        textFieldFlag = TRUE;
        [UIView beginAnimations:nil context:nil];		
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        contentView.frame = CGRectMake(0, -215, 320, 416);
        [UIView commitAnimations]; 
    }
    else if (textField.tag == kFooterTextFieldTag+1) {
        textFieldFlag = TRUE;
        [UIView beginAnimations:nil context:nil];		
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        contentView.frame = CGRectMake(0, -215, 320, 416);
        [UIView commitAnimations]; 
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UIView *contentView = (UIView *)[self.view viewWithTag:kContentViewTag];
    
    if (textField.tag == kFooterTextFieldTag) {
        if (!textFieldFlag) {
            [UIView beginAnimations:nil context:nil];		
            [UIView setAnimationDuration:0.25f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            contentView.frame = CGRectMake(0, 0, 320, 416);
            [UIView commitAnimations]; 
        }
    }
    else if (textField.tag == kFooterTextFieldTag+1) {
        if (!textFieldFlag) {
            [UIView beginAnimations:nil context:nil];		
            [UIView setAnimationDuration:0.25f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            contentView.frame = CGRectMake(0, 0, 320, 416);
            [UIView commitAnimations]; 
        } 
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIView *contentView = (UIView *)[self.view viewWithTag:kContentViewTag];
    
    if (textView.tag == kNoteContentTextViewTag) {
        textFieldFlag = FALSE;

        [UIView beginAnimations:nil context:nil];		
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        textView.frame = CGRectMake(0, 50, 320, 245-95);
        contentView.frame = CGRectMake(0, 0, 320, 416);
        [UIView commitAnimations];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag == kNoteContentTextViewTag) {
        [UIView beginAnimations:nil context:nil];		
        [UIView setAnimationDuration:0.25f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        textView.frame = CGRectMake(0, 50, 320, 245);
        [UIView commitAnimations];
    }
}

- (void)tapGestureEvent
{
    UIView *contentView = (UIView *)[self.view viewWithTag:kContentViewTag];
    UITextView *noteContentTextView = (UITextView *)[contentView viewWithTag:kNoteContentTextViewTag];
    UITextField *noteTitleTextField = (UITextField *)[contentView viewWithTag:kNoteTitleTextFieldTag];
    UITextField *writerTextField = (UITextField *)[contentView viewWithTag:kFooterTextFieldTag];
    UITextField *tagTextField = (UITextField *)[contentView viewWithTag:kFooterTextFieldTag+1];
    
    [UIView beginAnimations:nil context:nil];		
    [UIView setAnimationDuration:0.25f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    contentView.frame = CGRectMake(0, 0, 320, 416);
    [UIView commitAnimations]; 
    
    [noteContentTextView resignFirstResponder];
    [noteTitleTextField resignFirstResponder];
    [writerTextField resignFirstResponder];
    [tagTextField resignFirstResponder];
}


- (void)createView
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = [self.currentNote title];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.9f];
    titleLabel.shadowOffset = CGSizeMake(0, -1);
    titleLabel.shadowColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.3f];
    [titleLabel sizeToFit];
    titleLabel.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = titleLabel;
    [titleLabel release];
    
    UIBarButtonItem *updateButton = [[UIBarButtonItem alloc]initWithTitle:@"Update" style:UIBarButtonItemStyleBordered target:self action:@selector(updateButtonEvent)];
	self.navigationItem.rightBarButtonItem = updateButton;
    [updateButton release];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureEvent)];
    tapGesture.delegate = self;
    [tapGesture setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate  *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    UIView *contentView = (UIView *)[self.view viewWithTag:kContentViewTag];
    UITextView *noteContentTextView = (UITextView *)[contentView viewWithTag:kNoteContentTextViewTag];
    UITextField *noteTitleTextField = (UITextField *)[contentView viewWithTag:kNoteTitleTextFieldTag];
    UITextField *writerTextField = (UITextField *)[contentView viewWithTag:kFooterTextFieldTag];
    UITextField *tagTextField = (UITextField *)[contentView viewWithTag:kFooterTextFieldTag+1];
    UIImageView *photoImageView = (UIImageView *)[contentView viewWithTag:kPhotoImageViewTag];

    if (alertView.tag == kUpdateAlertTag) {
        if (buttonIndex == 1) {
            
            NSMutableString *saveContents = [NSMutableString string];
            [saveContents setString:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
            [saveContents appendString:@"<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\">"];
            [saveContents appendString:@"<en-note>"];
            [saveContents appendString:noteContentTextView.text];
            
            if (photoImageView.image != nil) {
				UIImage *image = photoImageView.image;
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

                [[ENManager sharedInstance] updateNote:[self.currentNote guid] title:noteTitleTextField.text content:saveContents resource:resources tagNames:tagNames author:author];

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
                
                [[ENManager sharedInstance] updateNote:[self.currentNote guid] title:noteTitleTextField.text content:saveContents resource:nil tagNames:tagNames author:author];
            }

            
            appDelegate.updateNoteFlag = TRUE;
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)updateButtonEvent
{
    UIAlertView *updateAlert = [[UIAlertView alloc]initWithTitle:@"Update this note?" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes", nil];
    updateAlert.tag = kUpdateAlertTag;
    [updateAlert show];
    [updateAlert release];
}


@end
