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
#import <ifaddrs.h>
#import <sys/types.h>

static ViewController * selfInstance = nil;

@interface ViewController ()

@property (nonatomic, assign) CFSocketRef socket;
@property (nonatomic, strong) UITextField * textFiled;
@property (nonatomic, strong) UILabel * recvLabel;
@property (nonatomic, strong) UIButton * sendBtn;
@property (nonatomic, strong) UIButton * connectBtn;
@property (nonatomic, strong) UIButton * disConnectBtn;

@property (nonatomic, assign) int sock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    selfInstance = nil;
    [self configView];
    [self createConnect];
}

- (void)configView {
    _textFiled = [[UITextField alloc] init];
    _textFiled.frame = CGRectMake(10, 400, 300, 40);
    _textFiled.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_textFiled];
    
    _sendBtn = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(sendData:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(310, 400, 75, 40);
        [button setTitle:@"发送" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    });
    
    _recvLabel = ({
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, 30)];
        [self.view addSubview:label];
        label;
    });
    
    _connectBtn = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(connectToServer:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(150, 500, 75, 40);
        [button setTitle:@"connect" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    });
    
    _disConnectBtn = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(disConnect:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(280, 500, 75, 40);
        [button setTitle:@"disconnect" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    });
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
        
        CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr4, sizeof(addr4));

        //绑定socket
        CFSocketConnectToAddress(_socket, address, -1);
        // 连接超时时间，如果为负，则不尝试连接，而是把连接放在后台进行，如果_socket消息类型为kCFSocketConnectCallBack，将会在连接成功或失败的时候在后台触发回调函数
        
        CFRunLoopRef cfRunLoopRef = CFRunLoopGetCurrent();
        CFRunLoopSourceRef sourceRef = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);
        CFRunLoopAddSource(cfRunLoopRef, sourceRef, kCFRunLoopCommonModes);
        CFRelease(sourceRef);
    }
}

static void TCPServerConnectCallBack(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void * data, void * info) {
    NSLog(@"%@", info);
    if (data != NULL && type == kCFSocketConnectCallBack) {
        NSLog(@"connect fail");
        return;
    }
    
    [NSThread detachNewThreadSelector:@selector(readMessage) toTarget:selfInstance withObject:nil];
}

- (void)send:(id)sender {
    [self sendMessage];
}

- (void)readMessage {
    char buf[2048];
    NSString * logStr;
    do {
        ssize_t recvLen = recv(CFSocketGetNative(_socket), buf, sizeof(buf), 0);
        if (recvLen > 0) {
            logStr = [NSString stringWithFormat:@"%@\n", [NSString stringWithFormat:@"%s", buf]];
            
            [self performSelectorOnMainThread:@selector(showMessage:) withObject:logStr waitUntilDone:YES];
        }
    } while (strcmp(buf, "exit" != 0));
}

- (void)sendMessage {
    NSString * stringToSend = self.textFiled.text;
    const char * data = [stringToSend UTF8String];
    send(CFSocketGetNative(_socket), data, strlen(data) + 1, 0);
}

- (void)showMessage:(NSString *)message {
    self.recvLabel.text = message;
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


#pragma mark - seperator line

- (void)connectToServer:(id)sender {
    NSString * host = [self getIPAddress];
    NSString * port = @12345;
    
    // 1、 创建socket
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock == -1) {
        NSLog(@"socket error : %d", sock);
        return;
    }
    
    struct hostent *remoteHostEnt = gethostbyname([host UTF8String]);
    if (remoteHostEnt == NULL) {
        close(sock);
        NSLog(@"无法解析服务器主机名");
        return;
    }
    struct in_addr *remoteInAddr = (struct in_addr *)remoteHostEnt->h_addr_list[0];
    struct sockaddr_in socketParam;
    socketParam.sin_family = AF_INET;
    socketParam.sin_addr = *remoteInAddr;
    socketParam.sin_port = htons([port intValue]);
    
    int con = connect(sock, (struct sockaddr *)&socketParam, sizeof(socketParam));
    if (con == -1) {
        
        close(sock);
        NSLog(@"连接失败");
        return;
    }
    NSLog(@"连接成功");
    self.sock = sock;
    
    NSThread * recvThread = [[NSThread alloc] initWithTarget:self selector:@selector(recvData) object:nil];
    [recvThread start];
}

- (void)disConnect:(id)sender {

}

- (void)sendData:(UIButton *)sender {
//    char sendData[32] = "hello service";
//    ssize_t size_t = send(self.sock, sendData, strlen(sendData), 0);
    NSString * stringToSend = self.textFiled.text;
    const char * data = [stringToSend UTF8String];
    ssize_t size_t = send(self.sock, data, strlen(data), 0);
    NSLog(@"%zd", size_t);
}

- (void)recvData {
    ssize_t bytesRecv = -1;
    char recvData[32] = "";
    while (1) {
        bytesRecv = recv(self.sock, recvData, 32, 0);
        NSLog(@"%zd %s", bytesRecv, recvData);
        NSString * str = [NSString stringWithUTF8String:recvData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMessage:str];
        });
        if (bytesRecv == 0) {
            break;
        }
    }
}

- (NSString *)getIPAddress {
    NSString * address = @"error";
    struct ifaddrs *interfces = NULL;
    struct ifaddrs *temp_addr = NULL;
    
    int success = 0;
    
    success = getifaddrs(&interfces);
    if (success == 0) {
        temp_addr = interfces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    freeifaddrs(interfces);
    NSLog(@"%@", address);
    return address;
}

@end
