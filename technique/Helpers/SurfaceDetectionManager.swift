//
//  SurfaceDetectionManager.swift
//  technique
//
//  Created by Abdiel Mg on 25/07/23.
//

import Foundation
import CoreMotion

class SurfaceDetectionManager {
    private var motionManager: CMMotionManager
    private var timer: Timer?
    private let checkInterval: TimeInterval = 1.0 // Intervalo de verificación en segundos
    private var isCurrentlyFlat: Bool = false
    
    // Señal que se llamará cuando el estado de la superficie plana cambie
    var surfaceStatusChanged: ((Bool) -> Void)?
    
    init() {
        motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.1
    }
    
    // Iniciar la verificación periódica
    func startSurfaceDetection() {
        if motionManager.isAccelerometerAvailable && timer == nil {
            timer = Timer.scheduledTimer(timeInterval: checkInterval, target: self, selector: #selector(checkFlatSurface), userInfo: nil, repeats: true)
        }
    }
    
    // Detener la verificación periódica
    func stopSurfaceDetection() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func checkFlatSurface() {
        motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
            guard let accelerometerData = data else {
                self?.isCurrentlyFlat = false
                self?.surfaceStatusChanged?(false)
                return
            }
            
            let verticalAcceleration = accelerometerData.acceleration.z
            let threshold: Double = -0.98
            
            self?.isCurrentlyFlat = (verticalAcceleration >= threshold)
            self?.surfaceStatusChanged?(self?.isCurrentlyFlat ?? false)
            
            self?.motionManager.stopAccelerometerUpdates()
        }
    }
}
