shader_type canvas_item;

// maximum 300 dots in predefined array gnarf (TODO: find a way to cheat out dynamic arrays as a uniform)
const int max_dot_count = 300;
uniform vec2 dots[max_dot_count];

vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}

void fragment() {
	if (COLOR.a > 0.1){
		for (int i = 0; i < max_dot_count; i++){
			vec2 mod_dot = vec2(abs(dots[i][0]), abs(dots[i][1]));
			if (distance(FRAGCOORD.xy, mod_dot) < 5.0){
				COLOR = vec4(0.5, 0.5, 0.0, 1.0);
			}
		}	
	}
}
