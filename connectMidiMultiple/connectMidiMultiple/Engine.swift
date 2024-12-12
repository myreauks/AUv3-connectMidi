//
//  Engine.swift
//  connectMidiMultiple
//
//  Created by Miro on 12.12.2024.
//

import Foundation
import AudioToolbox
import AVFoundation


class playerEngine: ObservableObject {
    
    private let engine = AVAudioEngine()
    private var midiUnit: AVAudioUnit?
    private var samplers = [AVAudioUnitSampler(),AVAudioUnitSampler(),AVAudioUnitSampler()]
    
    let files = ["Sounds/kickme.wav", "Sounds/tamb.wav", "Sounds/chh.wav"]
    
    init() {
        
        for (index, sampler) in samplers.enumerated() {
            engine.attach(sampler)
            engine.connect(sampler, to: engine.mainMixerNode, format: nil)
            do {
                try sampler.loadAudioFiles(at: [(Bundle.main.resourceURL?.appendingPathComponent(files[index]))!])
            } catch {
                print(error)
            }
        }

        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: nil)
        
        self.startEngine()
        
    }
    
    func startEngine() {
        initComponent(type: "aumi", subType: "demo", manufacturer: "Demo")
        
        do {
            try engine.start()
            
            print("Engine started")
        } catch {
            print(error)
        }
        for (index, sampler) in samplers.enumerated() {
            engine.attach(sampler)
            engine.connect(sampler, to: engine.mainMixerNode, format: nil)
            do {
                try sampler.loadAudioFiles(at: [(Bundle.main.resourceURL?.appendingPathComponent(files[index]))!])
            } catch {
                print(error)
            }
        }
    }
    
    func stopEngine() { engine.stop() }
    
    func sendNote() {
        print("Sending note")
        let cbytes = UnsafeMutablePointer<UInt8>.allocate(capacity: 3)
        cbytes[0] = 0b10010000
        cbytes[1] = 64
        cbytes[2] = 127
        self.midiUnit?.auAudioUnit.scheduleMIDIEventBlock!(AUEventSampleTimeImmediate, 0, 3, cbytes)
    }

    func initComponent(type: String, subType: String, manufacturer: String) {
        
        guard let component = AVAudioUnit.findComponent(type: type, subType: subType, manufacturer: manufacturer) else {
            fatalError("Failed to find component with type: \(type), subtype: \(subType), manufacturer: \(manufacturer))" )
        }
        
        // Instantiate the audio unit.
        AVAudioUnit.instantiate(with: component.audioComponentDescription,
                                options: AudioComponentInstantiationOptions.loadOutOfProcess) { avAudioUnit, error in
            
            if let audioUnit = avAudioUnit {
                
                self.midiUnit = audioUnit
                self.engine.attach(audioUnit)
                self.engine.connectMIDI(avAudioUnit!, to: self.samplers, format: nil, eventListBlock: { sampleTime, length, data in
                    return noErr
                })
            }
        }
    }
}


/// String extension
extension String {
    var fourCharCode: FourCharCode? {
        guard self.count == 4 && self.utf8.count == 4 else {
            return nil
        }

        var code: FourCharCode = 0
        for character in self.utf8 {
            code = code << 8 + FourCharCode(character)
        }
        return code
    }
}

/// Wraps and Audio Unit extension and provides helper functions.
extension AVAudioUnit {
    
    func setParameter(_ number: Int, value: AUValue) {
        self.auAudioUnit.parameterTree?.parameter(withAddress: AUParameterAddress(number))?.value = value
    }
    
    var wantsAudioInput: Bool {
        let componentType = self.auAudioUnit.componentDescription.componentType
        return componentType == kAudioUnitType_MusicEffect || componentType == kAudioUnitType_Effect
    }
    
    static fileprivate func findComponent(type: String, subType: String, manufacturer: String) -> AVAudioUnitComponent? {
        // Make a component description matching any Audio Unit of the selected component type.
        let description = AudioComponentDescription(componentType: type.fourCharCode!,
                                                    componentSubType: subType.fourCharCode!,
                                                    componentManufacturer: manufacturer.fourCharCode!,
                                                    componentFlags: 0,
                                                    componentFlagsMask: 0)
        return AVAudioUnitComponentManager.shared().components(matching: description).first
    }
}
