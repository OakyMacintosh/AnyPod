// main.m
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface AnyPodAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSTextField *statusLabel;
    NSTextField *musicPathField;
}
@end

@implementation AnyPodAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSRect frame = NSMakeRect(0, 0, 400, 220);
    window = [[NSWindow alloc] initWithContentRect:frame
                                          styleMask:(NSTitledWindowMask |
                                                     NSClosableWindowMask |
                                                     NSResizableWindowMask)
                                            backing:NSBackingStoreBuffered
                                              defer:NO];
    [window setTitle:@"AnyPod"];

    NSView *contentView = [window contentView];

    // Label
    NSTextField *label = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 170, 100, 24)];
    [label setStringValue:@"Music Folder:"];
    [label setBezeled:NO];
    [label setDrawsBackground:NO];
    [label setEditable:NO];
    [label setSelectable:NO];
    [contentView addSubview:label];

    // Path field
    musicPathField = [[NSTextField alloc] initWithFrame:NSMakeRect(120, 170, 180, 24)];
    [contentView addSubview:musicPathField];

    // Browse button
    NSButton *browseButton = [[NSButton alloc] initWithFrame:NSMakeRect(310, 170, 70, 24)];
    [browseButton setTitle:@"Browse"];
    [browseButton setButtonType:NSMomentaryPushButton];
    [contentView addSubview:browseButton];

    // Sync button
    NSButton *syncButton = [[NSButton alloc] initWithFrame:NSMakeRect(40, 110, 120, 32)];
    [syncButton setTitle:@"Sync Music"];
    [syncButton setButtonType:NSMomentaryPushButton];
    [contentView addSubview:syncButton];

    // Eject button
    NSButton *ejectButton = [[NSButton alloc] initWithFrame:NSMakeRect(220, 110, 120, 32)];
    [ejectButton setTitle:@"Eject iPod"];
    [ejectButton setButtonType:NSMomentaryPushButton];
    [contentView addSubview:ejectButton];

    // Status
    statusLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 40, 360, 24)];
    [statusLabel setStringValue:@"Status: Idle"];
    [statusLabel setBezeled:NO];
    [statusLabel setDrawsBackground:NO];
    [statusLabel setEditable:NO];
    [statusLabel setSelectable:NO];
    [contentView addSubview:statusLabel];

    [window center];
    [window makeKeyAndOrderFront:nil];
}

@end

int main(int argc, const char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSApplication *app = [NSApplication sharedApplication];
    AnyPodAppDelegate *delegate = [[AnyPodAppDelegate alloc] init];
    [app setDelegate:delegate];
    int ret = NSApplicationMain(argc, argv);
    [pool release];
    return ret;
}
