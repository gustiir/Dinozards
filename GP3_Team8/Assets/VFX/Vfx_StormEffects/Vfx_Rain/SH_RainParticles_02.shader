// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_RainParticles_02"
{
	Properties
	{
		_RainColor("RainColor", Color) = (1,1,1,1)
		_OpacityAlpha("Opacity/Alpha", Range( 0 , 2)) = 1
		_T_Particle_Sprite_rain_01("T_Particle_Sprite_rain_01", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa noforwardadd 
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _RainColor;
		uniform sampler2D _T_Particle_Sprite_rain_01;
		uniform float4 _T_Particle_Sprite_rain_01_ST;
		uniform float _OpacityAlpha;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float2 uv_T_Particle_Sprite_rain_01 = i.uv_texcoord * _T_Particle_Sprite_rain_01_ST.xy + _T_Particle_Sprite_rain_01_ST.zw;
			float4 temp_output_113_0 = pow( tex2D( _T_Particle_Sprite_rain_01, uv_T_Particle_Sprite_rain_01 ) , 2.0 );
			o.Emission = ( pow( ( _RainColor * _RainColor.a ) , 1.0 ) * temp_output_113_0 ).rgb;
			o.Alpha = ( temp_output_113_0 * ( i.vertexColor.a * _OpacityAlpha ) ).r;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
-1913;1;1906;1010;2058.697;2059.865;1.973614;True;False
Node;AmplifyShaderEditor.ColorNode;107;-689.0488,-1126.387;Float;False;Property;_RainColor;RainColor;0;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;108;-403.5472,-1042.187;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;109;-1160.318,-749.0203;Float;True;Property;_T_Particle_Sprite_rain_01;T_Particle_Sprite_rain_01;2;0;Create;True;0;0;False;0;da94e8b1d62b37948a011054d110c3eb;da94e8b1d62b37948a011054d110c3eb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;110;-768.3486,-530.6874;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;111;-774.9996,-215.2094;Float;False;Property;_OpacityAlpha;Opacity/Alpha;1;0;Create;True;0;0;False;0;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;112;-46.61505,-1014.846;Float;False;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;113;-791.6147,-811.8464;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;2;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-332.9999,-238.2094;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;115;-1158.793,-968.13;Float;True;Property;_T_Particle_Sprite_rain_02;T_Particle_Sprite_rain_02;3;0;Create;True;0;0;False;0;dcb2f3892df8e6741be4a18e113e1fbd;dcb2f3892df8e6741be4a18e113e1fbd;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;116;115.6515,-789.6871;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;117;145.2197,-526.0446;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;3;754.4686,-960.2838;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;SH_RainParticles_02;False;False;False;False;True;True;True;True;True;True;True;True;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;108;0;107;0
WireConnection;108;1;107;4
WireConnection;112;0;108;0
WireConnection;113;0;109;0
WireConnection;114;0;110;4
WireConnection;114;1;111;0
WireConnection;116;0;112;0
WireConnection;116;1;113;0
WireConnection;117;0;113;0
WireConnection;117;1;114;0
WireConnection;3;2;116;0
WireConnection;3;9;117;0
ASEEND*/
//CHKSM=7FF5E1CE2E0D62967BC8FAD23A3F87642CF31669