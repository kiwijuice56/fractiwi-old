shader_type canvas_item;

uniform float blur_amount : hint_range(0, 5);

void fragment(){
	COLOR = textureLod(TEXTURE, UV, blur_amount);
}