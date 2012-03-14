//
//  ViewController.m
//  LibSyncTest
//
//  Created by Andrew Camera on 13/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "LibSync.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize runButton;
@synthesize iPadRunButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


/* ATTACH FUNCTION TO RUN BUTTONS TO LAUNCH LIBRARY SYNC */
- (IBAction)runLibSync:(id)sender {
    
    NSLog(@"BUTTON PUSHED");
    LibSync *libClass = [[[LibSync alloc]init]autorelease];
    [libClass LibSyncOperation];    
}

- (IBAction)runLibSynciPhone:(id)sender {

    NSLog(@"BUTTON PUSHED");
    LibSync *libClass = [[[LibSync alloc]init]autorelease];
    [libClass LibSyncOperation];
}


- (void)viewDidUnload
{
    [self setRunButton:nil];
    [self setIPadRunButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)dealloc {
    [runButton release];
    [iPadRunButton release];
    [super dealloc];
}
@end
