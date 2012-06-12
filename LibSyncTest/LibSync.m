//
//  LibSync.m
//  LibSyncTest
//
//  Created by Andrew Camera on 13/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LibSync.h"
#import "LibSyncOperation.h"
@implementation LibSync 

@synthesize downloadArray, operationQueue;

-(void) LibSyncOperation {
    NSLog(@"function launched!");
    
    // Initialize download list. Download the homepage of each website
    downloadArray = [[NSArray alloc] initWithObjects:@"http://www.google.com",@"http://www.stackoverflow.com",@"http://www.reddit.com",@"http://www.facebook.com", nil];
    
    operationQueue = [[[NSOperationQueue alloc]init]autorelease];
    [operationQueue setMaxConcurrentOperationCount:1]; // Can set this as needed
    
	// Create an NSOperation for each site to be downloaded and add it to the queue
    for (int i = 0; i < [downloadArray count]; i++) {
        LibSyncOperation *libSyncOperation = [[[LibSyncOperation alloc] initWithURL:[downloadArray objectAtIndex:i]]autorelease];
        [operationQueue addOperation:libSyncOperation];
    }
    
}


@end
