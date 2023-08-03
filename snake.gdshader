shader_type canvas_item;

uniform vec2 red_location;
uniform vec2 green_location;
uniform vec2 blue_location;

uniform float time_progress;

void fragment() {
	if (COLOR.a > 0.00001){
		float red_dist = distance(FRAGCOORD.xy, red_location);
		float blue_dist = distance(FRAGCOORD.xy, blue_location);
		float green_dist = distance(FRAGCOORD.xy, green_location);
		float total_dist = red_dist + blue_dist + green_dist;
		COLOR = vec4(red_dist/total_dist, blue_dist/total_dist, green_dist/total_dist, 1.0);
	}
		
}
