shader_type spatial;
render_mode cull_disabled;

uniform float size = 0.5;
uniform float blade_bend = 0.5;

varying float bottom_to_top;

uniform vec3 color = vec3(0.3, 0.6, 0.1);

void vertex() {
	bottom_to_top = 1.0 - UV.y;
	
	VERTEX.z += blade_bend * pow(bottom_to_top, 2.0);
	
	VERTEX *= size;
}

void fragment() {
	AO = bottom_to_top;
	AO_LIGHT_AFFECT = 1.0;

    ALBEDO = color;
}
