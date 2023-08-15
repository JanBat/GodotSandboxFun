shader_type canvas_item;

//wobble effect shader for the title screen

uniform float height = 50.0;
uniform float speed = 10.0;

void vertex() {
	VERTEX.y += height * sin((UV.x) + (speed * TIME));
}
