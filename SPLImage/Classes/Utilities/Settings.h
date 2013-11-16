//
//  Settings.h
//  EVOLEAS
//
//  Created by Columbus 2 on 2/10/12.
//  Copyright (c) 2012 EVOLEAS (formerly Sapna Solutions PVT. Ltd.) All rights reserved.
//

//#define EV_DEBUG_LOG_ON   //prints appname, filename, methodName:(Line number), Log Statement
//#define EV_NORMAL_LOG_ON  //prints a normal NSLog Statement

//Custom Log Statements
#ifdef EV_DEBUG_LOG_ON
    #define EVLog( LogString, ... ) NSLog( @"EV-Debug-Log: <%p %@ %s:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __FUNCTION__, __LINE__, [NSString stringWithFormat:(LogString), ##__VA_ARGS__] )
#elif defined EV_NORMAL_LOG_ON
    #define EVLog( LogString, ... ) NSLog(@"%@", [NSString stringWithFormat:(LogString), ##__VA_ARGS__])
#else
    #define EVLog( LogString, ... )
#endif


//remove the cluttered logging mechanism for this.
#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

//Alert Factory
#define EV_Info_Alert( AlertString, ... ) {UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:[NSString stringWithFormat:(AlertString), ##__VA_ARGS__] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];[alert show];[alert release];}

#define EV_Alert( AlertString, ... ) {UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:(AlertString), ##__VA_ARGS__] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];[alert show];[alert release];}



//Custom Helper Definitions
#define DEVICE_IS_IPHONE [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone
#define IPHONE_PORTRAIT_FRAME CGRectMake(0, 0, 320, 480)
#define IPHONE_PORTRAIT_FRAME_STATUSBAR CGRectMake(0, 0, 320, 460)
#define IPHONE_LANDSCAPE_FRAME CGRectMake(0, 0, 480, 320)
#define IPHONE_LANDSCAPE_FRAME_STATUSBAR CGRectMake(0, 0, 460, 320)

#define DEVICE_IS_IPAD [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad
#define IPAD_PORTRAIT_FRAME CGRectMake(0, 0, 768, 1024)
#define IPAD_PORTRAIT_FRAME_STATUSBAR CGRectMake(0, 0, 768, 1004)
#define IPAD_LANDSCAPE_FRAME CGRectMake(0, 0, 1024, 768)
#define IPAD_LANDSCAPE_FRAME_STATUSBAR CGRectMake(0, 0, 1004, 768)


#define EVAppStatusBarOrientation ([[UIApplication sharedApplication] statusBarOrientation])
#define EVAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define EVIsPortrait()  UIInterfaceOrientationIsPortrait(PSAppStatusBarOrientation)
#define EVIsLandscape() UIInterfaceOrientationIsLandscape(PSAppStatusBarOrientation)


// use special weak keyword
#if !defined ps_weak && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0 && !defined (PSPDF_ARC_IOS5_COMPILE)
#define ps_weak weak
#define __ps_weak __weak
#define ps_nil(x)
#elif !defined ps_weak
#define ps_weak unsafe_unretained
#define __ps_weak __unsafe_unretained
#define ps_nil(x) x = nil
#endif

/*
static void print_free_memory() {
    vm_size_t pagesize;    
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    host_page_size(host_port, &pagesize);
    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        EVLog(@"Failed to fetch vm statistics");
    }else {
//         Stats in bytes  
        natural_t mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
        natural_t mem_free = vm_stat.free_count * pagesize;
        natural_t mem_total = mem_used + mem_free;
        EVLog(@"memory used: %uMB free: %uMB total: %uMB", mem_used/(1024*1024), mem_free/(1024*1024), mem_total/(1024*1024));
    }
}
*/