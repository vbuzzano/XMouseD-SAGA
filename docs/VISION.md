# []($PROGRAM_NAME)XMouseD[]() Vision & Architecture

Create the **simplest possible** mouse wheel driver for Vampire/Apollo SAGA:
- light (~6KB)
- Transparent to the user
- Rock-solid reliable
- Easy to understand and maintain

**Philosophy**: Do one thing well - read the SAGA eXtrended mouse features and inject events.

The SAGA chipset handles basic mouse functions **natively in hardware**:
- Mouse movement (X/Y position)
- Buttons 1, 2, 3 (left, right, middle)

F is a **complementary driver** that adds:
- **Wheel support** (scroll up/down) - reads counter at `$DFF213`
- **Buttons 4 & 5** (extra buttons) - reads bits 8-9 at `$DFF212`

> **Note**: # []($PROGRAM_NAME)XMouseD[]() is **optional**. Your mouse works without it - you just won't have wheel or extra buttons.

## Timer-Based Polling

**Considered**: Interrupt-driven (VBL, hardware IRQ)  
**Chosen**: Adaptive timer polling (5-150ms adaptive, or constant rate)

**Rationale**:
- Simpler code (no IRQ handler)
- Safer (no race conditions)
- Sufficient for wheel/buttons (not realtime critical)
- **Adaptive mode:** Low CPU impact at idle, responsive when active
- **Normal mode:** Constant polling for predictable behavior
- Configurable responsiveness vs CPU trade-off (8 modes)

> **New in v1.0:** Adaptive polling automatically adjusts frequency based on activity. 
> Idle = slow poll (100ms), Active = medium (30ms), Burst = fast (10ms). 
> Or choose normal mode for constant interval.

## VBCC Inline Pragmas

**Alternative**: Link with `-lamiga` stubs  
**Chosen**: Inline pragmas from VBCC headers

**Benefits**:
- Smaller executable (~200 bytes saved)
- Direct JSR calls via library base
- No external stub overhead
- Fully optimizable

## Single-File Architecture

**Alternative**: Multiple modules (daemon.c, hardware.c, inject.c, etc.)  
**Chosen**: Single file (~1300 lines)

**Benefits**:
- Faster compilation (<2s)
- Easier debugging (everything in one place)
- No module coupling issues
- Optimal inline opportunities

## Design Principles

1. **Do one thing well** - Read SAGA wheel/buttons, inject events
2. **Stay invisible** - User never thinks about XMouseD
3. **Fail gracefully** - No crashes, clean shutdown
4. **Play nice with others** - Works alongside IControl, FreeWheel, and other commodities
5.  **Stay lean** - ~6KB code, minimal CPU

