shader_type canvas_item;

uniform bool in_coin_rush;
/**
 *  [b]Note:[/b] Make sure the palettes are the same size.
 */
uniform sampler2D in_palette;
/**
 *  [b]Note:[/b] Make sure the palettes are the same size.
 */
uniform sampler2D out_palette;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	const int LOD = 0;
	
	vec4 color = texture(TEXTURE, UV);
	
	ivec2 texture_size = textureSize(in_palette, LOD);
	vec4 tmp_color = vec4(0.0);
	for (int i = 0; i < texture_size.x; i++) {
		ivec2 pos = ivec2(i, 0);
		vec4 in_color = texelFetch(in_palette, pos, LOD);
		vec4 out_color = texelFetch(out_palette, pos, LOD);
		tmp_color += float(color == in_color) * out_color;
	}
	
	vec3 coin_rush_effect;
	if (in_coin_rush) {
		coin_rush_effect = 0.5 + 0.5 * cos(TIME + UV.xyx + vec3(0.0, 2.0, 4.0));
	} else {
		coin_rush_effect = vec3(1.0, 1.0, 1.0);
	}
	vec4 coin_rush_color = vec4(coin_rush_effect, 1.0);
	
	COLOR = tmp_color * coin_rush_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
