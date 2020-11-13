package {
	
	import flash.display.Sprite;
	import flash.display.MovieClip;

	public class MovementDisplayControl extends MovieClip {
		
		private var _currentSprite:Sprite = new Sprite();
		private var _default:Sprite = new Sprite();
		private var _pawn1:Sprite = new GameResources.MovementPawn();
		private var _pawn2:Sprite = new GameResources.MovementPawn2();
		private var _pawn3:Sprite = new GameResources.MovementPawn3();
		
		private var _rook1:Sprite = new GameResources.MovementRook();
		private var _rook2:Sprite = new GameResources.MovementRook2();
		private var _rook3:Sprite = new GameResources.MovementRook3();
		
		private var _bishop1:Sprite = new GameResources.MovementBishop();
		private var _bishop2:Sprite = new GameResources.MovementBishop2();
		private var _bishop3:Sprite = new GameResources.MovementBishop3();
		
		private var _queen1:Sprite = new GameResources.MovementQueen();
		private var _queen2:Sprite = new GameResources.MovementQueen2();
		private var _queen3:Sprite = new GameResources.MovementQueen3();

		public function MovementDisplayControl():void {
			_setupSprite( _pawn1 );
			_setupSprite( _rook1 );
			_setupSprite( _bishop1 );
			_setupSprite( _queen1 );
			
			_setupSprite( _pawn2 );
			_setupSprite( _rook2 );
			_setupSprite( _bishop2 );
			_setupSprite( _queen2 );
			
			_setupSprite( _pawn3 );
			_setupSprite( _rook3 );
			_setupSprite( _bishop3 );
			_setupSprite( _queen3 );
		}
		
		private function _setupSprite( spr:Sprite ):void {
			spr.width = 100;
			spr.height = 100;
			spr.visible = false;
			addChild( spr );
		}
		
		public function showPiece( type:uint ):void {
			_currentSprite.visible = false;
			
			switch( type ) {
				case Piece.PAWN1:
					_currentSprite = _pawn1;
					break;
				case Piece.PAWN2:
					_currentSprite = _pawn2;
					break;
				case Piece.PAWN3:
					_currentSprite = _pawn3;
					break;
				case Piece.ROOK1:
					_currentSprite = _rook1;
					break;
				case Piece.ROOK2:
					_currentSprite = _rook2;
					break;
				case Piece.ROOK3:
					_currentSprite = _rook3;
					break;
				case Piece.BISH1:
					_currentSprite = _bishop1;
					break;
				case Piece.BISH2:
					_currentSprite = _bishop2;
					break;
				case Piece.BISH3:
					_currentSprite = _bishop3;
					break;
				case Piece.QUEEN1:
					_currentSprite = _queen1;
					break;
				case Piece.QUEEN2:
					_currentSprite = _queen2;
					break;
				case Piece.QUEEN3:
					_currentSprite = _queen3;
					break;
				default:
					_currentSprite = _default;
					break;
			}
			
			_currentSprite.visible = true;
		}
		
		public function clearShownPiece():void {
			_currentSprite.visible = false;
		}
	}
}
