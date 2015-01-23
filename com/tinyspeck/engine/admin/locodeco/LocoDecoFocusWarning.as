package com.tinyspeck.engine.admin.locodeco
{
import com.tinyspeck.engine.control.TSFrontController;
import com.tinyspeck.engine.model.TSModelLocator;
import com.tinyspeck.engine.port.CSSManager;
import com.tinyspeck.engine.view.util.StaticFilters;

import flash.text.TextField;

public class LocoDecoFocusWarning extends TextField {
	/* singleton boilerplate */
	public static var _instance:LocoDecoFocusWarning = null;
        public static function get instance() : LocoDecoFocusWarning {
            if (_instance == null) {
                _instance = new LocoDecoFocusWarning();
            }
            return _instance;
        }
	
	private var _model:TSModelLocator;
	
	public function LocoDecoFocusWarning() {
		CONFIG::god {
			if(_instance) throw new Error('Singleton');
		}
		
		_model = TSModelLocator.instance;
		
		styleSheet = CSSManager.instance.styleSheet;
		multiline = false;
		wordWrap = false;
		filters = StaticFilters.disconnectScreen_GlowA;
		htmlText = "<p class='un_focused_screen'>LOCODECO: Click the game if your keyboard doesn't work!</p>";
		width = 1000;
		height = textHeight + 4;
		width = textWidth + 4;
	}
	
	public function refresh():void {
		x = _model.layoutModel.gutter_w + _model.layoutModel.loc_vp_w - 10 - width;
		y = _model.layoutModel.header_h + _model.layoutModel.loc_vp_h - 10 - height;
	}
	
	public function show():void {
		refresh();
		TSFrontController.instance.addUnderCursor(this);
	}
	
	public function hide():void {
		parent.removeChild(this);
	}
}
}