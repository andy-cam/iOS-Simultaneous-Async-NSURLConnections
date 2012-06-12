//
//  LibSyncOperation.h
//  LibSyncTest
//
//  Created by Andrew Camera on 13/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibSyncOperation : NSOperation <NSURLConnectionDelegate>

// Object properties
@property (nonatomic, retain) NSString *downloadPath;
@property (nonatomic, retain) NSURL *downloadURL;
@property (nonatomic, retain) NSMutableData *downloadData;


// NSOperation state properties
@property BOOL downloadDone;
@property BOOL executing;
@property BOOL finished;

// Method prototypes
-(id)initWithURL:(NSString *)downloadString;
-(void) terminateOperation;

@end

