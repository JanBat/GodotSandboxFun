shader_type canvas_item;

//this shader helps render the backdrop in backdrop.tscn


//these uniforms are passed by the script, based on 
//locations of 3 rotating PathFollow2Ds
uniform vec2 red_location;
uniform vec2 green_location;
uniform vec2 blue_location;


void fragment() {
	float red_dist = distance(FRAGCOORD.xy, red_location);
	float blue_dist = distance(FRAGCOORD.xy, blue_location);
	float green_dist = distance(FRAGCOORD.xy, green_location);
	float total_dist = red_dist + blue_dist + green_dist;
	COLOR = vec4(red_dist/total_dist, blue_dist/total_dist, green_dist/total_dist, 1.0);
}
