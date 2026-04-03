%%raw(`import rough from "roughjs"`)
%%raw(`import { Player } from "@remotion/player"`)
%%raw(`import { useCurrentFrame, useVideoConfig } from "remotion"`)

let useRef = () => React.useRef(Nullable.null)
let current = (ref: React.ref<Nullable.t<'a>>) => ref.current->Nullable.toOption

let drawCat: (Dom.element, float) => unit = %raw(`function(svg, x) {
  const rc = rough.svg(svg, { options: { seed: 1 } })
  const o = { stroke: '#333', strokeWidth: 2, roughness: 1.5 }

  svg.replaceChildren()

  svg.appendChild(rc.circle(x, 200, 150, { ...o, fill: '#ffcc88', fillStyle: 'solid' }))
  svg.appendChild(rc.path('M '+(x-55)+' 140 L '+(x-70)+' 70 L '+(x-30)+' 120 Z', { ...o, fill: '#ffcc88', fillStyle: 'solid' }))
  svg.appendChild(rc.path('M '+(x+55)+' 140 L '+(x+70)+' 70 L '+(x+30)+' 120 Z', { ...o, fill: '#ffcc88', fillStyle: 'solid' }))
  svg.appendChild(rc.circle(x-25, 190, 20, { ...o, fill: '#fff', fillStyle: 'solid' }))
  svg.appendChild(rc.circle(x+25, 190, 20, { ...o, fill: '#fff', fillStyle: 'solid' }))
  svg.appendChild(rc.circle(x-23, 192, 8, { ...o, fill: '#333', fillStyle: 'solid' }))
  svg.appendChild(rc.circle(x+27, 192, 8, { ...o, fill: '#333', fillStyle: 'solid' }))
}`)

let scene: unit => React.element = %raw(`function() {
  const frame = useCurrentFrame()
  const { durationInFrames } = useVideoConfig()
  const x = 100 + (frame / durationInFrames) * 300

  const ref = React.useRef(null)
  React.useEffect(() => {
    if (ref.current) drawCat(ref.current, x)
  }, [frame])

  return React.createElement('svg', {
    ref, width: 500, height: 400,
    style: { background: '#fdf6e3' }
  })
}`)

@react.component
let make = () => {
  %raw(`
    React.createElement(Player, {
      component: scene,
      durationInFrames: 90,
      compositionWidth: 500,
      compositionHeight: 400,
      fps: 30,
      controls: true,
      loop: true,
      style: { width: 500 }
    })
  `)
}
