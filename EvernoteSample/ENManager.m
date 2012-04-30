//
//  LoginViewController.m
//  EvernoteSample
//
//  Created by Moon Jiyoun on 12. 3. 14..
//  Copyright (c) 2012년 Greenmonster, Inc. All rights reserved.
//


#import "ENManager.h"
#import "AppDelegate.h"


static ENManager *sharedManager;

@implementation ENManager

@synthesize auth, noteStoreClient;

@synthesize username, password;

#pragma mark - Class method

+ (ENManager*)sharedInstance {
	if (sharedManager == nil) {
		sharedManager = [[ENManager alloc] init];
	}
	return sharedManager;
}

#pragma mark - Important accessor

- (EDAMAuthenticationResult*)auth {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
	if (_auth == nil) {
		@try {
			THTTPClient *userStoreHttpClient = [[[THTTPClient alloc] initWithURL:[NSURL URLWithString:EVERNOTE_USER_STORE_URI]] autorelease];
			TBinaryProtocol *userStoreProtocol = [[[TBinaryProtocol alloc] initWithTransport:userStoreHttpClient] autorelease];
			EDAMUserStoreClient *userStore = [[[EDAMUserStoreClient alloc] initWithProtocol:userStoreProtocol] autorelease];
			
			EDAMAuthenticationResult* authResult = [userStore authenticate:appDelegate.userName :appDelegate.passWord :EVERNOTE_API_COSUMER_KEY :EVERNOTE_API_COSUMER_SECRET];
			
			NSLog(@"Authentication was successful for: %@", [[authResult user] username]);
			NSLog(@"Authentication token: %@", [authResult authenticationToken]);
			
			if ([userStore checkVersion:@"Cocoa EDAMTest" :[EDAMUserStoreConstants EDAM_VERSION_MAJOR] :[EDAMUserStoreConstants EDAM_VERSION_MINOR]]) {
				[_auth release];
				_auth = [authResult retain];
			}
            
            appDelegate.loginSuccessFlag = TRUE; // 로그인 성공
		}
		@catch (EDAMUserException *exception) {
			NSLog(@"main: Caught %d: %@", [exception errorCode], [exception reason]);
			[self releaseAuthorization];
            
            appDelegate.loginSuccessFlag = FALSE; // 로그인 실패
			return nil;
		}
		@finally {
		}
	}
	return _auth;
}

