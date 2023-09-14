//
//  AppDelegate.m
//  AppBlocker
//
//  Created by dingjie.triste on 2023/9/14.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize blacklist;

-(instancetype)init {
    self = [super init];
    if (self) {
        blacklist = @[@"com.baidu.BaiduNetdisk-mac"];
    }
    return self;
}

-(void)applicationDidFinishLaunching:(NSNotification *)notification {
    self.alertTriggered = NO;

    NSOperationQueue *notificationQueue = [[NSOperationQueue alloc] init];

    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserverForName:NSWorkspaceDidLaunchApplicationNotification
                                                                    object:nil
                                                                     queue:notificationQueue
                                                                usingBlock:^(NSNotification * _Nonnull note) {
         [self handleLaunchNote:note];
     }];
}

-(void)handleLaunchNote:(NSNotification * _Nonnull)note {

    NSRunningApplication *runningApp = [[note userInfo] objectForKey:NSWorkspaceApplicationKey];
    NSString             *bundleID   = runningApp.bundleIdentifier;
    NSString             *appName    = runningApp.localizedName;

    if (![self->blacklist containsObject:bundleID]) {
        NSLog(@"Allow \"%@\", \"%@\"", appName, bundleID);
        return;
    }

    NSLog(@"Block \"%@\", \"%@\"", appName, bundleID);

    [runningApp forceTerminate];

    if (self.alertTriggered) {
        NSLog(@"already alert, skip");
        return;
    }

    self.alertTriggered = YES;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self alertBlock:appName];
    });
}


-(void)alertBlock:(NSString *)appName {

    NSString *messageText     = NSLocalizedString(@"\"%@\" has been blocked", @"");
    NSString *informativeText = NSLocalizedString(@"Contact your administrator for more information", @"");
    NSString *buttonTitle     = NSLocalizedString(@"OK", @"");

    NSAlert *alert = [[NSAlert alloc] init];

    [alert setMessageText:[NSString stringWithFormat:messageText, appName]];
    [alert setInformativeText:informativeText];
    [alert addButtonWithTitle:buttonTitle];
    
    [alert setAlertStyle:NSAlertStyleWarning];
    [alert setIcon:[NSImage imageNamed:NSImageNameCaution]];

    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [[alert window] setLevel:NSStatusWindowLevel];

    [alert runModal];

    self.alertTriggered = NO;
}

@end
