// Makes the given keyboard layouts the only enabled ones and selects the first.
//
// Usage: swift input_sources.swift <layout id>...
// Layout IDs look like com.apple.keylayout.<name>, e.g. US, PolishPro, or
// RussianWin for "Russian - PC".
import Carbon

func inputSources(_ filter: [String: Any], includeAllInstalled: Bool) -> [TISInputSource] {
    TISCreateInputSourceList(filter as CFDictionary, includeAllInstalled).takeRetainedValue() as! [TISInputSource]
}

func sourceID(_ source: TISInputSource) -> String {
    Unmanaged<CFString>.fromOpaque(TISGetInputSourceProperty(source, kTISPropertyInputSourceID)).takeUnretainedValue() as String
}

func check(_ status: OSStatus, _ what: String) {
    if status != noErr { fatalError("\(what) failed with OSStatus \(status)") }
}

let wanted = Array(CommandLine.arguments.dropFirst())
if wanted.isEmpty { fatalError("usage: swift input_sources.swift <layout id>...") }

let sources = wanted.map { id -> TISInputSource in
    guard let source = inputSources([kTISPropertyInputSourceID as String: id], includeAllInstalled: true).first else {
        fatalError("no keyboard layout with id \(id)")
    }
    return source
}
for source in sources {
    check(TISEnableInputSource(source), "enabling \(sourceID(source))")
}
check(TISSelectInputSource(sources[0]), "selecting \(wanted[0])")

let keyboardLayouts = [kTISPropertyInputSourceType as String: kTISTypeKeyboardLayout!]
let enabledLayouts = inputSources(keyboardLayouts, includeAllInstalled: false)
for source in enabledLayouts where !wanted.contains(sourceID(source)) {
    check(TISDisableInputSource(source), "disabling \(sourceID(source))")
}

let enabled = inputSources(keyboardLayouts, includeAllInstalled: false)
print("Enabled keyboard layouts: \(enabled.map(sourceID).joined(separator: ", "))")
