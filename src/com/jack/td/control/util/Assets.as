package com.jack.td.control.util
{
	import com.jack.td.view.component.BaseImage;
	
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;	

	public class Assets
	{
		// textures
		[Embed(source="assets/textures/bg_splash.png")]
		private static const asset_bg_splash:Class;

		// texture atlas
		[Embed(source="assets/swf/enemy1.png")]
		private static const enemy1:Class;
		
		[Embed(source="assets/swf/enemy1.xml", mimeType="application/octet-stream")]
		private static const enemy1Xml:Class;


		private static var mTextureDic:Dictionary=new Dictionary();
		private static var mTexturesDic:Dictionary=new Dictionary();
		private static var mTextureAtlasDic:Dictionary=new Dictionary();

		public static function init():void
		{
//			registeTextureAtlas("effect", "effectXml");
//			registeTextureAtlas("asset2", "asset2Xml"); 
//			registeTextureAtlas("asset3", "asset3Xml");
//			registeTextureAtlas("items", "itemsXml");
			registeTextureAtlas("enemy1", "enemy1Xml");
		}

		public static function getBitmap(name:String):Bitmap
		{
			return new Assets[name] as Bitmap;
		}

		public static function getMovieClip(prefix:String, fps:Number=12):MovieClip
		{
			var t:Vector.<Texture>=getTextures(prefix);
			if (t && t.length > 0)
				return new MovieClip(t, fps);

			return null;
		}

		public static function getImage(name:String, touchAble:Boolean=false):Image
		{
			var t:Texture=getTexture(name);
			if (t)
			{
				if (touchAble)
					return new BaseImage(t);
				else
					return new Image(t);
			}

			return null;
		}

		public static function getTexture(name:String, scale:Number=1):Texture
		{
			// get from mTextureDic
			if (mTextureDic[name] == undefined)
			{
				if (Assets[name])
				{
					var data:Object=new Assets[name]();
					if (data is Bitmap)
					{
						mTextureDic[name]=Texture.fromBitmapData((data as Bitmap).bitmapData.clone(), false, false, scale);
						Bitmap(data).bitmapData.dispose();
						data = null;
					}
					else if (data is ByteArray)
					{
						mTextureDic[name]=Texture.fromAtfData(data as ByteArray, scale);
						data = null;
					}
				}
			}
			// get from mTextureAtlasDic
			if (mTextureDic[name] == undefined)
			{
				var t:Texture;
				var atlas:TextureAtlas;
				for each (atlas in mTextureAtlasDic)
				{
					t=atlas.getTexture(name);
					if (t)
					{
						mTextureDic[name]=t;
						break;
					}
				}
			}

			return mTextureDic[name];
		}

		public static function getTextures(prefix:String):Vector.<Texture>
		{
			// get from mTextureAtlasDic
			if (mTexturesDic[prefix] == undefined)
			{
				var t:Vector.<Texture>;
				var atlas:TextureAtlas;
				for each (atlas in mTextureAtlasDic)
				{
					t=atlas.getTextures(prefix);
					if (t && t.length > 0)
					{
						mTexturesDic[prefix]=t;
						break;
					}
				}
			}

			return mTexturesDic[prefix];
		}

		public static function registeTextureAtlas(atlasName:String, xmlName:String):void
		{
			if (mTextureAtlasDic[atlasName] == null)
			{
				var texture:Texture=getTexture(atlasName);
				var xml:XML=XML(new Assets[xmlName]());
				mTextureAtlasDic[atlasName]=new TextureAtlas(texture, xml);
			}
		}

		public static function getTextureAtlas(atlasName:String, xmlName:String):TextureAtlas
		{
			if (mTextureAtlasDic[atlasName] == null)
			{
				var texture:Texture=getTexture(atlasName);
				var xml:XML=XML(new Assets[xmlName]());
				mTextureAtlasDic[atlasName]=new TextureAtlas(texture, xml);
			}

			return mTextureAtlasDic[atlasName];
		}

	}
}
