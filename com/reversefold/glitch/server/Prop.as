package com.reversefold.glitch.server {
	public class Prop {
		private var _value : int;
		private var _lo : int;
		private var _hi : int;
		
		public function Prop(value : int = 0, lo : int = 0, hi : int = 2000000000) : void {
			_value = value;
			_lo = lo;
			_hi = hi;
		}
		
		public function get value() : int {
			return _value;
		}
		
		public function get lo() : int {
			return _lo;
		}
		
		public function get hi() : int {
			return _hi;
		}

		//Guessing
		public function get bottom() : int {
			return _lo;
		}

		//A guess
		public function get top() : int {
			return _hi;
		}

		
		public function apiSetLimits(lo : int, hi : int) : void {
			_lo = lo;
			_hi = hi;
		}
		
		public function apiSet(value : int) : void {
			_value = value;
		}
		
		public function apiInc(value : int) : int {
			_value += value;
			return _value;
		}
		
		public function apiDec(value : int) : int {
			_value -= value;
			return _value;
		}
	}
}
