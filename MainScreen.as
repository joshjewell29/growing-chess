package {

	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class MainScreen {
		
		private var _parent:Sprite;
		private var _screen:MovieClip = new MovieClip();
		
		public function MainScreen( parent:Sprite ):void {
			_parent = parent;
			
			var spr:Sprite = new Sprite();
			spr.graphics.beginFill( 0xFFFFFF );
			spr.graphics.drawRect( 0, 0, GameData.Document.width, GameData.Document.height );
			_screen.addChild( spr );
			
			const width:Number = 200;
			const height:Number = 50;
			
			var banner:Sprite = new GameResources.GameBaner();
			banner.width = 530;
			banner.height = 120;
			_screen.addChild( banner );
			
			var lvlSelectButton:Sprite = new GameResources.BtnLevelSelect();
			lvlSelectButton.width = width;
			lvlSelectButton.height = height;
			lvlSelectButton.x = 150;
			lvlSelectButton.y = 200;
			lvlSelectButton.buttonMode = true;
			lvlSelectButton.addEventListener( MouseEvent.CLICK, _onLevelSelect );
			_screen.addChild( lvlSelectButton );
			
			var creditsButton:Sprite = new GameResources.BtnCredits();
			creditsButton.width = width;
			creditsButton.height = height;
			creditsButton.x = 150;
			creditsButton.y = 275;
			creditsButton.buttonMode = true;
			creditsButton.addEventListener( MouseEvent.CLICK, _onCredits );
			_screen.addChild( creditsButton );
			
			var rivalGamesButton:Sprite = new GameResources.BtnRivalGames();
			rivalGamesButton.width = width;
			rivalGamesButton.height = height;
			rivalGamesButton.x = 150;
			rivalGamesButton.y = 350;
			rivalGamesButton.buttonMode = true;
			rivalGamesButton.addEventListener( MouseEvent.CLICK, _onRivalGamesButtonClick );
			_screen.addChild( rivalGamesButton );
		}
		
		private function _onCredits( me:MouseEvent ):void {
			Utility.LogAction( "_onCredits from MainScreen." );
		}
		
		private function _onLevelSelect( me:MouseEvent ):void {
			Utility.LogAction( "_onLevelSelect from MainScreen." );
			GameData.Document.levelSelectScreen.show();
			hide();
		}
		
		private function _onRivalGamesButtonClick( me:MouseEvent ):void {
			Utility.LogAction( "_onRivalGamesButtonClick from MainScreen." );
			var url:URLRequest = new URLRequest("http://www.rivalgames.org");
			navigateToURL( url );
		}
		
		public function show():void {
			if( _parent.contains( _screen ) )
				return;
				
			_parent.addChild( _screen );
		}
		
		public function hide():void {
			if( !_parent.contains( _screen ) )
				return;
				
			_parent.removeChild( _screen );
		}
	}
}
