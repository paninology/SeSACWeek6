//
//  CameraViewController.swift
//  SeSACWeek6
//
//  Created by yongseok lee on 2022/08/12.
//

import UIKit

import Alamofire
import SwiftyJSON
import YPImagePicker
import Kingfisher

class CameraViewController: UIViewController {

 
    @IBOutlet weak var photoImageView: UIImageView!
    
    //UIImagePickerController1
    
    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIImagePickerController2.
        picker.delegate = self

        
    }
    
    //오픈소스
    //권한 다 허용하기
    //권한 문구 등도 내부적으로 구현. 실제 카메라를 쓸 때 권한을 요청
    
    @IBAction func YPImagePickerClicked(_ sender: UIButton) {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.photoImageView.image = photo.image
                
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonClicked(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용불가 + 토스트/얼럿")
            return }
        picker.sourceType = .camera
        picker.allowsEditing = true
        
        present(picker, animated: true)
        
    }
    
    
    @IBAction func photoLibaryClicked(_ sender: UIButton) {
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용불가 + 토스트/얼럿")
            return
        }
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        
        present(picker, animated: true)
    }
    
    @IBAction func saveToPhotoLibrary(_ sender: UIButton) {
        
        if let image = photoImageView.image {
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    //이미지뷰 이미지 > 네이버 > 얼굴 분석 해줘 요청 > 응답
    //문자열이 아닌 파일, 이미지, pdf 파일 자체가 그대로 전송되지 않음. => 텍스트 형태로 인코딩
    //어떤 파일의 종류가 서버에게 전달이 되는 지 명시 = Content-Type
    @IBAction func FaceRecogButtonClicked(_ sender: Any) {
        let url = "https://openapi.naver.com/v1/vision/celebrity"
        let header: HTTPHeaders = [
        "X-Naver-Client-Id": "cWhxaKlp9yJW_KS0k2dx",
        "X-Naver-Client-Secret": "Rkulw9Qt8g",
        "Content-Type": "multipart/form-data" //안해도됨. 라이브러리에 내장되어있음
        ]
        
        //UIImage를 텍스트 형태(바이너리 타입)로 변환해서 전달
        guard let imageData = photoImageView.image?.jpegData(compressionQuality: 0.5) else { return }
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "image")
        }, to: url, headers: header)
        .validate(statusCode: 200...500).responseData { response in
            switch response.result {
            case.success(let value):
                let json = JSON(value)
                print(json)
                
            case .failure(let error):
                print(error)
            }
        }
        
        
//        if let image = photoImageView.image {
//
//        }
    }
    
}

//UIImagePickerController3
//네비게이션 컨트롤러를 상속받고 있음.
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //UIImagePickerController4. 사진을 선택하거나 카메라 촬영 직후
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#function)
        
        //원본, 편집, 메타 데이터 등 - infoKey
        
        if picker.sourceType == .camera {
            
        }
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            self.photoImageView.image = image
            
            dismiss(animated: true)
            
        }
    }
    
    //UIImagePickerController5. 취소버튼 클릭시
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
    }
    
}
