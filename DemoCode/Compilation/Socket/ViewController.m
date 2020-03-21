//
//  ViewController.m
//  Socket
//
//  Created by Jeremy on 2020/3/21.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import <netinet/tcp.h>
#import <netdb.h>


void TCPServerConnectCallBack(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
    
}

@interface ViewController ()

@property (nonatomic, assign) CFSocketRef socket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    socket(<#int#>, <#int#>, <#int#>);
//    bind(<#int#>, <#const struct sockaddr *#>, <#socklen_t#>);
//    listen(<#int#>, <#int#>);
//    connect(<#int#>, <#const struct sockaddr *#>, <#socklen_t#>);
//    accept(<#int#>, <#struct sockaddr *restrict#>, <#socklen_t *restrict#>);
    ////tcp
//    send(<#int#>, <#const void *#>, <#size_t#>, <#int#>);
//    recv(<#int#>, <#void *#>, <#size_t#>, <#int#>);
    
    ////udp
//    sendto(<#int#>, <#const void *#>, <#size_t#>, <#int#>, <#const struct sockaddr *#>, <#socklen_t#>);
//    recvfrom(<#int#>, <#void *#>, <#size_t#>, <#int#>, <#struct sockaddr *restrict#>, <#socklen_t *restrict#>);
//    sendto(<#int#>, <#const void *#>, <#size_t#>, <#int#>, <#const struct sockaddr *#>, <#socklen_t#>)
//    recvfrom(<#int#>, <#void *#>, <#size_t#>, <#int#>, <#struct sockaddr *restrict#>, <#socklen_t *restrict#>);
//    close(<#int#>);
}

- (void)testTCP {
    NSString * host = @"127.0.0.1";
    NSNumber * port = @(1880);
    // 第一个参数 ipv4h或者ipv6， 第二个参数 流格式还是数据报格式，也就是tcp还是udp
    int socketFileDescriptor = socket(AF_INET, SOCK_STREAM, 0);
    if (socketFileDescriptor == -1) {
        NSLog(@"create connect fail");
        return;
    }
    struct hostent * remoteHostEnt = gethostbyname([host UTF8String]);
    if (remoteHostEnt == NULL) {
        close(socketFileDescriptor);
        NSLog(@"DNS config solve faile");
        return;
    }
    
    struct in_addr * remoteInAddr = (struct in_addr *)remoteHostEnt->h_addr_list[0];
    // 设置socket参数
    struct sockaddr_in socketParameters;
    socketParameters.sin_family = AF_INET;
    socketParameters.sin_addr = *remoteInAddr;
    socketParameters.sin_port = htons([port intValue]);
    
    // 连接socket
    int ret = connect(socketFileDescriptor, (struct sockaddr *) &socketParameters, sizeof(socketParameters));
    if (ret == -1) {
        close(socketFileDescriptor);
        NSLog(@"连接失败");
        return;
    }
    NSLog(@"连接成功");
}

- (void)createConnect {
    CFSocketContext sockContext = {0, NULL, NULL, NULL, NULL};
    /*
     1. 为对象分配内存，可为nil
     2. 协议族
     3. TCP还是UDP
     4. 套接字协议
     5. 触发消息回调类型
     6. 回调g函数
     7. 一个持有CFSocket结构信息的对象，可以为nil.
     */
    _socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketConnectCallBack, TCPServerConnectCallBack, &sockContext);
    if (_socket != nil) {
        struct sockaddr_in addr4;
        memset(&addr4, 0, sizeof(addr4));
        
        addr4.sin_len = sizeof(addr4);
        addr4.sin_family = AF_INET;
        addr4.sin_port = htons(8888);
        addr4.sin_addr.s_addr = inet_addr([@"服务端IP地址" UTF8String]);
        
        CFDateRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr4, sizeof(addr4));
        
    }
}

@end
