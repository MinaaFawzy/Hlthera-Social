import UIKit
import Photos
import PhotosUI



@available(iOS 14, *)
class ImagePicker14:NSObject, PHPickerViewControllerDelegate{
    
    static var shared : ImagePicker14 = ImagePicker14()
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        var arr:[UIImage] = []
        let imagesData = results.filter{$0.itemProvider.canLoadObject(ofClass: UIImage.self)}
        
        
        
        
        
        
        
        
        
        
        if let itemProvider = imagesData.first?.itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self)
            { [weak self]  image, error in
                DispatchQueue.main.async {
                  guard let self = self else { return }
                  if let image = image as? UIImage {
                    pickerCallBack?(image)
                    } else {
                        
                        pickerCallBack?(UIImage(systemName: "exclamationmark.circle"))
                    }
                }
            }
        }
        
        
        
        
        
        
  
    }
    
    
    var configuration = PHPickerConfiguration()
    
    func getImage(res:PHPickerResult,completion:@escaping ((UIImage)->()))
    {
        if res.itemProvider.canLoadObject(ofClass: UIImage.self){
            res.itemProvider.loadObject(ofClass: UIImage.self)
            { [weak self]  image, error in
                DispatchQueue.main.async {
                guard let self = self else { return }
                  if let image = image as? UIImage {
                    completion(image)
                    }
                }
            }
        }
        
        
        
        
     
    }

    override init() {
        
    }
    
    func showPicker(filter:PHPickerFilter?,limit:Int,_ handler:PickerImage){
        configuration.filter = filter
        configuration.selectionLimit = limit
        // Create instance of PHPickerViewController
        let picker = PHPickerViewController(configuration: configuration)
        // Set the delegate
        picker.delegate = self
        pickerCallBack = handler
        // Present the picker
        UIApplication.shared.windows.first?.rootViewController?.present(picker, animated: true, completion: {
           
       })
        
    }
}
