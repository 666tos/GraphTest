//
//  BufferTexture.swift
//  ElevationGraph
//
//  Created by M Ivaniushchenko on 10/12/18.
//  Copyright © 2018 tos. All rights reserved.
//

import Foundation
import CoreGraphics
import OpenGLES

open class BufferTexture {
    var id: GLuint
    
    public init() {
        id = 0
        glGenTextures(1, &id)
    }
    
    open func load(_ data: [CGPoint]) -> Bool {
        let floatData: [GLfloat] = data.flatMap { [GLfloat($0.x), GLfloat($0.y)] }
        
        tacx_glBindTexture(target: GL_TEXTURE_2D, texture: id)
        
        tacx_glTexParameteri(target: GL_TEXTURE_2D, pname: GL_TEXTURE_MIN_FILTER, param: GL_NEAREST)
        tacx_glTexParameteri(target: GL_TEXTURE_2D, pname: GL_TEXTURE_MAG_FILTER, param: GL_NEAREST)
        tacx_glTexParameteri(target: GL_TEXTURE_2D, pname: GL_TEXTURE_WRAP_S, param: GL_CLAMP_TO_EDGE)
        tacx_glTexParameteri(target: GL_TEXTURE_2D, pname: GL_TEXTURE_WRAP_T, param: GL_CLAMP_TO_EDGE)
        
        tacx_glTexImage2D(target: GL_TEXTURE_2D, level: 0, internalformat: GL_RG32F, width: GLsizei(floatData.count/2), height: 1, border: 0, format: GL_RG, type: GL_FLOAT, pixels: floatData)
        
        return false
    }
    
}
