shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 color;
	color.r = 0.0;
	color.b = 3.0;
	color.g= 50.0 + sin(TIME*2.0);
	ALBEDO = color;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
