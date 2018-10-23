//
//  Graph.swift
//  ElevationGraph
//
//  Created by M Ivaniushchenko on 10/12/18.
//  Copyright © 2018 tos. All rights reserved.
//

import Foundation
import GLKit

private let INITIAL_COUNT = 4
private let MAX_COUNT = 1024
private let REDUCE_SIZE = 768

class Graph {
    typealias F = (CGFloat) -> CGFloat
    
    let bufferTexture = BufferTexture()
    var values: [CGPoint] = []
    var transform = GLKMatrix4Identity
    let shader: Shader
    let graphColor: UIColor
    let f: F

    init(shader: Shader, graphColor: UIColor, f: @escaping F) {
        self.shader = shader
        self.graphColor = graphColor
        self.f = f
        self.values = prepareData(count: INITIAL_COUNT)
    }
    
    func draw() {
        _ = self.bufferTexture.load(self.values)
        
        // Bind Texture
        tacx_glBindTexture(target: GL_TEXTURE_2D, texture: self.bufferTexture.id)
        
        glUniform1i(self.shader.uDataSize, GLint(self.values.count))
        glUniform1i(self.shader.uTextureWidth, GLint(self.values.count))
        glUniformMatrix4fv(self.shader.uTransform, 1, 0, self.transform.array)
        glUniform1f(self.shader.uMinX, GLfloat(self.values.first!.x))
        glUniform1f(self.shader.uMaxX, GLfloat(self.values.last!.x))

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        self.graphColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        glUniform3f(self.shader.uLineColor, GLfloat(red), GLfloat(green), GLfloat(blue))
        
        tacx_glDrawElements(mode: GL_TRIANGLES, count: 6, type: GL_UNSIGNED_INT, indices: nil)
    }
    
    private func createPoint(_ i: Int) -> CGPoint {
        let x = CGFloat(i)
        return CGPoint(x: x, y: self.f(x))
    }
    
    private func prepareData(count: Int) -> [CGPoint] {
        var points: [CGPoint] = []
        
        for i in 0 ..< count {
            points.append(self.createPoint(i))
        }
        
        return points
    }
    
    func appendPoints(count: Int = 4) {
        for _ in 0 ..< count {
            let lastPoint = self.values.last!
            
            let point = self.createPoint(Int(lastPoint.x) + 1)
            self.values.append(point)
            
            if (self.values.count >= MAX_COUNT - 1) {
                self.values = DataApproximator.reduceWithDouglasPeukerN(self.values, resultCount: REDUCE_SIZE)
            }
        }
    }
}
