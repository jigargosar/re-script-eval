open Rough

let drawCat = (rc: canvas, svg: Dom.element, x: float, y: float) => {
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

let drawMouse = (rc: canvas, svg: Dom.element, x: float, y: float) => {
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
