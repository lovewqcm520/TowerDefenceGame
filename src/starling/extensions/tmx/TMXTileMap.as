package starling.extensions.tmx
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;

	/**
	 * @author shaun.mitchell
	 */
	public class TMXTileMap extends Sprite
	{
		// The TMX file to load
		private var _fileName:String;
		private var _loader:URLLoader;
		private var _mapLoaded:Boolean;
		// XML of TMX file
		private var _TMX:XML;
		// Layers and tilesheet holders
		private var _layers:Vector.<TMXLayer>;
		private var _tilesheets:Vector.<TMXTileSheet>;
		// variables pertaining to map description
		private var _numLayers:uint;
		private var _numTilesets:uint;
		private var _tilelistCount:uint;
		private var _mapWidth:uint;
		private var _tileHeight:uint;
		private var _tileWidth:uint;
		// used to get the correct tile from various tilesheets
		private var _gidLookup:Vector.<uint>;
		private var _embedTilesets:Vector.<Bitmap>;

		private var _objectGroups:Vector.<TiledObjectGroup>;

		public function TMXTileMap():void
		{
			_mapLoaded = false;
			_fileName = "";
			_loader = new URLLoader();
			_numLayers = 0;
			_numTilesets = 0;
			_tilelistCount = 0;
			_mapWidth = 0;
			_tileHeight = 0;
			_tileWidth = 0;

			_layers = new Vector.<TMXLayer>();
			_tilesheets = new Vector.<TMXTileSheet>();
			_gidLookup = new Vector.<uint>();
		}

		public function load(file:String):void
		{
			_fileName = file;

			_loader.addEventListener(flash.events.Event.COMPLETE, loadTilesets);
			_loader.load(new URLRequest(_fileName));
		}

		public function loadFromEmbed(tmx:XML, tilesets:Vector.<Bitmap>):void
		{
			_TMX = tmx;
			_embedTilesets = tilesets;

			loadEmbedTilesets();
		}
		
		public function getObject(name:String):TiledObject
		{
			var len:int = _objectGroups.length;
			var og:TiledObjectGroup;
			var tiledObjects:Vector.<TiledObject>;
			var oLen:int;
			var o:TiledObject;
			for (var i:int = 0; i < len; i++) 
			{
				og = _objectGroups[i];
				tiledObjects = og.tiledObjects;
				oLen = tiledObjects.length;
				for (var j:int = 0; j <oLen; j++) 
				{
					o = tiledObjects[j];
					if(o.name == name)
					{
						return o;
					}
				}				
			}			
			
			return null;
		}

		// Getters ------------------------------------------
		public function layers():Vector.<TMXLayer>
		{
			return _layers;
		}

		public function tilesheets():Vector.<TMXTileSheet>
		{
			return _tilesheets;
		}

		public function numLayers():uint
		{
			return _numLayers;
		}

		public function numTilesets():uint
		{
			return _numTilesets;
		}

		public function mapWidth():uint
		{
			return _mapWidth;
		}

		public function tileHeight():uint
		{
			return _tileHeight;
		}

		public function tileWidth():uint
		{
			return _tileWidth;
		}

		// End getters --------------------------------------
		// get the number of tilsets from the TMX XML
		private function getNumTilesets():uint
		{
			if (_mapLoaded)
			{
				var count:uint = 0;
				for (var i:int = 0; i < _TMX.children().length(); i++)
				{
					if (_TMX.tileset[i] != null)
					{
						count++;
					}
				}

				trace(count);
				return count;
			}

			return 0;
		}

		// get the number of layers from the TMX XML
		private function getNumLayers():uint
		{
			if (_mapLoaded)
			{
				var count:uint = 0;
				for (var i:int = 0; i < _TMX.children().length(); i++)
				{
					if (_TMX.layer[i] != null)
					{
						count++;
					}
				}

				trace(count);
				return count;
			}
			return 0;
		}

		private function loadTilesets(event:flash.events.Event):void
		{
			trace("loading tilesets from file");
			_mapLoaded = true;

			_TMX = new XML(_loader.data);

			if (_TMX)
			{
				_mapWidth = _TMX.@width;
				_tileHeight = _TMX.@tileheight;
				_tileWidth = _TMX.@tilewidth;

				trace("map width" + _mapWidth);

				_numLayers = getNumLayers();
				_numTilesets = getNumTilesets();
				// _TMX.properties.property[1].@value;

				var tileSheet:TMXTileSheet = new TMXTileSheet();
				tileSheet.loadTileSheet(_TMX.tileset[_tilelistCount].@name, _TMX.tileset[_tilelistCount].image.@source, _TMX.tileset[_tilelistCount].@tilewidth, _TMX.tileset[_tilelistCount].@tileheight, _TMX.tileset[_tilelistCount].@firstgid - 1);
				tileSheet.addEventListener(starling.events.Event.COMPLETE, loadRemainingTilesets);
				_tilesheets.push(tileSheet);
				_gidLookup.push(_TMX.tileset[_tilelistCount].@firstgid);
				
				// get tiled object group
				_objectGroups = new Vector.<TiledObjectGroup>();
				for each (var objectGroup:XML in _TMX.objectgroup) 
				{
					var og:TiledObjectGroup = new TiledObjectGroup();
					og.name = 		String(objectGroup.@name);
					og.color = 		String(objectGroup.@color);
					og.x = 			Number(objectGroup.@x);
					og.y = 			Number(objectGroup.@y);
					og.width = 		Number(objectGroup.@width);
					og.height = 	Number(objectGroup.@height);
					og.opacity = 	Number(objectGroup.@opacity);
					objectGroup.@opacity == undefined ?	og.opacity = 1 : og.opacity = Number(objectGroup.@opacity);
					objectGroup.@visible == undefined ?	og.visible = true : og.visible = objectGroup.@visible;
					
					// get object
					for each (var object:XML in objectGroup.object) 
					{
						var o:TiledObject = new TiledObject();
						o.name = 	String(object.@name);
						o.type = 	String(object.@type);
						o.x = 		Number(object.@x);
						o.y = 		Number(object.@y);
						o.width = 	Number(object.@width);
						o.height = 	Number(object.@height);
						o.gid = 	String(object.@gid);						
						object.@visible == undefined ?	o.visible = true : o.visible = Boolean(object.@visible);
						
						o.polygon = String(object.polygon.@points);
						o.polyline = String(object.polyline.@points);
						
						// get object property
						for each (var pro:XML in objectGroup.properties.property) 
						{
							o.properties.set(String(pro.@name), String(pro.@value));
						}
						
						og.tiledObjects.push(o);
					}
					
					// get object group property
					for each (var property:XML in objectGroup.properties.property) 
					{
						og.properties.set(String(property.@name), String(property.@value));
					}
					
					_objectGroups.push(og);
				}
			}
		}

		private function loadEmbedTilesets():void
		{
			trace("loading embedded tilesets");
			_mapLoaded = true;

			if (_TMX)
			{
				_mapWidth = _TMX.@width;
				_tileHeight = _TMX.@tileheight;
				_tileWidth = _TMX.@tilewidth;

				trace("map width" + _mapWidth);

				_numLayers = getNumLayers();
				_numTilesets = getNumTilesets();
				trace(_numTilesets);
				// _TMX.properties.property[1].@value;

				for (var i:int = 0; i < _numTilesets; i++)
				{
					var tileSheet:TMXTileSheet = new TMXTileSheet();
					trace(_TMX.tileset[i].@name, _embedTilesets[i], _TMX.tileset[i].@tilewidth, _TMX.tileset[i].@tileheight, _TMX.tileset[i].@firstgid - 1);
					tileSheet.loadEmbedTileSheet(_TMX.tileset[i].@name, _embedTilesets[i], _TMX.tileset[i].@tilewidth, _TMX.tileset[i].@tileheight, _TMX.tileset[i].@firstgid - 1);
					_tilesheets.push(tileSheet);
					_gidLookup.push(_TMX.tileset[i].@firstgid);
				}
				
				loadMapData();
			}
		}

		private function loadRemainingTilesets(event:starling.events.Event):void
		{
			event.target.removeEventListener(starling.events.Event.COMPLETE, loadRemainingTilesets);

			_tilelistCount++;
			if (_tilelistCount >= _numTilesets)
			{
				trace("done loading tilelists");
				loadMapData();
			}
			else
			{
				trace(_TMX.tileset[_tilelistCount].@name);
				var tileSheet:TMXTileSheet = new TMXTileSheet();
				tileSheet.loadTileSheet(_TMX.tileset[_tilelistCount].@name, _TMX.tileset[_tilelistCount].image.@source, _TMX.tileset[_tilelistCount].@tilewidth, _TMX.tileset[_tilelistCount].@tileheight, _TMX.tileset[_tilelistCount].@firstgid - 1);
				tileSheet.addEventListener(starling.events.Event.COMPLETE, loadRemainingTilesets);
				_gidLookup.push(_TMX.tileset[_tilelistCount].@firstgid);
				_tilesheets.push(tileSheet);
			}
		}

		private function loadMapData():void
		{
			if (_mapLoaded)
			{
				for (var i:int = 0; i < _numLayers; i++)
				{
					trace("loading map data");
					var ba:ByteArray = Base64.decodeToByteArray(_TMX.layer[i].data);
					// comment by jack
					//ba.uncompress();

					var data:Array = new Array();

					for (var j:int = 0; j < ba.length; j += 4)
					{
						// Get the grid ID

						var a:int = ba[j];
						var b:int = ba[j + 1];
						var c:int = ba[j + 2];
						var d:int = ba[j + 3];

						var gid:int = a | b << 8 | c << 16 | d << 24;
						data.push(gid);
					}

					var tmxLayer:TMXLayer = new TMXLayer(data);

					_layers.push(tmxLayer);
				}

				drawLayers();
			}
		}

		// draw the layers into a holder contained in a TMXLayer object
		private function drawLayers():void
		{
			trace("drawing layers");
			for (var i:int = 0; i < _numLayers; i++)
			{
				trace("drawing layers");
				var row:int = 0;
				var col:int = 0;
				var arr:Array = _layers[i].getData();
				for (var j:int = 0; j < arr.length; j++)
				{
					if (col > (_mapWidth - 1) * _tileWidth)
					{
						col = 0;
						row += _tileHeight;
					}

					if (arr[j] != 0)
					{
						var img:Image = new Image(_tilesheets[findTileSheet(arr[j])].textureAtlas.getTexture(String(arr[j])));
						img.x = col;
						img.y = row;
						_layers[i].getHolder().addChild(img);
					}

					col += _tileWidth;
				}
			}

			// notify that the load is complete
			dispatchEvent(new starling.events.Event(starling.events.Event.COMPLETE));
		}

		private function findTileSheet(id:uint):int
		{
			var value:int = 0;
			var theOne:int;
			for (var i:int = 0; i < _tilesheets.length; i++)
			{
				if (_tilesheets[i].textureAtlas.getTexture(String(id)) != null)
				{
					theOne = i;
				}
				else
				{
					value = i;
				}
			}
			return theOne;
		}
	}
}
