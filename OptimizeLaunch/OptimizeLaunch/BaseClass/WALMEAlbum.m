//
//  WALMEAlbum.m
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEAlbum.h"

@implementation WALMEAlbum

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"photoId"     : @"photo_id",
             @"linkThumb"   : @"link_thumb",
             @"isVideo"     : @"is_video",
             };
}

@end
