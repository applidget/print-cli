//
//  main.m
//  print-cli
//
//  Created by Robin Monjo on 05/06/15.
//  Copyright (c) 2015 Applidget. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Printer.h"

int main(int argc, const char * argv[]) {

  @autoreleasepool {
    
    if (argc == 1) {
      NSLog(@"Usage: printer-cli /path/to/file [\"printer name\"]");
      NSLog(@"Current printer: %@", [Printer currentPrinter]);
      NSLog(@"Available printers:");
      NSArray *printers = [Printer availablePrinters];
      for (NSString *name in printers) {
        NSLog(@"%@", name);
      }
      return 0;
    }
    
    NSString *path = [NSString stringWithUTF8String:argv[1]];
    NSString *printer = nil;
    if (argc >= 3) {
      printer = [NSString stringWithUTF8String:argv[2]];
    }
    
    return [Printer printPDF:[NSURL fileURLWithPath:path] onPrinter:printer];
  }
}
