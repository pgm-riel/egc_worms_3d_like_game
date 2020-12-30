#version 430
 

// Uniforms for light properties
uniform vec3 light_direction;
uniform vec3 light_position;
uniform vec3 eye_position;
uniform vec3 light1;
uniform vec3 light2;

uniform float angle;
uniform float material_kd;
uniform float material_ks;
uniform int material_shininess;

uniform sampler2D texture_1;
uniform sampler2D texture_2;
 
in vec3 tangent;
in vec2 texcoord;
in vec3 world_position;
in vec3 world_normal;
flat in int spot_frag;
//in mat3 tbn;
layout(location = 0) out vec4 out_color;

vec3 CalcBumpedNormal()                                                                     
{                                                                                           
    vec3 Normal = normalize(world_normal);                                                       
    vec3 Tangent = normalize(tangent);                                                     
    Tangent = normalize(Tangent - dot(Tangent, Normal) * Normal);                           
    vec3 Bitangent = cross(Tangent, Normal);                                                
    vec3 BumpMapNormal = texture(texture_1, texcoord).xyz;                                
    BumpMapNormal = 2.0 * BumpMapNormal - vec3(1.0, 1.0, 1.0);                              
    vec3 NewNormal;                                                                         
    mat3 TBN = mat3(Tangent, Bitangent, Normal);                                            
    NewNormal = TBN * BumpMapNormal;                                                        
    NewNormal = normalize(NewNormal);                                                       
    return NewNormal;                                                                       
}                                                                                           
                                                                                          
     
void main()
{
	// TODO : calculate the out_color using the texture2D() function
	vec4 color1 = texture2D( texture_1, texcoord);
	//vec4 color2 = texture2D( texture_2, texcoord);

	vec4 color_ambient_light = vec4(0.8f,0.f,0.0f,1);
	vec4 color_diffuse_light = vec4(0.5f,0.f,0.2f,1);
	vec4 color_specular_light = vec4(1.f,1.f,0.0f,1);

	vec4 color_ambient_light1 = vec4(1.f,0.8f,0.0f,1);
	vec4 color_diffuse_light1 = vec4(0.1f,0.f,0.5f,0.3);
	vec4 color_specular_light1 = vec4(0.4f,0.f,0.1f,1);
	
	vec4 color_ambient_light2 = vec4(1.f,0.8f,0.0f,1);
	vec4 color_diffuse_light2 = vec4(0.1f,0.5f,0.0f,0.3);
	vec4 color_specular_light2 = vec4(1.f,1.f,0.0f,1);


	vec3 normal = CalcBumpedNormal();
	
	vec3 L = normalize( light_position - world_position);
	vec3 L1 = normalize( light1 - world_position);
	vec3 L2 = normalize( light2 - world_position);
	vec3 V = normalize( eye_position - world_position);
	vec3 H = normalize( L + V );
	vec3 H1 = normalize( L1 + V);
	vec3 H2 = normalize( L2 + V);
	
	// TODO: define ambient light component
	float ambient_light = 0.25f;

	// TODO: compute diffuse light component
	float diffuse_light = (material_kd + 0.2) * max(dot(normal,L),0);

	// TODO: compute specular light component
	float specular_light = 0;

	if (diffuse_light > 0)
	{
		specular_light =  pow(max(dot(H, normal), 0), (material_shininess)) * (material_ks -0.1f) ;
	}
	
	float cut_off = radians(90.0f);

	float spot_light = dot(-L, light_direction);

	float att = 1;
	if (spot_light > cos(cut_off))
	{
	
		float spot_light_limit = cos(cut_off);
 
		// Quadratic attenuation
		float linear_att = (spot_light - spot_light_limit) / (1 - spot_light_limit);
		float light_att_factor = pow(linear_att, 2);
	
			att = light_att_factor;
		
		diffuse_light = diffuse_light * att;
		specular_light = specular_light * att;
	}
		
// TODO: define ambient light component
	float ambient_light1 = 0.1f;

	// TODO: compute diffuse light component
	float diffuse_light1 = (material_kd + 2.f) * max(dot(normal,L1),0);

	// TODO: compute specular light component
	float specular_light1 = 0;

	if (diffuse_light1 > 0)
	{
		specular_light1 = pow(max(dot(H2, normal), 0), (material_shininess - 10)) * (material_ks) ;
	}
		
	float cut_off1 = radians(90.0f);

	float spot_light1 = dot(-L1, light_direction);

	float att1 = 1;
	if (spot_light1 > cos(cut_off1))
	{
	
		float spot_light_limit1 = cos(cut_off1);
 
		// Quadratic attenuation
		float linear_att = (spot_light1 - spot_light_limit1) / (1 - spot_light_limit1);
		float light_att_factor = pow(linear_att, 2);
	
		
		att1 = light_att_factor;
		diffuse_light1 = diffuse_light1 * att1;
		specular_light1 = specular_light1 * att1;
	}
	
			
// TODO: define ambient light component
	float ambient_light2 = 0.1f;

	// TODO: compute diffuse light component
	float diffuse_light2 = (material_kd + 2.f) * max(dot(normal,L2),0);

	// TODO: compute specular light component
	float specular_light2 = 0;

	if (diffuse_light2 > 0)
	{
		specular_light2 = pow(max(dot(H2, normal), 0), (material_shininess - 10)) * (material_ks) ;
	}
		
	float cut_off2 = radians(90.0f);

	float spot_light2 = dot(-L2, light_direction);

	float att2 = 1;
	if (spot_light2 > cos(cut_off2))
	{
	
		float spot_light_limit2 = cos(cut_off2);
 
		// Quadratic attenuation
		float linear_att = (spot_light2 - spot_light_limit2) / (1 - spot_light_limit2);
		float light_att_factor = pow(linear_att, 2);
	
		
		att2 = light_att_factor;
		diffuse_light2 = diffuse_light2 * att2;
		specular_light2 = specular_light2 * att2;
	}



	out_color =  ambient_light * color_ambient_light + diffuse_light * color_diffuse_light + specular_light * color_specular_light;
	out_color +=  diffuse_light1 * color_diffuse_light1 + specular_light1 * color_specular_light1;
	out_color +=  diffuse_light2 * color_diffuse_light2 + specular_light2 * color_specular_light2;
	
 
}