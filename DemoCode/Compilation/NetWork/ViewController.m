//
//  ViewController.m
//  NetWork
//
//  Created by Jeremy on 2019/12/18.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import <unistd.h>
#import <arpa/inet.h>
#import <resolv.h>
#import <netdb.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test1];
    [self test2];
    [self test3];
}

- (void)test1 {
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    char * ptr, **pptr;
    struct hostent *hptr;
    char str[32];
    ptr = "www.meitu.com";
    NSMutableArray * ips = [NSMutableArray array];
    if ((hptr = gethostbyname(ptr)) == NULL) {
        return;
    }
    for (pptr = hptr->h_addr_list; *pptr!=NULL; pptr++) {
        NSString * ipstr = [NSString stringWithCString:inet_ntop(hptr->h_addrtype, *pptr, str, sizeof(str)) encoding:NSUTF8StringEncoding];
        [ips addObject:ipstr?:@""];
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"22222 === ip  === %@ ==== time cost: %0.3fs", ips, end - start);
}

- (void)test2 {
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    unsigned char auResult[512];
    int nByteRead = 0;
    nByteRead = res_query("www.meitu.com", ns_c_in, ns_t_a, auResult, sizeof(auResult));
    
    ns_msg handle;
    ns_initparse(auResult, nByteRead, &handle);
    
    NSMutableArray *iplist = nil;
    int msg_count = ns_msg_count(handle, ns_s_an);
    if (msg_count > 0) {
        iplist = [[NSMutableArray alloc] initWithCapacity:msg_count];
        for (int rrnum = 0; rrnum < msg_count; rrnum++) {
            ns_rr rr;
            if (ns_parserr(&handle, ns_s_an, rrnum, &rr) == 0) {
                char ip1[16];
                strcpy(ip1, inet_ntoa(*(struct in_addr *)ns_rr_rdata(rr)));
                NSString * ipstring = [NSString stringWithCString:ip1 encoding:NSASCIIStringEncoding];
                if (![ipstring isEqualToString:@""]) {
                    [iplist addObject:ipstring];
                }
            }
        }
        CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
        NSLog(@"1111 === ip === %@ === time cost : %0.3fs", iplist, end - start);
    }
}

- (void)test3 {
    Boolean result, bResolved;
    CFHostRef hostRef;
    CFArrayRef addresses = NULL;
    NSMutableArray * ipsArr = [NSMutableArray array];
    CFStringRef hostNameRef = CFStringCreateWithCString(kCFAllocatorDefault, "www.meitu.com", kCFStringEncodingASCII);
    
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, hostNameRef);
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
    if (result == TRUE) {
        addresses = CFHostGetAddressing(hostRef, &result);
    }
    bResolved = result == TRUE ? true : false;
    if (bResolved) {
        struct sockaddr_in * remoteAddr;
        for (int i = 0; i < CFArrayGetCount(addresses); i++) {
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in *)CFDataGetBytePtr(saData);
            if (remoteAddr != NULL) {
                char ip[16];
                strcpy(ip, inet_ntoa(remoteAddr->sin_addr));
                NSString * ipStr = [NSString stringWithCString:ip encoding:NSUTF8StringEncoding];
                [ipsArr addObject:ipStr];
            }
        }
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"3333 === ip === %@ === cost : %.3fs", ipsArr, end - start);
    CFRelease(hostNameRef);
    CFRelease(hostRef);
}

@end
