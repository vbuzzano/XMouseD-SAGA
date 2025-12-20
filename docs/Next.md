# Next - Post v1.0 Release & Testing

## ✅ Completed for v1.0
- [x] Wheel scrolling (UP/DOWN)
- [x] Extra buttons 4 & 5 support (code ready, testing pending)
- [x] Adaptive polling system (8 modes)
- [x] Hot config update (no restart)
- [x] Debug mode toggle
- [x] Message timeout fix (2s)
- [x] Button-hold reactive fix
- [x] Full documentation (README, .guide, .readme, USAGE.md)
- [x] Installer script with contextual messages
- [x] CHANGELOG.md
- [x] Code analysis report (PROJECT_ANALYSIS.md)
- [x] CONFIG_STOP renamed to CONFIG_FEATURES_MASK (clarity)
- [x] VISION.md completed (Single-File Architecture + Design Principles)
- [x] TECHNICAL.md with polling modes reference table
- [x] Executable size: 5.96KB (<6KB target achieved)

---

## 📋 Testing & Validation (v1.0 RC)

### Real Hardware Testing
- [ ] **Test buttons 4 & 5 on real Vampire V4**
  - Verify hardware reads from `$DFF212` bits 8-9
  - Confirm event injection works with FreeWheel or IControl
  - Test all modes (Adaptive/Normal profiles)

- [ ] **Long-term stability test (multiple days)**
  - Run XMouseD continuously for 48-72 hours
  - Monitor for memory leaks, timer drift, or crashes
  - Verify daemon stays responsive under heavy scrolling
  - Check adaptive polling transitions work smoothly

### Edge Cases
- [ ] Hot config updates during active scrolling
- [ ] Rapid mode switching (0x13 → 0x23 → 0x33 → 0x13)
- [ ] ApolloWheel/other tools NOT running (verify no conflicts)
- [ ] Reboot with User-Startup enabled

---

## 📋 Post-Testing (Before Final Release)

### Critical - Documentation Placeholders
- [x] Run `.\scripts\env-replace.ps1` on all files before release
  - [x] README.md
  - [x] XMouseD.guide
  - [x] XMouseD.readme
  - [x] CHANGELOG.md
  - [x] Install
  - [x] docs/TECHNICAL.md
  - [x] docs/VISION.md
  
  Format: `~ VALUE [VAR_ENV_NAME]~` → actual values

### Critical - Version Consistency
- [x] **Verify all version strings match `1.0`**:
  - [x] src/xmoused.c: `PROGRAM_VERSION "1.0"`
  - [x] src/xmoused.c: `PROGRAM_DATE "2025-12-18"` (current date)
  - [x] CHANGELOG.md: move `[Unreleased]` to `[1.0.0]` with date
  - [x] All docs using placeholders (updated by env-replace)

### Critical - Build & Test
- [x] **Clean build**: `make clean && make MODE=release`
- [x] **Size check**: executable should be ~6KB
- [x] **Test on real Vampire V4**: Core wheel functionality
- [ ] **Test buttons 4 & 5 on real Vampire V4**: *pending*
- [x] **Test hot config**: mode switching without restart
- [x] **Test Installer script**: Full install path
- [ ] **Long-term stability test**: *pending (multiple days)*

### Release Package
- [ ] **Run `.\scripts\build-release.ps1`** to create LHA archive (after testing complete)
  - Verify LHA archive is 100% Amiga-compatible
  - Test extraction and installation on real Amiga
  - Update RELEASE_CHECK.md checklist
- [x] **Verify archive structure**:
  ```
  XMouseD-1.0.lha
    + XMouseD-1.0/
       - Install
       - Install.info
       - XMouseD (executable, no .exe extension!) <--- manque bit 2 E (executable) ajouter lors de l'install
       - XMouseD.guide
       - XMouseD.guide.info
    - XMouseD-1.0.info
    - XMouseD-1.0.readme
    - XMouseD-1.0.readme.info
  ```
- [x] **Test extraction and install from archive**

### Optional - Cleanup
- [x] **Archive or delete ROADMAP.md** (obsolete now)

---

## 🚀 Future Ideas (v1.1+)

### Inactive Mode (CONFIG_FEATURES_MASK = 0)
When config byte has neither wheel nor buttons enabled (0x00):
- Instead of stopping daemon completely
- Keep daemon alive in "inactive" mode
- Switch to slow timer (≥1 second polling)
- Monitor for config changes via public port
- Resume normal operation when features re-enabled

**Benefits**:
- Instant re-activation (no process restart)
- Keeps public port alive for external control
- Minimal CPU usage in inactive state (~0.1%)
- Smoother integration with future GUI tools

**Implementation**:
- Add `POLL_STATE_INACTIVE` to adaptive state machine
- Set timer to 1000000µs (1 second) when `CONFIG_FEATURES_MASK == 0`
- Skip hardware reads and event injection in inactive state
- Transition back to normal on `XMSG_CMD_SET_CONFIG` with features enabled

### Dynamic Wheel Acceleration (Branch: `test_dynamic_scroll`)
Use bit 2 or bit 3 for dynamic multiplier feature:
- Detect scroll burst (fast consecutive wheel events)
- Auto-increase multiplier (1x → 2x → 4x) during burst
- Auto-decrease on slow scroll
- Timeout reset after 300ms idle

**Use case**: Long file lists in DirectoryOpus/editors - scroll faster to reach bottom quickly

**Status**: Experimental branch created, needs refinement and testing

### Button Hold Issue Investigation
When button 4/5 is held down:
- Adaptive polling may consider it "inactive" after threshold
- Transitions to TO_IDLE state
- Release detection might be delayed

**Solution options**:
- Keep polling active while any button pressed
- Add button state to activity detection
- Test real-world impact first

---

## 📝 Release Checklist Summary

1. ✅ Code complete and tested
2. ⚠️ **Run env-replace.ps1** on all docs
3. ⚠️ **Update PROGRAM_DATE** to release date
4. ⚠️ **Move CHANGELOG [Unreleased] → [1.0.0]**
5. ⚠️ **Clean build MODE=release**
6. ⚠️ **Test on real hardware**
7. ⚠️ **Run build-release.ps1**
8. ⚠️ **Verify LHA structure**
9. ✅ Git tag `v1.0.0`
10. ✅ GitHub release with LHA attachment



