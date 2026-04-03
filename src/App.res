// --- Remotion bindings ---

type playerRef
@send external seekTo: (playerRef, int) => unit = "seekTo"
@send external getCurrentFrame: playerRef => int = "getCurrentFrame"

module Player = {
  @module("@remotion/player") @react.component
  external make: (
    ~component: React.component<'props>,
    ~durationInFrames: int,
    ~compositionWidth: int,
    ~compositionHeight: int,
    ~fps: int,
    ~controls: bool=?,
    ~loop: bool=?,
    ~style: JsxDOMStyle.t=?,
    @as("ref") ~playerRef: React.ref<Nullable.t<playerRef>>=?,
  ) => React.element = "Player"
}

type videoConfig = {durationInFrames: int, fps: int, width: int, height: int}

@module("remotion")
external useCurrentFrame: unit => int = "useCurrentFrame"

@module("remotion")
external useVideoConfig: unit => videoConfig = "useVideoConfig"

module Sequence = {
  @module("remotion") @react.component
  external make: (
    ~from: int,
    ~durationInFrames: int,
    ~children: React.element,
  ) => React.element = "Sequence"
}

// --- RoughJS bindings ---

type roughCanvas
type roughOptions = {
  stroke?: string,
  strokeWidth?: int,
  fill?: string,
  fillStyle?: string,
  roughness?: float,
  seed?: int,
}

@module("roughjs") @scope("default")
external svgContext: (Dom.element, {..}) => roughCanvas = "svg"

@send external circle: (roughCanvas, float, float, float, roughOptions) => Dom.element = "circle"
@send external path: (roughCanvas, string, roughOptions) => Dom.element = "path"
@send external line: (roughCanvas, float, float, float, float, roughOptions) => Dom.element = "line"
@send external ellipse: (roughCanvas, float, float, float, float, roughOptions) => Dom.element = "ellipse"
@send external appendChild: (Dom.element, Dom.element) => unit = "appendChild"
@send external replaceChildren: Dom.element => unit = "replaceChildren"

