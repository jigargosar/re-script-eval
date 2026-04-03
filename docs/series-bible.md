# Series Bible — ReScript Cartoon Engine

## Stack

- **ReScript** (latest) — core engine, typed animation logic
- **RoughJS** — hand-drawn SVG rendering for that sketchy cartoon look
- **Remotion** — frame-by-frame video export (React-based, ReScript interop)
- **SVG** — rendering canvas

## Architecture

1. **ReScript Core Engine**
   - Character system — composable body parts as RoughJS SVG shapes
   - Animation engine — keyframe interpolation + easing
   - Cartoon physics — squash, stretch, smear, gravity with comedic timing
   - Scene graph — backgrounds, layers, camera

2. **Timeline & Sequencer**
   - Scene definitions — what happens when, for how long
   - Action choreography — chase sequences, gag setups, punchlines
   - Audio sync points — boing, crash, slide whistle cues

3. **Rendering Pipeline**
   - Frame-by-frame SVG rendering via RoughJS
   - Export to video using Remotion
   - 24fps × 10min = ~14,400 frames per episode

4. **Asset System**
   - Character rigs (head, body, limbs as composable RoughJS groups)
   - Prop library (anvils, dynamite, pies, mallets)
   - Background templates (kitchen, yard, alley)
   - Sound effect bank

## Why This Stack

- **RoughJS** renders SVG with "hand-drawn" quality — lines wobble slightly, fills have crosshatch/scribble patterns. Each frame looks slightly different, creating organic movement for free.
- **ReScript's type system** makes animation state machines safe. Variants and pattern matching make illegal states unrepresentable (a character can't be "running" and "flattened" simultaneously unless explicitly modeled).
- **Remotion** renders React components frame-by-frame to video. ReScript compiles to JS with excellent React bindings (@rescript/react), giving a proper video export pipeline.

## The Tom & Jerry Formula

### Visual Comedy Rules
- Minimal dialogue — humor is 95% visual + sound effects
- No lip sync needed — character expressions carry the comedy
- Wide eyes, grimace, grin are the emotional vocabulary

### Cartoon Physics
- **Delayed gravity** — character runs off cliff, pauses, THEN falls
- **Squash & stretch** — flatten on impact, elongate when launched
- **Smear frames** — motion blur as stretched character shape
- **Prop exaggeration** — tiny dynamite = massive explosion

### Episode Structure (Chase Formula)
1. **Setup** — establish the status quo
2. **Provocation** — one character bothers the other
3. **Chase cycle** — escalating gags (3-5 per episode)
4. **Reversal** — tables turn
5. **Resolution** — back to status quo (or ironic twist)

### Timing
- 10 minutes ≈ 5-7 gag sequences
- Each gag: setup (10-15s) → anticipation (3-5s) → punchline (2-3s) → reaction (3-5s)
- The pause before the punchline is everything

## Scene Authoring (Declarative)

Episodes are defined as ReScript data structures, not imperative code:

```rescript
let scene1 = {
  duration: seconds(30),
  background: Kitchen,
  actions: [
    CharAction(cat, RunTo(table), ~easing=Ease.comedic),
    Wait(beats(2)),  // comedic pause
    CharAction(mouse, DropAnvil, ~from=Above),
    CharAction(cat, Flatten, ~duration=seconds(1)),
    SFX(Boing),
    CharAction(cat, PeelOffFloor, ~easing=Ease.rubbery),
  ]
}
```

## Animation Approach

- **Procedural over hand-keyed** — physics system generates squash/stretch/bounce rather than manually keying every frame
- **Character-as-rig, not character-as-sprite** — each body part is a separate RoughJS shape that can be independently transformed, giving infinite poses from a small set of parts
- **Define WHAT happens, engine figures out HOW it looks**

## Build Phases

1. **Phase 1 — Character Rig**: composable RoughJS SVG parts, pose system, expression system
2. **Phase 2 — Animation Engine**: keyframe system, easing, cartoon physics module
3. **Phase 3 — Scene System**: background layers, parallax, camera (pan/zoom/shake), transitions
4. **Phase 4 — Timeline & Choreography**: declarative scene descriptions, action sequencing DSL, audio cues
5. **Phase 5 — Export Pipeline**: Remotion integration, audio mixing, 10-minute episode assembly

## Development Approach

View-first: build visual mocks, then derive model/state from what we see.
