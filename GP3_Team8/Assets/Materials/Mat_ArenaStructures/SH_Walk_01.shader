// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SH_Walk"
{
	Properties
	{
		_FireColor("FireColor", Color) = (1,1,1,1)
		_TextureSample0("Texture Sample 0", 2D) = "white" {}
		_OpacityAlpha("Opacity/Alpha", Range( 0 , 2)) = 2
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_T_SmokeLowDetail_8x8_01("T_SmokeLowDetail_8x8_01", 2D) = "white" {}
		_Emission("Emission", Float) = 1
		_Noise_Opacity("Noise_Opacity", Float) = 1
		_Float0("Float 0", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend One One
		
		AlphaToMask On
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform float4 _FireColor;
		uniform sampler2D _T_SmokeLowDetail_8x8_01;
		uniform float4 _T_SmokeLowDetail_8x8_01_ST;
		uniform float _OpacityAlpha;
		uniform float _Emission;
		uniform float _Float0;
		uniform float _Noise_Opacity;
		uniform sampler2D _TextureSample0;
		uniform float _Cutoff = 0.5;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 color18 = IsGammaSpace() ? float4(0.2924528,0.2924528,0.2924528,1) : float4(0.06955753,0.06955753,0.06955753,1);
			float2 uv_T_SmokeLowDetail_8x8_01 = i.uv_texcoord * _T_SmokeLowDetail_8x8_01_ST.xy + _T_SmokeLowDetail_8x8_01_ST.zw;
			float4 tex2DNode12 = tex2D( _T_SmokeLowDetail_8x8_01, uv_T_SmokeLowDetail_8x8_01 );
			float4 temp_output_6_0 = ( i.vertexColor * i.vertexColor );
			float temp_output_4_0 = ( i.vertexColor.a * _OpacityAlpha );
			o.Emission = ( ( ( ( color18 * color18.a ) * ( _FireColor * _FireColor.a ) ) * tex2DNode12 * ( temp_output_6_0 + temp_output_4_0 ) ) * _Emission ).rgb;
			float2 temp_output_24_0 = ( i.uv_texcoord * 2.0 );
			float4 tex2DNode26 = tex2D( _TextureSample0, temp_output_24_0 );
			float lerpResult28 = lerp( 0.0 , 5.0 , ( 1.0 - (i.vertexColor).r ));
			float temp_output_36_0 = ( _Float0 * ( _Noise_Opacity - ( ( tex2DNode26.r * 1.0 ) * lerpResult28 ) ) );
			o.Alpha = temp_output_36_0;
			#if UNITY_PASS_SHADOWCASTER
			clip( temp_output_36_0 - _Cutoff );
			#endif
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows 

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
-1913;7;1906;1004;2038.554;286.767;1.319335;True;False
Node;AmplifyShaderEditor.VertexColorNode;23;-1715.33,1315.732;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;22;-1908.33,1023.733;Float;False;Constant;_Float2;Float 2;3;0;Create;True;0;0;False;0;2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-1985.33,879.7326;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-1699.33,938.7326;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ComponentMaskNode;25;-1498.33,1308.732;Float;False;True;False;False;False;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;18;-1942.825,-664.2542;Float;False;Constant;_Color1;Color 1;5;0;Create;True;0;0;False;0;0.2924528,0.2924528,0.2924528,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;2;-1825.391,223.1873;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;3;-1947.114,-463.512;Float;False;Property;_FireColor;FireColor;0;0;Create;True;0;0;False;0;1,1,1,1;1,0.5773492,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;27;-1243.33,1301.732;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-1845.042,453.6653;Float;False;Property;_OpacityAlpha;Opacity/Alpha;2;0;Create;True;0;0;False;0;2;2;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;26;-1525.33,829.7324;Float;True;Property;_TextureSample0;Texture Sample 0;1;0;Create;True;0;0;False;0;74b4b67d8ec1be54a8babc4dc731abff;74b4b67d8ec1be54a8babc4dc731abff;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-1520.116,147.8878;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1664.612,-349.3126;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-1664.825,-642.2542;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1397.065,430.6653;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-1144.262,936.8623;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;28;-909.3308,1266.732;Float;False;3;0;FLOAT;0;False;1;FLOAT;5;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-929.3308,605.7324;Float;False;Property;_Noise_Opacity;Noise_Opacity;7;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-1189.915,9.888227;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-703.3308,1004.733;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;12;-1798.019,-101.3355;Float;True;Property;_T_SmokeLowDetail_8x8_01;T_SmokeLowDetail_8x8_01;5;0;Create;True;0;0;False;0;2e647f1661e870a45b7c9586a03afdf7;2e647f1661e870a45b7c9586a03afdf7;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-1363.825,-540.2542;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;14;-975.5651,-438.1678;Float;True;Property;_Emission;Emission;6;0;Create;True;0;0;False;0;1;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-553.331,615.7324;Float;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-954.4135,-119.8125;Float;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-702.8851,481.2399;Float;False;Property;_Float0;Float 0;8;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-688.0181,-202.2352;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;16;-990.8253,-625.2542;Float;False;Constant;_Color0;Color 0;5;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-1196.846,245.83;Float;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-915.7452,177.33;Float;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;36;-305.885,463.2399;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-723.8256,-529.2542;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-744.5027,746.7983;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;35;-1530.262,1029.862;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;74b4b67d8ec1be54a8babc4dc731abff;74b4b67d8ec1be54a8babc4dc731abff;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;-329.2796,190.8148;Float;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-2.68343,4.025146;Float;False;True;2;Float;ASEMaterialInspector;0;0;Unlit;SH_Walk;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;4;1;False;-1;1;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;3;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;24;0;21;0
WireConnection;24;1;22;0
WireConnection;25;0;23;0
WireConnection;27;0;25;0
WireConnection;26;1;24;0
WireConnection;6;0;2;0
WireConnection;6;1;2;0
WireConnection;9;0;3;0
WireConnection;9;1;3;4
WireConnection;19;0;18;0
WireConnection;19;1;18;4
WireConnection;4;0;2;4
WireConnection;4;1;1;0
WireConnection;29;0;26;1
WireConnection;28;2;27;0
WireConnection;8;0;6;0
WireConnection;8;1;4;0
WireConnection;30;0;29;0
WireConnection;30;1;28;0
WireConnection;20;0;19;0
WireConnection;20;1;9;0
WireConnection;32;0;31;0
WireConnection;32;1;30;0
WireConnection;11;0;20;0
WireConnection;11;1;12;0
WireConnection;11;2;8;0
WireConnection;15;0;11;0
WireConnection;15;1;14;0
WireConnection;7;0;6;0
WireConnection;7;1;4;0
WireConnection;7;2;12;0
WireConnection;10;0;7;0
WireConnection;36;0;33;0
WireConnection;36;1;32;0
WireConnection;17;0;16;0
WireConnection;17;1;14;0
WireConnection;34;0;26;1
WireConnection;35;1;24;0
WireConnection;37;0;10;0
WireConnection;37;1;36;0
WireConnection;0;2;15;0
WireConnection;0;9;36;0
WireConnection;0;10;36;0
ASEEND*/
//CHKSM=EB062705803CB9582CA63F618EEA7EA0F1383196