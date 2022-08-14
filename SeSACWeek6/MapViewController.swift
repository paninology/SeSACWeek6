//
//  MapViewController.swift
//  SeSACWeek6
//
//  Created by yongseok lee on 2022/08/11.
//

import UIKit
import MapKit
//Location1. 임포트
import CoreLocation

/*
 MAPVIEW
 -지도와 위치 권한은 상관없다.
 -만약 지도에 현재 위치 등을 표현하고 싶다면 위치 권한을 등록해야함
 -중심, 범위 지정
 -핀은 별개
 
 */

//권한: 반영이 조금씩 느릴 수 있음. 지웠다가 실행해도
class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    //Location2. 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location3 프로토콜 연결
        locationManager.delegate = self
//        checkUserDeviceLocationServiceAuthorization() 제거 가능한 이유 알기. 사이클 이해하기
        //지도 중심 설정: 애플앱 활용해 좌표 복사
        let center = CLLocationCoordinate2D(latitude: 37.534355, longitude: 126.901907)
        setRegionAndAnnotation(center: center)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
         
        showRequestLocationServiceAlert()
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        
        //지도 중심 기반으로 보여질 범위 설정
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
        
        //핀 추가
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "당산역"
        mapView.addAnnotation(annotation)
    }

}
//위치 관련된 User Defined 메서드
extension MapViewController {

    //Location7. iOS 버전에 따른 분기 처리 및 iOS 위치 서비스 활성화 여부 확인
    //위치 서비스가 켜져 있다면 권한을 요청하고, 꺼져 있다면 커스텀 얼럿으로 상황 알려주기
    //CLAuthorizationStatus
    //-denied: 허용 안함/ 설정에서 추후에 거부/ 위치 서비스 중지/ 비행기 모드
    //-restricted: 앱에서 권한 자체가 없는 경우/ 자녀 보호 기능 같은걸로 아예 제한
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            //인스턴스를 통해서 locationManager가 가지고 있는 상태를 가져옴
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        //iOS 위치 서비스 활성화 여부 체크
        if CLLocationManager.locationServicesEnabled() {
            //위치 서비스가 활성화 되어 있으므로, 위치 권한 요청 가능. 위치 권한을 요청함
            checkUserCurrentLaocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다. 위치 서비스를 켜주세요")
        }
        
    }
    
    //Location8. 사용자의 위치 권항 상태 확인
        //사용자가 위치를 허용했는지, 거부했는지, 아직 선택하지 않았는지 등을 확인(단, 사전에 iOS 위치 서비스 활성화 꼭 확인)
    func checkUserCurrentLaocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("Not Determined")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() //앱를 사용하는 동안에 대한 위치 권한 요청
            //plist whenInUse -> request 메서드 OK 되어있어야함
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
          //설정화면까지 이동 / 설정 세부화면까지 이동
          //한번도 설정 앱에 들어가지 않았거나, 막 다운받은 앱이거나에 따라 다르다c
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

//Location4. 프로토콜 선언
extension MapViewController: CLLocationManagerDelegate {
    
    //Location5. 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        //ex. 위도 경도 기반으로 날씨 정보를 조회
        //ex. 지도를 다시 세팅
        if let coordinate = locations.last?.coordinate {

            setRegionAndAnnotation(center: coordinate)
            //날씨 정보 API 요청
        }
        
        //위치 없데이트 멈춰!! 택시나 네비같은경우 아니라면 계속 받아 올 필요가 있는지 고민
        locationManager.stopUpdatingLocation()
    }
    
    //Location6. 사용자의 위치를 못 가지고 온경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    //Location9. 사용자의 권한 상태가 바뀔 때를 알려줌
    //거부 했다가 설정에서 변경했거나, notDetermined에서 허용을 했거나 등
    //허용 했어서 위치를 가지고 오는 중에, 설정에서 거부하고 돌아온다면??
    //iOS 14 이상: 사용자의 권한 상태가 변경이 될 때, 위치 관리자 생성할 때 호출됨
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { //초기화 될 때 한번 실행된다. 즉 앱 실행할때 호출됨. 그래서 뷰디드로드에 말고 그냥 여기서 호출해도됨
        print(#function)
        checkUserDeviceLocationServiceAuthorization() //아예 첨부터 시작. 위치서비스를 끌 수도 있어서
    }
    
    //13미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) { //지도 움직일때
        locationManager.startUpdatingLocation()
    }
    
    //지도에 커스텀 핀 추가
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//    }
    
    
    
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//
//    }
    
    
}
