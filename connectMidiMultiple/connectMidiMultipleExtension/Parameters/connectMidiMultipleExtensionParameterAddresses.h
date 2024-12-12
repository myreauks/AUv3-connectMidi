//
//  connectMidiMultipleExtensionParameterAddresses.h
//  connectMidiMultipleExtension
//
//  Created by Miro on 12.12.2024.
//

#pragma once

#include <AudioToolbox/AUParameters.h>

#ifdef __cplusplus
namespace connectMidiMultipleExtensionParameterAddress {
#endif

typedef NS_ENUM(AUParameterAddress, connectMidiMultipleExtensionParameterAddress) {
    sendNote = 0,
    midiNoteNumber = 1
};

#ifdef __cplusplus
}
#endif
