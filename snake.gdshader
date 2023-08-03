shader_type canvas_item;

void fragment() {
	if (COLOR.a != 0.0){
		COLOR = vec4(UV, 0.5, 1.0);
	}
		
}
