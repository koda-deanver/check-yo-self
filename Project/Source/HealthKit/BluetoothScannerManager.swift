//
//  BluetoothScannerManager.swift
//  KWI
//
//  Created by Phil Rattazzi on 2/3/18.
//  Copyright © 2018 KWI. All rights reserved.
//
//  This class replaces the former "ExternalBluetoothScanner.m" objective-c code as the interface with bluetooth scanners.

import Foundation

// MARK: - Protocol -

/// Delegate for when the BluetoothScannerManager handles scanning events.
protocol BluetoothScannerDelegate: class {
    func bluetoothScanner(withID scannerID: Int32, didScanBarcode barcode: String)
}

// MARK: - Class -

/// Acts as the main interface between the app and connected Bluetooth scanners.
final class BluetoothScannerManager: NSObject {
    
    // MARK: - Static Members -
    
    static let shared = BluetoothScannerManager()
    
    // MARK: - Public Members -
    
    /// Read only getter for *_scanningIsEnabled*
    var scanningIsEnabled: Bool { return _scanningIsEnabled }
    
    // MARK: - Private Members -
    
    /// Delegate object to handle scanning of barcodes. **Required**
    private weak var delegate: BluetoothScannerDelegate!
    /// Instance of Zebra's API.
    private var zebraAPI: ISbtSdkApi!
    /// Determines whether to accept input from scanner.
    private var _scanningIsEnabled = false
    /// Used to determine the state of Bluetooth in the iOS settings menu.
    private var peripheralManager: CBPeripheralManager?
    
    /// Int32 value representing all possible delegate methods to subscribe to.
    private var allScannerEvents: Int32 {
        return Int32(SBT_EVENT_SCANNER_APPEARANCE |
            SBT_EVENT_SCANNER_DISAPPEARANCE | SBT_EVENT_SESSION_ESTABLISHMENT |
            SBT_EVENT_SESSION_TERMINATION | SBT_EVENT_BARCODE | SBT_EVENT_IMAGE | SBT_EVENT_VIDEO | SBT_EVENT_RAW_DATA)
    }
    
    // MARK: - Private Methods -
    
    ///
    /// Initial setup for Zebra API.
    ///
    /// Creates instance of API, subscribes to scanner events, and configures app to accept input from both *MFi* and *BTLE* scanners.
    ///
    /// - warning: Events that are not included in sbtSubscribe will not call thier respective delegate methods.
    /// - warning: If the operational mode does not match that of the scanner, the delegate methods will not be called.
    ///
    private func setupZebraAPI() {
        
        zebraAPI = SbtSdkFactory.createSbtSdkApiInstance()
        zebraAPI.sbtSetDelegate(self)
        zebraAPI.sbtSubsribe(forEvents: allScannerEvents)
        zebraAPI.sbtSetOperationalMode(Int32(SBT_OPMODE_ALL))
        zebraAPI.sbtEnableAvailableScannersDetection(true)
        
        LoggerService.log(message: "Bluetooth Scanning: Zebra API Initialized.", forLogLevel: .info, inOwner: self)
    }
    
    // MARK: - Public Methods -
    
    ///
    /// Initial setup for *BluetoothScannerManager*.
    ///
    /// The zebra API is only set up if Bluetooth is enabled in the settings menu. Scanners cannot be used or connected until *setupZebraAPI* is run. This is to avoid the warning message that results when trying to run *setupZebraAPI* while Bluetooth is disabled. The delegate method *peripheralManagerDidUpdateState* is called immediatly after this and determines whether to call *setupZebraAPI*.
    ///
    func configure(withDelegate delegate: BluetoothScannerDelegate) {
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: false])
        self.delagate = delegate
    }
    
    ///
    /// Enables handling of scanned barcodes.
    ///
    func enableScanning() { _scanningIsEnabled = true }
    
    ///
    /// Disables handling of scanned barcodes.
    ///
    func disableScanning() { _scanningIsEnabled = false }
}

// MARK: - Extension: ISbtSdkApiDelegate -
// Contains a series of methods fired when the scanner performs a specific action.

extension BluetoothScannerManager: ISbtSdkApiDelegate {
    
    ///
    /// Attempts to establish communication with newly appeared scanner.
    ///
    /// This method will be called at any time a compatible scanner is found with a Bluetooth connection.
    ///
    func sbtEventScannerAppeared(_ availableScanner: SbtScannerInfo!) {
        LoggerService.log(message: "Bluetooth Scanning: \(availableScanner.getScannerName()) appeared.", forLogLevel: .info, inOwner: self)
        zebraAPI.sbtEstablishCommunicationSession(availableScanner.getScannerID())
    }
    
    ///
    /// Log message when a communication session is established with a scanner.
    ///
    /// This is called when *sbtEstablishCommunicationSession* is successful in establishing a connection. When connection is established, the scanner will beep.
    ///
    func sbtEventCommunicationSessionEstablished(_ activeScanner: SbtScannerInfo!) {
        LoggerService.log(message: "Bluetooth Scanning: Established communication with \(activeScanner.getScannerName()).", forLogLevel: .info, inOwner: self)
    }
    
    ///
    /// Logs when communication to a scanner is lost.
    ///
    func sbtEventCommunicationSessionTerminated(_ scannerID: Int32) {
        LoggerService.log(message: "Bluetooth Scanning: Lost connection to \(scannerID).", forLogLevel: .warning, inOwner: self)
    }
    
    ///
    /// Handles a scanned barcode from active scanner.
    ///
    func sbtEventBarcode(_ barcodeData: String!, barcodeType: Int32, fromScanner scannerID: Int32) {
        
        LoggerService.log(message: "Bluetooth Scanning: Barcode \(barcodeData) scanned.", forLogLevel: .info, inOwner: self)
        
        if scanningIsEnabled {
            delegate?.bluetoothScanner(withID: scannerID, didScanBarcode: barcodeData)
        }
    }
    
    // Unused but available if needed.
    func sbtEventBarcodeData(_ barcodeData: Data!, barcodeType: Int32, fromScanner scannerID: Int32) {}
    func sbtEventScannerDisappeared(_ scannerID: Int32) {}
    func sbtEventFirmwareUpdate(_ fwUpdateEventObj: FirmwareUpdateEvent!) {}
    func sbtEventImage(_ imageData: Data!, fromScanner scannerID: Int32) {}
    func sbtEventVideo(_ videoFrame: Data!, fromScanner scannerID: Int32) {}
}

// MARK: - Extension: CGPeripheralManagerDelegate -

extension BluetoothScannerManager: CBPeripheralManagerDelegate {
    
    ///
    /// Set up Zebra API only if Bluetooth is enabled and the API has not previously been set up.
    ///
    /// This method is called the first time after *peripheralManager* is initialized in *configure()*, and then again each time the Bluetooth status is changed.
    ///
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn && zebraAPI == nil { setupZebraAPI() }
    }
}

