shader_type canvas_item;

uniform float texture_size_y = 462.0;
uniform float player_pos_y = 0.0;

void vertex() {
	
}

void fragment() {
	vec2 offset = vec2(0.0, player_pos_y / texture_size_y);
	vec4 tex = texture(TEXTURE, fract(UV + offset));
	COLOR = tex;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
