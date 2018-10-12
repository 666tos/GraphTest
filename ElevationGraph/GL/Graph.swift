//
//  Graph.swift
//  ElevationGraph
//
//  Created by M Ivaniushchenko on 10/12/18.
//  Copyright © 2018 tos. All rights reserved.
//

import Foundation
import GLKit

let MAX_COUNT = 1024

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
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.graphColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        glUniform3f(self.shader.uLineColor, GLfloat(red), GLfloat(green), GLfloat(blue))
        
        tacx_glDrawElements(mode: GL_TRIANGLES, count: 6, type: GL_UNSIGNED_INT, indices: nil)
    }
    
    private class func prepareData(count: Int) -> [GLfloat] {
        let points = GraphMaskGenerator.generatePoints(count, value: 0.5, min: 0, max: 1)
        let diff = points.max - points.min
        let values: [GLfloat] = points.data.map { GLfloat(($0.y - points.min) / diff) }
        return values
    }
    
    func appendPoint() {
        let random = CGFloat(drand48() - 0.5)
        let delta = GLfloat(0.05 * random)
        let value = self.values[self.filledDataSize] + delta
        let normalizedValue = max(min(value, 1), 0)
        
        if (self.filledDataSize == MAX_COUNT - 1) {
            self.values.remove(at: 0)
            self.values.append(normalizedValue)
        }
        else {
            self.values[self.filledDataSize + 1] = normalizedValue
            self.filledDataSize += 1
        }
    }
}
