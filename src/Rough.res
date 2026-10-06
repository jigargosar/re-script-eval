type canvas
type options = {
  stroke?: string,
  strokeWidth?: int,
  fill?: string,
  fillStyle?: string,
  roughness?: float,
  seed?: int,
}

@module("roughjs") @scope("default")
external svgContext: (Dom.element, {..}) => canvas = "svg"

@send external circle: (canvas, float, float, float, options) => Dom.element = "circle"
@send external path: (canvas, string, options) => Dom.element = "path"
@send external line: (canvas, float, float, float, float, options) => Dom.element = "line"
@send external ellipse: (canvas, float, float, float, float, options) => Dom.element = "ellipse"
