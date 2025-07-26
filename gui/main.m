#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface AnyPodAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSTextField *statusLabel;
    NSTextField *musicPathField;
}
@end

@implementation AnyPodAppDelegate

- (void)createMenu {
    NSMenu *mainMenu = [[NSMenu alloc] init];

    // App menu
    NSMenuItem *appMenuItem = [[NSMenuItem alloc] init];
    [mainMenu addItem:appMenuItem];

    NSMenu *appMenu = [[NSMenu alloc] initWithTitle:@"AnyPod"];
    NSString *appName = @"AnyPod";
    NSString *quitTitle = [NSString stringWithFormat:@"Quit %@", appName];
    NSMenuItem *quitItem = [[NSMenuItem alloc]
        initWithTitle:quitTitle
               action:@selector(terminate:)
        keyEquivalent:@"q"];
    [appMenu addItem:quitItem];
    [appMenuItem setSubmenu:appMenu];

    // File menu
    NSMenuItem *fileMenuItem = [[NSMenuItem alloc] init];
    [mainMenu addItem:fileMenuItem];

    NSMenu *fileMenu = [[NSMenu alloc] initWithTitle:@"File"];
    NSMenuItem *syncItem = [[NSMenuItem alloc]
        initWithTitle:@"Sync"
               action:nil
        keyEquivalent:@"s"];
    [fileMenu addItem:syncItem];

    NSMenuItem *ejectItem = [[NSMenuItem alloc]
        initWithTitle:@"Eject"
               action:nil
        keyEquivalent:@"e"];
    [fileMenu addItem:ejectItem];

    [fileMenuItem setSubmenu:fileMenu];

    // Help menu
    NSMenuItem *helpMenuItem = [[NSMenuItem alloc] init];
    [mainMenu addItem:helpMenuItem];

    NSMenu *helpMenu = [[NSMenu alloc] initWithTitle:@"Help"];
    NSMenuItem *aboutItem = [[NSMenuItem alloc]
        initWithTitle:@"About AnyPod"
               action:nil
        keyEquivalent:@""];

    [helpMenu addItem:aboutItem];
    [helpMenuItem setSubmenu:helpMenu];

    [NSApp setMainMenu:mainMenu];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self createMenu];

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
