# Oblitus - Binson Echorec Emulation for Monome Norns

## Project Overview
Oblitus is a norns script that emulates the legendary Binson Echorec drum echo delay unit, featuring a visual representation of the rotating magnetic drum with multiple record/playback heads.

## Binson Echorec Key Characteristics

### Core Technology
- **Magnetic Drum System**: Uses a rotating steel/alloy disc with magnetic tape instead of tape loops
- **Multi-Head Design**: 4 playback heads positioned around the drum circumference
- **Motor-Driven**: Stable AC motor drive with rubber jockey wheel
- **Delay Times**: ~75ms, 150ms, 225ms, 300ms (musically related intervals)

### Operating Modes
1. **ECHO**: Single distinct repeat (classic 50s slapback)
2. **REPEAT**: Multiple repetitions with feedback control
3. **SWELL**: Reverb-like effect using all 4 playback heads simultaneously

### Controls
- **Drum Speed**: Controls rotation speed (affects delay time)
- **Echo Time**: Fine-tunes delay timing
- **Record Level**: Input signal level to drum
- **Repeat/Feedback**: Amount of signal fed back to create multiple repeats
- **Echo Tone**: High-frequency filtering
- **Playback Head Selectors**: Individual on/off for heads 1-4
- **Magic Eye**: Visual input level meter

## Norns Implementation Requirements

### Core Audio Engine
- **Multi-tap Delay**: 4 discrete delay taps with musically related timing
- **Variable Delay Time**: Speed control affects all taps proportionally
- **Feedback System**: Controllable regeneration for repeat mode
- **High-frequency Filtering**: Tape saturation/age simulation
- **Input/Output Levels**: Proper gain staging

### Visual Interface
- **Rotating Disc Animation**: Central visual element showing drum rotation
- **Playback Head Indicators**: 4 heads positioned around disc perimeter
- **Record Head**: Visually distinct recording position
- **Speed Indicator**: Visual representation of rotation speed
- **Level Meters**: Input/output level visualization
- **Mode Indicators**: Clear visual feedback for Echo/Repeat/Swell modes

### Control Interface
- **Encoder 1**: Drum Speed (delay time)
- **Encoder 2**: Feedback/Repeat amount
- **Encoder 3**: Mix (dry/wet balance)
- **Key 1**: Mode selector (Echo/Repeat/Swell)
- **Key 2**: Tap tempo for musical timing
- **Key 3**: Bypass/Mute

### Monome Grid Integration
- **16x8 Grid Layout**:
  - **Row 1**: Playback head on/off (heads 1-4)
  - **Row 2**: Speed presets (8 musical subdivisions)
  - **Row 3**: Mode selection and tap tempo
  - **Row 4**: Input level visualization
  - **Rows 5-8**: Step sequencer for automated parameter changes

### Advanced Features
- **Preset System**: Save/recall complete settings
- **MIDI Sync**: Tempo-synced delay times
- **CV Integration**: External control of parameters
- **Stereo Processing**: Stereo input/output with width control
- **Tape Aging**: Simulation of magnetic tape wear and flutter

### Technical Specifications
- **Sample Rate**: 48kHz
- **Bit Depth**: 24-bit
- **Max Delay Time**: 2 seconds (for extended creative use)
- **CPU Usage**: Optimized for norns hardware
- **Memory Usage**: Efficient buffer management

### File Structure
```
Oblitus/
├── Oblitus.lua          # Main script
├── lib/
│   ├── Engine_Oblitus.sc # SuperCollider engine
│   ├── oblitus_ui.lua   # UI rendering functions
│   └── oblitus_grid.lua # Grid integration
└── README.md             # User documentation
```

## Implementation Priorities
1. Core delay engine with 4 taps
2. Basic UI with rotating disc visualization
3. Essential controls (speed, feedback, mix)
4. Mode switching (Echo/Repeat/Swell)
5. Grid integration for advanced control
6. Polish and optimization