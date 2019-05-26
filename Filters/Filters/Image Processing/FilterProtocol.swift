import Foundation

public protocol FilterProtocol {
    func filter(sourcePixel: Pixel) -> Pixel;
}

public enum Channel : String {
    case RED
    case GREEN
    case BLUE
}
