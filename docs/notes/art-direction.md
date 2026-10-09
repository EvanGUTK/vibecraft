---
tags: [vibecraft, art]
updated: 2026-10-09
---

# Art direction

Owner: **Visual Arts Master**. This is a seed written by Chief with the hard constraints; sections marked
*(open — Visual Arts)* are yours to fill in M0. Architecture context: [[architecture]] §8, §9.1, §12.

## Hard constraints (from architecture, MUST)
- **Original work only.** Nothing copied, traced, recoloured or "recreated" from Minecraft or any other game. CC0
  sources allowed with provenance in `assets/art/LICENSES.md`. The word "Minecraft" never appears in art or UI.
- Block textures **16×16** PNG, no anti-aliasing at source, faces named `<block>_<face>.png` (`all`, `top`,
  `bottom`, `side`, or `north/south/east/west`). Animated tiles are vertical strips with `frames` in a sidecar json.
- One **master palette** (`assets/art/palette.hex`), 48–64 colours. The packer rejects off-palette pixels.
- Consistent **light direction**: top-left key light baked into textures and UI bevels.
- Entity skins **64×64**, cuboid models in `content/models/*.json` (schema from Chief).
- UI: 9-slice panels with 4 px borders at 1×, bitmap font (ASCII + Latin-1 in v1), GUI scale 2× default.
- Landing art: 1920×1080 stage, webp, composed from row strips + a right-hand panel per world, same mechanics as
  vel.gg/bo1z (see architecture §1.3). Must remain readable at 1280×720.
- Deliver through `tools/art` so outputs are reproducible; never hand-place files in `apps/web/public/generated/`.
- Lightmap (16×16, architecture §8.5), fog colours per biome and sky gradient keys are art deliverables.

## Style pillars *(open — Visual Arts)*
Three to five adjectives and a paragraph each. Reference boards go in `assets/art/reference/` (own sketches only).

## Palette *(open — Visual Arts)*
Hue families, value ramps, how biomes shift tint, hostile vs passive mob colour language.

## Texture rules *(open — Visual Arts)*
Noise density, edge treatment, tiling tests, how ores read against stone, transparency rules for cutout blocks.

## UI rules *(open — Visual Arts)*
Panel anatomy, slot anatomy, hover/pressed states, iconography, type specimen, HUD layout at 1080p and 720p.

## Entity and model rules *(open — Visual Arts)*
Proportions, pivot conventions, texture layout per model, animation notes for Code Master.

## Landing and brand *(open — Visual Arts)*
World-select composition, logo, icon set (PWA 192/512, maskable, favicon), og image (1280×720).

## Deliverable checklist by milestone
- **M0**: pillars, palette, 16 textures, `pack-blocks` tool, icons, placeholder og image.
- **M1**: 32 textures incl. ores/leaves/water/animated, lightmap, sky + clouds + sun/moon, fog colours, crack decal, selection outline spec.
- **M2**: item icons (tools × tiers, materials, food), 6 mob models + skins, player model + default skin, full UI kit, HUD, screens, font.
- **M3**: landing art (all panels), world thumbnails frame, loading veil art, PWA icons final.
- **M5**: polish pass, og cards, promo stills.
