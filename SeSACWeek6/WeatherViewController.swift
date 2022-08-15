//
//  WeatherViewController.swift
//  SeSACWeek6
//
//  Created by yongseok lee on 2022/08/13.
//

import UIKit
//import MapKit
import CoreLocation
import Kingfisher

class WeatherViewController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var messegaLabel: UILabel!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
  
    
    let locationManager = CLLocationManager()

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        weatherLabelsSet()
        
    }

    func weatherLabelsSet() {
        temperatureLabel.talkLabelsSet()
        messegaLabel.talkLabelsSet()
        humidityLabel.talkLabelsSet()
        windLabel.talkLabelsSet()
        locationLabel.font = .boldSystemFont(ofSize: 24)
        iconImageView.backgroundColor = .white
    }
    
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        checkUserDeviceLocationServiceAuthorization()
    }
    

}

extension WeatherViewController {

   
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            //인스턴스를 통해서 locationManager가 가지고 있는 상태를 가져옴
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }

        if CLLocationManager.locationServicesEnabled() {
            //위치 서비스가 활성화 되어 있으므로, 위치 권한 요청 가능. 위치 권한을 요청함
            checkUserCurrentLaocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다. 위치 서비스를 켜주세요")
            showRequestLocationServiceAlert()
        }
        
    }
    
    func checkUserCurrentLaocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("Not Determined")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
//            locationManager.startUpdatingLocation() //없어도 괜찮나? didChange가 있기 때문에
        case .restricted, .denied:
            print("Denied, 아이폰 설정으로 유도")
        case .authorizedWhenInUse:
            print("When In Use")
            //사용자가 위치를 허용해둔 상태라면, startUpdatingLocation을 통해 didUpdateLocations 메서드가 실행
            locationManager.startUpdatingLocation()
        default: print("Default")
        }
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
         
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
          
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    //Location5. 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)

        if let coordinate = locations.last?.coordinate {
            
            WeatherAPIManager.shared.callRequest(lat: coordinate.latitude, lon: coordinate.longitude) { [self] json in
                print(json)
           
                let iconURL = URL(string: WeatherAPIManager.shared.iconURL(id: json["weather"][0]["icon"].stringValue))
                let temperature = round((json["main"]["temp"].doubleValue - 273.15) * 100) / 100
                
                self.locationLabel.text = json["name"].stringValue
                self.humidityLabel.text = "  오늘의 습도는 \(json["main"]["humidity"].intValue.description)도 입니다  "
                self.messegaLabel.text = "  좋은 하루 되세요  "
                self.temperatureLabel.text = "  오늘의 기온은 \(temperature)도 입니다  "
                self.windLabel.text = "  오늘의 풍속은 \(json["wind"]["speed"].stringValue)입니다  "
                self.iconImageView.kf.setImage(with: iconURL)
                
                dateSet(time: json["dt"].doubleValue)
                convertToAddressWith(coordinate: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
   
            }
 
            print(coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
   

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
  
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { //초기화 될 때 한번 실행된다. 즉 앱 실행할때 호출됨. 그래서 뷰디드로드에 말고 그냥 여기서 호출해도됨
        print(#function)
        checkUserDeviceLocationServiceAuthorization() //아예 첨부터 시작. 위치서비스를 끌 수도 있어서
    }
    
    //13미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func convertToAddressWith(coordinate: CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(coordinate) { (placemarks, error) in
            if error != nil {
                //                NSLog("\(error)")
                print("error")
                return
            }
            guard let placemark = placemarks?.first,
                  let dong = placemark.subLocality,
                  let city = placemark.locality else { return }
            
            self.locationLabel.text = "\(city), \(dong)"
            //출처 https://greenchobo.tistory.com/8    너무 오래된 버전인듯...
        }
    }
    
    func dateSet(time: Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM월 dd일 hh시 mm분"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        let dt = Date(timeIntervalSince1970: time)
        self.dateLabel.text = formatter.string(from: dt)
    }
}
