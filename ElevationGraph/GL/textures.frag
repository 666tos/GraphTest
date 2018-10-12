uniform int _uDataSize;
uniform highp vec2 _uSize;

uniform sampler2D _uTexture;
uniform int _uTextureWidth;
uniform lowp vec3 _uLineColor;

varying lowp vec3 _vPosition;
varying lowp vec3 _vNormal;
varying lowp vec2 _vTexCoord;

highp float readTextureValue(int x) {
    highp float fullTextureWidth = float(_uTextureWidth);
//    highp float scale = float(_uDataSize) / float(fullTextureWidth);
    highp float floatIndex = float(x) / fullTextureWidth;
    return texture2D(_uTexture, vec2(floatIndex, 0)).r;
}

highp vec2 getValue(lowp float x, highp float lineThickness) {
    highp float floatDataSize = float(_uDataSize);
    lowp float halfThickness = 0.5 * lineThickness;
    
    highp float floatIndex = x * floatDataSize;
    int leftIndex = int(floor(floatIndex));
    int rightIndex = int(ceil(floatIndex));
    
//    if (floatDataSize < _uSize.x) {
        // Need interpolation
        highp float leftValue = readTextureValue(leftIndex);
        highp float rightValue = readTextureValue(rightIndex);
        highp float diff = rightValue - leftValue;
        highp float result = leftValue + fract(floatIndex) * diff;
        
        return vec2(result - halfThickness, result + halfThickness);
//    }
//    else {
//        // Need range
//        highp float floatOffset = halfThickness * floatDataSize;
//        int offset = int(ceil(floatOffset));
//        rightIndex = leftIndex + offset;
//
//        highp float leftValue = readTextureValue(leftIndex);
//        highp float rightValue = readTextureValue(rightIndex);
//
//        highp float avg = 0.5 * (leftValue + rightValue);
//        highp float minValue = avg - halfThickness;
//        highp float maxValue = avg + halfThickness;
//
////        lowp float minValue = min(leftValue, rightValue) - halfThickness;
////        lowp float maxValue = max(leftValue, rightValue) + halfThickness;
//
//        return vec2(minValue, maxValue);
//    }
}

highp vec4 getColor(highp float x, highp float y) {
    
//    highp float dataSizeFloat = float(_uDataSize);
//    lowp float floatIndex = clamp(x * dataSizeFloat, 0.0, dataSizeFloat);
    highp float lineThickness = 4.0/256.0;
    highp vec2 value = getValue(x, lineThickness);
    
    highp vec4 backgroundColor = vec4(0.0, 0.0, 0.0, 0.0);
    highp vec4 plotColor = vec4(_uLineColor, 1.0);
    
    if (y > value[1]) plotColor = backgroundColor;
    else if (y > value[0]);
    else plotColor = plotColor * 0.5;
    
    return plotColor;
}

void main() {
//    lowp vec4 textureColor = texture2D(_uTexture, vec2(_vTexCoord.x, 0));
    highp vec4 plotColor = getColor(_vTexCoord.x, _vTexCoord.y);
    
//    gl_FragColor = vec4(textureColor.r, textureColor.g, textureColor.b, plotColor.a);
    gl_FragColor = plotColor;
}
