//
//  main.c
//  CTest
//
//  Created by super on 2018/12/28.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>

int total (int num,...);

struct foo1 {
    char *p;
    char c;
    long l;
};
//24
struct foo2 {
    char c;         // 1 byte
    char pad[7];    // 7 bytes
    char *p;        // 8 bytes
    long l;         // 8 bytes
};
//24
struct foo3 {
    char *p;    // 8 bytes
    char c;     // 1 byte
};
//16
struct foo4 {
    short s;    // 2 bytes
    char c;     // 1 byte
};
//4
struct foo5 {
    char c;
    struct foo5_inner {
        char *p;
        short x;
    } inner;
};
//24
struct foo6 {
    short s;
    char c;
    int flip:1;
    int nybble:4;
    int sertet:7;
};
//8
struct foo7 {
    int bigfield:31;
    int littlefield:1;
};
// 4
struct foo8 {
    int bigfield:31;
    int littlefield:1;
    int bigfield2:31;
    int littlefield2:1;
};
// 8
struct foo9 {
    int bigfield:31;
    int bigfield2:31;
    int littlefield:1;
    int littlefield2:1;
};
// 12
struct foo10 {
    char c;
    struct foo10 *p;
    short x;
};
//24
struct foo11 {
    struct fooll *p;
    short x;
    char c;
};
//16
struct foo12 {
    struct foo12_inner {
        char *p;
        short x;
    } inner;
    char c;
};
//24
int main(int argc, const char * argv[]) {
    printf("sizeof(char *)                  = %zu\n", sizeof(char *));
    printf("sizeof(long)                    = %zu\n", sizeof(long));
    printf("sizeof(int)                     = %zu\n", sizeof(int));
    printf("sizeof(short)                   = %zu\n", sizeof(short));
    printf("sizeof(char)                    = %zu\n", sizeof(char));
    printf("sizeof(float)                   = %zu\n", sizeof(float));
    printf("sizeof(double)                  = %zu\n", sizeof(double));
    printf("sizeof(struct foo1)             = %zu\n", sizeof(struct foo1));
    printf("sizeof(struct foo2)             = %zu\n", sizeof(struct foo2));
    printf("sizeof(struct foo3)             = %zu\n", sizeof(struct foo3));
    printf("sizeof(struct foo4)             = %zu\n", sizeof(struct foo4));
    printf("sizeof(struct foo5)             = %zu\n", sizeof(struct foo5));
    printf("sizeof(struct foo6)             = %zu\n", sizeof(struct foo6));
    printf("sizeof(struct foo7)             = %zu\n", sizeof(struct foo7));
    printf("sizeof(struct foo8)             = %zu\n", sizeof(struct foo8));
    printf("sizeof(struct foo9)             = %zu\n", sizeof(struct foo9));
    printf("sizeof(struct foo10)            = %zu\n", sizeof(struct foo10));
    printf("sizeof(struct foo11)            = %zu\n", sizeof(struct foo11));
    printf("sizeof(struct foo12)            = %zu\n", sizeof(struct foo12));
    
    //    printf("Hello, World!\n");
    // insert code here...
//    int sum = total(3, 2,3,4);
//    printf("%d", sum);
//    int a = 077;
//
//    char * name[100];
//    char * description;
//    strcpy(name, "Jeremy Ren");
////    description = "test";
////    description = malloc(sizeof(char) * 30);
////    description = "testmalloc";
////    description = calloc(50, sizeof(char));
////    description = "testalloc";
//    description = realloc(description, sizeof(char) * 100);
//    description = "testalloc";
//    free(description);
//    printf(description);
//    printf(temp);
//    int a=2;
//    int b=3;
//    return add_a_and_b(a,b);
    
/*
    _add_a_and_b:push%ebx
    mov%eax,[%esp+8]mov%ebx,[%esp+12]add%eax,%ebx
    pop%ebx
    ret
    _main:push 3 push 2 call _add_a_and_b add%esp,8ret
    
    先从寄存器取出栈地址 然后地址减去4 int型占4个字节
    然后再存入esp寄存器
    push 3 将3入栈
    同上 累计减8
    push 2 将2入栈
    调用方法 程序回去找_add_a_and_b标签，并为该函数建立一个新的帧
    call
    从ebx寄存器中取出地址，然后写入_add_a_and_b这个帧 累计减去12
    push %ebx
    将esp+8 = 2写入eax寄存器
    mov%eax,[%esp+8]
    将esp+12 = 3写入ebx寄存器
    mov%ebx,[%esp+12]
    将两个寄存器的值相加并将结果写入第一个寄存器 eax
    add%eax,%ebx
    将stack当前指针的值取出，并将这个值写入ebx寄存器 还会将esp的地址加4 回收4个字节
    pop%ebx
    将esp指针加8位就是回收2 和 3吧
    add%esp,8
    终止当前函数的执行，当前函数的帧被收回。
    ret
*/
    return 0;
}

int total (int num, ...) {
    va_list valist;
    int sum = 0;
    va_start(valist, num);
    for (int i = 0; i < num; i++) {
        sum += va_arg(valist, int);
    }
    va_end(valist);
    return sum;
}
