//
//  LibSyncOperation.m
//  LibSyncTest
//
//  Created by Andrew Camera on 13/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LibSyncOperation.h"

@implementation LibSyncOperation

@synthesize downloadURL, downloadData, downloadPath;
@synthesize downloadDone, executing, finished;

/* Function to initialize the NSOperation with the URL to download */
- (id)initWithURL:(NSString *)downloadString {
	
	if (![super init]) return nil;
    
    // Construct the URL to be downloaded
	downloadURL = [[NSURL alloc]initWithString:downloadString];
	downloadData = [[NSMutableData alloc] init];
    
    NSLog(@"downloadURL: %@",[downloadURL path]);
    
    // Create the download path
    downloadPath = [[[NSString alloc]initWithFormat:@"%@.txt",downloadString]stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	
	NSLog(@"downloadPath: %@",downloadPath);
	
	return self;
}

-(void)dealloc {
	
	[downloadData release];
	[downloadPath release];
	[downloadURL release];
	[super dealloc];
}

-(void)main {
	
	if (![self isCancelled]) {
		
		[self willChangeValueForKey:@"isExecuting"];
		executing = YES;
			
		// Create the download connection
        NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:downloadURL];
        NSLog(@"%s: downloadRequest: %@",__FUNCTION__,downloadURL);
        NSURLConnection *downloadConnection = [[NSURLConnection alloc] initWithRequest:downloadRequest delegate:self];
		
		// IMPORTANT! The next line is what keeps the NSOperation alive for the during of the NSURLConnection!
		[downloadConnection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
		[downloadConnection start]; 
        
        // Continue the download until operation is cancelled, finished or errors out
        if (downloadConnection) {
            NSLog(@"connection established!");
            do {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            } while (!downloadDone);
            [self terminateOperation];
        } else {
            NSLog(@"couldn't establish connection for: %@", downloadURL);
            
            // Cleanup Operation so next one (if any) can run
            [self terminateOperation];
        }
			}
	else { // Operation has been cancelled, clean up
		[self terminateOperation];
	}
}


#pragma mark -
#pragma mark NSURLConnection Delegate methods
// NSURLConnectionDelegate method: handle the initial connection 
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse*)response {
	NSLog(@"%s: Received response!", __FUNCTION__);
}

// NSURLConnectionDelegate method: handle data being received during connection
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[downloadData appendData:data];
	NSLog(@"downloaded %d bytes", [data length]);
}

// NSURLConnectionDelegate method: What to do once request is completed
-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"%s: Download finished! File: %@", __FUNCTION__, downloadURL);
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDir = [paths objectAtIndex:0];
	NSString *filePath = [downloadPath stringByReplacingOccurrencesOfString:@"http://" withString:@""];
	
	NSString *targetPath = [docDir stringByAppendingPathComponent:filePath];
	BOOL isDir; 
	
	// If target folder path doesn't exist, create it 
	if (![fileManager fileExistsAtPath:[targetPath stringByDeletingLastPathComponent] isDirectory:&isDir]) {
		NSError *makeDirError = nil;
		[fileManager createDirectoryAtPath:[targetPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:&makeDirError];
		if (makeDirError != nil) {
			NSLog(@"MAKE DIR ERROR: %@", [makeDirError description]);
			[self terminateOperation];
		}
	}
	
	NSError *saveError = nil;
	// Write the downloaded website homepage to the root Documents folder of the app
	[downloadData writeToFile:targetPath options:NSDataWritingAtomic error:&saveError];
	if (saveError != nil) {
		NSLog(@"Download save failed! Error: %@", [saveError description]);
		[self terminateOperation];
	}
	else {
		NSLog(@"file has been saved!: %@", targetPath);
	}
	downloadDone = true;
}

// NSURLConnectionDelegate method: Handle the connection failing 
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"%s: File download failed! Error: %@", __FUNCTION__, [error description]);
	[self terminateOperation];
}

// Function to clean up the variables and mark Operation as finished
-(void) terminateOperation {
	[self willChangeValueForKey:@"isFinished"];
	[self willChangeValueForKey:@"isExecuting"];
	finished = YES;
	executing = NO;
    downloadDone = YES;
	[self didChangeValueForKey:@"isExecuting"];
	[self didChangeValueForKey:@"isFinished"];
}


#pragma mark -
#pragma mark NSOperation state Delegate methods
// NSOperation state methods
- (BOOL)isConcurrent {
	return YES;
}

- (BOOL)isExecuting {
	return executing;
}

- (BOOL)isFinished {
	return finished;
}

@end

