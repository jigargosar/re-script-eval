@send external appendChild: (Dom.element, Dom.element) => unit = "appendChild"
@send external replaceChildren: Dom.element => unit = "replaceChildren"

let useRef = () => React.useRef(Nullable.null)
let current = (ref: React.ref<Nullable.t<'a>>) => ref.current->Nullable.toOption

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
  let make = (~bg: string, ~label as _: string) => {
    let frame = Remotion.useCurrentFrame()
    let {durationInFrames} = Remotion.useVideoConfig()
    let t = Float.fromInt(frame) /. Float.fromInt(durationInFrames)
    let svgRef = useRef()

    React.useEffect1(() => {
      svgRef->current->Option.forEach(svg => {
        let rc = Rough.svgContext(svg, {"options": {"seed": 1}})
        svg->Rough.replaceChildren

        // Ground line
        let groundO: Rough.options = {stroke: "#333", strokeWidth: 2, roughness: 2.0}
        svg->Rough.appendChild(rc->Rough.line(0.0, 340.0, 500.0, 340.0, groundO))

        // Cat walks right, mouse walks left
        let catX = 50.0 +. t *. 400.0
        let mouseX = 450.0 -. t *. 400.0
        Characters.drawCat(rc, svg, catX, 250.0)
        Characters.drawMouse(rc, svg, mouseX, 280.0)
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
        <Remotion.Sequence key={s.name} from={s.from} durationInFrames={s.duration}>
          <SceneView bg={s.bg} label={s.label} />
        </Remotion.Sequence>
      )
      ->React.array}
    </>
  }
}

// --- Chapter list ---

module ChapterList = {
  @react.component
  let make = (~playerRef: React.ref<Nullable.t<Remotion.playerRef>>, ~currentFrame: int) => {
    <div className="flex flex-col gap-1 min-w-40">
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
            playerRef.current->Nullable.toOption->Option.forEach(p => p->Remotion.seekTo(s.from))}
          className={`block border-none cursor-pointer text-left font-mono text-sm px-3 py-2 ${isActive
              ? "border-l-3 border-l-red-500 bg-stone-100 font-bold"
              : "border-l-3 border-l-transparent"}`}>
          <div> {s.label->React.string} </div>
          <div className="text-xs text-stone-400"> {timeStr->React.string} </div>
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
      ->Option.forEach(p => setCurrentFrame(_ => p->Remotion.getCurrentFrame))
    }, 100)
    Some(() => Js.Global.clearInterval(interval))
  })

  <div className="flex gap-4 p-6 justify-center items-start font-mono">
    <Remotion.Player
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
