import UIKit

public class Average {
    public var red: Int
    public var green: Int
    public var blue: Int
    
    public init(red: Int, green: Int, blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
    }
    
    public class func getAverageFromUIImage(uiImage: UIImage) -> Average? {
        return Average.getAverageFromImage(rgb: RGBAImage(image: uiImage)!)
    }
    
    public class func getAverageFromImage(rgb: RGBAImage) -> Average? {
        var totalRed = 0
        var totalGreen = 0
        var totalBlue = 0
        
        for y in 0..<rgb.height {
            for x in 0..<rgb.width {
                let index = y * rgb.width + x
                var pixel = rgb.pixels[index]
                totalRed += Int(pixel.red)
                totalGreen += Int(pixel.green)
                totalBlue += Int(pixel.blue)
            }
        }
        
        let count = rgb.width * rgb.height
        
        return Average(red:totalRed / count, green: totalGreen / count, blue:totalBlue / count)
    }
}
