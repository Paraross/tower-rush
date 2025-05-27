shader_type canvas_item;

uniform float progress = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 empty_color = vec4(0.5, 0.5, 0.5, 1.0);
	vec4 full_color = vec4(1.0, 1.0, 1.0, 1.0);

	if (UV.x < progress) {
		COLOR = full_color;
	} else {
		COLOR = empty_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
