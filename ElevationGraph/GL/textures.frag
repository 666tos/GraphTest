uniform int _uDataSize;
uniform highp vec2 _uSize;
uniform highp float _uMinX;
uniform highp float _uMaxX;

uniform sampler2D _uTexture;
uniform int _uTextureWidth;
uniform highp vec3 _uLineColor;

varying highp vec3 _vPosition;
varying highp vec3 _vNormal;
varying highp vec2 _vTexCoord;

void readTextureValue(highp float x, inout highp vec2 result[2]) {
    highp float fullTextureWidth = float(_uTextureWidth);
    highp float textureStep = 1.0 / fullTextureWidth;
    
    highp vec2 prevData = vec2(-1.0, 0.0);
    
    for ( int i = 0; i < _uDataSize; i++ ) {
        highp float textureX = textureStep * float(i);
        highp vec2 data = texture2D(_uTexture, vec2(textureX, 0.0)).xy;
//        highp vec2 data = testData[i];
        
        if ((x >= prevData.x) && (x < data.x)) {
            result[0] = prevData;
            result[1] = data;
            return;
        }
        
        prevData = data;
    }
    
//    highp float floatIndex = float(x) / fullTextureWidth;
//    return texture2D(_uTexture, vec2(floatIndex, 0)).g;
}

highp vec2 getValue(highp float x, highp float lineThickness) {
    highp float floatDataSize = float(_uDataSize);
    highp float halfThickness = 0.5 * lineThickness;
    
    highp float xPosition = _uMinX + x * (_uMaxX - _uMinX);
   
    highp vec2 graphPoints[2];
    
    readTextureValue(xPosition, graphPoints);
    
//    highp float xLength = graphPoints[1].x - graphPoints[0].x;
//    highp float yLength = graphPoints[1].y - graphPoints[0].y;
//
//    highp float weight = (x - graphPoints[0].x) / xLength;
//    highp float result = graphPoints[0].y + weight * yLength;
//
//    return vec2(result - halfThickness, result + halfThickness);
    
    highp float minY = min(graphPoints[0].y, graphPoints[1].y);
    highp float maxY = max(graphPoints[0].y, graphPoints[1].y);
    
    return vec2(minY - halfThickness, maxY + halfThickness);
}

highp vec4 getColor(highp float x, highp float y) {
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
    highp vec4 plotColor = getColor(_vTexCoord.x, _vTexCoord.y);
    
    gl_FragColor = plotColor;
}
