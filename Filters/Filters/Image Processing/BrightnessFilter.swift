import Foundation

import Foundation

public class BrightnessFilter : FilterProtocol {
    public var average: Average
    
    public init(average: Average) {
        self.average = average
    }
    
    public func filter(sourcePixel: Pixel, multiplier: Int) -> Pixel {
        var newPixel = sourcePixel
        
        let blueDiff = Int(sourcePixel.blue) - average.blue
        
        if (blueDiff > 0) {
            newPixel.blue = UInt8(max(0, min(255, Int(newPixel.blue) + blueDiff * multiplier)))
        }
        
        let redDiff = Int(sourcePixel.red) - average.red
        
        if (redDiff > 0) {
            newPixel.red = UInt8(max(0, min(255, Int(newPixel.red) + redDiff * multiplier)))
        }
        
        let greenDiff = Int(sourcePixel.green) - average.green
        
        if (greenDiff > 0) {
            newPixel.green = UInt8(max(0, min(255, Int(newPixel.green) + greenDiff * multiplier)))
        }
        
        return newPixel
    }
}
