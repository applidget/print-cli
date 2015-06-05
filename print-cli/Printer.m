//
//  Printer.m
//  print-cli
//
//  Created by Robin Monjo on 05/06/15.
//  Copyright (c) 2015 Applidget. All rights reserved.
//

#import "Printer.h"
#import <Quartz/Quartz.h>

@implementation Printer

static NSString const* kPrinterNameKey = @"NSPrinterName";

+ (NSString *) currentPrinter {
  return   [[NSPrintInfo sharedPrintInfo].dictionary objectForKey:kPrinterNameKey];
}

+ (NSArray *) availablePrinters {
  return [NSPrinter printerNames];
}

+ (int) printPDF:(NSURL *)file onPrinter:(NSString *) printerName {
  CFURLRef fileURL = (__bridge CFURLRef)file;
  CFStringRef mimeType = (__bridge CFStringRef)@"application/pdf";
  
  NSPrintInfo *printInfo = [NSPrintInfo sharedPrintInfo];
  
  if (printerName) {
    NSPrinter *printer = [NSPrinter printerWithName:printerName];
    if (!printer) {
      NSLog(@"printer %@ not available or not found", printerName);
      return 1;
    }
    printInfo.printer = printer;
  }
  
  NSLog(@"Printing %@ on %@ printer", file, [printInfo.dictionary objectForKey:kPrinterNameKey]);
  
  printInfo.paperName = @"A4";
  
  PMPrintSettings printSettings = [printInfo PMPrintSettings];
  
  // Obtain the print session from the printInfo.
  PMPrintSession printSession = [printInfo PMPrintSession];
  PMDestinationType printDestination = 0;
  OSStatus status = noErr;
  
  // Verify that the destination is the printer.
  status = PMSessionGetDestinationType(printSession, printSettings, &printDestination);
  
  if ((status != noErr) || (printDestination != kPMDestinationPrinter)) {
    NSLog(@"Either got an error from PMSessionGetDestinationType or the print destination wasn't kPMDestinationPrinter");
    return 1;
  }
  
  // The destination printer is needed by PMPrinterPrintWithFile and related functions.
  PMPrinter currentPrinter = NULL;
  status = PMSessionGetCurrentPrinter(printSession, &currentPrinter);
  
  if (status != noErr) {
    NSLog(@"Got an error from PMSessionGetCurrentPrinter (%d)", status);
    return 1;
  }
  
  CFArrayRef mimeTypes;
  status = PMPrinterGetMimeTypes(currentPrinter, printSettings, &mimeTypes);
  if (status != noErr || mimeType == NULL) {
    NSLog(@"failed to get printer mimeTypes: %d", status);
    return 1;
  }
  
    
  CFIndex arrayCount = CFArrayGetCount(mimeTypes);
  if (!CFArrayContainsValue(mimeTypes, CFRangeMake(0, arrayCount), mimeType)) {
    NSLog(@"MIME type %@ isn't supported by the printer", (__bridge NSString *)mimeType);
    return 1;
  }
      
  // Obtain the page format from the printInfo.
  PMPageFormat pageFormat =  [printInfo PMPageFormat];
      
  status = PMPrinterPrintWithFile(currentPrinter, printSettings, pageFormat, mimeType, fileURL);
  if (status != noErr) {
    NSLog(@"PMPrinterPrintWithFile returned error %d", status);
    return 1;
  }
  return 0;
}

@end
