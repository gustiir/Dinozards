// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_WindDash"
{
	Properties
	{
		_SpeedDir("SpeedDir", Float) = 1.2
		_Emission("Emission", Float) = 4
		_ColorStart("ColorStart", Color) = (0,0.2550521,1,1)
		_ColorEnd("ColorEnd", Color) = (0,0.02701235,1,0)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_Speed("Speed", Vector) = (-1,0,0,0)
		_FadeOut("FadeOut", Float) = -1
		_TextureSample2("Texture Sample 2", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _ColorStart;
		uniform float4 _ColorEnd;
		uniform float _Emission;
		uniform sampler2D _TextureSample2;
		uniform float4 _TextureSample2_ST;
		uniform float _FadeOut;
		uniform sampler2D _TextureSample0;
		uniform float _SpeedDir;
		uniform float2 _Speed;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float temp_output_110_0 = ( 1.0 - pow( ( distance( i.uv_texcoord , float2( 0.5,0.5 ) ) * 2.2 ) , 1.85 ) );
			float4 lerpResult14 = lerp( _ColorStart , _ColorEnd , i.uv_texcoord.x);
			float2 uv_TextureSample2 = i.uv_texcoord * _TextureSample2_ST.xy + _TextureSample2_ST.zw;
			float temp_output_82_0 = ( ( ( ( ( i.uv_texcoord.x + 0.0 ) * ( 1.0 - ( i.uv_texcoord.x + 0.0 ) ) ) * 10.0 ) + _FadeOut ) * 0.44 );
			float temp_output_93_0 = ( temp_output_82_0 * 1.0 );
			o.Emission = ( temp_output_110_0 * ( ( ( lerpResult14 * i.vertexColor * _Emission ) * ( i.vertexColor * tex2D( _TextureSample2, uv_TextureSample2 ) ) ) * temp_output_93_0 ) ).rgb;
			float mulTime29 = _Time.y * _SpeedDir;
			float Time31 = mulTime29;
			float2 UV32 = i.uv_texcoord;
			float2 panner79 = ( Time31 * _Speed + UV32);
			float temp_output_94_0 = ( ( tex2D( _TextureSample0, panner79 ).a * i.vertexColor.a ) * temp_output_93_0 );
			o.Alpha = ( temp_output_110_0 * temp_output_94_0 * temp_output_94_0 );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:fade keepalpha fullforwardshadows noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog nometa 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
-1925;11;1906;988;3495.013;721.4993;1.644023;True;False
Node;AmplifyShaderEditor.TextureCoordinatesNode;83;-2759.722,824.2161;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;28;-3517.716,753.9522;Float;False;Property;_SpeedDir;SpeedDir;0;0;Create;True;0;0;False;0;1.2;1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;89;-2518.511,1014.078;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;29;-3361.953,758.3743;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;30;-3484.301,-57.17591;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;88;-2357.512,840.0783;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;84;-2309.094,1008.01;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-2129.251,-810.9727;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;109;-1686.74,263.6883;Float;False;Constant;_Vector0;Vector 0;9;0;Create;True;0;0;False;0;0.5,0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-2984.592,792.8976;Float;False;Time;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;81;-3328.154,174.1376;Float;False;Property;_Speed;Speed;7;0;Create;True;0;0;False;0;-1,0;-0.96,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;90;-2115.513,922.0783;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-3189.927,-52.66273;Float;True;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;8;-1839.705,-904.7033;Float;False;Property;_ColorEnd;ColorEnd;4;0;Create;True;0;0;False;0;0,0.02701235,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;9;-1847.243,-1075.941;Float;False;Property;_ColorStart;ColorStart;3;0;Create;True;0;0;False;0;0,0.2550521,1,1;0,0.2549019,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;7;-1900.868,-730.0753;Float;True;True;True;True;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;108;-1749.14,26.88781;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;79;-2849.249,27.8141;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;-2,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;14;-1492.677,-774.1652;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;11;-1558.668,-338.988;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;107;-1451.54,153.2881;Float;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1597.322,-507.4552;Float;False;Property;_Emission;Emission;1;0;Create;True;0;0;False;0;4;4;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1632.04,1233.779;Float;False;Property;_FadeOut;FadeOut;8;0;Create;True;0;0;False;0;-1;0.57;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;115;-2026.958,-143.1281;Float;True;Property;_TextureSample2;Texture Sample 2;9;0;Create;True;0;0;False;0;None;2d1799863ec0eae4486837c982fefe7f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-1849.513,914.0783;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;-2467.674,-261.8125;Float;True;Property;_TextureSample0;Texture Sample 0;5;0;Create;True;0;0;False;0;0f49ca6fb10803646a7eef59638d9871;0f49ca6fb10803646a7eef59638d9871;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;82;-1508.992,926.5449;Float;True;ConstantBiasScale;-1;;5;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;-1.68;False;2;FLOAT;0.44;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-1073.584,-770.3192;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;111;-1229.752,153.3326;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;2.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1119.553,-386.0474;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;93;-1286.512,1168.079;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;112;-1000.929,149.2167;Float;True;2;0;FLOAT;0;False;1;FLOAT;1.85;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1103.232,610.1629;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-860.3047,-514.8794;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;-573.6021,-368.5742;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;94;-800.5121,755.0783;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;110;-753.4951,147.3895;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;102;-2326.71,1608.833;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;97;-2448.657,-39.4047;Float;True;Property;_TextureSample1;Texture Sample 1;6;0;Create;True;0;0;False;0;0f49ca6fb10803646a7eef59638d9871;0f49ca6fb10803646a7eef59638d9871;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;103;-2375.128,1440.902;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;100;-2777.341,1425.04;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-1867.129,1514.902;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;114;-307.45,275.9377;Float;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;101;-2536.128,1614.902;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;113;-313.1512,-102.8839;Float;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;92;-1171.022,873.0283;Float;True;2;0;FLOAT;0;False;1;FLOAT;0.64;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;104;-2133.129,1522.902;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;106;-1526.609,1527.368;Float;True;ConstantBiasScale;-1;;6;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT;0;False;1;FLOAT;-1.68;False;2;FLOAT;0.44;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;43;-2354.914,198.2897;Float;True;Property;_T_FlowMap_01;T_FlowMap_01;2;0;Create;True;0;0;False;0;0f49ca6fb10803646a7eef59638d9871;0f49ca6fb10803646a7eef59638d9871;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;22;-3139.383,-128.9957;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;SH_WindDash;False;False;False;False;True;True;True;True;True;True;True;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;89;0;83;1
WireConnection;29;0;28;0
WireConnection;88;0;83;1
WireConnection;84;0;89;0
WireConnection;31;0;29;0
WireConnection;90;0;88;0
WireConnection;90;1;84;0
WireConnection;32;0;30;0
WireConnection;7;0;6;1
WireConnection;79;0;32;0
WireConnection;79;2;81;0
WireConnection;79;1;31;0
WireConnection;14;0;9;0
WireConnection;14;1;8;0
WireConnection;14;2;7;0
WireConnection;107;0;108;0
WireConnection;107;1;109;0
WireConnection;91;0;90;0
WireConnection;20;1;79;0
WireConnection;82;3;91;0
WireConnection;82;1;96;0
WireConnection;15;0;14;0
WireConnection;15;1;11;0
WireConnection;15;2;13;0
WireConnection;111;0;107;0
WireConnection;16;0;11;0
WireConnection;16;1;115;0
WireConnection;93;0;82;0
WireConnection;112;0;111;0
WireConnection;18;0;20;4
WireConnection;18;1;11;4
WireConnection;19;0;15;0
WireConnection;19;1;16;0
WireConnection;95;0;19;0
WireConnection;95;1;93;0
WireConnection;94;0;18;0
WireConnection;94;1;93;0
WireConnection;110;0;112;0
WireConnection;102;0;101;0
WireConnection;97;1;79;0
WireConnection;103;0;100;2
WireConnection;105;0;104;0
WireConnection;114;0;110;0
WireConnection;114;1;94;0
WireConnection;114;2;94;0
WireConnection;101;0;100;2
WireConnection;113;0;110;0
WireConnection;113;1;95;0
WireConnection;92;0;82;0
WireConnection;104;0;103;0
WireConnection;104;1;102;0
WireConnection;106;3;105;0
WireConnection;43;1;79;0
WireConnection;0;2;113;0
WireConnection;0;9;114;0
ASEEND*/
//CHKSM=0953451766B624AB29A24FE5398EC0E3B4204E42