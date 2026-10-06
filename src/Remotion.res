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
