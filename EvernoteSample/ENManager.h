//
//  LoginViewController.m
//  EvernoteSample
//
//  Created by Moon Jiyoun on 12. 3. 14..
//  Copyright (c) 2012년 Greenmonster, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "THTTPClient.h"
#import "TBinaryProtocol.h"
#import "UserStore.h"
#import "NoteStore.h"
#import "NSData+MD5.h"

#define EVERNOTE_USER_STORE_URI			@"https://www.evernote.com/edam/user"
#define EVERNOTE_NOTE_STORE_BASE_URI	@"http://www.evernote.com/edam/note/"

#define EVERNOTE_API_COSUMER_KEY		@"xxxxxxxxxxxxxxxx"
#define EVERNOTE_API_COSUMER_SECRET		@"xxxxxxxxxxxxxxxx"

@interface ENManager : NSObject {
    NSString					*username;
    NSString					*password;

	// don't access following instances without accessor
	EDAMAuthenticationResult	*_auth;
	EDAMNoteStoreClient			*_noteStoreClient;
    
    NSInteger userId;
    NSString *name;

}

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

@property (nonatomic, readonly) EDAMAuthenticationResult *auth;
@property (nonatomic, readonly) EDAMNoteStoreClient *noteStoreClient;

#pragma mark - Class method

+ (ENManager*)sharedInstance;

#pragma mark - Important accessor

- (EDAMAuthenticationResult*)auth;
- (EDAMNoteStoreClient*)noteStoreClient;

#pragma mark - Instance method

- (void)releaseAuthorization;

#pragma mark - Fetch note and notebook

- (NSArray*)notebooks;
- (EDAMNoteList*)noteListWithNotebookGuid:(EDAMGuid)guid;
- (EDAMNote*)noteWithNoteGuid:(EDAMGuid)guid;

#pragma mark - Update note and notebook

- (EDAMNote*)updateNote:(EDAMGuid)noteGuid title:(NSString*)title content:(NSString*)content resource:(NSArray *)resource tagNames:(NSString *)tagNames author:(NSString *)author;

#pragma mark - Create note and notebook

- (EDAMNotebook*)createNewNotebookWithTitle:(NSString*)title;
- (EDAMNote*)createNote:(EDAMGuid)notebookGuid title:(NSString*)title content:(NSString*)content resources:(NSArray*)resources tagNames:(NSString *)tagNames author:(NSString *)author;

#pragma mark - Tag

- (NSString*)getNoteTag:(EDAMGuid)tagGuid;

#pragma mark - Remove(expunge) note

- (int)removeNote:(EDAMGuid)noteGuid;
- (int)removeNotebook:(EDAMGuid)notebookGuid;

@end
