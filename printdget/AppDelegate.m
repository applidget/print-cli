//
//  AppDelegate.m
//  printdget
//
//  Created by Robin Monjo on 25/01/16.
//  Copyright © 2016 Applidget. All rights reserved.
//

#import "AppDelegate.h"
#import "Printer.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
  [[NSAppleEventManager sharedAppleEventManager] setEventHandler:self andSelector:@selector(handleURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

- (void)handleURLEvent:(NSAppleEventDescriptor*)event withReplyEvent:(NSAppleEventDescriptor*)replyEvent {
  NSString* urlString = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
  urlString = [[urlString stringByReplacingOccurrencesOfString:@"printget::/" withString:@""] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSLog(@"urlString === > %@", urlString);
  
  NSURL *url = [NSURL URLWithString:urlString];
  NSData *urlData = [NSData dataWithContentsOfURL:url];
  NSString *filePath = nil;
  if (urlData) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"printget.pdf"];
    [urlData writeToFile:filePath atomically:YES];
    NSLog(@"filePath ===> %@", filePath);
  } else {
    NSLog(@"NO URL DATA");
    [NSApp terminate:self];
  }
  
  [Printer printPDF:[NSURL URLWithString:filePath] onPrinter:[Printer currentPrinter]];
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSError *error = nil;
  [fileManager removeItemAtPath:filePath error:&error];
  if (error) {
    NSLog(@"Unresolved error while deleting file: %@", [error description])
  }
  
  [NSApp terminate:self];
  
}


@end
