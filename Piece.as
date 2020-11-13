package {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	
	public class Piece {
		
		private static const MAX_TILE_VALUE:uint = 99;
		
		private static var uniqueCounter:uint = 0;
		static public const INVALID:uint = uniqueCounter++;
		
		//Order important to decide if something is a bad trade.
		static public const PAWN1:uint = uniqueCounter++;
		static public const ROOK1:uint = uniqueCounter++;
		static public const BISH1:uint = uniqueCounter++;
		static public const QUEEN1:uint = uniqueCounter++;
		
		static public const PAWN2:uint = uniqueCounter++;
		static public const ROOK2:uint = uniqueCounter++;
		static public const BISH2:uint = uniqueCounter++;
		static public const QUEEN2:uint = uniqueCounter++;
		
		static public const PAWN3:uint = uniqueCounter++;
		static public const ROOK3:uint = uniqueCounter++;
		static public const BISH3:uint = uniqueCounter++;
		static public const QUEEN3:uint = uniqueCounter++;
		
		static public const FLAG:uint = uniqueCounter++;
		
		private var _type:uint = INVALID; 
		private var _sprite:Sprite;
		private var _ghost:Sprite;
		private var _gameTile:Tile = null;
		public var _player:uint = 0;
		private var _moveLogic:MoveLogic;
		
		public function Piece( moveLogic:MoveLogic, type:uint, player:uint ):void {
			_type = type;
			_player = player;
			_moveLogic = moveLogic;
		}
		
		public function getType():uint {
			return _type;
		}
		
		public function CopyAsPlayer( player:uint ):Piece {
			return new Piece( _moveLogic, _type, player );
		}
		
		public function samePlayer( player:uint ):Boolean {
			return ( _player == player );
		}
		
		public function isFlag():Boolean {
			return ( _type == FLAG );
		}
		
		public function couldAttackToWithPiece( tile:Tile ):Boolean {
			if ( _moveLogic.pieceInWay( _gameTile, tile ) ) {
				return false;
			}
						
			var yDiff:int = _gameTile.getY() - tile.getY();
			var xDiff:int = _gameTile.getX() - tile.getX();
			
			//Inverse for Player One
			if( _player == Constants.AI_PLAYER ) {
				yDiff = 0 - yDiff;
				xDiff = 0 - xDiff;
			}
			
			if ( _type == PAWN1 ) {//Pawns attack on the diagnol.
				if( bish1Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else if( rook1Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else
					return false;
			}
			else if ( _type == PAWN2 ) {//Pawns attack on the diagnol.
				if( bish2Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else if( rook2Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else
					return false;
			}
			else if ( _type == PAWN3 ) {//Pawns attack on the diagnol.
				if( bish3Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else if( rook3Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else
					return false;
			}
			else if( _type == ROOK1 ) {
				return rook1Rules( xDiff, yDiff );
			}
			else if( _type == ROOK2 ) {
				return rook2Rules( xDiff, yDiff );
			}
			else if( _type == ROOK3 ) {
				return rook3Rules( xDiff, yDiff );
			}
			else if( _type == BISH1 ) {
				return bish1Rules( xDiff, yDiff );
			}
			else if( _type == BISH2 ) {
				return bish2Rules( xDiff, yDiff );
			}
			else if( _type == BISH3 ) {
				return bish3Rules( xDiff, yDiff );
			}
			else if( _type == QUEEN1 ) {
				if( rook1Rules( xDiff, yDiff ) )
					return true;
				else
					return bish1Rules( xDiff, yDiff );
			}
			else if( _type == QUEEN2 ) {
				if( rook2Rules( xDiff, yDiff ) )
					return true;
				else
					return bish2Rules( xDiff, yDiff );
			}
			else if( _type == QUEEN3 ) {
				if( rook3Rules( xDiff, yDiff ) )
					return true;
				else
					return bish3Rules( xDiff, yDiff );
			}
			else if( _type == FLAG ) {
				return false;
			}
			else {
				throw new Error( "Invalid Piece type: " + _type );
			}
		}
		
		public function canAttackTo( tile:Tile ):Boolean {
			if ( _moveLogic.pieceInWay( _gameTile, tile ) ) {
				return false;
			}
						
			var yDiff:int = _gameTile.getY() - tile.getY();
			var xDiff:int = _gameTile.getX() - tile.getX();
			
			if( tile.getPiece() == null )
				return false;
			
			// Cannot attack your own piece.
			if ( tile.getPiece()._player == _player )
				return false;
			
			//Inverse for Player One
			if( _player == Constants.AI_PLAYER ) {
				yDiff = 0 - yDiff;
				xDiff = 0 - xDiff;
			}
			
			if ( _type == PAWN1 ) {//Pawns attack on the diagnol.
				if( bish1Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else if( rook1Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else
					return false;
			}
			else if ( _type == PAWN2 ) {//Pawns attack on the diagnol.
				if( bish2Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else if( rook2Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else
					return false;
			}
			else if ( _type == PAWN3 ) {//Pawns attack on the diagnol.
				if( bish3Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else if( rook3Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else
					return false;
			}
			else if( _type == ROOK1 ) {
				return rook1Rules( xDiff, yDiff );
			}
			else if( _type == ROOK2 ) {
				return rook2Rules( xDiff, yDiff );
			}
			else if( _type == ROOK3 ) {
				return rook3Rules( xDiff, yDiff );
			}
			else if( _type == BISH1 ) {
				return bish1Rules( xDiff, yDiff );
			}
			else if( _type == BISH2 ) {
				return bish2Rules( xDiff, yDiff );
			}
			else if( _type == BISH3 ) {
				return bish3Rules( xDiff, yDiff );
			}
			else if( _type == QUEEN1 ) {
				if( rook1Rules( xDiff, yDiff ) )
					return true;
				else
					return bish1Rules( xDiff, yDiff );
			}
			else if( _type == QUEEN2 ) {
				if( rook2Rules( xDiff, yDiff ) )
					return true;
				else
					return bish2Rules( xDiff, yDiff );
			}
			else if( _type == QUEEN3 ) {
				if( rook3Rules( xDiff, yDiff ) )
					return true;
				else
					return bish3Rules( xDiff, yDiff );
			}
			else if( _type == FLAG ) {
				return false;
			}
			else {
				throw new Error( "Invalid Piece type: " + _type );
			}
		}
		
		private function rook1Rules( xDiff:int, yDiff:int ):Boolean {
			if ( Math.abs( yDiff ) == 1 && xDiff == 0 || yDiff == 0 && Math.abs( xDiff ) == 1 )
				return true;
			else
				return false;
		}
		
		private function rook2Rules( xDiff:int, yDiff:int ):Boolean {
			if ( Math.abs( yDiff ) <= 2 && xDiff == 0 || yDiff == 0 && Math.abs( xDiff ) <= 2 )
				return true;
			else
				return false;
		}
		
		private function rook3Rules( xDiff:int, yDiff:int ):Boolean {
			if ( Math.abs( yDiff ) > 0 && xDiff == 0 || yDiff == 0 && Math.abs( xDiff ) > 0 )
				return true;
			else
				return false;
		}
		
		private function bish1Rules( xDiff:int, yDiff:int ):Boolean {
			if( Math.abs( yDiff ) == Math.abs( xDiff ) && Math.abs( yDiff ) == 1 )
				return true;
			else
				return false;
		}
		
		private function bish2Rules( xDiff:int, yDiff:int ):Boolean {
			if( Math.abs( yDiff ) == Math.abs( xDiff ) && Math.abs( yDiff ) > 0 && Math.abs( yDiff ) <= 2 )
				return true;
			else
				return false;
		}
		
		private function bish3Rules( xDiff:int, yDiff:int ):Boolean {
			if( Math.abs( yDiff ) == Math.abs( xDiff ) && Math.abs( yDiff ) > 0 )
				return true;
			else
				return false;
		}
		
		public function canMoveTo( tile:Tile ):Boolean {
			if( _moveLogic.pieceInWay( _gameTile, tile ) ) {
				return false;
			}
			
			var yDiff:int = _gameTile.getY() - tile.getY();
			var xDiff:int = _gameTile.getX() - tile.getX();
			
			if( tile.getPiece() != null )
				return false;
			
			//Inverse for Player One
			if( _player == Constants.AI_PLAYER ) {
				yDiff = 0 - yDiff;
				xDiff = 0 - xDiff;
			}

			if ( _type == PAWN1 ) {
				if( bish1Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else if( rook1Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else
					return false;
			}
			else if ( _type == PAWN2 ) {
				if( bish2Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else if( rook2Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else
					return false;
			}
			else if ( _type == PAWN3 ) {
				if( bish3Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else if( rook3Rules( xDiff, yDiff ) && yDiff > 0 )
					return true;
				else
					return false;
			}
			else if( _type == ROOK1 ) {
				return rook1Rules( xDiff, yDiff );
			}
			else if( _type == ROOK2 ) {
				return rook2Rules( xDiff, yDiff );
			}
			else if( _type == ROOK3 ) {
				return rook3Rules( xDiff, yDiff );
			}
			else if( _type == BISH1 ) {
				return bish1Rules( xDiff, yDiff );
			}
			else if( _type == BISH2 ) {
				return bish2Rules( xDiff, yDiff );
			}
			else if( _type == BISH3 ) {
				return bish3Rules( xDiff, yDiff );
			}
			else if( _type == QUEEN1 ) {
				if( rook1Rules( xDiff, yDiff ) )
					return true;
				else
					return bish1Rules( xDiff, yDiff );
			}
			else if( _type == QUEEN2 ) {
				if( rook2Rules( xDiff, yDiff ) )
					return true;
				else
					return bish2Rules( xDiff, yDiff );
			}
			else if( _type == QUEEN3 ) {
				if( rook3Rules( xDiff, yDiff ) )
					return true;
				else
					return bish3Rules( xDiff, yDiff );
			}
			else if( _type == FLAG ) {
//				if( rook1Rules( xDiff, yDiff ) )
//					return true;
//				else
//					return bish1Rules( xDiff, yDiff );
				return false;
			}
			else {
				throw new Error( "Invalid Piece type: " + _type );
			}
		}
		
		public function addToTile( tile:Tile ):void {
			_sprite = _draw( tile );
			_gameTile = tile;
		}
		
		public function ghostToTile( tile:Tile ):void {
			_ghost = _draw( tile );
			_ghost.alpha = 0.3;
		}
		
		public function removeGhost( tile:Tile ):void {
			_ghost.graphics.clear();
			tile.removeChild( _ghost );
		}
		
		public function removeFromTile():void {
			_cleanup( _gameTile );
		}
		
		private function _draw( parent:Tile ):Sprite {
			var spr:Sprite = null;			
			if( _type == PAWN1 ) {
				if ( _player == 1 )
					spr = new GameResources.Pawn1();
				else
					spr = new GameResources.Pawn1_Red();
			}
			else if( _type == PAWN2 )
				if ( _player == 1 )
					spr = new GameResources.Pawn2();
				else
					spr = new GameResources.Pawn2_Red();
			else if( _type == PAWN3 )
				if ( _player == 1 )
					spr = new GameResources.Pawn3();
				else
					spr = new GameResources.Pawn3_Red();
			else if( _type == ROOK1 )
				if ( _player == 1 )
					spr = new GameResources.Rook1();
				else
					spr = new GameResources.Rook1_Red();
			else if( _type == ROOK2 )
				if ( _player == 1 )
					spr = new GameResources.Rook2();
				else
					spr = new GameResources.Rook2_Red();
			else if( _type == ROOK3 )
				if ( _player == 1 )
					spr = new GameResources.Rook3();
				else
					spr = new GameResources.Rook3_Red();
			else if ( _type == BISH1 )
				if ( _player == 1 )
					spr = new GameResources.Bishop1();
				else
					spr = new GameResources.Bishop1_Red();
			else if ( _type == BISH2 )
				if ( _player == 1 )
					spr = new GameResources.Bishop2();
				else
					spr = new GameResources.Bishop2_Red();
			else if ( _type == BISH3 )
				if ( _player == 1 )
					spr = new GameResources.Bishop3();
				else
					spr = new GameResources.Bishop3_Red();
			else if( _type == QUEEN1 )
				if ( _player == 1 )
					spr = new GameResources.Queen1();
				else
					spr = new GameResources.Queen1_Red();
			else if( _type == QUEEN2 )
				if ( _player == 1 )
					spr = new GameResources.Queen2();
				else
					spr = new GameResources.Queen2_Red();
			else if( _type == QUEEN3 )
				if ( _player == 1 )
					spr = new GameResources.Queen3();
				else
					spr = new GameResources.Queen3_Red();
			else if ( _type == FLAG ) {
				if ( _player == 1 )
					spr = new GameResources.Flag();
				else
					spr = new GameResources.Flag_Red();
			}
			else
				throw new Error( "Missing type to draw: " + _type );
			
//			spr.width = parent.getSize() / 2;// - ( parent.getSize() * 0.1 );
//			spr.height = parent.getSize() - ( parent.getSize() * 0.1 );

			var scale:Number = 0;
			var scaleHeight:Number = spr.height / ( parent.getSize() - ( parent.getSize() * 0.1 ) );
			var scaleWidth:Number = spr.width / ( parent.getSize() - ( parent.getSize() * 0.1 ) );
			if( scaleHeight > scaleWidth )
				scale = scaleHeight;
			else
				scale = scaleWidth;

			spr.width /= scale;
			spr.height /= scale;

			spr.graphics.clear();
			
			spr.x = parent.getCenterX() - ( spr.width / 2 );
			spr.y = parent.getCenterY() - ( spr.height / 2 );
			spr.mouseEnabled = false;
			
			parent.addChild( spr );
			return spr;
		}
		
		private function _cleanup( parent:Tile ):void {
			parent.removeChild( _sprite );
			_sprite = null;
		}
		
		public function toString():String {
			if( _type == PAWN1 )
				return "Pawn1";
			else if( _type == PAWN2 )
				return "Pawn2";
			else if( _type == PAWN3 )
				return "Pawn3";
			else if( _type == ROOK1 )
				return "Rook1";
			else if( _type == ROOK2 )
				return "Rook2";
			else if( _type == ROOK3 )
				return "Rook3";
			else if( _type == BISH1 )
				return "Bish1";
			else if( _type == BISH2 )
				return "Bish2";
			else if( _type == BISH3 )
				return "Bish3";
			else if( _type == QUEEN1 )
				return "Queen1";
			else if( _type == QUEEN2 )
				return "Queen2";
			else if( _type == QUEEN3 )
				return "Queen3";
			else if( _type == FLAG )
				return "Flag";
				
			return "Bad Piece " + _type;
		}
	}
	
}
