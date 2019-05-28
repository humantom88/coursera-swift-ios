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
    
    var multiplier = 5
    
    public init(average: Average) {
        self.filters = [
            FiltersState.redFilter: RedFilter(average: average),
            FiltersState.greenFilter: GreenFilter(average: average),
            FiltersState.blueFilter: BlueFilter(average: average)
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
            return self.filters[filter]?.filter(sourcePixel: pixel, multiplier: multiplier) ?? pixel
        }
        
        return pixel
    }
}
