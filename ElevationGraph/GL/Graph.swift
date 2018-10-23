//
//  Graph.swift
//  ElevationGraph
//
//  Created by M Ivaniushchenko on 10/12/18.
//  Copyright © 2018 tos. All rights reserved.
//

import Foundation
import GLKit

let MAX_COUNT = 128
let REDUCE_SIZE = 20

class Graph {
    let bufferTexture = BufferTexture()
    var filledDataSize = 0
    var values = prepareData(count: MAX_COUNT)
    var transform = GLKMatrix4Identity
    let shader: Shader
    let graphColor: UIColor

    init(shader: Shader, graphColor: UIColor) {
        self.shader = shader
        self.graphColor = graphColor
    }
    
    func draw() {
        _ = self.bufferTexture.load(self.values)
        
        // Bind Texture
        tacx_glBindTexture(target: GL_TEXTURE_2D, texture: self.bufferTexture.id)
        
        glUniform1i(self.shader.uDataSize, GLint(self.filledDataSize))
        glUniform1i(self.shader.uTextureWidth, GLint(MAX_COUNT))
        glUniformMatrix4fv(self.shader.uTransform, 1, 0, self.transform.array)
        glUniform1f(self.shader.uMinX, GLfloat(self.values.first!.x))
        glUniform1f(self.shader.uMaxX, GLfloat(self.values[self.filledDataSize].x))
//        glUniform1f(self.shader.uMinX, GLfloat(0))
//        glUniform1f(self.shader.uMaxX, GLfloat(MAX_COUNT))

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.graphColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        glUniform3f(self.shader.uLineColor, GLfloat(red), GLfloat(green), GLfloat(blue))
        
        tacx_glDrawElements(mode: GL_TRIANGLES, count: 6, type: GL_UNSIGNED_INT, indices: nil)
    }
    
    private class func createPoint(_ i: Int) -> CGPoint {
        let x = CGFloat(i)
        let value = sin(CGFloat(x)/30.0) / 2.0 + 0.5
        return CGPoint(x: x, y: value)
    }
    
    private class func prepareData(count: Int) -> [CGPoint] {
        var points: [CGPoint] = []
        
        for i in 0 ..< count {
            points.append(createPoint(i))
        }
        
        return points
    }
    
    func appendPoint() {
        let lastPoint = self.values[self.filledDataSize]
        
//        let random = CGFloat(drand48() - 0.5)
//        let delta = random / 10
//        let value = max(min(lastPoint.y + delta, 1), 0)
        let point = Graph.createPoint(Int(lastPoint.x) + 1)
        
        if (self.filledDataSize == MAX_COUNT - 1) {
            self.values.remove(at: 0)
            self.values.append(point)
//            self.values = DataApproximator.reduceWithDouglasPeukerN(self.values, resultCount: REDUCE_SIZE)
        }
        else {
            self.values[self.filledDataSize + 1] = point
            self.filledDataSize += 1
        }
    }
}
