attribute highp vec3 _inPosition;
attribute highp vec3 _inNormal;
attribute highp vec2 _inTexCoord;

varying highp vec3 _vPosition;
varying highp vec3 _vNormal;
varying highp vec2 _vTexCoord;

uniform highp mat4 _uTransform;

void main() {
    _vPosition = _inPosition;
    _vNormal = _inNormal;
    _vTexCoord = _inTexCoord;
    
    gl_Position = _uTransform * vec4(_inPosition, 1.0);
}
