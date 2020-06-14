//
//  Util.swift
//  UIViewVideoCapture
//
//  Created by Joshua Teitelbaum on 6/14/20.
//  Copyright © 2020 sparklesparklesparkle. All rights reserved.
//

import Foundation
import Photos

func checkPhotoLibraryPermission() {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized: break
    //handle authorized status
    case .denied, .restricted : break
    //handle denied status
    case .notDetermined:
        // ask for permissions
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized: break
            // as above
            case .denied, .restricted: break
            // as above
            case .notDetermined: break
            // won't happen but still
            @unknown default:
                break;
            }
        }
    @unknown default:
        break;
    }
}
