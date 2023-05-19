//
//  MapViewController.swift
//  MichinoEkiApp
//
//  Created by 藤森太暉 on 2023/05/11.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    //MARK: Properties
    var locationManager : CLLocationManager?
    var userHeading: CLLocationDirection?
    
    
    var stations : [Station] = [
        Station(id: "", name: "佐渡", latitude: 38.083889, longitude: 138.436111, url: ""),
        Station(id: "", name: "阿賀野", latitude: 37.738056, longitude: 139.307222, url: ""),
    ]
    
    //MARK: UIView
    lazy var mapView :MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = self
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    var headingImageView: UIImageView?
    
    lazy var userTrackingButton : MKUserTrackingButton = {
        let button = MKUserTrackingButton(mapView: self.mapView)
        button.backgroundColor = .white
        button.tintColor = UIColor(named: "main")
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var changeMaptypeButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "map"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(named: "main")
        button.layer.cornerRadius = 10
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    //MARK: LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configulation()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 仮
        for station in stations {
            self.addAnnotation(latitude: station.latitude, longitude: station.longitude, title: station.name)
        }
    }
   
}



//MARK: - Extensions
extension MapViewController {
    // 諸々のセットアップ
    func configulation() {
        setupLayout()
        initLocationManager()
        initMap()
    }
    
    func setupLayout() {
        let stackView = UIStackView(arrangedSubviews:[userTrackingButton,changeMaptypeButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)
        view.addSubview(stackView)
        
        mapView.anchor(top: view.topAnchor,
                       bottom: view.bottomAnchor,
                       left: view.leftAnchor,
                       right: view.rightAnchor)
        stackView.anchor(right: view.rightAnchor,
                         centerY: view.centerYAnchor,
                         width: 60,
                         height: 100,
                         rightPadding: 10)
        
    }
    
    func initMap() {
        // 縮尺を設定
        var region:MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region,animated:true)
        
        // 現在位置表示の有効化
        mapView.showsUserLocation = true
        // 現在位置設定（デバイスの動きとしてこの時の一回だけ中心位置が現在位置で更新される）
        mapView.userTrackingMode = .follow
        
        let config = MKStandardMapConfiguration(emphasisStyle: .muted)
        config.pointOfInterestFilter = .excludingAll // POIを非表示
        mapView.preferredConfiguration = config
    }
    
    private func initLocationManager() {
        // マネージャーの初期化
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        // アプリの使用中のみ位置情報サービスの利用許可を求める
        locationManager?.requestWhenInUseAuthorization()
        
        DispatchQueue.global().async {
            
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager?.startUpdatingHeading()
                self.locationManager?.startUpdatingLocation()
            }
        }
    }
    // アノテーション（地図ピン追加）
    private func addAnnotation (latitude : CLLocationDegrees,// 緯度
                                longitude: CLLocationDegrees ,// 経度
                                title : String){
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        annotation.title = title
    
        self.mapView.addAnnotation(annotation)
    }
    
    private func addHeadingView(toAnnotationView annotationView: MKAnnotationView) {
        if headingImageView == nil {
            guard let image = UIImage(named: "direction") else { return }
            headingImageView = UIImageView(image: image)
            headingImageView!.frame = CGRect(x: (annotationView.frame.size.width - image.size.width)/32 + 20,
                                             y: (annotationView.frame.size.height - image.size.height)/32 + 20,
                                             width: (image.size.width) / 16,
                                             height: (image.size.height)/16 )
            annotationView.insertSubview(headingImageView!, at: 0)
            headingImageView!.isHidden = true
        }
    }
    
    // 向きを更新する
    private func updateHeadingRotation() {
        if let userHeading = locationManager?.heading?.trueHeading,
           let headingImageView = headingImageView {
            
            headingImageView.isHidden = false
            headingImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
            
            let mapHeading : CLLocationDirection = mapView.camera.heading
            
            var imageHeading : CLLocationDirection = 0
            
            if userHeading < mapHeading {
                imageHeading = (userHeading + 360) - mapHeading
            }else {
                imageHeading = userHeading - mapHeading
            }
            
            if mapView.userTrackingMode != .followWithHeading {
                let rotation = CGFloat(imageHeading/180 * Double.pi)
                headingImageView.transform = CGAffineTransform(rotationAngle: rotation)
            }else {
                headingImageView.isHidden = true
                headingImageView.transform = CGAffineTransform(rotationAngle: 0)
            }
            
        }
    }
    
}
// マップビューのデリゲートメソッド
extension MapViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {return nil}
        
        guard let title = annotation.title as? String else { return nil }

//        let isStamp : Bool = isStampDic[title] ?? false
        let markerView = MKMarkerAnnotationView()
        markerView.annotation = annotation
        markerView.glyphImage = UIImage(systemName: "house.and.flag.fill")
        // TODO: 行ったことがあるかないかで色を替える
        markerView.markerTintColor = UIColor(named: "main")
        
        markerView.displayPriority = .defaultLow
        return markerView
    }
    
    // ピンをタップした時の処理
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation { return } // 現在地マーカをタップしたら処理を抜ける
        
        guard let anno = view.annotation ,
              let stationName = anno.title as? String else { return }
        
        // 配列の中から条件に一致する要素を取り出す
        guard let station = stations.first(where: {$0.name == stationName}) else { return }
        
        let detailVC = StationDetailViewController()
        detailVC.station = station
//        detailVC.stationLocation = CLLocation(latitude: station.latitude, longitude: station.longitude)
//        detailVC.isStampDic = self.isStampDic
//        detailVC.isStamp = self.isStampDic[station.name] ?? false
        
        detailVC.modalPresentationStyle = .fullScreen
        
        self.present(detailVC, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ){
            // 画面遷移時にannotationの消滅が見えるため遅延
            mapView.removeAnnotations(mapView.annotations)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if views.last?.annotation is MKUserLocation {
            addHeadingView(toAnnotationView: views.last!)
        }
    }
}

// ロケーションマネージャのデリゲートメソッド
extension MapViewController : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy < 0 { return }

        let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        userHeading = heading
        updateHeadingRotation()
    }
    
    
    
    //位置情報が取得できなかった時の処理
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報が取得できません")
    }
}
