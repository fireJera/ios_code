//
//  WALMEWebViewController+Delegate.h
//  BanteaySrei
//
//  Created by Jeremy on 2019/4/15.
//  Copyright © 2019 BanteaySrei. All rights reserved.
//

#import "WALMEWebViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WALMEWebViewController (Delegate)<WKNavigationDelegate, WKScriptMessageHandler, WKUIDelegate>

@end

NS_ASSUME_NONNULL_END
