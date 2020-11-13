package {
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class DifficultyBeatScreen {
		
		private var _parent:Sprite;
		private var _screen:MovieClip = new MovieClip();
		private var _nxtLvlButton:Sprite = new GameResources.Button_Next_Level();
		
		public function DifficultyBeatScreen( parent:Sprite ):void {
			_parent = parent;
			
			const x:Number = 150;
			const y:Number = 100;
			
			var clearBackground:Sprite = new Sprite();
			clearBackground.graphics.beginFill( 0x000000, 0.2 );
			clearBackground.graphics.drawRect( 0, 0, GameData.Document.width, GameData.Document.height );
			_screen.addChild( clearBackground );
			
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill( 0x00ff00, 1.0 );
			spr.graphics.drawRect( x, y, 300, 200 );
			_screen.addChild( spr );
			
			var txt:TextField = new TextField();
			txt.text = "You beat Easy! Think you can handle Normal?";
			txt.x = x;
			txt.y = y;
			txt.width = 300;
			_screen.addChild( txt );
			
			_nxtLvlButton.addEventListener( MouseEvent.CLICK, _onClick );
			_nxtLvlButton.x = x + 50;
			_nxtLvlButton.y = y + 100;
			_nxtLvlButton.mouseEnabled = true;
			_nxtLvlButton.buttonMode = true;
			_screen.addChild( _nxtLvlButton );
		}
		
		private function _onClick( me:MouseEvent ):void {
			hide();
		}
		
		public function show():void {
			if( _parent.contains( _screen ) )
				return;
				
			_parent.addChild( _screen );
		}
		
		public function hide():void {
			if ( _parent.contains( _screen ) == false )
				return;
				
			_parent.removeChild( _screen );
		}
	}
}
