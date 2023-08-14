shader_type canvas_item;

// this shader renders the individual snake segments
// inspired by worley noise
// https://godotshaders.com/snippet/voronoi/


// maximum 1000 dots in predefined array
const int max_dot_count = 1000;
uniform vec2 dots[max_dot_count];

vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}

void fragment() {
	if (COLOR.a > 0.1){
		float green = 0.0;
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
		}	
		green = 1.0 - (distance(lowest, FRAGCOORD.xy) / distance(second_lowest, FRAGCOORD.xy));
		
		COLOR = vec4(0.05, green, 0.05, 1.0);
	}
}
