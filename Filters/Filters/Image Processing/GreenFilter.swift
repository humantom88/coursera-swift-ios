import Foundation

public class GreenFilter : FilterProtocol {
    public var average: Average
    public var multiplier: Int = 1
    
    public init(multiplier: Int, average: Average) {
        self.average = average
        self.multiplier = multiplier
    }
    
    public func filter(sourcePixel: Pixel) -> Pixel {
        var newPixel = sourcePixel
        
        let greenDiff = Int(sourcePixel.green) - average.green
        
        if (greenDiff > 0) {
            newPixel.green = UInt8(max(0, min(255, Int(newPixel.green) + greenDiff * multiplier)))
        }
        
        return newPixel
    }
}
