//
//  Camera.swift
//  QR-Reader
//
//  Created by ShoKatsukawa on 2016/06/08.
//  Copyright © 2016年 ShoKatsukawa. All rights reserved.
//

import UIKit
import AVFoundation

class Camera: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    var stillImageOutput: AVCaptureStillImageOutput!
    var session: AVCaptureSession!
    
    override init() {
        super.init()
    }
    
    func configureCamera(view:(UIView)) -> Bool {
        // init camera device
        var captureDevice: AVCaptureDevice?
        let devices: NSArray = AVCaptureDevice.devices()
        
        // find back camera
        for device: AnyObject in devices {
            if device.position == AVCaptureDevicePosition.Back {
                captureDevice = device as? AVCaptureDevice
            }
        }
        
        if captureDevice != nil {
            print(captureDevice!.localizedName)
            print(captureDevice!.modelID)
        } else {
            print("Missing Camera")
            return false
        }
        
        // init device input
        var deviceInput:(AVCaptureInput)!
        
        do {
            let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            // Do the rest of your work...
        } catch let error as NSError {
            // Handle any errors
            print(error)
        }
        
        self.stillImageOutput = AVCaptureStillImageOutput()
        
        // init session
        self.session = AVCaptureSession()
        self.session.sessionPreset = AVCaptureSessionPresetPhoto
        self.session.addInput(deviceInput as AVCaptureInput)
        self.session.addOutput(self.stillImageOutput)
        self.session.sessionPreset = AVCaptureSessionPresetPhoto
        
        // layer for preview
        let previewLayer = AVCaptureVideoPreviewLayer.init(session: self.session)
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer!.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        
        let metaOutput = AVCaptureMetadataOutput();
        metaOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue());
        self.session.addOutput(metaOutput);
        metaOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code];
        metaOutput.rectOfInterest = previewLayer!.frame
        
        self.session.startRunning()
        
        return true
    }
    
    /**
     * MetadataObjectsDelegate
     */
    func captureOutput(captureOutput: AVCaptureOutput!,
                       didOutputMetadataObjects metadataObjects: [AnyObject]!,
                                                fromConnection connection: AVCaptureConnection!) {
        for metadataObject in metadataObjects {
            if let metadataObject = metadataObject as? AVMetadataMachineReadableCodeObject {
                if metadataObject.type == AVMetadataObjectTypeQRCode {
                    if metadataObject.stringValue != nil {
                        print(metadataObject.stringValue)
                    }
                }
            }
        }
    }
}
