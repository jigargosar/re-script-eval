%%raw(`import rough from "roughjs"`)

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

let animate: Dom.element => unit = %raw(`function (svg) {
  let start = null
  function loop(ts) {
    if (!start) start = ts
    const t = (ts - start) / 3000
    const x = 100 + (t % 1) * 300
    drawCat(svg, x)
    requestAnimationFrame(loop)
  }
  requestAnimationFrame(loop)
}`)

@react.component
let make = () => {
  let svgRef = useRef()

  React.useEffect0(() => {
    svgRef->current->Option.forEach(animate)
    None
  })

  <svg
    ref={ReactDOM.Ref.domRef(svgRef)}
    width="400"
    height="400"
    style={{background: "#fdf6e3"}}
  />
}
