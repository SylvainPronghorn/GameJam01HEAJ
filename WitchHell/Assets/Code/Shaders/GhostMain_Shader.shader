// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "GhostMain_Shader"
{
	Properties
	{
		[NoScaleOffset]_Albedo("Albedo", 2D) = "white" {}
		[NoScaleOffset]_Emission("Emission", 2D) = "white" {}
		_MainTilingandOffset("Main Tiling and Offset", Vector) = (1,1,0,0)
		_AlbedoTint("Albedo Tint", Color) = (1,1,1,0)
		_EmissionTint("Emission Tint", Color) = (1,1,1,0)
		_FresnelBias("Fresnel Bias", Float) = 0
		_FresnelScale("Fresnel Scale", Float) = 1
		_FresnelPower("Fresnel Power", Float) = 4
		_NDotLPower("NDotL Power", Range( 0.01 , 16)) = 1
		_NDotLIntensity("NDotL Intensity", Range( 0.01 , 10)) = 1
		_OpacityHandler("OpacityHandler", Range( 0 , 1)) = 1
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
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float4 _AlbedoTint;
		uniform sampler2D _Albedo;
		uniform float4 _MainTilingandOffset;
		uniform sampler2D _Emission;
		uniform float4 _EmissionTint;
		uniform float _FresnelBias;
		uniform float _FresnelScale;
		uniform float _FresnelPower;
		uniform float _NDotLPower;
		uniform float _NDotLIntensity;
		uniform float _OpacityHandler;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 appendResult19 = (float3(_AlbedoTint.r , _AlbedoTint.g , _AlbedoTint.b));
			float2 appendResult7 = (float2(_MainTilingandOffset.z , _MainTilingandOffset.w));
			float2 appendResult6 = (float2(_MainTilingandOffset.x , _MainTilingandOffset.y));
			float2 temp_cast_0 = (0.5).xx;
			float2 MainUV13 = ( appendResult7 + ( appendResult6 * ( i.uv_texcoord - temp_cast_0 ) ) + 0.5 );
			float4 tex2DNode3 = tex2D( _Albedo, MainUV13 );
			float3 appendResult20 = (float3(tex2DNode3.r , tex2DNode3.g , tex2DNode3.b));
			float4 tex2DNode4 = tex2D( _Emission, MainUV13 );
			float3 appendResult23 = (float3(tex2DNode4.r , tex2DNode4.g , tex2DNode4.b));
			float3 appendResult22 = (float3(_EmissionTint.r , _EmissionTint.g , _EmissionTint.b));
			float3 FinalEmissif26 = ( ( appendResult19 * appendResult20 ) + ( appendResult23 * appendResult22 ) );
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = Unity_SafeNormalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV28 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode28 = ( _FresnelBias + _FresnelScale * pow( 1.0 - fresnelNdotV28, _FresnelPower ) );
			float Fresnel32 = saturate( fresnelNode28 );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float dotResult38 = dot( ase_normWorldNormal , ase_worldViewDir );
			float NDotL42 = saturate( ( pow( dotResult38 , _NDotLPower ) * _NDotLIntensity ) );
			float temp_output_53_0 = saturate( ( saturate( ( Fresnel32 + NDotL42 ) ) * _OpacityHandler ) );
			o.Emission = ( FinalEmissif26 * temp_output_53_0 );
			o.Alpha = temp_output_53_0;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit alpha:premul keepalpha fullforwardshadows exclude_path:deferred 

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
				float3 worldNormal : TEXCOORD3;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
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
				surfIN.worldNormal = IN.worldNormal;
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
Version=17402
302;73;814;655;196.4301;-92.77307;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;14;-2869.334,15.57956;Inherit;False;986.5498;542.0001;;9;5;7;6;8;9;10;11;12;13;Main UV;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;49;-1561.563,1688.74;Inherit;False;1437.422;408.9104;Comment;9;37;36;41;38;47;40;46;39;42;NDotL;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector4Node;5;-2819.334,66.80734;Inherit;False;Property;_MainTilingandOffset;Main Tiling and Offset;2;0;Create;True;0;0;False;0;1,1,0,0;1,1,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-2750.785,441.5796;Inherit;False;Constant;_Float0;Float 0;3;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;9;-2793.785,306.5796;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;37;-1501.569,1882.656;Inherit;False;World;True;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;6;-2577.785,65.57956;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;10;-2568.785,306.5796;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WorldNormalVector;36;-1511.563,1738.74;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-2392.785,280.5796;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-1243.758,1981.651;Inherit;False;Property;_NDotLPower;NDotL Power;8;0;Create;True;0;0;False;0;1;0;0.01;16;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;7;-2580.785,160.5796;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;50;-1291.229,983.9734;Inherit;False;940.1749;309.0001;Comment;6;30;31;29;28;33;32;Fresnel;1,1,1,1;0;0
Node;AmplifyShaderEditor.DotProductOpNode;38;-1109.429,1823.589;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;29;-1231.229,1033.973;Inherit;False;Property;_FresnelBias;Fresnel Bias;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-939.1814,1977.435;Inherit;False;Property;_NDotLIntensity;NDotL Intensity;9;0;Create;True;0;0;False;0;1;0;0.01;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;40;-960.4615,1831.366;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-1240.229,1104.974;Inherit;False;Property;_FresnelScale;Fresnel Scale;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1241.229,1176.974;Inherit;False;Property;_FresnelPower;Fresnel Power;7;0;Create;True;0;0;False;0;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;12;-2252.785,258.5796;Inherit;False;3;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;48;-1561.617,-275.7489;Inherit;False;1310.671;962.947;Emissif;14;16;15;3;4;17;21;20;22;19;23;18;24;25;26;Emissif;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;46;-685.4227,1834.547;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;13;-2106.785,265.5796;Inherit;False;MainUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FresnelNode;28;-969.3657,1064.68;Inherit;False;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;33;-738.6854,1063.524;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-1501.481,291.9089;Inherit;False;13;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;-1511.617,14.89375;Inherit;False;13;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;39;-486.3338,1826.024;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;4;-1322.432,268.8553;Inherit;True;Property;_Emission;Emission;1;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-1331.087,-10.20231;Inherit;True;Property;_Albedo;Albedo;0;1;[NoScaleOffset];Create;True;0;0;False;0;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;42;-348.1411,1822.569;Inherit;False;NDotL;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;32;-575.0544,1042.946;Inherit;False;Fresnel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;17;-1258.266,-225.7489;Inherit;False;Property;_AlbedoTint;Albedo Tint;3;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;21;-1246.493,475.1982;Inherit;False;Property;_EmissionTint;Emission Tint;4;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;20;-1048.183,20.96805;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;22;-1033.493,504.1981;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;34;-121.1581,62.8544;Inherit;False;32;Fresnel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;-118.4393,154.5669;Inherit;False;42;NDotL;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;19;-1056.074,-197.1729;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;-1032.183,297.968;Inherit;False;FLOAT3;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;-863.1963,388.8845;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-876.5894,-55.75083;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;64.67389,111.2456;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-628.6552,189.4437;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;45;210.9473,107.6339;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;52;103.5628,251.2991;Inherit;False;Property;_OpacityHandler;OpacityHandler;10;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;26;-474.9464,182.3127;Inherit;False;FinalEmissif;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;436.735,106.4419;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;27;590.2188,-203.0131;Inherit;False;26;FinalEmissif;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;53;585.7309,102.3028;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;854.9556,-190.2688;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;2;1048.919,-201.2451;Float;False;True;-1;2;ASEMaterialInspector;0;0;Unlit;GhostMain_Shader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Premultiply;0.5;True;True;0;False;Transparent;;Transparent;ForwardOnly;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;3;1;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexScale;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;6;0;5;1
WireConnection;6;1;5;2
WireConnection;10;0;9;0
WireConnection;10;1;8;0
WireConnection;11;0;6;0
WireConnection;11;1;10;0
WireConnection;7;0;5;3
WireConnection;7;1;5;4
WireConnection;38;0;36;0
WireConnection;38;1;37;0
WireConnection;40;0;38;0
WireConnection;40;1;41;0
WireConnection;12;0;7;0
WireConnection;12;1;11;0
WireConnection;12;2;8;0
WireConnection;46;0;40;0
WireConnection;46;1;47;0
WireConnection;13;0;12;0
WireConnection;28;1;29;0
WireConnection;28;2;30;0
WireConnection;28;3;31;0
WireConnection;33;0;28;0
WireConnection;39;0;46;0
WireConnection;4;1;16;0
WireConnection;3;1;15;0
WireConnection;42;0;39;0
WireConnection;32;0;33;0
WireConnection;20;0;3;1
WireConnection;20;1;3;2
WireConnection;20;2;3;3
WireConnection;22;0;21;1
WireConnection;22;1;21;2
WireConnection;22;2;21;3
WireConnection;19;0;17;1
WireConnection;19;1;17;2
WireConnection;19;2;17;3
WireConnection;23;0;4;1
WireConnection;23;1;4;2
WireConnection;23;2;4;3
WireConnection;24;0;23;0
WireConnection;24;1;22;0
WireConnection;18;0;19;0
WireConnection;18;1;20;0
WireConnection;44;0;34;0
WireConnection;44;1;43;0
WireConnection;25;0;18;0
WireConnection;25;1;24;0
WireConnection;45;0;44;0
WireConnection;26;0;25;0
WireConnection;51;0;45;0
WireConnection;51;1;52;0
WireConnection;53;0;51;0
WireConnection;35;0;27;0
WireConnection;35;1;53;0
WireConnection;2;2;35;0
WireConnection;2;9;53;0
ASEEND*/
//CHKSM=440E36A95ED61401CA1BF5D12B94EF1989C9FBAB