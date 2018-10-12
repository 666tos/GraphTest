//
//  GLViewController.swift
//  ElevationGraph
//
//  Created by M Ivaniushchenko on 10/11/18.
//  Copyright © 2018 tos. All rights reserved.
//

import UIKit
import GLKit

let WIDTH:GLsizei = 800, HEIGHT:GLsizei = 600

class GLViewController: GLKViewController {
    
    var ourShader: Shader!
    var texture: Texture!
    var VBO:GLuint=0, EBO:GLuint=0, VAO:GLuint=0
    var values = prepareData(count: 4)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = EAGLContext(api: .openGLES3)!
        
        let glView = self.view as! GLKView
        glView.context = context
        glView.drawableDepthFormat = .format24
        glView.drawableColorFormat = .RGBA8888
        
        EAGLContext.setCurrent(context)
        
        // Build and compile our shader program
        
        self.ourShader = Shader(vertexFile: "textures.vs", fragmentFile: "textures.frag")
        
        // Load image from disk
        self.texture = Texture(filename: "container2.png")
        
        // Set up vertex data
//        let vertices:[GLfloat] = [
//            // Positions       // Normals        // Texture Coords
//             1.0,  1.0, 0.0,   0.0, 0.0, 1.0,   1.0, 1.0,
//            -1.0,  1.0, 0.0,   0.0, 0.0, 1.0,   0.0, 1.0,
//             1.0, -1.0, 0.0,   0.0, 0.0, 1.0,   1.0, 0.0,
//             1.0, -1.0, 0.0,   0.0, 0.0, 1.0,   1.0, 0.0,
//            -1.0,  1.0, 0.0,   0.0, 0.0, 1.0,   0.0, 1.0,
//            -1.0, -1.0, 0.0,   0.0, 0.0, 1.0,   0.0, 0.0,
//        ]
        
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
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        // Render
        // Clear the colorbuffer
        tacx_glClearColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        tacx_glClear(mask: GL_COLOR_BUFFER_BIT)
        
        // Activate shader
        ourShader.use()
        
        if (self.framesDisplayed % 2 == 0) {
            self.appendPoint()
        }
        
        glUniform1i(ourShader.uDataSize, GLint(values.count))
        glUniform1fv(ourShader.uData, GLsizei(values.count), values)
        glUniform2f(ourShader.uSize, GLfloat(view.bounds.size.width/2), GLfloat(view.bounds.size.height/2))
        
        // Bind Texture
        tacx_glBindTexture(target: GL_TEXTURE_2D, texture: self.texture.id)
        
        // Draw container
        tacx_glBindVertexArray(VAO)
        tacx_glDrawElements(mode: GL_TRIANGLES, count: 6, type: GL_UNSIGNED_INT, indices: nil)
    }
    
    private class func prepareData(count: Int) -> [GLfloat] {
        let points = GraphMaskGenerator.generatePoints(count, value: 0.5, min: 0, max: 1)
        let diff = points.max - points.min
        let values: [GLfloat] = points.data.map { GLfloat(($0.y - points.min) / diff) }
        return values
    }
    
    private func appendPoint() {
        if (self.values.count > 512) {
            return;
        }
        
        let random = CGFloat(drand48() - 0.5)
        let delta = GLfloat(0.02 * random)
        let value = self.values.last! + delta
        let normalizedValue = max(min(value, 1), 0)
        self.values.append(normalizedValue)
    }
}
