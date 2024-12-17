import UIKit
//import AlamofireImage

extension UIImage {
    
    func blur(_ radius: Double) -> UIImage? {
        if let img = CIImage(image: self) {
            return UIImage(ciImage: img.applyingGaussianBlur(sigma: radius))
        }
        return nil
    }

  
    func imageWithSize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        draw(in: rect)
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultingImage
    }
    func ResizeImageOriginalSize(targetSize: CGSize) -> UIImage? {
        var actualHeight: Float = Float(self.size.height)
        var actualWidth: Float = Float(self.size.width)
        let maxHeight: Float = Float(targetSize.height)
        let maxWidth: Float = Float(targetSize.width)
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        var compressionQuality: Float = 1.0
        //50 percent compression

        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1.0
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, CGFloat(compressionQuality))
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    func imageWithSize(size: CGSize, extraMargin: CGFloat) -> UIImage? {
        
        let imageSize = CGSize(width: size.width + extraMargin * 2, height: size.height + extraMargin * 2)
        UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
        let drawingRect = CGRect(x: extraMargin, y: extraMargin, width: size.width, height: size.height)
        draw(in: drawingRect)
        let resultingImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultingImage
    }
    

    
    func imageWithSize(size: CGSize, roundedRadius radius: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if let currentContext = UIGraphicsGetCurrentContext() {
            let rect = CGRect(origin: .zero, size: size)
            currentContext.addPath(UIBezierPath(roundedRect: rect,
                                                byRoundingCorners: .allCorners,
                                                cornerRadii: CGSize(width: radius, height: radius)).cgPath)
            currentContext.clip()
            
            // Don't use CGContextDrawImage, coordinate system origin in UIKit and Core Graphics are vertical oppsite.
            draw(in: rect)
            currentContext.drawPath(using: .fillStroke)
            let roundedCornerImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return roundedCornerImage
        }
        return nil
    }
    
}


//extension UIImageView {
//
//    //MARK:- Load Image From String Using Almofire
//
//    func loadImage(_ urlString: String?, with placeHolder: UIImage) -> Void {
//        guard let url = (URL.init(string: String.getString(urlString)))?.absoluteURL else {return}
//        self.af_setImage(withURL: url, placeholderImage: placeHolder)
//    }
//}
