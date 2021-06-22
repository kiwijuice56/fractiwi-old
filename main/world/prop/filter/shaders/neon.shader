shader_type canvas_item;

uniform float speed_div;

void fragment() {
	vec4 curr_color = texture(TEXTURE,UV); // Get current color of pixel
	vec4 col = curr_color + vec4(TIME/speed_div);
	col -= floor(col);
	col.a = curr_color.a;
	col.b = curr_color.b;
	col.g = curr_color.g;
	COLOR = col;
}