#!/usr/bin/env bash
# macOS settings that live in `defaults` rather than in a dotfile, so stow can't
# link them. install.sh runs this on macOS, and running it again is harmless.
# The key repeat and trackpad settings take effect after logging out and back in.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"

# Keyboard: fast key repeat. Holding a key repeats it instead of offering accents.
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
defaults write -g ApplePressAndHoldEnabled -bool false

# Keyboard layouts: Polish Pro and Russian - PC, and no others.
swift "$DIR/input_sources.swift" com.apple.keylayout.PolishPro com.apple.keylayout.RussianWin
# Ctrl+Space switches to the previous layout. The shortcut ships disabled on
# some Macs. 60 is "Select the previous input source" in System Settings >
# Keyboard > Keyboard Shortcuts > Input Sources. Its parameters are the
# character (32, space), the key code (49, space) and the modifier mask
# (262144, Ctrl).
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 \
  '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>'
# Applies the shortcut change without logging out.
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u

# Typing: no autocorrect, no auto-capitalization, no period on double space, and
# no smart quotes or dashes.
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Trackpad: faster pointer, tap to click and three-finger drag. Like System
# Settings, three-finger drag moves the swipe gestures to four fingers.
defaults write -g com.apple.trackpad.scaling -float 2.5
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2

# Dock: AeroSpace manages the windows, so keep the Dock out of the way. It is
# small, sits on the left without recent apps, and auto-hides. It only slides in
# after the pointer rests at the screen edge for 1000 s.
defaults write com.apple.dock orientation -string left
defaults write com.apple.dock tilesize -int 16
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 1000
# Spaces keep their order instead of moving the most recently used one first.
defaults write com.apple.dock mru-spaces -bool false
# The bottom-right hot corner does nothing, instead of opening Quick Note.
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-br-modifier -int 0

# Finder opens folders in list view.
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv

# Screenshots go to ~/Documents.
defaults write com.apple.screencapture location -string "$HOME/Documents"

killall Dock Finder SystemUIServer
