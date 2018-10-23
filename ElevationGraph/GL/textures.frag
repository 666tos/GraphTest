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
        
        if ((x >= prevData.x) && (x < data.x)) {
            result[0] = prevData;
            result[1] = data;
            return;
        }
        
        prevData = data;
    }
}

highp vec2 getValue(highp float x, highp float lineThickness) {
    highp float floatDataSize = float(_uDataSize);
    highp float halfThickness = 0.5 * lineThickness;
    
    highp float xPosition = _uMinX + x * (_uMaxX - _uMinX);
   
    highp vec2 graphPoints[2];
    
    readTextureValue(xPosition, graphPoints);
    
    highp float xLength = graphPoints[1].x - graphPoints[0].x;
    highp float yLength = graphPoints[1].y - graphPoints[0].y;

    highp float weight = (xPosition - graphPoints[0].x) / xLength;
    highp float result = graphPoints[0].y + weight * yLength;
    
    highp float minY = min(result - halfThickness, result + halfThickness);
    highp float maxY = max(result - halfThickness, result + halfThickness);

    return vec2(minY, maxY);
}

highp vec4 getColor(highp float x, highp float y) {
    highp float lineThickness = 4.0/256.0;
    highp float aa = lineThickness/2.0;
    highp vec2 value = getValue(x, lineThickness);
    
    highp vec4 backgroundColor = vec4(0.0, 0.0, 0.0, 0.0);
    highp vec4 plotColor = vec4(_uLineColor, 1.0);
    
    if (y > value[1] + aa) plotColor = backgroundColor;
    else if (y > value[1]) plotColor = plotColor * (1.0 - (y - value[1]) / aa);
    else if (y > value[0]);
    else if (y > value[0] - aa) plotColor = plotColor * (2.0 + (y - value[0]) / aa) / 2.0;
    else plotColor = plotColor * 0.5;
    
//    if (y > value[1]) plotColor = backgroundColor;
//    else if (y > value[0]);
//    else plotColor = plotColor * 0.5;
    
    return plotColor;
}

void main() {
    highp vec4 plotColor = getColor(_vTexCoord.x, _vTexCoord.y);
    
    gl_FragColor = plotColor;
}
