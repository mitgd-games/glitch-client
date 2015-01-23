package com.tinyspeck.engine.pack
{
	import com.tinyspeck.engine.data.decorate.Swatch;

	public class FloorSwatchBagUI extends SwatchBagUI
	{
		/* singleton boilerplate */
		public static var _instance:FloorSwatchBagUI = null;
        public static function get instance() : FloorSwatchBagUI {
            if (_instance == null) {
                _instance = new FloorSwatchBagUI();
            }
            return _instance;
        }
		
		public function FloorSwatchBagUI(){
			//set the type
			super(Swatch.TYPE_FLOOR);
			
			CONFIG::god {
				if(_instance) throw new Error('Singleton');
			}			
		}
	}
}