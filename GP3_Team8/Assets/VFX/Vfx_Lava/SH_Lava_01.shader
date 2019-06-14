// Upgrade NOTE: upgraded instancing buffer 'SH_Lava_01' to new syntax.

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Lava_01"
{
	Properties
	{
		_Albedo("Albedo", 2D) = "bump" {}
		_Normals("Normals", 2D) = "white" {}
		_Mask("Mask", 2D) = "white" {}
		_WoodSpecular("WoodSpecular", 2D) = "white" {}
		_FireEffectTex("FireEffectTex", 2D) = "white" {}
		_FireSpeed("FireSpeed", Range( 0 , 1)) = 0.1
		_Smoothness("Smoothness", Float) = 0
		_Emission("Emission", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform sampler2D _Normals;
		uniform float4 _Normals_ST;
		uniform sampler2D _Mask;
		uniform float4 _Mask_ST;
		uniform sampler2D _FireEffectTex;
		uniform float _FireSpeed;
		uniform float _Emission;
		uniform sampler2D _WoodSpecular;
		uniform float4 _WoodSpecular_ST;

		UNITY_INSTANCING_BUFFER_START(SH_Lava_01)
			UNITY_DEFINE_INSTANCED_PROP(float, _Smoothness)
#define _Smoothness_arr SH_Lava_01
		UNITY_INSTANCING_BUFFER_END(SH_Lava_01)

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Normal = UnpackNormal( tex2D( _Albedo, uv_Albedo ) );
			float2 uv_Normals = i.uv_texcoord * _Normals_ST.xy + _Normals_ST.zw;
			o.Albedo = tex2D( _Normals, uv_Normals ).rgb;
			float2 uv_Mask = i.uv_texcoord * _Mask_ST.xy + _Mask_ST.zw;
			float mulTime10 = _Time.y * _FireSpeed;
			float2 temp_cast_1 = (mulTime10).xx;
			float2 uv_TexCoord8 = i.uv_texcoord + temp_cast_1;
			float2 panner7 = ( 1.0 * _Time.y * float2( 0,0.2 ) + uv_TexCoord8);
			o.Emission = ( ( ( tex2D( _Mask, uv_Mask ) * tex2D( _FireEffectTex, panner7 ) ) * ( 0.4007456 * ( _SinTime.w + 2.0 ) ) ) * _Emission ).rgb;
			float2 uv_WoodSpecular = i.uv_texcoord * _WoodSpecular_ST.xy + _WoodSpecular_ST.zw;
			o.Metallic = tex2D( _WoodSpecular, uv_WoodSpecular ).r;
			float _Smoothness_Instance = UNITY_ACCESS_INSTANCED_PROP(_Smoothness_arr, _Smoothness);
			o.Smoothness = _Smoothness_Instance;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
-1913;28;1906;983;3047.148;-187.8114;1.019867;True;False
Node;AmplifyShaderEditor.RangedFloatNode;11;-2719.634,835.4337;Float;False;Property;_FireSpeed;FireSpeed;5;0;Create;True;0;0;False;0;0.1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;10;-2374.82,849.5735;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-2293.423,639.5732;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;7;-1798.946,658.6766;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0.2;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SinTimeNode;12;-1456.581,972.9265;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1455.449,380.5017;Float;True;Property;_Mask;Mask;2;0;Create;True;0;0;False;0;36be8d528a4fa024faa4680d7658642c;36be8d528a4fa024faa4680d7658642c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1204.381,1061.327;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;15;-1283.681,802.6259;Float;False;Constant;_FireIntensity;Fire Intensity;6;0;Create;True;0;0;False;0;0.4007456;0;1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-1409.9,582.3458;Float;True;Property;_FireEffectTex;FireEffectTex;4;0;Create;True;0;0;False;0;f7e96904e8667e1439548f0f86389447;f7e96904e8667e1439548f0f86389447;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-982.1569,411.6919;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-788.3804,963.8264;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-426.2493,492.2772;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-372.7263,274.0606;Float;False;Property;_Emission;Emission;7;0;Create;True;0;0;False;0;0;8.39;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-665.5104,85.07713;Float;False;InstancedProperty;_Smoothness;Smoothness;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1428.336,-40.0988;Float;True;Property;_Albedo;Albedo;0;0;Create;True;0;0;False;0;11f03d9db1a617e40b7ece71f0a84f6f;11f03d9db1a617e40b7ece71f0a84f6f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;-1413.453,-248.8172;Float;True;Property;_Normals;Normals;1;0;Create;True;0;0;False;0;7130c16fd8005b546b111d341310a9a4;7130c16fd8005b546b111d341310a9a4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-801.6364,158.9011;Float;True;Property;_WoodSpecular;WoodSpecular;3;0;Create;True;0;0;False;0;6618005f6bafebf40b3d09f498401fba;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;18;-2020.566,236.863;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1988.481,916.1683;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-2368.65,1033.355;Float;False;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-185.0709,314.8553;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;79.19202,79.19202;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;SH_Lava_01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;10;0;11;0
WireConnection;8;1;10;0
WireConnection;7;0;8;0
WireConnection;13;0;12;4
WireConnection;5;1;7;0
WireConnection;6;0;3;0
WireConnection;6;1;5;0
WireConnection;14;0;15;0
WireConnection;14;1;13;0
WireConnection;16;0;6;0
WireConnection;16;1;14;0
WireConnection;22;0;16;0
WireConnection;22;1;23;0
WireConnection;0;0;2;0
WireConnection;0;1;1;0
WireConnection;0;2;22;0
WireConnection;0;3;4;0
WireConnection;0;4;17;0
ASEEND*/
//CHKSM=9D0EE3BDBF0A46DAD98B052CA9675587CB0EBF68