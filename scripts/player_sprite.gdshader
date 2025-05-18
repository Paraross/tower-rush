shader_type canvas_item;

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
	COLOR = tmp_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
