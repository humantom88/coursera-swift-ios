import Foundation

public class RedFilter : FilterProtocol {
    public var average: Average
    public var multiplier: Int = 1

    public init(multiplier: Int, average: Average) {
        self.average = average
        self.multiplier = multiplier
    }
    
    public func filter(sourcePixel: Pixel) -> Pixel {
        var newPixel = sourcePixel

        let redDiff = Int(sourcePixel.red) - average.red

        if (redDiff > 0) {
            newPixel.red = UInt8(max(0, min(255, Int(newPixel.red) + redDiff * multiplier)))
        }
        
        return newPixel
    }
}
