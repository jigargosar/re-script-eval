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
@send external appendChild: (Dom.element, Dom.element) => unit = "appendChild"
@send external replaceChildren: Dom.element => unit = "replaceChildren"

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
  ) => React.element = "Player"
}
type videoConfig = {durationInFrames: int, fps: int, width: int, height: int}

@module("remotion")
external useCurrentFrame: unit => int = "useCurrentFrame"

@module("remotion")
external useVideoConfig: unit => videoConfig = "useVideoConfig"

let useRef = () => React.useRef(Nullable.null)
let current = (ref: React.ref<Nullable.t<'a>>) => ref.current->Nullable.toOption

let drawCat = (svg: Dom.element, x: float) => {
  let rc = svgContext(svg, {"options": {"seed": 1}})
  let o = {stroke: "#333", strokeWidth: 2, roughness: 1.5, fill: "#ffcc88", fillStyle: "solid"}

  svg->replaceChildren

  svg->appendChild(rc->circle(x, 200.0, 150.0, o))
  svg->appendChild(rc->path(`M ${(x -. 55.0)->Float.toString} 140 L ${(x -. 70.0)->Float.toString} 70 L ${(x -. 30.0)->Float.toString} 120 Z`, o))
  svg->appendChild(rc->path(`M ${(x +. 55.0)->Float.toString} 140 L ${(x +. 70.0)->Float.toString} 70 L ${(x +. 30.0)->Float.toString} 120 Z`, o))
  svg->appendChild(rc->circle(x -. 25.0, 190.0, 20.0, {...o, fill: "#fff"}))
  svg->appendChild(rc->circle(x +. 25.0, 190.0, 20.0, {...o, fill: "#fff"}))
  svg->appendChild(rc->circle(x -. 23.0, 192.0, 8.0, {...o, fill: "#333"}))
  svg->appendChild(rc->circle(x +. 27.0, 192.0, 8.0, {...o, fill: "#333"}))
}

module Scene = {
  @react.component
  let make = () => {
    let frame = useCurrentFrame()
    let {durationInFrames} = useVideoConfig()
    let x = 100.0 +. Float.fromInt(frame) /. Float.fromInt(durationInFrames) *. 300.0
    let svgRef = useRef()

    React.useEffect1(() => {
      svgRef->current->Option.forEach(svg => drawCat(svg, x))
      None
    }, [frame])

    <svg
      ref={ReactDOM.Ref.domRef(svgRef)}
      width="500"
      height="400"
      style={{background: "#fdf6e3"}}
    />
  }
}

@react.component
let make = () => {
  <Player
    component={Scene.make}
    durationInFrames={90}
    compositionWidth={500}
    compositionHeight={400}
    fps={30}
    controls={true}
    loop={true}
    style={{width: "500px"}}
  />
}
