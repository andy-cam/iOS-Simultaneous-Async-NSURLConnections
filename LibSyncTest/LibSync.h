//
//  LibSync.h
//  LibSyncTest
//
//  Created by Andrew Camera on 13/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LibSync : NSObject <NSURLConnectionDelegate> {
    NSArray *downloadArray;
	NSOperationQueue *operationQueue;
}

@property (nonatomic, retain) NSArray *downloadArray;
@property (nonatomic, retain) NSOperationQueue *operationQueue;

-(void) LibSyncOperation;

@end
