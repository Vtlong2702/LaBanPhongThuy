import CoreLocation
import Combine

/// Đọc hướng từ la bàn của iPhone.
final class CompassManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var heading: Double = 0
    @Published var accuracy: Double = -1
    @Published var dungBacThat = false
    let coLaBan = CLLocationManager.headingAvailable()

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.headingFilter = 0.5
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func start() {
        guard coLaBan else { return }
        // Cần quyền vị trí để có hướng Bắc thật (đã bù độ lệch từ).
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }

    func stop() {
        manager.stopUpdatingHeading()
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.trueHeading >= 0 {
            heading = newHeading.trueHeading
            dungBacThat = true
        } else {
            heading = newHeading.magneticHeading
            dungBacThat = false
        }
        accuracy = newHeading.headingAccuracy
    }

    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        true
    }
}
