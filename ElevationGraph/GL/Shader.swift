import Foundation
import GLKit

public class Shader {

    public private(set) var program: GLuint = 0
    public private(set) var uDataSize: Int32 = 0
    public private(set) var uSize: Int32 = 0
    public private(set) var uTextureWidth: Int32 = 0
    public private(set) var uTransform: Int32 = 0
    public private(set) var uLineColor: Int32 = 0
    public private(set) var uMinX: Int32 = 0
    public private(set) var uMaxX: Int32 = 0

    public init(vertex:String, fragment:String)
    {
        let vertexID = tacx_glCreateShader(type: GL_VERTEX_SHADER)
        defer{ glDeleteShader(vertexID) }
        if let errorMessage = Shader.compileShader(vertexID, source: vertex) {
            fatalError(errorMessage)
        }
        let fragmentID = tacx_glCreateShader(type: GL_FRAGMENT_SHADER)
        defer{ glDeleteShader(fragmentID) }
        if let errorMessage = Shader.compileShader(fragmentID, source: fragment) {
            fatalError(errorMessage)
        }
        self.program = tacx_glCreateProgram()
        if let errorMessage = linkProgram(program, vertex: vertexID, fragment: fragmentID) {
            fatalError(errorMessage)
        }
    }


    public convenience init(vertexFile:String, fragmentFile:String)
    {
        
        do {
            
            let vertexData = try Data(contentsOf: Bundle.main.url(forResource: vertexFile, withExtension: nil)!, options: [.uncached, .alwaysMapped])
            let fragmentData = try Data(contentsOf: Bundle.main.url(forResource: fragmentFile, withExtension: nil)!, options: [.uncached, .alwaysMapped])
            let vertexString = String(data: vertexData, encoding: .utf8)!
            let fragmentString = String(data: fragmentData, encoding: .utf8)!
            self.init(vertex: vertexString, fragment: fragmentString)
        }
        catch let error as NSError {
            fatalError(error.localizedFailureReason!)
        }
        catch {
            fatalError(String(describing: error))
        }
    }


    deinit
    {
        tacx_glDeleteProgram(program)
    }


    public func use()
    {
        tacx_glUseProgram(program)
    }


    private static func compileShader(_ shader: GLuint, source: String) -> String?
    {
        var cStringSource = (source as NSString).utf8String
        
        tacx_glShaderSource(shader: shader, count: 1, string: &cStringSource, length: nil)
        
        tacx_glCompileShader(shader)
        var success:GLint = 1
        tacx_glGetShaderiv(shader: shader, pname: GL_COMPILE_STATUS, params: &success)
        if success != GL_TRUE {
            var logSize:GLsizei = 0
            tacx_glGetShaderiv(shader: shader, pname: GL_INFO_LOG_LENGTH, params: &logSize)
            if logSize == 0 { return "" }
            var infoLog = [GLchar](repeating: 0, count: Int(logSize))
            tacx_glGetShaderInfoLog(shader: shader, bufsize: logSize, length: nil, infolog: &infoLog)
            return String(cString:infoLog)
        }
        return nil
    }


    private func linkProgram(_ program: GLuint, vertex: GLuint, fragment: GLuint) -> String?
    {
        tacx_glAttachShader(program: program, shader: vertex)
        tacx_glAttachShader(program: program, shader: fragment)
        
        glBindAttribLocation(program, 0, "_inPosition")
        glBindAttribLocation(program, 1, "_inNormal")
        glBindAttribLocation(program, 2, "_inTexCoord")
        
        tacx_glLinkProgram(program)
        
        uDataSize = glGetUniformLocation(program, "_uDataSize")
        uSize = glGetUniformLocation(program, "_uSize")
        uTextureWidth = glGetUniformLocation(program, "_uTextureWidth")
        uTransform = glGetUniformLocation(program, "_uTransform")
        uLineColor = glGetUniformLocation(program, "_uLineColor")
        uMinX = glGetUniformLocation(program, "_uMinX")
        uMaxX = glGetUniformLocation(program, "_uMaxX")

        var success:GLint = 1
        tacx_glGetProgramiv(program: program, pname: GL_LINK_STATUS, params: &success)
        if success != GL_TRUE {
        var logSize:GLint = 0
            tacx_glGetProgramiv(program: program, pname: GL_INFO_LOG_LENGTH, params: &logSize)
            if logSize == 0 { return "" }
            var infoLog = [GLchar](repeating: 0, count: Int(logSize))
            tacx_glGetProgramInfoLog(program: program, bufsize: logSize, length: nil, infolog: &infoLog)
            return String(cString:infoLog)
        }
        return nil
    }

}
