//
//  ServiceViewController.m
//  Socket
//
//  Created by Jeremy on 2020/3/24.
//  Copyright © 2020 Jeremy. All rights reserved.
//

#import "ServiceViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import <netinet/tcp.h>
#import <sys/types.h>
#import <ifaddrs.h>

@interface ServiceViewController () {
    CFSocketRef _socket;
    NSMutableArray * addressArr;
}

@property (nonatomic, assign) int newSock;
@property (nonatomic, assign) int sock;
@property (nonatomic, strong) NSMutableArray *infoArray;

@property (nonatomic, strong) UIButton * startBtn;
@property (nonatomic, strong) UIButton * sendBtn;

@end

static CFWriteStreamRef outputStream;
static ServiceViewController * selfClass = nil;

@implementation ServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    selfClass = self;
    addressArr = [NSMutableArray array];
    
    [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://image.baidu.com/search/detail?ct=503316480&z=0&ipn=false&word=风景电脑壁纸&step_word=&hs=0&pn=0&spn=0&di=56105480860&pi=0&rn=1&tn=baiduimagedetail&is=0%2C0&istype=0&ie=utf-8&oe=utf-8&in=&cl=2&lm=-1&st=-1&cs=1363482873%2C1492771985&os=2200545678%2C3916134210&simid=4263289627%2C720205809&adpicid=0&lpn=0&ln=3994&fr=&fmq=1501838304131_R&fm=rs3&ic=undefined&s=undefined&se=&sme=&tab=0&width=undefined&height=undefined&face=undefined&ist=&jit=&cg=wallpaper&bdtype=0&oriquery=风景&objurl=http%3A%2F%2Fpic1.win4000.com%2Fwallpaper%2Fe%2F53ec732e6142b.jpg&fromurl=ippr_z2C%24qAzdH3FAzdH3Fooo_z%26e3Botg9aaa_z%26e3Bv54AzdH3Fowssrwrj6_kt2_cd9dm_8_z%26e3Bip4s&gsm=0&rpstart=0&rpnum=0"]];
    outputStream = NULL;
    [self configView];
//    [self createConnect];
}

- (void)configView {
    _receLa = ({
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 300, 200)];
        label.textColor = [UIColor blackColor];
        [self.view addSubview:label];
        label;
    });
    
    _listlabl = ({
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 300, 300, 200)];
        label.textColor = [UIColor blackColor];
        [self.view addSubview:label];
        label;
    });
    
    _textF = ({
        UITextField * textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(10, 500, 300, 40);
        textField.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:textField];
        textField;
    });
    
    _clientTf = ({
        UITextField * textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(10, 560, 300, 40);
        textField.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:textField];
        textField;
    });
    
    _startBtn = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(200, 600, 75, 40);
        [button setTitle:@"start" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    });
    
    _sendBtn = ({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(200, 650, 75, 40);
        [button setTitle:@"send" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
        button;
    });
}

- (BOOL)createConnect {
    _socket = CFSocketCreate(kCFAllocatorDefault, PF_INET, SOCK_STREAM, IPPROTO_TCP, kCFSocketAcceptCallBack, TCPServerAcceptCallBack, NULL);
    if (_socket == NULL) {
        NSLog(@"cannot create socket");
        return 0;
    }
    int optval = 1;
    setsockopt(CFSocketGetNative(_socket), SOL_SOCKET, SO_REUSEADDR, (void *)&optval, sizeof(optval));
    
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = PF_INET;
    addr4.sin_port = htons(8888);
    addr4.sin_addr.s_addr = htonl(INADDR_ANY);
    
    CFDataRef address = CFDataCreate(kCFAllocatorDefault, (UInt8 *)&addr4, sizeof(addr4));
    
    if (CFSocketSetAddress(_socket, address) != kCFSocketSuccess) {
        NSLog(@"Bind to address failed");
        if (!_socket) {
            CFRelease(_socket);
            _socket = NULL;
            return 0;
        }
    }
    
    CFRunLoopRef cfRunLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceRef source = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _socket, 0);
    CFRunLoopAddSource(cfRunLoop, source, kCFRunLoopCommonModes);
    CFRelease(source);
    return 1;
}

