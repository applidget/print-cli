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
  NSString* url = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
  NSLog(@"%@", url);
  
  //TODO:
  // 1: decode the url to get the pdf file url
  // 2: download the pdf to a temporary file
  // 3: use Printer class code to print the pdf
  // 4: delete the PDF
  // 5: exit the app
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [NSApp terminate:self];
  });
  
}


@end
