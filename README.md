# Oblitus

A monome norns script that emulates the legendary Binson Echorec drum echo delay unit.

```
         REC
          ┌─┐
          │ │
    ┌─────┼─┼─────┐
    │  ●  │ │  ●  │ 4
    │     │ │     │
    │  ●  ╱─╲  ●  │ 1
    │    ╱   ╲    │
    │   ╱  ●  ╲   │
    │  ╱       ╲  │
    │ ╱    ●    ╲ │
    │╱           ╲│
    └─────────────┘
     3           2
    
    SPEED: 1.00  MODE: REPEAT
    FDBK:  0.30  MIX:  0.50
```

## Description

Oblitus recreates the distinctive sound and visual appeal of the Italian Binson Echorec, featuring a rotating magnetic drum with multiple record/playback heads. The script provides authentic delay characteristics with musical timing relationships between the heads.

## Features

### Core Functionality
- **Multi-tap Delay**: 4 discrete delay taps with musically related timing (75ms, 150ms, 225ms, 300ms)
- **Variable Speed**: Drum speed control affects all delay times proportionally
- **Three Operating Modes**:
  - **ECHO**: Single distinct repeat (classic slapback)
  - **REPEAT**: Multiple repetitions with feedback control
  - **SWELL**: Reverb-like effect using all 4 playback heads

### Visual Interface
- **Rotating Disc Animation**: Real-time visualization of the magnetic drum
- **Playback Head Indicators**: 4 heads positioned around the disc perimeter
- **Record Head Display**: Fixed recording position
- **Level Meters**: Input level visualization (Magic Eye simulation)
- **Parameter Display**: Real-time parameter values

### Controls

#### Hardware Controls
- **Encoder 1**: Drum Speed (0.1x - 2.0x)
- **Encoder 2**: Feedback/Repeat Amount (0.0 - 0.95)
- **Encoder 3**: Dry/Wet Mix (0.0 - 1.0)
- **Key 1**: Cycle through modes (Echo → Repeat → Swell)
- **Key 2**: Tap tempo (randomized for creative exploration)
- **Key 3**: Reset to default values

#### Monome Grid Integration (if connected)
- **Row 1**: Individual playback head on/off (columns 1-4)
- **Row 2**: Speed presets (8 musical subdivisions)
- **Row 3**: Mode selection (columns 1-3) + Tap tempo (column 8)

### Audio Characteristics
- **Tape Flutter**: Realistic speed variations
- **Progressive High-Frequency Loss**: Each head loses more high frequencies
- **Analog Saturation**: Soft clipping for vintage character
- **Magnetic Tape Simulation**: Frequency response modeling

## Installation

1. Copy the `Oblitus.lua` file to your norns `~/dust/code/` directory
2. Copy the `Engine_Oblitus.sc` file to `~/dust/code/Oblitus/lib/`
3. Restart norns or run `;restart` in maiden

## Usage

1. Select "Oblitus" from the norns script menu
2. Connect audio input to norns
3. Adjust parameters using encoders and keys
4. Connect a monome grid for expanded control options

## Parameters

- **Drum Speed**: Controls the rotation speed of the magnetic drum (affects delay time)
- **Feedback**: Amount of signal fed back for multiple repeats
- **Mix**: Balance between dry (original) and wet (delayed) signals
- **Mode**: Operating mode selection
- **Individual Head States**: Toggle playback heads on/off (via grid)

## Tips
- Start with Echo mode for classic slapback delay
- Use Repeat mode with moderate feedback for rhythmic delays  
- Try Swell mode for ambient, reverb-like textures
- Lower drum speeds create longer, more atmospheric delays
- Higher speeds produce shorter, more percussive effects

## Technical Notes

The script uses SuperCollider for audio processing and implements:
- Multi-tap DelayC units with interpolation
- LFNoise2 for tape flutter simulation
- Progressive low-pass filtering for authentic head behavior
- Soft saturation using tanh for analog character

## Version History

- v1.0: Initial release with core functionality, visual interface, and grid integration

## License
This script is released under the MIT License. See `LICENSE` for details.

## Credits

Based on the legendary Binson Echorec drum echo delay unit, designed by Dr. Bini in the 1950s. Used by artists like Pink Floyd, Led Zeppelin, and many others to create iconic sounds.

Developed by Josh Ng for the monome norns sound computer.
