shader_type canvas_item;

uniform bool in_coin_rush;
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
	
	bool uv_in_borders = true;// UV.x > 0.1 && UV.x < 0.9 && UV.y > 0.1 && UV.y < 0.9;
	if (in_coin_rush && COLOR == vec4(1.0, 1.0, 1.0, 1.0)) {
		vec3 coin_rush_effect = 0.5 + 0.5 * cos(TIME + UV.xyx + vec3(0.0, 2.0, 4.0));
		vec4 coin_rush_color = vec4(coin_rush_effect, 1.0);
		COLOR *= coin_rush_color;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