- (EDAMNoteStoreClient*)noteStoreClient {
	if (_noteStoreClient == nil) {
		if (self.auth) {
			@try {
				NSString *noteStoreUriBase = [[[NSString alloc] initWithString:EVERNOTE_NOTE_STORE_BASE_URI] autorelease];
				NSURL *noteStoreUri =  [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", noteStoreUriBase, [[self.auth user] shardId]] ]autorelease];
				THTTPClient *noteStoreHttpClient = [[[THTTPClient alloc] initWithURL:noteStoreUri] autorelease];
				TBinaryProtocol *noteStoreProtocol = [[[TBinaryProtocol alloc] initWithTransport:noteStoreHttpClient] autorelease];
				EDAMNoteStoreClient *noteStore = [[[EDAMNoteStoreClient alloc] initWithProtocol:noteStoreProtocol] autorelease];
				
				if (noteStore) {
					[_noteStoreClient release];
					_noteStoreClient = [noteStore retain];
				}
			}
            @catch (EDAMUserException *exception) {
                NSLog(@"main: Caught %d: %@", [exception errorCode], [exception reason]);
				[self releaseAuthorization];
				return nil;
			}
			@finally {
			}
		}
	}
	return _noteStoreClient;
}

#pragma mark - Instance method

- (void)releaseAuthorization {
	[_auth release];
	_auth = nil;
	[_noteStoreClient release];
	_noteStoreClient = nil;
}

#pragma mark - Fetch note and notebook

- (NSArray*)notebooks {
	if (self.noteStoreClient) {
		@try {
			NSArray *notebooks = [self.noteStoreClient listNotebooks:[self.auth authenticationToken]];
			return [NSArray arrayWithArray:notebooks];
		}
		@catch (EDAMUserException *exception) {
			NSLog(@"main: Caught %d: %@", [exception errorCode], [exception reason]);
			[self releaseAuthorization];
			return nil;
		}
		@finally {
		}
	}
	return [NSArray array];
}

-  (EDAMNoteList*)noteListWithNotebookGuid:(EDAMGuid)guid {
	EDAMNoteFilter *filter = [[[EDAMNoteFilter alloc] initWithOrder:NoteSortOrder_CREATED ascending:FALSE words:nil notebookGuid:guid tagGuids:nil timeZone:nil inactive:NO] autorelease];	
    
	if (self.noteStoreClient) {
		@try {
			return [self.noteStoreClient findNotes:[self.auth authenticationToken] :filter :0 :[EDAMLimitsConstants EDAM_USER_NOTES_MAX]];
		}
		@catch (EDAMUserException *exception) {
			NSLog(@"main: Caught %d: %@", [exception errorCode], [exception reason]);
			[self releaseAuthorization];
			return nil;
		}
		@finally {
		}
	}
	return nil;
}

- (EDAMNote*)noteWithNoteGuid:(EDAMGuid)guid {
	if (self.noteStoreClient) {
		@try {
			return [self.noteStoreClient getNote:[self.auth authenticationToken] :guid :YES :YES :YES :YES];
		}
		@catch (EDAMUserException *exception) {
			NSLog(@"main: Caught %d: %@", [exception errorCode], [exception reason]);
			[self releaseAuthorization];
			return nil;
		}
		@finally {
		}
	}
	return nil;
}

#pragma mark - Update note and notebook


- (EDAMNote*)updateNote:(EDAMGuid)noteGuid title:(NSString*)title content:(NSString*)content resource:(NSArray *)resource tagNames:(NSString *)tagNames author:(NSString *)author
{
	EDAMNote *createdNewNote = nil;
	if (self.noteStoreClient) {
		@try {
            EDAMNoteAttributes *newNoteAttributes = [[EDAMNoteAttributes alloc]init];
            [newNoteAttributes setAuthor:author];

			EDAMNote *newNote = [[EDAMNote alloc] init];
			[newNote setGuid:noteGuid];
			[newNote setTitle:title];
			[newNote setContent:content];
            [newNote setResources:resource];
            [newNote setTagNames:[NSArray arrayWithObjects:tagNames, nil]];
            [newNote setAttributes:newNoteAttributes];
            [newNote setUpdated:(long long)[[NSDate date] timeIntervalSince1970] * 1000];
			createdNewNote = [self.noteStoreClient updateNote:[self.auth authenticationToken] :newNote];
            [newNoteAttributes release];
			[newNote release];
		}
		@catch (EDAMUserException *exception) {
			NSLog(@"main: Caught %d: %@", [exception errorCode], [exception reason]);
			[self releaseAuthorization];
			return nil;
		}
		@finally {
			if (createdNewNote)
				return createdNewNote;
		}
	}
	return nil;
}

#pragma mark - Create note and notebook

- (EDAMNotebook*)createNewNotebookWithTitle:(NSString*)title {
	EDAMNotebook *createdNewNotebook = nil;
	if (self.noteStoreClient) {
		@try {
			EDAMNotebook *newNotebook = [[EDAMNotebook alloc] init];
			[newNotebook setName:title];
			createdNewNotebook = [self.noteStoreClient createNotebook:[self.auth authenticationToken] :newNotebook];
			[newNotebook release];
		}
		@catch (EDAMUserException *exception) {
			NSLog(@"main: Caught %d: %@", [exception errorCode], [exception reason]);
			[self releaseAuthorization];
			return nil;
		}
		@finally {
			if (createdNewNotebook)
				return createdNewNotebook;
		}
	}
	return nil;
}

- (EDAMNote*)createNote:(EDAMGuid)notebookGuid title:(NSString*)title content:(NSString*)content resources:(NSArray*)resources tagNames:(NSString *)tagNames author:(NSString *)author {
	EDAMNote *createdNewNote = nil;
	if (self.noteStoreClient) {
		@try {
            EDAMNoteAttributes *newNoteAttributes = [[EDAMNoteAttributes alloc]init];
            [newNoteAttributes setAuthor:author];
            
			EDAMNote *newNote = [[EDAMNote alloc] init];
			[newNote setNotebookGuid:notebookGuid];
			[newNote setTitle:title];
			[newNote setContent:content];
            [newNote setTagNames:[NSArray arrayWithObjects:tagNames, nil]];
            [newNote setAttributes:newNoteAttributes];
			[newNote setCreated:(long long)[[NSDate date] timeIntervalSince1970] * 1000];
			[newNote setResources:resources];
			createdNewNote = [self.noteStoreClient createNote:[self.auth authenticationToken] :newNote];
            [newNoteAttributes release];
			[newNote release];
        }
		@catch (EDAMUserException *exception) {
			NSLog(@"main: Caught %d: %@", [exception errorCode], [exception reason]);
			[self releaseAuthorization];
			return nil;
		}
		@finally {
			if (createdNewNote)
				return createdNewNote;
		}
	}
	return nil;
}

#pragma mark - Tag

- (NSString*)getNoteTag:(EDAMGuid)tagGuid
{
    NSArray *edamTag = nil;
    NSString *tag = nil;
    edamTag = [self.noteStoreClient getNoteTagNames:[self.auth authenticationToken] :tagGuid];
    
    if ([edamTag count] == 0) {
        tag = @"None";
    }
    else {
        tag = [NSString stringWithFormat:@"%@", [edamTag objectAtIndex:0]];
    }
    
    return tag;
}

#pragma mark - Remove(expunge) note, but not supported?

// currently not supported to remove notes with API....?

- (int)removeNote:(EDAMGuid)noteGuid {
	int result = 0;
	if (self.noteStoreClient) {
		@try {
			result = [self.noteStoreClient deleteNote:[self.auth authenticationToken] :noteGuid];
		}
		@catch (EDAMUserException *exception) {
			NSLog(@"main: Caught %d: %@", [exception errorCode], [exception reason]);
			[self releaseAuthorization];
			return result;
		}
		@finally {
			return result;
		}
	}
	return result;
}

- (int)removeNotebook:(EDAMGuid)notebookGuid
{
    int result = 0;
	if (self.noteStoreClient) {
		@try {
            result = [self.noteStoreClient expungeNotebook:[self.auth authenticationToken] :notebookGuid];
		}
		@catch (EDAMUserException *exception) {
			NSLog(@"main: Caught %d: %@", [exception errorCode], [exception reason]);
			[self releaseAuthorization];
			return result;
		}
		@finally {
			return result;
		}
	}
	return result;
}

#pragma mark - Override

- (id)retain {
	// for singleton design pattern
	return self;
}


- (void)dealloc {
    [password release];
	[username release];
	[_auth release];
	[_noteStoreClient release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseAuthorization) name:UIApplicationWillResignActiveNotification  object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseAuthorization) name:UIApplicationDidEnterBackgroundNotification  object:nil];
    }
    return self;
}

@end
