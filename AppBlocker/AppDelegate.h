//
//  AppDelegate.h
//  AppBlocker
//
//  Created by dingjie.triste on 2023/9/14.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate : NSObject <NSApplicationDelegate, NSAlertDelegate>
@property BOOL alertTriggered;
@property NSArray*blacklist;
@end

NS_ASSUME_NONNULL_END
