//
//  NSData+LETAD_Base64.h
//  LetDate
//
//  Created by Jeremy on 2019/1/19.
//  Copyright © 2019 JersiZhu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (LETAD_Base64)

- (NSString *)base64String;

- (NSString *)md5String;

@end

NS_ASSUME_NONNULL_END
