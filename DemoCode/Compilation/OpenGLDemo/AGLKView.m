//
//  AGLKView.m
//  OpenGLDemo
//
//  Created by Jeremy on 2019/3/8.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "AGLKView.h"
#import <QuartzCore/QuartzCore.h>

@implementation AGLKView

//////////////////////////////
// This method returns the CALayer subclass to be used by
// CoreAnimation with this view
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame context:(EAGLContext *)aContext {
    if (self = [super initWithFrame:frame]) {
        CAEAGLLayer * eagLayer = (CAEAGLLayer *)self.layer;
        
        // 不适用保留背景的意思是layer的任何部分需要在显示到屏幕上时都要绘制整个层的内容。
        // In other wrods Don't try to save any content that drawed before to reused later.
        eagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        self.context = aContext;
    }
    return self;
}

//////////////////////////////
// This method is called automatically to initialize each Cocoa
// Touch object as the object is unarchived from an
// Interface Builder .xib or .stroyboard file.
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        CAEAGLLayer * eagLayer = (CAEAGLLayer *)self.layer;
        eagLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
    }
    return self;
}

//////////////////////////////
// This method sets the receiver's OpenGL ES Context. If the
// receiver already has a different Context, this method deletes
// OpenGL ES Frames Buffer resources in the old Context and the
// recreates them in the new Context.
- (void)setContext:(EAGLContext *)aContext {
    if (context != aContext) {
        [EAGLContext setCurrentContext:context];
    }
    if (0 != defaultFrameBuffer) {
        glDeleteFramebuffers(1, &defaultFrameBuffer);
        defaultFrameBuffer = 0;
    }
    if (0 != colorRenderBuffer) {
        glDeleteRenderbuffers(1, &colorRenderBuffer);
        colorRenderBuffer = 0;
    }
    context = aContext;
    
    if (nil != context) {
        context = aContext;
        [EAGLContext setCurrentContext:context];
        
        glGenFramebuffers(1, &defaultFrameBuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFrameBuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER,
                                  GL_COLOR_ATTACHMENT0,
                                  GL_RENDERBUFFER,
                                  colorRenderBuffer);
    }
}

//////////////////////////////
// This method returns the receiver's OpenGL ES Context
- (EAGLContext *)context {
    return context;
}

//////////////////////////////
// Calling this method tells the receiver to redraw the contents
// of its associated OpenGL ES Frame Buffer. This method
// configure OpenGL ES and then calls -drawRect:
- (void)display {
    [EAGLContext setCurrentContext:self.context];
    glViewport(0, 0, (GLsizei)self.drawableWidth, (GLsizei)self.drawableHeight);
    [self drawRect:self.bounds];
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)drawRect:(CGRect)rect {
    if (self.delegate) {
        [self.delegate glkView:self drawInRect:[self bounds]];
    }
}

//////////////////////////////
// This method is called automatically whenever a UIView is
// resized including just after the view is added to a UIWindow.
- (void)layoutSubviews {
    CAEAGLLayer * eagLayer = (CAEAGLLayer *)self.layer;
    // Initializer the current Frame Buffer's pixel color buffer
    // so that is shares the corresponding Core Animation Layer's
    // pixel color storage.
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eagLayer];
    
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    if (status != GL_FRAMEBUFFER_COMPLETE) {
        NSLog(@"failed to make complete frame buffer object %x", status);
    }
}

//////////////////////////////
// This method returns the width in pixels of current context's
// Pixel Color Render Buffer
- (NSInteger)drawableWidth {
    GLint backingWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    return (NSInteger)backingWidth;
}

//////////////////////////////
// This method returns the height in pixels of current context's
// Pixel Color Render Buffer
- (NSInteger)drawableHeight {
    GLint backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    return (NSInteger)backingHeight;
}

//////////////////////////////
// This method is called automatically when the references count
// for a Cocoa Touch object reaches zero.
- (void)dealloc {
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    context = nil;
}

@end
