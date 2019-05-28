import Foundation

public class BlueFilter : FilterProtocol {
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
        
        return newPixel
    }
}