static void TCPServerAcceptCallBack(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void * data, void * info) {
    if (kCFSocketAcceptCallBack == type) {
        CFSocketNativeHandle handle = *(CFSocketNativeHandle *)data;
        uint8_t name[SOCK_MAXADDRLEN];
        socklen_t nameLen = sizeof(name);
        
        if (getpeername(handle, (struct sockaddr *)name, &nameLen)) {
            NSLog(@"error");
            exit(1);
        }
        NSLog(@"%s connected", inet_ntoa(((struct sockaddr_in *)name)->sin_addr));
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, handle, &readStream, &writeStream);
        
        if (readStream && writeStream) {
            [selfClass->addressArr addObject:(__bridge id _Nonnull)writeStream];
            NSString * addre = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)name)->sin_addr)];
            selfClass.listlabl.text = [selfClass.listlabl.text stringByAppendingString:addre];
            
            CFStreamClientContext streamContext = {0, (__bridge void *)(addre), NULL, NULL};
            if (!CFReadStreamSetClient(readStream, kCFStreamEventHasBytesAvailable, readStreamFunc, &streamContext)) {
                exit(1);
            }
            if (!CFWriteStreamSetClient(writeStream, kCFStreamEventCanAcceptBytes, writeStreamFunc, &streamContext)) {
                exit(1);
            }
            CFReadStreamScheduleWithRunLoop(readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
            CFWriteStreamScheduleWithRunLoop(writeStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
            CFReadStreamOpen(readStream);
            CFWriteStreamOpen(writeStream);
        }
        else {
            close(handle);
        }
    }
}

void readStreamFunc(CFReadStreamRef stream, CFStreamEventType type, void *clientCallBackInfo) {
    uint8_t buff[255];
    CFReadStreamRead(stream, buff, 255);
    printf("received %s", buff);
    NSString * str = [NSString stringWithCString:(char *)buff encoding:NSUTF8StringEncoding];
    [selfClass showReceiveData:str];
}

void writeStreamFunc(CFWriteStreamRef stream, CFStreamEventType type, void *clientCallBackInfo) {
    
}

- (void)sendStream {
    int index = [self.clientTf.text intValue];
    
    UInt8 buff[1024];
    memcmp(buff, [self.textF.text UTF8String], sizeof(buff));
    
    outputStream = (__bridge CFWriteStreamRef)addressArr[index];
    CFWriteStreamWrite(outputStream, (UInt8 *)self.textF.text.UTF8String, strlen(_textF.text.UTF8String) + 1 + 1);
    
    [self.view endEditing:YES];
}

- (void)showReceiveData:(NSString *)str {
    self.receLa.text = str;
}

- (void)send:(id)sender {
    [self sendStream];
}


#pragma mark - seperator line
- (void)buttonDidClick:(UIButton *)sender {
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    [self.infoArray addObject:@"正在创建socket"];
    self.sock = sock;
    if (self.sock == -1) {
        close(self.sock);
        NSLog(@"socket error : %d", self.sock);
        [self.infoArray addObject:@"创建socket失败..."];
        return;
    }
    struct sockaddr_in client;
    client.sin_family = AF_INET;
    NSString * ipStr = [self getIPAddress];
    const char *ip = [ipStr cStringUsingEncoding:NSASCIIStringEncoding];
    
    client.sin_addr.s_addr = inet_addr(ip);
    client.sin_port = htons(12345);
    
    int bd = bind(self.sock, (struct sockaddr *)&client, sizeof(client));
    [self.infoArray addObject:@"绑定固定端口..."];
    if (bd == -1) {
        close(self.sock);
        NSLog(@"bind error : %d", bd);
        [self.infoArray addObject:@"绑定固定端口失败..."];
        return;
    }
    
    int ls = listen(self.sock, 128);
    [self.infoArray addObject:@"监听端口号..."];
    if (ls == -1) {
        close(self.sock);
        NSLog(@"listen error : %d", ls);
        [self.infoArray addObject:@"监听端口号失败..."];
        return;
    }
    
    NSThread * recvThread = [[NSThread alloc] initWithTarget:self selector:@selector(recvData) object:nil];
    [recvThread start];
}

- (void)recvData {
    struct sockaddr_in rest;
    socklen_t rest_size = sizeof(struct sockaddr_in);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.infoArray addObject:@"等待连接..."];
    });
    self.newSock = accept(self.sock, (struct sockaddr *)&rest, &rest_size);
    ssize_t bytesRecv = -1;
    char recvData[32] = "";
    while (1) {
        bytesRecv = recv(self.newSock, recvData, 32, 0);
        NSLog(@"%zd %s", bytesRecv, recvData);
        __block NSString *dataStr = [NSString stringWithFormat:@"收到数据:%s", recvData];
        dispatch_async(dispatch_get_main_queue(), ^{
            _listlabl.text = dataStr;
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.infoArray addObject:dataStr];
        });
        if (bytesRecv == 0) {
            break;
        }
    }
}

- (void)sendMessage {
//    char sendData[32] = "hello, client";
    const char *sendData = [_textF.text UTF8String];
    ssize_t size_t = send(self.newSock, sendData, strlen(sendData), 0);
    if (size_t > 0) {
        [self.infoArray addObject:[NSString stringWithFormat:@"发送数据：%s", sendData]];
    }
}

- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    success = getifaddrs(&interfaces);
    if (success == 0) {
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if (temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    freeifaddrs(interfaces);
    NSLog(@"%@", address);
    return address;
}

@end
