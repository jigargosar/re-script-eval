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

// --- Player ref helpers ---

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
  let make = (~bg: string, ~label: string) => {
    let frame = useCurrentFrame()
    let {durationInFrames} = useVideoConfig()
    let progress = Float.fromInt(frame) /. Float.fromInt(durationInFrames) *. 100.0

    <div
      style={{
        width: "100%",
        height: "100%",
        backgroundColor: bg,
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        fontFamily: "monospace",
      }}>
      <div style={{fontSize: "48px", color: "#333", fontWeight: "bold"}}>
        {label->React.string}
      </div>
      <div style={{fontSize: "18px", color: "#666", marginTop: "16px"}}>
        {`Frame ${frame->Int.toString} / ${durationInFrames->Int.toString}`->React.string}
      </div>
      <div
        style={{
          marginTop: "24px",
          width: "60%",
          height: "8px",
          backgroundColor: "#ccc",
          borderRadius: "4px",
        }}>
        <div
          style={{
            width: `${progress->Float.toString}%`,
            height: "100%",
            backgroundColor: "#e74c3c",
            borderRadius: "4px",
          }}
        />
      </div>
    </div>
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
