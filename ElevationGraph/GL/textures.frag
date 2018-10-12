uniform lowp float _uData[512];
uniform int _uDataSize;
uniform highp vec2 _uSize;

uniform sampler2D _uTexture;

varying lowp vec3 _vPosition;
varying lowp vec3 _vNormal;
varying lowp vec2 _vTexCoord;

lowp vec2 getValue(lowp float x, highp float lineThickness) {
    highp float floatDataSize = float(_uDataSize);
    lowp float halfThickness = 0.5 * lineThickness;
    
    highp float floatIndex = x * floatDataSize;
    int leftIndex = int(floor(floatIndex));
    int rightIndex = int(ceil(floatIndex));
    
    if (floatDataSize < _uSize.x) {
        // Need interpolation
        lowp float leftValue = _uData[leftIndex];
        lowp float rightValue = _uData[rightIndex];
        lowp float diff = rightValue - leftValue;
        lowp float result = leftValue + fract(floatIndex) * diff;
        
        return vec2(result - halfThickness, result + halfThickness);
    }
    else {
        // Need range
        highp float floatOffset = halfThickness * floatDataSize;
        int offset = int(ceil(floatOffset));
        rightIndex = leftIndex + offset;
        
        lowp float leftValue = _uData[leftIndex];
        lowp float rightValue = _uData[rightIndex];
        
        lowp float avg = 0.5 * (leftValue + rightValue);
        lowp float minValue = avg - halfThickness;
        lowp float maxValue = avg + halfThickness;
        
//        lowp float minValue = min(leftValue, rightValue) - halfThickness;
//        lowp float maxValue = max(leftValue, rightValue) + halfThickness;
        
        return vec2(minValue, maxValue);
    }
}

lowp vec4 getColor(lowp float x, lowp float y) {
    
//    highp float dataSizeFloat = float(_uDataSize);
//    lowp float floatIndex = clamp(x * dataSizeFloat, 0.0, dataSizeFloat);
    highp float lineThickness = 4.0/256.0;
    lowp vec2 value = getValue(x, lineThickness);
    
    lowp vec4 backgroundColor = vec4(0.0, 1.0, 0.0, 0.0);
    lowp vec4 lineColor = vec4(0.0, 0.0, 1.0, 1.0);
    
    lowp vec4 plotColor = backgroundColor;
    
    if (y > value[1]);
    else if (y > value[0]) plotColor = lineColor;
    else plotColor = lineColor * 0.5;
    
    return plotColor;
}

void main() {
//    lowp vec4 textureColor = texture2D(_uTexture, _vTexCoord);
    lowp vec4 plotColor = getColor(_vTexCoord.x, _vTexCoord.y);
    
//    gl_FragColor = vec4(textureColor.r, textureColor.g, textureColor.b, plotColor.a);
    gl_FragColor = plotColor;
}
