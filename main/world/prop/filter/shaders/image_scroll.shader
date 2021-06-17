shader_type canvas_item;

uniform sampler2D image;
uniform float speed_div;

void fragment() {
	vec4 curr_color = texture(TEXTURE,UV); // Get current color of pixel
	if (curr_color == vec4(1,1,1,1)){
		vec2 uv = SCREEN_UV + TIME/speed_div;
		uv =  uv - floor(uv);
		COLOR = texture(image , uv);
	}else{
		COLOR = curr_color;
	}
}