let useRef = () => React.useRef(Nullable.null)
let current = (ref: React.ref<Nullable.t<'a>>) => ref.current->Nullable.toOption

// --- Characters ---

let drawCat = (rc: roughCanvas, svg: Dom.element, x: float, y: float) => {
  let o = {stroke: "#333", strokeWidth: 2, roughness: 1.5, fill: "#ffcc88", fillStyle: "solid"}
  // Head
  svg->appendChild(rc->circle(x, y, 80.0, o))
  // Ears (pointy)
  svg->appendChild(rc->path(`M ${(x -. 28.0)->Float.toString} ${(y -. 30.0)->Float.toString} L ${(x -. 35.0)->Float.toString} ${(y -. 65.0)->Float.toString} L ${(x -. 12.0)->Float.toString} ${(y -. 25.0)->Float.toString} Z`, o))
  svg->appendChild(rc->path(`M ${(x +. 28.0)->Float.toString} ${(y -. 30.0)->Float.toString} L ${(x +. 35.0)->Float.toString} ${(y -. 65.0)->Float.toString} L ${(x +. 12.0)->Float.toString} ${(y -. 25.0)->Float.toString} Z`, o))
  // Eyes
  svg->appendChild(rc->circle(x -. 12.0, y -. 5.0, 12.0, {...o, fill: "#fff"}))
  svg->appendChild(rc->circle(x +. 12.0, y -. 5.0, 12.0, {...o, fill: "#fff"}))
  svg->appendChild(rc->circle(x -. 11.0, y -. 4.0, 5.0, {...o, fill: "#333"}))
  svg->appendChild(rc->circle(x +. 13.0, y -. 4.0, 5.0, {...o, fill: "#333"}))
  // Body
  svg->appendChild(rc->ellipse(x, y +. 65.0, 50.0, 70.0, o))
  // Legs
  svg->appendChild(rc->line(x -. 15.0, y +. 95.0, x -. 20.0, y +. 130.0, o))
  svg->appendChild(rc->line(x +. 15.0, y +. 95.0, x +. 20.0, y +. 130.0, o))
  // Tail
  svg->appendChild(rc->path(`M ${(x +. 25.0)->Float.toString} ${(y +. 80.0)->Float.toString} Q ${(x +. 60.0)->Float.toString} ${(y +. 50.0)->Float.toString} ${(x +. 55.0)->Float.toString} ${(y +. 30.0)->Float.toString}`, {...o, fill: ?None}))
}

let drawMouse = (rc: roughCanvas, svg: Dom.element, x: float, y: float) => {
  let o = {stroke: "#333", strokeWidth: 2, roughness: 1.5, fill: "#ccc", fillStyle: "solid"}
  // Head (smaller)
  svg->appendChild(rc->circle(x, y, 40.0, o))
  // Ears (round, big)
  svg->appendChild(rc->circle(x -. 18.0, y -. 22.0, 20.0, {...o, fill: "#ffb6c1"}))
  svg->appendChild(rc->circle(x +. 18.0, y -. 22.0, 20.0, {...o, fill: "#ffb6c1"}))
  // Eyes
  svg->appendChild(rc->circle(x -. 7.0, y -. 3.0, 6.0, {...o, fill: "#fff"}))
  svg->appendChild(rc->circle(x +. 7.0, y -. 3.0, 6.0, {...o, fill: "#fff"}))
  svg->appendChild(rc->circle(x -. 6.0, y -. 2.0, 3.0, {...o, fill: "#333"}))
  svg->appendChild(rc->circle(x +. 8.0, y -. 2.0, 3.0, {...o, fill: "#333"}))
  // Body
  svg->appendChild(rc->ellipse(x, y +. 30.0, 25.0, 35.0, o))
  // Legs
  svg->appendChild(rc->line(x -. 8.0, y +. 45.0, x -. 10.0, y +. 60.0, o))
  svg->appendChild(rc->line(x +. 8.0, y +. 45.0, x +. 10.0, y +. 60.0, o))
  // Tail (long, curvy)
  svg->appendChild(rc->path(`M ${(x -. 12.0)->Float.toString} ${(y +. 40.0)->Float.toString} Q ${(x -. 40.0)->Float.toString} ${(y +. 20.0)->Float.toString} ${(x -. 45.0)->Float.toString} ${(y -. 5.0)->Float.toString}`, {...o, fill: ?None}))
}

// --- Scene data ---

type scene = {
  name: string,
  from: int,
  duration: int,
  bg: string,
  label: string,
}

let scenes = [
  {name: "Kitchen", from: 0, duration: 90, bg: "#fdf6e3", label: "Kitchen"},
  {name: "Backyard", from: 90, duration: 90, bg: "#d5e8d4", label: "Backyard"},
  {name: "Kitchen 2", from: 180, duration: 90, bg: "#fdf6e3", label: "Kitchen"},
]

let totalFrames = scenes->Array.reduce(0, (acc, s) => acc + s.duration)
let fps = 30

// --- Scene component (trivial colored box + label) ---

module SceneView = {
  @react.component
  let make = (~bg: string, ~_label: string) => {
    let frame = useCurrentFrame()
    let {durationInFrames} = useVideoConfig()
    let t = Float.fromInt(frame) /. Float.fromInt(durationInFrames)
    let svgRef = useRef()

    React.useEffect1(() => {
      svgRef->current->Option.forEach(svg => {
        let rc = svgContext(svg, {"options": {"seed": 1}})
        svg->replaceChildren

        // Ground line
        let groundO = {stroke: "#333", strokeWidth: 2, roughness: 2.0}
        svg->appendChild(rc->line(0.0, 340.0, 500.0, 340.0, groundO))

        // Scene label
        // Cat walks right, mouse walks left (or varies by scene)
        let catX = 50.0 +. t *. 400.0
        let mouseX = 450.0 -. t *. 400.0
        drawCat(rc, svg, catX, 250.0)
        drawMouse(rc, svg, mouseX, 280.0)
      })
      None
    }, [frame])

    <svg
      ref={ReactDOM.Ref.domRef(svgRef)}
      width="500"
      height="400"
      style={{background: bg}}
    />
  }
}

// --- Episode ---

module Episode1 = {
  @react.component
  let make = () => {
    <>
      {scenes
      ->Array.map(s =>
        <Sequence key={s.name} from={s.from} durationInFrames={s.duration}>
          <SceneView bg={s.bg} label={s.label} />
        </Sequence>
      )
      ->React.array}
    </>
  }
}

// --- Chapter list ---

module ChapterList = {
  @react.component
  let make = (~playerRef: React.ref<Nullable.t<playerRef>>, ~currentFrame: int) => {
    <div
      style={{
        display: "flex",
        flexDirection: "column",
        gap: "4px",
        minWidth: "160px",
      }}>
      {scenes
      ->Array.map(s => {
        let isActive = currentFrame >= s.from && currentFrame < s.from + s.duration
        let timeStr = {
          let sec = s.from / fps
          let min = sec / 60
          `${min->Int.toString}:${(mod(sec, 60))->Int.toString->String.padStart(2, "0")}`
        }
        <button
          key={s.name}
          onClick={_ =>
            playerRef.current->Nullable.toOption->Option.forEach(p => p->seekTo(s.from))}
          style={{
            padding: "8px 12px",
            border: "none",
            borderLeft: isActive ? "3px solid #e74c3c" : "3px solid transparent",
            backgroundColor: isActive ? "#f5f5f5" : "transparent",
            cursor: "pointer",
            textAlign: "left",
            fontFamily: "monospace",
            fontSize: "14px",
          }}>
          <div style={{fontWeight: isActive ? "bold" : "normal"}}>
            {s.label->React.string}
          </div>
          <div style={{fontSize: "12px", color: "#999"}}>
            {timeStr->React.string}
          </div>
        </button>
      })
      ->React.array}
    </div>
  }
}

// --- App ---

@react.component
let make = () => {
  let playerRef = React.useRef(Nullable.null)
  let (currentFrame, setCurrentFrame) = React.useState(() => 0)

  React.useEffect0(() => {
    let interval = Js.Global.setInterval(() => {
      playerRef.current
      ->Nullable.toOption
      ->Option.forEach(p => setCurrentFrame(_ => p->getCurrentFrame))
    }, 100)
    Some(() => Js.Global.clearInterval(interval))
  })

  <div
    style={{
      display: "flex",
      gap: "16px",
      padding: "24px",
      justifyContent: "center",
      alignItems: "flex-start",
      fontFamily: "monospace",
    }}>
    <Player
      playerRef
      component={Episode1.make}
      durationInFrames={totalFrames}
      compositionWidth={500}
      compositionHeight={400}
      fps={30}
      controls={true}
      loop={true}
      style={{width: "500px"}}
    />
    <ChapterList playerRef currentFrame />
  </div>
}
