// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Lightning_6x6_01"
{
	Properties
	{
		_LightningColor("LightningColor", Color) = (1,1,1,1)
		_OpacityAlpha("Opacity/Alpha", Range( 0 , 2)) = 2
		_T_SmokeLowDetail_8x8_01("T_SmokeLowDetail_8x8_01", 2D) = "white" {}
		_Emission("Emission", Float) = 5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _LightningColor;
		uniform float _Emission;
		uniform sampler2D _T_SmokeLowDetail_8x8_01;
		uniform float4 _T_SmokeLowDetail_8x8_01_ST;
		uniform float _OpacityAlpha;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_T_SmokeLowDetail_8x8_01 = i.uv_texcoord * _T_SmokeLowDetail_8x8_01_ST.xy + _T_SmokeLowDetail_8x8_01_ST.zw;
			float grayscale12 = Luminance(tex2D( _T_SmokeLowDetail_8x8_01, uv_T_SmokeLowDetail_8x8_01 ).rgb);
			float temp_output_13_0 = pow( grayscale12 , 3.3 );
			float4 temp_output_5_0 = ( i.vertexColor * i.vertexColor );
			float temp_output_4_0 = ( i.vertexColor.a * _OpacityAlpha );
			float4 temp_output_8_0 = ( temp_output_5_0 + temp_output_4_0 );
			o.Emission = ( ( ( _LightningColor * _LightningColor.a ) * _Emission ) * ( temp_output_13_0 * temp_output_8_0 * temp_output_8_0 ) ).rgb;
			o.Alpha = ( ( temp_output_5_0 * temp_output_4_0 * temp_output_13_0 ) * float4( 1,1,1,0 ) ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard alpha:fade keepalpha fullforwardshadows 

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
-1923;12;1918;1016;1959.388;468.7316;1.3;True;False
Node;AmplifyShaderEditor.SamplerNode;6;-1687.881,-63.32772;Float;True;Property;_T_SmokeLowDetail_8x8_01;T_SmokeLowDetail_8x8_01;2;0;Create;True;0;0;False;0;c892a8cd812b8014e8ac8bafe9de34d9;c892a8cd812b8014e8ac8bafe9de34d9;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;1;-1403.436,501.2997;Float;False;Property;_OpacityAlpha;Opacity/Alpha;1;0;Create;True;0;0;False;0;2;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;2;-1342.103,270.5828;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;12;-1365.409,-64.97783;Float;True;0;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-1084.487,195.5223;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-961.4358,478.2997;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;3;-1205.683,-483.9774;Float;False;Property;_LightningColor;LightningColor;0;0;Create;True;0;0;False;0;1,1,1,1;0.1462264,0.6376427,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-555.386,-232.131;Float;False;Property;_Emission;Emission;3;0;Create;True;0;0;False;0;5;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;13;-1126.516,-62.13672;Float;True;2;0;FLOAT;0;False;1;FLOAT;3.3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-792.216,53.308;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-893.2838,-359.3777;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-335.6857,-408.9313;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-761.216,293.4645;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-518.7844,-72.17805;Float;True;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-501.1161,216.9644;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-161.4868,-151.5312;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;0,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;SH_Lightning_6x6_01;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;True;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;12;0;6;0
WireConnection;5;0;2;0
WireConnection;5;1;2;0
WireConnection;4;0;2;4
WireConnection;4;1;1;0
WireConnection;13;0;12;0
WireConnection;8;0;5;0
WireConnection;8;1;4;0
WireConnection;9;0;3;0
WireConnection;9;1;3;4
WireConnection;16;0;9;0
WireConnection;16;1;17;0
WireConnection;7;0;5;0
WireConnection;7;1;4;0
WireConnection;7;2;13;0
WireConnection;11;0;13;0
WireConnection;11;1;8;0
WireConnection;11;2;8;0
WireConnection;10;0;7;0
WireConnection;18;0;16;0
WireConnection;18;1;11;0
WireConnection;0;2;18;0
WireConnection;0;9;10;0
ASEEND*/
//CHKSM=728E02BA892EE5393E4CBBB93501DDE61E55E9BB