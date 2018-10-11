attribute lowp vec3 _inPosition;
attribute lowp vec3 _inNormal;
attribute lowp vec2 _inTexCoord;

varying lowp vec3 _vPosition;
varying lowp vec3 _vNormal;
varying lowp vec2 _vTexCoord;

void main() {
    _vPosition = _inPosition;
    _vNormal = _inNormal;
    _vTexCoord = _inTexCoord;
    
    gl_Position = vec4(_inPosition, 1.0);
}
