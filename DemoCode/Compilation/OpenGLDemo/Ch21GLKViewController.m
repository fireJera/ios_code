//
//  Ch21GLKViewController.m
//  OpenGLDemo
//
//  Created by Jeremy on 2019/3/7.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#import "Ch21GLKViewController.h"

typedef struct {
    GLKVector3 positionCoords;
} SceneVertex;

static const SceneVertex vertics[] = {
    {{-0.5f, -0.5f, 0.0}},
    {{ 0.5f, -0.5f, 0.0}},
    {{-0.5f,  0.5f, 0.0}},
};

@interface Ch21GLKViewController () {
    GLuint vertexBufferID;
}

@property (nonatomic, strong) GLKBaseEffect * baseEffect;

@end

@implementation Ch21GLKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView * view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View Controler's view is not a GLKView");
    // create an OPENGL ES 2.0 context and provide it to the view
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];
    
    // create a base effect that provides standard OpenGL ES 2.0 Shading Language programs
    // and set constants to be used for all subsequent rendering
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f,        //red
                                                   1.0f,        //green
                                                   1.0f,        //blue
                                                   1.0f);       //alpha
    
    // set the background color stored int the current context
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Generate, bind, and initialize contents of a buffer to be stored in GPU memory
    glGenBuffers(1, &vertexBufferID);                                               // STEP 1
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);                                  // STEP 2
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertics), vertics, GL_STATIC_DRAW);        // STEP 3
}


//////////////////////////////////////////////////////
// GLKView delegate method: Called by the view Controller's vie
// whenever Cocoa Touch asks the view controller's view to
// draw itself. (In this case, render into a Frame Buffer that shares memory with a Core Animation Layer)
//////////////////////////////////////////////////////
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.baseEffect prepareToDraw];
    
    // Clear Frame Buffer (erase previous drawing)
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Enable use of currently bound vertex buffer
    glEnableVertexAttribArray(GLKVertexAttribPosition); // STEP 4
    
    glVertexAttribPointer(GLKVertexAttribPosition,      // STEP 5
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex),
                          NULL);
    
    // Draw triangles using the first three vertices in the
    // currently bound vertex buffer
    glDrawArrays(GL_TRIANGLES,                          // STEP 6
                 0,
                 6);
}

- (void)dealloc {
    GLKView * view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if (0 != vertexBufferID) {
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID = 0;
    }
    // stop using the context created in -viewDidload
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
