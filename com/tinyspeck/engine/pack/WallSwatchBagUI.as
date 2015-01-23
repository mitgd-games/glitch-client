package com.tinyspeck.engine.pack
{
	import com.tinyspeck.engine.data.decorate.Swatch;

	public class WallSwatchBagUI extends SwatchBagUI
	{
		/* singleton boilerplate */
		public static var _instance:WallSwatchBagUI = null;
        public static function get instance() : WallSwatchBagUI {
            if (_instance == null) {
                _instance = new WallSwatchBagUI();
            }
            return _instance;
        }
		
		public function WallSwatchBagUI(){
			//set the type
			super(Swatch.TYPE_WALLPAPER);
			
			CONFIG::god {
				if(_instance) throw new Error('Singleton');
			}		
		}
	}
}