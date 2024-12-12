//
//  connectMidiMultipleExtensionAudioUnit.h
//  connectMidiMultipleExtension
//
//  Created by Miro on 12.12.2024.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface connectMidiMultipleExtensionAudioUnit : AUAudioUnit
- (void)setupParameterTree:(AUParameterTree *)parameterTree;
@end
