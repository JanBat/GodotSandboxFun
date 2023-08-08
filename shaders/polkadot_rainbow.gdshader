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
		float r = 0.0;
		vec2 lowest = dots[0];
		vec2 second_lowest = dots[0];
		for (int i = 1; i < max_dot_count; i++){
			if (distance(dots[i], FRAGCOORD.xy) < distance(lowest, FRAGCOORD.xy)){
				second_lowest = lowest;
				lowest = dots[i];
			}
			else if (distance(dots[i], FRAGCOORD.xy) < distance(second_lowest, FRAGCOORD.xy)){
				second_lowest = dots[i];
			}
			//vec2 mod_dot = vec2(abs(dots[i][0]), abs(dots[i][1]));
			//float dist = distance(FRAGCOORD.xy, mod_dot);
			
		}	
		r = 1.0 - (distance(lowest, FRAGCOORD.xy) / distance(second_lowest, FRAGCOORD.xy));
		
		COLOR = vec4(0.0, r, 0.0, 1.0);
	}
}
