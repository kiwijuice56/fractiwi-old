shader_type canvas_item;

uniform sampler2D image;
uniform vec2 dir;

void fragment() {
	vec4 curr_color = texture(TEXTURE,UV);
	vec2 new_uv = (SCREEN_UV + (TIME * dir));
	new_uv -= floor(new_uv);
	vec4 new_color = mix(texture(image, new_uv), curr_color, curr_color.a);
	COLOR = new_color;
}