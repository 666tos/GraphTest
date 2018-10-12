//
//  GLViewController.swift
//  ElevationGraph
//
//  Created by M Ivaniushchenko on 10/11/18.
//  Copyright © 2018 tos. All rights reserved.
//

import UIKit
import GLKit

class GLViewController: GLKViewController {
    
    var ourShader: Shader!
    var VBO:GLuint=0, EBO:GLuint=0, VAO:GLuint=0
    var graphs: [Graph] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = EAGLContext(api: .openGLES3)!
        
        let glView = self.view as! GLKView
        glView.context = context
        glView.drawableDepthFormat = .format24
        glView.drawableColorFormat = .RGBA8888
        
        EAGLContext.setCurrent(context)
        
        self.preferredFramesPerSecond = 60
        
        // Build and compile our shader program
        
        self.ourShader = Shader(vertexFile: "textures.vs", fragmentFile: "textures.frag")
        
        let colors = [UIColor(rgb: 0x1abc9c),
                      UIColor(rgb: 0x2980b9),
                      UIColor(rgb: 0x8e44ad),
                      UIColor(rgb: 0xf1c40f),
                      UIColor(rgb: 0xe74c3c),
                      UIColor(rgb: 0xc0392b),
                      UIColor(rgb: 0xecf0f1),
                      UIColor(rgb: 0x1abc9c)]
        
        for i in 0 ..< 8 {
            self.graphs.append(Graph(shader: self.ourShader, graphColor: colors[i]))
        }
        
        let vertices:[GLfloat] = [
            // Positions       // Normals        // Texture Coords
            0.8,  0.8, 0.0,   0.0, 0.0, 1.0,   1.0, 1.0,
            -0.8,  0.8, 0.0,   0.0, 0.0, 1.0,   0.0, 1.0,
            0.8, -0.8, 0.0,   0.0, 0.0, 1.0,   1.0, 0.0,
            0.8, -0.8, 0.0,   0.0, 0.0, 1.0,   1.0, 0.0,
            -0.8,  0.8, 0.0,   0.0, 0.0, 1.0,   0.0, 1.0,
            -0.8, -0.8, 0.0,   0.0, 0.0, 1.0,   0.0, 0.0,
            ]
        
        let indices: [GLuint] = [
            0, 1, 2,
            3, 4, 5,
        ]
        
        tacx_glGenVertexArrays(n: 1, arrays: &VAO)
//        defer { glDeleteVertexArrays(1, &VAO) }
        
        tacx_glGenBuffers(n: 1, buffers: &VBO)
//        defer { glDeleteBuffers(1, &VBO) }
        
        tacx_glGenBuffers(n: 1, buffers: &EBO)
//        defer { glDeleteBuffers(1, &EBO) }
        
        tacx_glBindVertexArray(VAO)
        
        tacx_glBindBuffer(target: GL_ARRAY_BUFFER, buffer: VBO)
        tacx_glBufferData(target: GL_ARRAY_BUFFER,
                          size: MemoryLayout<GLfloat>.stride * vertices.count,
                          data: vertices, usage: GL_STATIC_DRAW)
        
        tacx_glBindBuffer(target: GL_ELEMENT_ARRAY_BUFFER, buffer: EBO)
        tacx_glBufferData(target: GL_ELEMENT_ARRAY_BUFFER,
                          size: MemoryLayout<GLuint>.stride * indices.count,
                          data: indices, usage: GL_STATIC_DRAW)
        
        // Position attribute
        tacx_glEnableVertexAttribArray(index: 0)
        let pointer0offset = UnsafeRawPointer(bitPattern: 0)
        tacx_glVertexAttribPointer(index: 0, size: 3, type: GL_FLOAT,
                                   normalized: false, stride: GLsizei(MemoryLayout<GLfloat>.stride * 8), pointer: pointer0offset)
        
        // Normals attribute
        tacx_glEnableVertexAttribArray(index: 1)
        let pointer1offset = UnsafeRawPointer(bitPattern: MemoryLayout<GLfloat>.stride * 3)
        tacx_glVertexAttribPointer(index: 1, size: 3, type: GL_FLOAT,
                                   normalized: false, stride: GLsizei(MemoryLayout<GLfloat>.stride * 8), pointer: pointer1offset)
        
        // TexCoord attribute
        tacx_glEnableVertexAttribArray(index: 2)
        let pointer2offset = UnsafeRawPointer(bitPattern: MemoryLayout<GLfloat>.stride * 6)
        tacx_glVertexAttribPointer(index: 2, size: 2, type: GL_FLOAT,
                                   normalized: false, stride: GLsizei(MemoryLayout<GLfloat>.stride * 8), pointer: pointer2offset)
        
        tacx_glBindBuffer(target: GL_ARRAY_BUFFER, buffer: 0) // Note that this is allowed,
        // the call to glVertexAttribPointer registered VBO as the currently bound
        // vertex buffer object so afterwards we can safely unbind.
        
        tacx_glBindVertexArray(0) // Unbind VAO; it's always a good thing to
        // unbind any buffer/array to prevent strange bugs.
        // remember: do NOT unbind the EBO, keep it bound to this VAO.
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        if (self.framesDisplayed % 2 == 0) {
            self.graphs.forEach { $0.appendPoint() }
        }
        
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        // Render
        // Clear the colorbuffer
        tacx_glClearColor(red: 0.05, green: 0.05, blue: 0.075, alpha: 1.0)
        tacx_glClear(mask: GL_COLOR_BUFFER_BIT)
        
        // Activate shader
        ourShader.use()
        
        var transform = GLKMatrix4Identity
        transform = GLKMatrix4Scale(transform, 1.0, 0.15, 0.5)
        transform = GLKMatrix4Translate(transform, 0, -4, 0)
        
        glUniform2f(ourShader.uSize, GLfloat(view.bounds.size.width/2), GLfloat(view.bounds.size.height/2))
        
        // Draw container
        tacx_glBindVertexArray(VAO)
        
        for graph in self.graphs {
            graph.transform = transform
            graph.draw()
            
            transform = GLKMatrix4Translate(transform, 0, 2, 0)
        }
    }
}
