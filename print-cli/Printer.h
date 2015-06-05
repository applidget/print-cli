//
//  Printer.h
//  print-cli
//
//  Created by Robin Monjo on 05/06/15.
//  Copyright (c) 2015 Applidget. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Printer : NSObject

#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

+ (NSString *) currentPrinter;
+ (NSArray *) availablePrinters;
+ (int) printPDF:(NSURL *)file onPrinter:(NSString *) printerName;

@end
