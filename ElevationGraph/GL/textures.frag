uniform lowp float _uData[512];
uniform int _uDataSize;

uniform sampler2D _uTexture;

varying lowp vec3 _vPosition;
varying lowp vec3 _vNormal;
varying lowp vec2 _vTexCoord;

lowp float getValue(int index) {
    return _uData[index];
}

lowp vec4 getColor(lowp float value, lowp float y) {
    lowp vec4 backgroundColor = vec4(0.0, 1.0, 0.0, 0.0);
    lowp vec4 lineColor = vec4(0.0, 0.0, 1.0, 1.0);
    lowp float halfThickness = 1.0/256.0;
    
    lowp vec4 plotColor = backgroundColor;
    
    if (y > value + halfThickness);
    else if (y > value - halfThickness) plotColor = lineColor;
    else plotColor = lineColor * 0.5;
    
    return plotColor;
}

void main() {
    lowp float dataSizeFloat = float(_uDataSize);
    lowp float floatIndex = clamp(_vTexCoord.x * dataSizeFloat, 0.0, dataSizeFloat);
    lowp float value = getValue(int(floatIndex));
    lowp vec4 textureColor = texture2D(_uTexture, _vTexCoord);
    lowp vec4 plotColor = getColor(value, _vTexCoord.y);
    
//    gl_FragColor = vec4(textureColor.r, textureColor.g, textureColor.b, plotColor.a);
    gl_FragColor = plotColor;
}
