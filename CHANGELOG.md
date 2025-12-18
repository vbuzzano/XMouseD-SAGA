# Changelog

All notable changes to XMouseD will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.0.0] - 2025-12-18

Initial release of XMouseD - Extended mouse driver for Apollo 68080 SAGA chipset.

### Features
- **Mouse wheel scrolling** - Scroll up/down support with NewMouse compatibility
- **Extra buttons 4 & 5** - Full support for additional mouse buttons
- **Adaptive polling system** - 8 modes (4 adaptive + 4 normal) for optimal CPU/responsiveness balance
  - Adaptive modes: COMFORT, BALANCED, REACTIVE, ECO (smart polling based on user activity)
  - Normal modes: MODERATE, ACTIVE, INTENSIVE, PASSIVE (constant polling rates)
- **Hot configuration** - Change settings without restarting daemon via `XMouseD 0xBYTE`
- **STATUS command** - Query daemon state and current configuration
- **Debug mode** - Toggle debug console at runtime for troubleshooting (DEV builds)
- **Lightweight** - ~6KB release build, ~7.5KB dev build with minimal CPU footprint

### Usage
- `XMouseD` - Toggle daemon (start/stop)
- `XMouseD START` - Start with default config (0x13)
- `XMouseD STOP` - Stop daemon
- `XMouseD STATUS` - Query daemon status and config
- `XMouseD 0xBYTE` - Start/update with custom config byte (supports hot config)

### Configuration
Default config byte: `0x13` (wheel ON, buttons ON, BALANCED adaptive mode)
- Bit 0: Wheel enable
- Bit 1: Buttons 4 & 5 enable
- Bits 4-5: Poll mode selection (8 modes total)
- Bit 7: Debug console (DEV builds only)

### Technical
- Singleton daemon with public message port (`XMouseD_Port`)
- Timer-based polling (adaptive or fixed intervals: 5ms/10ms/20ms/40ms)
- Direct SAGA hardware register access ($DFF212-$DFF213)
- Input.device event injection (IECLASS_RAWKEY + IECLASS_NEWMOUSE)
- 2-second message timeout for reliable IPC
- Wrap-around handling for 8-bit wheel counter delta calculation
- Proper resource cleanup on daemon exit (timer, input.device, ports)
- SAGA wheel register: $DFF213 (8-bit signed counter)
- SAGA button register: $DFF212 (bits 8-9 for buttons 4 & 5)
- Event codes: 0x7A (NM_WHEEL_UP), 0x7B (NM_WHEEL_DOWN)
- Background daemon using WBM pattern (CLI module detachment)
- 68080 optimized with instruction scheduling for dual-pipe architecture

### Compatibility
- Vampire V4 Standalone, A6000 (Apollo 68080 SAGA chipset)
- AmigaOS 3.x (3.0+), ApolloOS 9.x
- USB mouse with wheel and extra buttons

### Documentation
- AmigaGuide manual (XMouseD.guide)
- Aminet-ready readme (XMouseD.readme)
- Technical documentation (docs/TECHNICAL.md, docs/VISION.md)
- Installer script included
