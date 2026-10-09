---
tags: [vibecraft, sound]
updated: 2026-10-09
---

# Sound design

Owner: **Sound Master**. Seed written by Chief with the hard constraints; sections marked *(open — Sound Master)*
are yours to fill in M0. Architecture context: [[architecture]] §10.

## Hard constraints (from architecture, MUST)
- **Original work only.** No Minecraft sounds or music, no derivatives. CC0 sources allowed with provenance in
  `assets/sound/LICENSES.md`.
- Masters are **48 kHz WAV** in `assets/sound/{sfx,music,ambience,ui}`; delivery via `tools/sound/encode` to Ogg
  Vorbis q5 + AAC m4a + `manifest.json` ([[decisions]] ADR-011). Never hand-place files in `generated/`.
- Loudness: SFX peaks around −16 LUFS short-term, music −20 LUFS integrated, ambience −26 LUFS; true peak ≤ −1 dBTP.
- Every sound event has a **caption** for subtitles (architecture §9.6).
- Event ids follow `domain.subject.action` (`block.stone.break`, `entity.player.hurt`, `ui.click`,
  `ambient.cave`, `music.day_1`). Block sound groups: `stone wood grass sand metal glass cloth snow water`.
- The engine (`packages/audio`) is DOM-free except for `AudioContext`; it never imports world/sim and learns about
  the world only through `GameEvent`s and the listener pose + environment struct from the client session.
- Bus layout fixed by architecture §10.1: `master → music | sfx | ambience | ui`; sfx and ambience through the
  environment chain (reverb, low-pass). Voice pool 64 with priority stealing.

## Sonic pillars *(open — Sound Master)*
Three to five adjectives and what each means in practice.

## Materials and footsteps *(open — Sound Master)*
Per sound group: source approach (foley vs synthesis), variants count (aim 4–6), pitch range, how break/place/hit
differ.

## Mobs and player *(open — Sound Master)*
Voice design for 3 hostile + 3 passive originals, hurt/death/ambient/attack sets, player hurt/eat/level.

## Music *(open — Sound Master)*
Instrumentation, tempo ranges per director state, track lengths, silence gaps, how combat and underground differ.

## Ambience *(open — Sound Master)*
Biome beds, time-of-day layers, cave drone, underwater, how layers crossfade.

## Environment chain *(open — Sound Master)*
Reverb impulse set (cave small/large, interior, open), low-pass curve underwater, ducking rules.

## Deliverable checklist by milestone
- **M0**: pillars, bus/loudness spec, `packages/audio` skeleton with tests, `sound-events.json` v0, encode tool, 6 SFX (`ui.click`, `ui.hover`, `block.stone.step/break/place`, `block.wood.place`).
- **M1**: all 9 block groups × 5 actions, water/fire loops, day/night ambience beds, first music track.
- **M2**: 6 mob voice sets, player set, inventory/crafting UI sounds, music director states with 4 tracks, combat cue.
- **M3**: menu music, landing hover/pick sounds, save/load cues.
- **M5**: final mix pass, loudness audit, captions audit, LICENSES audit.
