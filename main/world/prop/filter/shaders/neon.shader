shader_type canvas_item;

uniform float speed_div;

void fragment() {
	vec4 curr_color = texture(TEXTURE,UV); 
	curr_color.r += abs(sin(TIME/speed_div));
	curr_color.g -= abs(cos(TIME/speed_div));
	curr_color.b -= abs(sin(TIME/speed_div));
	curr_color.a = curr_color.a;
	COLOR = curr_color;
}