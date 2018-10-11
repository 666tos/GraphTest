uniform sampler2D _uTexture;

//varying highp vec3 _vPosition;
//varying highp vec3 _vNormal;
varying highp vec2 _vTexCoord;

void main()
{
    gl_FragColor = texture2D(_uTexture, _vTexCoord);
}
