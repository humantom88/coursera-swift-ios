import Foundation

public class RedFilter : FilterProtocol {
    public var average: Average

    public init(average: Average) {
        self.average = average
    }
    
    public func filter(sourcePixel: Pixel, multiplier: Int) -> Pixel {
        var newPixel = sourcePixel

        let redDiff = Int(sourcePixel.red) - average.red

        if (redDiff > 0) {
            newPixel.red = UInt8(max(0, min(255, Int(newPixel.red) + redDiff * multiplier)))
        }
        
        return newPixel
    }
}
