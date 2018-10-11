attribute highp vec3 _inPosition;
attribute highp vec3 _inNormal;
attribute highp vec2 _inTexCoord;

//varying highp vec3 _vPosition;
//varying highp vec3 _vNormal;
varying highp vec2 _vTexCoord;

void main()
{
    _vTexCoord = _inTexCoord;
//    _vPosition = _inPosition.xyz;
//    _vNormal = _inNormal.xyz;
    
    gl_Position = vec4(_inPosition, 1.0);
}
