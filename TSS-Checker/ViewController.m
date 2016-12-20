//
//  ViewController.m
//  TSS-Checker
//
//  Created by areft on 12/19/16.
//  Copyright © 2016 Mohammad Aref Tamanadar. All rights reserved.
//

#import "ViewController.h"
#import "MobileDeviceAccess.h"

@interface ViewController () <MobileDeviceAccessListener>

@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self checkPaths];
    //[self PrepareApp];
    self.title = @"TSS-Checker by @arefttt";
    self.getLatestVersion.state = 0;
}
- (IBAction)get_saveSHSH:(id)sender {
    [self PrepareApp];
}
- (IBAction)ClearApp:(id)sender {
    
}

-(void)checkPaths {
    NSFileManager* fileManager = [[NSFileManager alloc] init];
    NSString* bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSArray* urlPaths = [fileManager URLsForDirectory:NSApplicationSupportDirectory
                                            inDomains:NSUserDomainMask];
    
    NSURL* appDirectory = [[urlPaths objectAtIndex:0] URLByAppendingPathComponent:bundleID isDirectory:YES];
    
    //TODO: handle the error
    if (![fileManager fileExistsAtPath:[appDirectory path]]) {
        [fileManager createDirectoryAtURL:appDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
-(void) displayWithMessage:(NSString *)message {
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setAlertStyle:NSInformationalAlertStyle];
    [alert setMessageText:@"Gesture Notification"];
    [alert setInformativeText:message];
    [alert runModal];
}

-(void) PrepareApp{
    NSString *ecidString = self.ecidTextField.stringValue;
    NSString *deviceIdentString = self.DeviceIdent.stringValue;
    
    
    if (ecidString.length<10) {
        [self displayWithMessage:@"ECID field cant be Empty!"];
    }
    if (deviceIdentString.length<3) {
        if (![deviceIdentString containsString:@"iPhone"] || ![deviceIdentString containsString:@"iPad"]|| ![deviceIdentString containsString:@"iPod"]) {
            [self displayWithMessage:@"you should specify a device Identifier , for example : \n iPhone 6 plus identifier = iPhone7,1 \n click on ? button for getting more info!"];
            
        }
        
    }
    
    if (!(ecidString.length<10) && !(deviceIdentString.length<3)) {
        [self GetSHSH];

    }
    
}

-(void)GetSHSH{

    NSString *ecidString = self.ecidTextField.stringValue;
    NSString *deviceIdentString = self.DeviceIdent.stringValue;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString *appPath = [[NSBundle mainBundle] bundlePath];
    NSString *scriptPath = [appPath stringByAppendingPathComponent:@"Contents/Resources/tsschecker_macos"];
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath:scriptPath];

    
    
    [task setArguments:@[ @"-d", deviceIdentString,@"-l" , @"-e" ,ecidString, @"--save-path", path, @"-s" ]];
    
    
    if ([self.getLatestVersion state]==NSOnState) {
        [task setArguments:@[ @"-d", deviceIdentString,@"-l" , @"-e" ,ecidString, @"--save-path", path, @"-s" ]];
    }
    else if([self.getLatestVersion state]==NSOffState){
        [task setArguments:@[ @"-d", deviceIdentString,@"-i", @"10.1.1" , @"-e" ,ecidString, @"--save-path", path, @"-s" ]];
    }
    else if([self.getLatestVersion state]==NSMixedState){
        NSLog(@"OFF-MixedChecked");
    }
    
    
    NSLog(@"%@",path);
    
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    NSPipe *input = [NSPipe pipe];
    [task setStandardOutput: pipe];
    [task setStandardInput: input];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    [task launch];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    
    NSLog (@"script returned:\n%@", string);
    [self.logView setString:string];
    if ([self.logView.string containsString:@"Saved shsh blobs!"]) {
        [[NSWorkspace sharedWorkspace]openFile:path withApplication:@"Finder"];
    }
}
- (IBAction)CheckON_OFF:(id)sender {
    NSLog(@"state %ld", (long)[sender state]);
    if ([sender state]==1) {
        NSLog(@"ON-Checked");
        _versionLabel.alphaValue = 0;
        _versionField.alphaValue = 0;
        _versionLabel2.stringValue = @"";
    }
    else if([sender state]==0){
        NSLog(@"OFF-UnChecked");
        _versionLabel.alphaValue=1;
        _versionField.alphaValue = 1;
        _versionLabel2.stringValue = @"eg : 7.1.2 , 10.1.1 , 10.2";
    }
}
- (IBAction)openDevicesList:(id)sender {
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"https://www.theiphonewiki.com/wiki/Models"]];

}




@end
