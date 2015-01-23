package com.tinyspeck.engine.pack
{
	import com.tinyspeck.engine.data.decorate.Swatch;

	public class CeilingSwatchBagUI extends SwatchBagUI
	{
		/* singleton boilerplate */
		public static var _instance:CeilingSwatchBagUI = null;
        public static function get instance() : CeilingSwatchBagUI {
            if (_instance == null) {
                _instance = new CeilingSwatchBagUI();
            }
            return _instance;
        }
		
		public function CeilingSwatchBagUI(){
			//set the type
			super(Swatch.TYPE_CEILING);
			
			CONFIG::god {
				if(_instance) throw new Error('Singleton');
			}			
		}
	}
}