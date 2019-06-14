// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Dissolve"
{
	Properties
	{
		_Mask("Mask", 2D) = "white" {}
		_Texture0("Texture 0", 2D) = "white" {}
		_Distortion("Distortion", Range( 0 , 1)) = 0.1437543
		_ScrollSpeed("Scroll Speed", Range( 0 , 1)) = 0.8394761
		_Warm("Warm", Color) = (0.09019606,0.1862756,0.8196079,0)
		_Hot("Hot", Color) = (0.01568625,0.9921569,0.1532664,0)
		_Burn("Burn", Range( 0 , 1.1)) = 0.1411765
		_Albedo("Albedo", 2D) = "white" {}
		_HeatWave("Heat Wave", Range( 0 , 1)) = 0
		_WiggleAmount("Wiggle Amount", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		AlphaToMask On
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
		};

		uniform sampler2D _Texture0;
		uniform float _ScrollSpeed;
		uniform sampler2D _Mask;
		uniform float _HeatWave;
		uniform float _Burn;
		uniform float _WiggleAmount;
		uniform sampler2D _Albedo;
		uniform float4 _Albedo_ST;
		uniform float4 _Warm;
		uniform float4 _Hot;
		uniform float4 _Texture0_ST;
		uniform float _Distortion;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_12_0 = ( _Time.y * _ScrollSpeed );
			float2 panner34 = ( temp_output_12_0 * float2( 0,-1 ) + v.texcoord.xy);
			float3 tex2DNode33 = UnpackNormal( tex2Dlod( _Texture0, float4( panner34, 0, 0.0) ) );
			float4 tex2DNode23 = tex2Dlod( _Mask, float4( ( ( (tex2DNode33).xy * _HeatWave ) + v.texcoord.xy ), 0, 0.0) );
			float temp_output_24_0 = step( tex2DNode23.r , _Burn );
			v.vertex.xyz += ( ( ( ase_worldPos * ase_vertex3Pos ) * tex2DNode33 * temp_output_24_0 ) * _WiggleAmount );
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_Albedo = i.uv_texcoord * _Albedo_ST.xy + _Albedo_ST.zw;
			o.Albedo = tex2D( _Albedo, uv_Albedo ).rgb;
			float2 uv_Texture0 = i.uv_texcoord * _Texture0_ST.xy + _Texture0_ST.zw;
			float temp_output_12_0 = ( _Time.y * _ScrollSpeed );
			float2 panner10 = ( temp_output_12_0 * float2( 0,-1 ) + float2( 0,0 ));
			float2 uv_TexCoord8 = i.uv_texcoord + panner10;
			float4 lerpResult16 = lerp( _Warm , _Hot , tex2D( _Mask, ( ( (UnpackNormal( tex2D( _Texture0, uv_Texture0 ) )).xy * _Distortion ) + uv_TexCoord8 ) ));
			float4 temp_cast_1 = (2.0).xxxx;
			float2 panner34 = ( temp_output_12_0 * float2( 0,-1 ) + i.uv_texcoord);
			float3 tex2DNode33 = UnpackNormal( tex2D( _Texture0, panner34 ) );
			float4 tex2DNode23 = tex2D( _Mask, ( ( (tex2DNode33).xy * _HeatWave ) + i.uv_texcoord ) );
			float temp_output_24_0 = step( tex2DNode23.r , _Burn );
			float temp_output_29_0 = ( _Burn / 1.1 );
			float temp_output_43_0 = step( tex2DNode23.r , ( 1.0 - temp_output_29_0 ) );
			float temp_output_45_0 = ( temp_output_43_0 - step( tex2DNode23.r , ( 1.0 - _Burn ) ) );
			float4 temp_cast_2 = (temp_output_45_0).xxxx;
			float4 temp_cast_3 = (temp_output_45_0).xxxx;
			o.Emission = ( ( ( ( pow( lerpResult16 , temp_cast_1 ) * 2.0 ) * ( temp_output_24_0 + ( temp_output_24_0 - step( tex2DNode23.r , temp_output_29_0 ) ) ) ) - temp_cast_2 ) - temp_cast_3 ).rgb;
			o.Alpha = temp_output_43_0;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
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
				surfIN.worldPos = worldPos;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
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
1;1;1918;1016;-375.6213;21.83325;1;True;False
Node;AmplifyShaderEditor.SimpleTimeNode;11;-2169.598,406.6609;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-2204.497,483.7621;Float;False;Property;_ScrollSpeed;Scroll Speed;4;0;Create;True;0;0;False;0;0.8394761;0.828;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;12;-1888.802,402.761;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;35;-2133.286,586.4359;Float;True;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;3;-2203.975,-138.6136;Float;True;Property;_Texture0;Texture 0;2;0;Create;True;0;0;False;0;d01457b88b1c5174ea4235d140b5fab8;d01457b88b1c5174ea4235d140b5fab8;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.PannerNode;34;-1865.163,596.5411;Float;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;4;-1966.668,-139.9981;Float;True;Property;_TextureSample1;Texture Sample 1;1;0;Create;True;0;0;False;0;1f649a906aa594c4b813d3675fdc149f;1f649a906aa594c4b813d3675fdc149f;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;33;-1604.862,616.5537;Float;True;Property;_TextureSample3;Texture Sample 3;9;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;10;-1590.882,327.4366;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,-1;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-1309.641,800.7256;Float;False;Property;_HeatWave;Heat Wave;9;0;Create;True;0;0;False;0;0;0.02;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;5;-1448.766,-165.7829;Float;False;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;36;-1296.302,608.2358;Float;True;True;True;False;True;1;0;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1626.761,89.83045;Float;False;Property;_Distortion;Distortion;3;0;Create;True;0;0;False;0;0.1437543;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;39;-995.553,768.5374;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1028.963,613.5549;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1219.005,315.3313;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1155.896,38.4729;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-487.1521,468.617;Float;True;Constant;_DivideAmount;Divide Amount;9;0;Create;True;0;0;False;0;1.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;2;-981.9996,-203.1337;Float;True;Property;_Mask;Mask;1;0;Create;True;0;0;False;0;dad94e13cca70aa42ad2392a78d9afc1;24172d6c9cc40ce48a5fbffda7610cee;False;white;Auto;Texture2D;0;1;SAMPLER2D;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-523.2869,400.6323;Float;False;Property;_Burn;Burn;7;0;Create;True;0;0;False;0;0.1411765;0.2472269;0;1.1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;40;-706.3428,435.0072;Float;True;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;9;-858.5515,34.76636;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;23;-545.9874,212.4317;Float;True;Property;_TextureSample2;Texture Sample 2;7;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleDivideOpNode;29;-263.1522,477.617;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-593.5002,-67.3334;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;1f649a906aa594c4b813d3675fdc149f;1f649a906aa594c4b813d3675fdc149f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;15;-643.7952,-282.6384;Float;False;Property;_Hot;Hot;6;0;Create;True;0;0;False;0;0.01568625,0.9921569,0.1532664,0;0.8773585,0.7422774,0.08690815,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;14;-644.7952,-443.6384;Float;False;Property;_Warm;Warm;5;0;Create;True;0;0;False;0;0.09019606,0.1862756,0.8196079,0;0.9803922,0.2235138,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;21;-190.5421,-81.94891;Float;True;Constant;_Float0;Float 0;7;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;16;-198.7952,-366.6384;Float;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StepOpNode;28;-112.2535,468.7089;Float;True;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;24;-106.6875,263.1317;Float;True;2;0;FLOAT;0;False;1;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;41;-153.8467,880.2043;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;42;91.15332,737.2043;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;19;163.4579,-388.9489;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;136.8479,476.617;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;48;713.5107,71.4104;Float;True;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;32;317.8479,358.617;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;44;113.1533,891.2043;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;43;312.1533,704.2043;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;512.4579,-352.9489;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WorldPosInputsNode;50;720.2521,-119.188;Float;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;516.0126,259.4317;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;45;511.1533,873.2043;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;1061.252,64.81198;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;1321.095,193.3495;Float;True;3;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;53;1192.884,431.7737;Float;False;Property;_WiggleAmount;Wiggle Amount;10;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;46;835.1533,771.2043;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;47;987.6057,868.6805;Float;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;27;732.0126,-372.5683;Float;True;Property;_Albedo;Albedo;8;0;Create;True;0;0;False;0;None;7a170cdb7cc88024cb628cfcdbb6705c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;52;1579.756,412.7381;Float;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2055.802,205.3376;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;SH_Dissolve;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;0;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;11;0
WireConnection;12;1;13;0
WireConnection;34;0;35;0
WireConnection;34;1;12;0
WireConnection;4;0;3;0
WireConnection;33;0;3;0
WireConnection;33;1;34;0
WireConnection;10;1;12;0
WireConnection;5;0;4;0
WireConnection;36;0;33;0
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;8;1;10;0
WireConnection;6;0;5;0
WireConnection;6;1;7;0
WireConnection;40;0;38;0
WireConnection;40;1;39;0
WireConnection;9;0;6;0
WireConnection;9;1;8;0
WireConnection;23;0;2;0
WireConnection;23;1;40;0
WireConnection;29;0;25;0
WireConnection;29;1;30;0
WireConnection;1;0;2;0
WireConnection;1;1;9;0
WireConnection;16;0;14;0
WireConnection;16;1;15;0
WireConnection;16;2;1;0
WireConnection;28;0;23;1
WireConnection;28;1;29;0
WireConnection;24;0;23;1
WireConnection;24;1;25;0
WireConnection;41;0;25;0
WireConnection;42;0;29;0
WireConnection;19;0;16;0
WireConnection;19;1;21;0
WireConnection;31;0;24;0
WireConnection;31;1;28;0
WireConnection;32;0;24;0
WireConnection;32;1;31;0
WireConnection;44;0;23;1
WireConnection;44;1;41;0
WireConnection;43;0;23;1
WireConnection;43;1;42;0
WireConnection;20;0;19;0
WireConnection;20;1;21;0
WireConnection;26;0;20;0
WireConnection;26;1;32;0
WireConnection;45;0;43;0
WireConnection;45;1;44;0
WireConnection;51;0;50;0
WireConnection;51;1;48;0
WireConnection;49;0;51;0
WireConnection;49;1;33;0
WireConnection;49;2;24;0
WireConnection;46;0;26;0
WireConnection;46;1;45;0
WireConnection;47;0;46;0
WireConnection;47;1;45;0
WireConnection;52;0;49;0
WireConnection;52;1;53;0
WireConnection;0;0;27;0
WireConnection;0;2;47;0
WireConnection;0;9;43;0
WireConnection;0;11;52;0
ASEEND*/
//CHKSM=B0C64B5240E5CA73488A6AD3B2ECCCC1500D4E47