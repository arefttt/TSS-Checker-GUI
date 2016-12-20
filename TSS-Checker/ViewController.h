//
//  ViewController.h
//  TSS-Checker
//
//  Created by areft on 12/19/16.
//  Copyright © 2016 Mohammad Aref Tamanadar. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DragView.h"

@interface ViewController : NSViewController 
@property (weak) IBOutlet NSTextField *ecidTextField;
@property (weak) IBOutlet NSTextField *DeviceIdent;
@property (weak) IBOutlet NSTextView *logView;
@property (weak) IBOutlet NSButton *openDeviceList;

@property (weak) IBOutlet NSButton *getLatestVersion;
@property (weak) IBOutlet NSTextField *versionLabel;
@property (weak) IBOutlet NSTextField *versionField;
@property (weak) IBOutlet NSTextFieldCell *versionLabel2;


@end

