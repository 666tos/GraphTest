//
//  GLCommands.swift
//  ElevationGraph
//
//  Created by M Ivaniushchenko on 10/11/18.
//  Copyright © 2018 tos. All rights reserved.
//

import Foundation
import GLKit

extension GLKMatrix4 {
    var array: [GLfloat] {
        return (0..<16).map { i in
            self[i]
        }
    }
}

public func tacx_glCreateShader(type: Int32) -> GLuint {
    return glCreateShader(GLenum(type))
}

public func tacx_glShaderSource(shader:GLuint, count:GLsizei, string:UnsafePointer<UnsafePointer<GLchar>?>!, length:UnsafePointer<GLint>!) {
    glShaderSource(shader, count, string, length)
}

public func tacx_glViewport(x: GLint, y: GLint, width: GLsizei, height: GLsizei) {
    glViewport(x, y, width, height)
}

public func tacx_glGetShaderiv(shader: GLuint, pname: Int32, params: UnsafeMutablePointer<GLint>!) {
    glGetShaderiv(shader, GLenum(pname), params)
}

public func tacx_glGetProgramInfoLog(program: GLuint, bufsize: GLsizei, length: UnsafeMutablePointer<GLsizei>!, infolog: UnsafeMutablePointer<GLchar>!) {
    glGetProgramInfoLog(program, bufsize, length, infolog)
}

public func tacx_glGetShaderInfoLog(shader: GLuint, bufsize: GLsizei, length: UnsafeMutablePointer<GLsizei>!, infolog: UnsafeMutablePointer<GLchar>!) {
    glGetShaderInfoLog(shader, bufsize, length, infolog)
}

public func tacx_glGetProgramiv(program: GLuint, pname: Int32, params: UnsafeMutablePointer<GLint>!) {
    glGetProgramiv(program, GLenum(pname), params)
}

public func tacx_glCreateProgram() -> GLuint {
    return glCreateProgram()
}

public func tacx_glDeleteProgram(_ program: GLuint) {
    return glDeleteProgram(program)
}

public func tacx_glUseProgram(_ program: GLuint) {
    return glUseProgram(program)
}

public func tacx_glCompileShader(_ shader: GLuint) {
    glCompileShader(shader)
}

public func tacx_glAttachShader(program: GLuint, shader: GLuint) {
    glAttachShader(program, shader)
}

public func tacx_glLinkProgram(_ program: GLuint) {
    return glLinkProgram(program)
}

public func tacx_glTexParameteri(target: Int32, pname: Int32, param: GLint) {
    glTexParameteri(GLenum(target), GLenum(pname), param)
}

public func tacx_glBindBuffer(target: Int32, buffer: GLuint) {
    glBindBuffer(GLenum(target), buffer)
}

public func tacx_glBindVertexArray(_ array: GLuint) {
    glBindVertexArray(array)
}

public func tacx_glTexImage2D(target:Int32, level:GLint, internalformat:GLint, width:GLsizei, height:GLsizei, border:GLint, format:Int32, type:Int32, pixels:UnsafeRawPointer?) {
    glTexImage2D(GLenum(target), level, internalformat, width, height, border, GLenum(format), GLenum(type), pixels)
}

public func tacx_glClearColor(red: GLfloat, green: GLfloat, blue: GLfloat, alpha: GLfloat) {
    glClearColor(red, green, blue, alpha)
}

public func tacx_glClear(mask:Int32) {
    glClear(GLbitfield(mask))
}

public func tacx_glGenVertexArrays(n:GLsizei, arrays:UnsafeMutablePointer<GLuint>?) {
    glGenVertexArrays(n, arrays)
}

public func tacx_glGenBuffers(n:GLsizei, buffers:UnsafeMutablePointer<GLuint>?) {
    glGenBuffers(n, buffers)
}

public func tacx_glEnableVertexAttribArray(index:GLuint) {
    glEnableVertexAttribArray(index)
}

public func tacx_glBufferData(target:Int32, size:GLsizeiptr, data:UnsafeRawPointer?, usage:Int32) {
    glBufferData(GLenum(target), size, data, GLenum(usage))
}

public func tacx_glVertexAttribPointer(index:GLuint, size:GLint, type:Int32, normalized:Bool, stride:GLsizei, pointer:UnsafeRawPointer?) {
    glVertexAttribPointer(index, size, GLenum(type), GLboolean(normalized ? 1 : 0), stride, pointer)
}

public func tacx_glGenTextures(n:GLsizei, textures:UnsafeMutablePointer<GLuint>?) {
    glGenTextures(n, textures)
}

public func tacx_glBindTexture(target:Int32, texture:GLuint) {
    glBindTexture(GLenum(target), texture)
}

public func tacx_glDrawElements(mode:Int32, count:GLsizei, type:Int32, indices:UnsafeRawPointer?) {
    glDrawElements(GLenum(mode), count, GLenum(type), indices)
}

public func tacx_glDrawArrays(mode:Int32, first: GLint, count:GLsizei) {
    glDrawArrays(GLenum(mode), first, count)
}
