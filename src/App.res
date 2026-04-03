%%raw(`import rough from "roughjs"`)

let drawCat: Dom.element => unit = %raw(`function(svg) {
  const rc = rough.svg(svg)
  const o = { stroke: '#333', strokeWidth: 2, roughness: 1.5 }

  // Head
  svg.appendChild(rc.circle(200, 200, 150, { ...o, fill: '#ffcc88', fillStyle: 'solid' }))

  // Ears
  svg.appendChild(rc.path('M 145 140 L 130 70 L 170 120 Z', { ...o, fill: '#ffcc88', fillStyle: 'solid' }))
  svg.appendChild(rc.path('M 255 140 L 270 70 L 230 120 Z', { ...o, fill: '#ffcc88', fillStyle: 'solid' }))

  // Eyes
  svg.appendChild(rc.circle(175, 190, 20, { ...o, fill: '#fff', fillStyle: 'solid' }))
  svg.appendChild(rc.circle(225, 190, 20, { ...o, fill: '#fff', fillStyle: 'solid' }))
  svg.appendChild(rc.circle(177, 192, 8, { ...o, fill: '#333', fillStyle: 'solid' }))
  svg.appendChild(rc.circle(227, 192, 8, { ...o, fill: '#333', fillStyle: 'solid' }))
}`)

@react.component
let make = () => {
  let svgRef = React.useRef(Nullable.null)

  React.useEffect0(() => {
    svgRef.current
    ->Nullable.toOption
    ->Option.forEach(drawCat)
    None
  })

  <svg
    ref={ReactDOM.Ref.domRef(svgRef)}
    width="400"
    height="400"
    style={{background: "#fdf6e3"}}
  />
}
