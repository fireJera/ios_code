//
//  AGLKView.h
//  OpenGLDemo
//
//  Created by Jeremy on 2019/3/8.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

NS_ASSUME_NONNULL_BEGIN

@class EAGLContext;

@protocol AGLKViewDelegate;

@interface AGLKView : UIView {
    EAGLContext * context;
    GLuint defaultFrameBuffer;
    GLuint colorRenderBuffer;
    GLuint drawableWidth;
    GLuint drawableHeight;
}

@property (nonatomic, weak) IBOutlet id<AGLKViewDelegate> delegate;
@property (nonatomic, retain) EAGLContext * context;
@property (nonatomic, readonly) NSInteger drawableWidth;
@property (nonatomic, readonly) NSInteger drawableHeight;

- (void)display;
//- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)aContext;
@end

NS_ASSUME_NONNULL_END

@protocol AGLKViewDelegate <NSObject>

@required
- (void)glkView:(AGLKView *)view drawInRect:(CGRect)rect;

@end

