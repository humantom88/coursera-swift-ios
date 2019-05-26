import Foundation

public class BlueFilter : FilterProtocol {
    public var average: Average
    public var multiplier: Int = 1
    
    public init(multiplier: Int, average: Average) {
        self.average = average
        self.multiplier = multiplier
    }
    
    public func filter(sourcePixel: Pixel) -> Pixel {
        var newPixel = sourcePixel
        
        let blueDiff = Int(sourcePixel.blue) - average.blue
        
        if (blueDiff > 0) {
            newPixel.blue = UInt8(max(0, min(255, Int(newPixel.blue) + blueDiff * multiplier)))
        }
        
        return newPixel
    }
}
