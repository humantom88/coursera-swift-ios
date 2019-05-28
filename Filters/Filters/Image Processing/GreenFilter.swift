import Foundation

public class GreenFilter : FilterProtocol {
    public var average: Average

    public init(average: Average) {
        self.average = average
    }
    
    public func filter(sourcePixel: Pixel, multiplier: Int) -> Pixel {
        var newPixel = sourcePixel
        
        let greenDiff = Int(sourcePixel.green) - average.green
        
        if (greenDiff > 0) {
            newPixel.green = UInt8(max(0, min(255, Int(newPixel.green) + greenDiff * multiplier)))
        }
        
        return newPixel
    }
}
