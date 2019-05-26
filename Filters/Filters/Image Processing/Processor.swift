import UIKit

public struct FiltersState: OptionSet, Hashable {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    static let none = FiltersState(rawValue: 0)
    static let redFilter = FiltersState(rawValue: 1 << 0)
    static let greenFilter = FiltersState(rawValue: 1 << 1)
    static let blueFilter = FiltersState(rawValue: 1 << 2)
}

public class Processor {
    
    var filters: [FiltersState: FilterProtocol]
    
    public init(average: Average) {
        self.filters = [
            FiltersState.redFilter: RedFilter(multiplier: 5, average: average),
            FiltersState.greenFilter: GreenFilter(multiplier: 5, average: average),
            FiltersState.blueFilter: BlueFilter(multiplier: 5, average: average)
        ]
    }
    
    public func processImage(image: inout RGBAImage, filtersState: FiltersState) {
        for y in 0..<image.height {
            for x in 0..<image.width {
                let index = y * image.width + x
                let pixel = image.pixels[index]
                
                let newPixel: Pixel = pixel
                
                image.pixels[index] = processPixel(pixel: newPixel, filtersState: filtersState)
            }
        }
    }
    
    public func processUIImage(image: UIImage, filteredState: FiltersState) -> UIImage {
        var rgbaImage = RGBAImage.init(image: image)
        
        processImage(image: &rgbaImage!, filtersState: filteredState)
        
        return rgbaImage!.toUIImage() ?? image
    }
    
    private func processPixel(pixel: Pixel, filtersState: FiltersState) -> Pixel {
        var processedPixel = pixel
        
        processedPixel = applyFilter(pixel: processedPixel, filtersState: filtersState, filter: FiltersState.redFilter)
        processedPixel = applyFilter(pixel: processedPixel, filtersState: filtersState, filter: FiltersState.greenFilter)
        processedPixel = applyFilter(pixel: processedPixel, filtersState: filtersState, filter: FiltersState.blueFilter)
        
        return processedPixel
    }
    
    private func applyFilter(pixel: Pixel, filtersState: FiltersState, filter: FiltersState) -> Pixel {
        if (filtersState.contains(filter)) {
            return self.filters[filter]?.filter(sourcePixel: pixel) ?? pixel
        }
        
        return pixel
    }
}

/*
 let image = UIImage(named: "sample")
 
 // Declare the RGBAImage
 var myRGBA = RGBAImage(image: image!)
 
 // Workflow
 let average = Average.getAverageFromImage(rgb: myRGBA!)
 
 let redFilter = RedFilter(multiplier: 5, average: average!)
 let greenFilter = GreenFilter(multiplier: 5, average: average!)
 let blueFilter = BlueFilter(multiplier: 5, average: average!)
 let brightnessFilter = BrightnessFilter(multiplier: 3, average: average!)
 let secondGreenFilter = GreenFilter(multiplier: 2, average: average!)
 
 let filtersPipeline = [redFilter, greenFilter, brightnessFilter]
 
 let processor = Processor(filters: filtersPipeline)
 
 var anotherImage = RGBAImage(image: image!)
 processor.processImage(image: &anotherImage!)
 
 let realImage = anotherImage!.toUIImage()

 */
