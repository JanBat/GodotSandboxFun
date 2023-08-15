shader_type canvas_item;

uniform float height = 50.0;
uniform float speed = 10.0;

void vertex() {
	VERTEX.y += height * sin((UV.x) + (speed * TIME));
	
}
