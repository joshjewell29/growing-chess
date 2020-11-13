package {
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class LevelButton extends MovieClip {
		
		public var level:uint;
		
		public function LevelButton( spr:Sprite ):void {
			addChild( spr );
		}
	}
}
