//
//  ViewController.swift
//  CameraTest
//
//  Created by Judit Greskovits on 15/09/2014.
//  Copyright (c) 2014 Judit Greskovits. All rights reserved.
//

/*UIImage *image = [UIImage imageNamed:@"myImage"];
CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
context:nil
options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];

NSDictionary *options = @{ CIDetectorSmile: @YES, CIDetectorEyeBlink: @YES };

NSArray *features = [detector featuresInImage:image.CIImage options:options];

for (CIFaceFeature *feature in features) {
    NSLog(@"Bounds: %@", NSStringFromCGRect(feature.bounds));
    
    if (feature.hasSmile) {
        NSLog(@"Nice smile!");
    } else {
        NSLog(@"Why so serious?");
    }
    if (feature.leftEyeClosed || feature.rightEyeClosed) {
        NSLog(@"Open your eyes!");
    }
}*/

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    let detector = CIDetector(ofType:CIDetectorTypeFace, context:nil, options:[CIDetectorAccuracy:CIDetectorAccuracyHigh, CIDetectorSmile:true, CIDetectorEyeBlink:true])
    
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("Hello")
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let devices = AVCaptureDevice.devices()
        
        for device in devices {
            if(device.hasMediaType(AVMediaTypeVideo)) {
                if(device.position == AVCaptureDevicePosition.Front) {
                    captureDevice = device as? AVCaptureDevice
                    if(captureDevice != nil) {
                        println("Capture device found")
                        beginSession();
                    }
                    
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureDevice() {
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            // device.focusMode = .Locked // what / why is this???
            device.unlockForConfiguration()
        }
    }
    
    func beginSession() {
        
        configureDevice()
        
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if(err != nil) {
            println("error: \(err?.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
}

