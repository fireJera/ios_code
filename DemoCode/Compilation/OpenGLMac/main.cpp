//
//  main.cpp
//  OpenGLMac
//
//  Created by Jeremy on 2019/5/25.
//  Copyright © 2019 Jeremy. All rights reserved.
//

#include <stdio.h>
#include "GLTools.h"
#include "GLMatrixStack.h"
#include "GLFrame.h"
#include "GLFrustum.h"
#include "GLGeometryTransform.h"
#include "GLShaderManager.h"

#include <math.h>

#ifdef __APPLE__
#include <glut/glut.h>
#else
#define FREEGLUT_STATIC
#inlcude <GL/glut.h>
#endif

//#include <GLFW/glfw3.h>

GLFrame viewFrame;                              // 观察者

GLFrustum viewFrustum;
GLTriangleBatch torusBatch;
GLMatrixStack modelViewMatix;
GLMatrixStack projectionMatix;
GLGeometryTransform transformPipleLline;
GLShaderManager shaderManager;

int iCull = 0;
int iDepth = 0;

void ProcessMenu(int value) {
    switch (value) {
        case 1:
            iCull = !iCull;
            break;
            case 2:
            break;
        default:
            break;
    }
    glutPostRedisplay();
}

void RederScene(void) {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    if (iCull) {
        // 开启表面剔除(默认背面剔除)
        glEnable(GL_CULL_FACE);
        // 指定顺时针(GL_CCW)或逆时针(GL_CW)为正面
        glFrontFace(GL_CCW);
        // 选择剔除的面 // GL_BACK GL_FRONT GL_FONT_AND_BACK 这里是剔除背面
        glCullFace(GL_BACK);
    } else {
        // 关闭表面剔除
        glDisable(GL_CULL_FACE);
    }
    
    modelViewMatix.PushMatrix(viewFrame);
    GLfloat vRed[] = {1.0, 0.0, 0.0, 1.0};
    
    shaderManager.UseStockShader(GLT_SHADER_DEFAULT_LIGHT, transformPipleLline.GetModelViewMatrix(), transformPipleLline.GetProjectionMatrix(), vRed);
    torusBatch.Draw();
    
    modelViewMatix.PopMatrix();
    glutSwapBuffers();
}

void SetupRC() {
    // 颜色缓存区
    glClearColor(0.3, 0.3, 0.3, 0.3);
    shaderManager.InitializeStockShaders();
    viewFrame.MoveForward(7.0f);
    
    gltMakeTorus(torusBatch, 1.0f, 0.3f, 52, 26);
    
    glPointSize(4.0f);
}

void SpecialKeys(int key, int x, int y) {
    if (key == GLUT_KEY_UP) {
        viewFrame.RotateWorld(m3dDegToRad(-5.0), 1.0, 0.0, 0.0);
    }
    
    if (key == GLUT_KEY_DOWN) {
        viewFrame.RotateWorld(m3dDegToRad(5.0), 1.0, 0.0, 0.0);
    }
    
    if (key == GLUT_KEY_LEFT) {
        viewFrame.RotateWorld(m3dDegToRad(-5.0), 0.0, 1.0, 0.0);
    }
    
    if (key == GLUT_KEY_RIGHT) {
        viewFrame.RotateWorld(m3dDegToRad(5.0), 0.0, 1.0, 0.0);
    }
    glutPostRedisplay();
}

void ChangeSize(int w, int h) {
    if (h == 0) {
        h = 1;
    }
    glViewport(0, 0, w, h);
    
    viewFrustum.SetPerspective(35.0, float(w) / float(h), 1.0, 100.0);
    
    projectionMatix.LoadMatrix(viewFrustum.GetProjectionMatrix());
    transformPipleLline.SetMatrixStacks(modelViewMatix, projectionMatix);
}

int main(int argc, char *argv[]) {
    gltSetWorkingDirectory(argv[0]);
    
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH | GLUT_STENCIL);
    glutInitWindowSize(800, 600);
    glutCreateWindow("Geometry Test Program");
    glutReshapeFunc(ChangeSize);
    glutSpecialFunc(SpecialKeys);
    glutDisplayFunc(RederScene);
    
    // 设置右击菜单
    glutCreateMenu(ProcessMenu);
    glutAddMenuEntry("Toogle Cull Face", 1);
//    glutAddSubMenu("Toogle Cull Face", 1);
    glutAttachMenu(GLUT_RIGHT_BUTTON);
    
    GLenum err = glewInit();
    if (GLEW_OK != err) {
        fprintf(stderr, "GLEW Error : %s \n", glewGetErrorString(err));
        return 1;
    }
    
    SetupRC();
    
    glutMainLoop();
    return 0;
}
