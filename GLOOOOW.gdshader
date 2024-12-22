shader_type canvas_item;

uniform sampler2D mask : filter_nearest;
uniform vec4 clr : source_color;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float val = texture(mask,UV).r;
	if(COLOR.r > 0.5){
		COLOR.rgb = mix(COLOR,clr * 2.,COLOR.r).rgb;
		COLOR.rgb += (sin(TIME * 2. + SCREEN_UV.x * SCREEN_UV.y * 10.)  + 1.) / 8.;
	}
	else{
		//COLOR.rgb += (sin(-TIME * 0.5 + SCREEN_UV.x *  (SCREEN_UV.x + 1.) * SCREEN_UV.y * 10.)  + 1.) / 100.;
		
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
