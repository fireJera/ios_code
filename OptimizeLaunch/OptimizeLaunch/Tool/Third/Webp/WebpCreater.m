//
//  WebpCreater.m
//  webP
//
//  Created by super on 2018/4/16.
//  Copyright © 2018 Jeremy. All rights reserved.
//

#import "webpCreater.h"
//#import <libwebp/webp/decode.h>
//#import <libwebp/webp/demux.h>
//#import <libwebp/webp/encode.h>
//#import <libwebp/webp/types.h>
//#import <libwebp/webp/mux.h>
//#import <libwebp/webp/mux_types.h>
//#import <libwebp/webp/format_constants.h>
//#import <CoreGraphics/CoreGraphics.h>
//#import <UIKit/UIKit.h>

@implementation WebpCreater
//
//static int SetLoopCount(int loop_count, WebPData* const webp_data) {
//    int ok = 1;
//    WebPMuxError err;
//    uint32_t features;
//    WebPMuxAnimParams new_params;
//    WebPMux* const mux = WebPMuxCreate(webp_data, 1);
//    if (mux == NULL) return 0;
//
//    err = WebPMuxGetFeatures(mux, &features);
//    ok = (err == WEBP_MUX_OK);
//    if (!ok || !(features & ANIMATION_FLAG)) goto End;
//
//    err = WebPMuxGetAnimationParams(mux, &new_params);
//    ok = (err == WEBP_MUX_OK);
//    if (ok) {
//        new_params.loop_count = loop_count;
//        err = WebPMuxSetAnimationParams(mux, &new_params);
//        ok = (err == WEBP_MUX_OK);
//    }
//    if (ok) {
//        WebPDataClear(webp_data);
//        err = WebPMuxAssemble(mux, webp_data);
//        ok = (err == WEBP_MUX_OK);
//    }
//
//End:
//    WebPMuxDelete(mux);
//    if (!ok) {
//        fprintf(stderr, "Error during loop-count setting\n");
//    }
//    return ok;
//}
//
////------------------------------------------------------------------------------
//
//- (NSData *)convertWebp:(NSArray<UIImage *> *)array {
////    const char* output = NULL;
//    WebPAnimEncoder* enc = NULL;
//    int verbose = 0;
//    int pic_num = 0;
//    int duration = 100;
//    int timestamp_ms = 0;
//    int loop_count = 0;
//    int width = 0, height = 0;
//    WebPAnimEncoderOptions anim_config;
//    WebPConfig config;
//    WebPPicture pic;
//    WebPData webp_data;
//    int c;
//    int have_input = 0;
////    CommandLineArguments cmd_args;
//    int ok;
////    = ExUtilInitCommandLineArguments(argc - 1, argv + 1, &cmd_args);
//
////    if (!ok) return 1;
////    argc = cmd_args.argc_;
////    argv = cmd_args.argv_;
//
//    WebPDataInit(&webp_data);
//    if (!WebPAnimEncoderOptionsInit(&anim_config) ||
//        !WebPConfigInit(&config) ||
//        !WebPPictureInit(&pic)) {
//        fprintf(stderr, "Library version mismatch!\n");
//        ok = 0;
//        goto End;
//    }
//
//    // 1st pass of option parsing
////    for (c = 0; ok && c < argc; ++c) {
////        if (argv[c][0] == '-') {
//            int parse_error = 0;
////            if (!strcmp(argv[c], "-o") && c + 1 < argc) {
////                argv[c] = NULL;
////                output = argv[++c];
////            }
////            else if (!strcmp(argv[c], "-kmin") && c + 1 < argc) {
////                argv[c] = NULL;
////                anim_config.kmin = ExUtilGetInt(argv[++c], 0, &parse_error);
////            }
////            else if (!strcmp(argv[c], "-kmax") && c + 1 < argc) {
////                argv[c] = NULL;
////                anim_config.kmax = ExUtilGetInt(argv[++c], 0, &parse_error);
////            }
////            strcmp(“abcd”,”abcd”)的返回值是 0；
////            else if (!strcmp(argv[c], "-loop") && c + 1 < argc) {
////                argv[c] = NULL;
//                loop_count = 0;
//                if (loop_count < 0) {
//                    fprintf(stderr, "Invalid non-positive loop-count (%d)\n", loop_count);
//                    parse_error = 1;
//                }
////            }
////            else if (!strcmp(argv[c], "-min_size")) {
////                anim_config.minimize_size = 1;
////            }
////            else if (!strcmp(argv[c], "-mixed")) {
////                anim_config.allow_mixed = 1;
////                config.lossless = 0;
////            }
////            else if (!strcmp(argv[c], "-v")) {
////                verbose = 1;
////            }
////            else if (!strcmp(argv[c], "-h") || !strcmp(argv[c], "-help")) {
////                Help();
////                goto End;
////            }
////            else {
////                continue;
////            }
////            ok = !parse_error;
////            if (!ok) goto End;
////            argv[c] = NULL;   // mark option as 'parsed' during 1st pass
////        } else {
////            have_input |= 1;
////        }
////    }
////    if (!have_input) {
////        fprintf(stderr, "No input file(s) for generating animation!\n");
////        goto End;
////    }
//
//    // image-reading pass
//    pic_num = 0;
//    config.lossless = 1;
//    for (int c = 0; c < array.count; ++c) {
//
////        if (argv[c][0] == '-') {    // parse local options
//            int parse_error = 0;
////            if (!strcmp(argv[c], "-lossy")) {
////                if (!anim_config.allow_mixed)
//                    config.lossless = 0;
////            }
////            else if (!strcmp(argv[c], "-lossless")) {
////                if (!anim_config.allow_mixed) config.lossless = 1;
////            }
////            else if (!strcmp(argv[c], "-q") && c + 1 < argc) {
////                config.quality = ExUtilGetFloat(argv[++c], &parse_error);
////            }
////            else if (!strcmp(argv[c], "-m") && c + 1 < argc) {
////                config.method = ExUtilGetInt(argv[++c], 0, &parse_error);
////            }
////            else if (!strcmp(argv[c], "-d") && c + 1 < argc) {
////                duration = 300;
////                if (duration <= 0) {
////                    fprintf(stderr, "Invalid negative duration (%d)\n", duration);
////                    parse_error = 1;
////                }
////            }
////            else {
////                parse_error = 1;   // shouldn't be here.
////                fprintf(stderr, "Unknown option [%s]\n", argv[c]);
////            }
////            ok = !parse_error;
////            if (!ok) goto End;
////            continue;
////        }
//
//        if (ok) {
//            ok = WebPValidateConfig(&config);
//            if (!ok) {
//                fprintf(stderr, "Invalid configuration.\n");
//                goto End;
//            }
//        }
//
//        // read next input image
//        pic.use_argb = 1;
//
//        UIImage * image = array[c];
//        CGImageRef webPImageRef = image.CGImage;
//        size_t webPBytesPerRow = CGImageGetBytesPerRow(webPImageRef);
//
//        size_t webPImageWidth = CGImageGetWidth(webPImageRef);
//        size_t webPImageHeight = CGImageGetHeight(webPImageRef);
//
//        CGDataProviderRef webPDataProviderRef = CGImageGetDataProvider(webPImageRef);
//        CFDataRef webPImageDatRef = CGDataProviderCopyData(webPDataProviderRef);
//
//        uint8_t *webPImageData = (uint8_t *)CFDataGetBytePtr(webPImageDatRef);
//
////        WebPConfig config;
////        if (!WebPConfigPreset(&config, preset, quality)) {
////            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
////            [errorDetail setValue:@"Configuration preset failed to initialize." forKey:NSLocalizedDescriptionKey];
////            if(error != NULL)
////                *error = [NSError errorWithDomain:[NSString stringWithFormat:@"%@.errorDomain",  [[NSBundle mainBundle] bundleIdentifier]] code:-101 userInfo:errorDetail];
////
////            CFRelease(webPImageDatRef);
////            return nil;
////        }
////
////        if (!WebPValidateConfig(&config)) {
////            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
////            [errorDetail setValue:@"One or more configuration parameters are beyond their valid ranges." forKey:NSLocalizedDescriptionKey];
////
////            CFRelease(webPImageDatRef);
////            return nil;
////        }
//
//        pic.width = image.size.width;
////        (int)webPImageWidth;
//        pic.height = image.size.height;
////        (int)webPImageHeight;
////        pic.colorspace = WEBP_YUV420;
//
//        WebPPictureImportRGBA(&pic, webPImageData, (int)webPBytesPerRow);
//        WebPPictureARGBToYUVA(&pic, WEBP_YUV420);
//        WebPCleanupTransparentArea(&pic);
//
//        //TODO: - read image tp pic
////        ok = ReadImage(argv[c], &pic);
////        if (!ok) goto End;
//
//        if (enc == NULL) {
//            width  = pic.width;
//            height = pic.height;
//            enc = WebPAnimEncoderNew(width, height, &anim_config);
//            ok = (enc != NULL);
//            if (!ok) {
//                fprintf(stderr, "Could not create WebPAnimEncoder object.\n");
//            }
//        }
//
//        if (ok) {
//            ok = (width == pic.width && height == pic.height);
//            if (!ok) {
//                fprintf(stderr, "Frame #%d dimension mismatched! "
//                        "Got %d x %d. Was expecting %d x %d.\n",
//                        pic_num, pic.width, pic.height, width, height);
//            }
//        }
//
//        if (ok) {
//            ok = WebPAnimEncoderAdd(enc, &pic, timestamp_ms, &config);
//            if (!ok) {
//                fprintf(stderr, "Error while adding frame #%d\n", pic_num);
//            }
//        }
//        WebPPictureFree(&pic);
//        if (!ok) goto End;
//
//        if (verbose) {
//            fprintf(stderr, "Added frame #%3d at time %4d (file: %s)\n",
//                    pic_num, timestamp_ms, c);
//        }
//        timestamp_ms += duration;
//        ++pic_num;
//        CFRelease(webPImageDatRef);
//    }
//
//    // add a last fake frame to signal the last duration
//    ok = ok && WebPAnimEncoderAdd(enc, NULL, timestamp_ms, NULL);
//    ok = ok && WebPAnimEncoderAssemble(enc, &webp_data);
//    if (!ok) {
//        fprintf(stderr, "Error during final animation assembly.\n");
//    }
//
//End:
//    // free resources
//    WebPAnimEncoderDelete(enc);
//
//    if (ok && loop_count > 0) {  // Re-mux to add loop count.
//        ok = SetLoopCount(loop_count, &webp_data);
//    }
//
//    if (ok) {
//        //TODO: - nsdata init
//        NSData *webPFinalData = [NSData dataWithBytes:webp_data.bytes length:webp_data.size];
//        return webPFinalData;
////            ok = ImgIoUtilWriteFile(output, webp_data.bytes, webp_data.size);
//    }
//
//    if (ok) {
//        fprintf(stderr, "[%d frames, %u bytes].\n",
//                pic_num, (unsigned int)webp_data.size);
//    }
//    WebPDataClear(&webp_data);
////    ExUtilDeleteCommandLineArguments(&cmd_args);
//    return nil;
//}
//
////static int ReadImage(const char filename[], WebPPicture* const pic) {
////    const uint8_t* data = NULL;
////    size_t data_size = 0;
////    WebPImageReader reader;
////    int ok;
////#ifdef HAVE_WINCODEC_H
////    // Try to decode the file using WIC falling back to the other readers for
////    // e.g., WebP.
////    ok = ReadPictureWithWIC(filename, pic, 1, NULL);
////    if (ok) return 1;
////#endif
////    if (!ImgIoUtilReadFile(filename, &data, &data_size)) return 0;
////    reader = WebPGuessImageReader(data, data_size);
////    ok = reader(data, data_size, pic, 1, NULL);
////    free((void*)data);
////    return ok;
////}

@end
