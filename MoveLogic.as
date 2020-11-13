package {
	
	import flash.utils.Dictionary;

	public class MoveLogic {
		
		public var _gameTiles:Dictionary = new Dictionary();
		
		public function pieceInWay( tileA:Tile, tileB:Tile ):Boolean {
			var diffX:int = tileA.getX() - tileB.getX();
			var diffY:int = tileA.getY() - tileB.getY();
			
			if( diffX == 0 && diffY != 0 ) {
				return _pieceInWayVerticle( tileA, tileB );
			}
			else if( diffX != 0 && diffY == 0 ) {
				return _pieceInWayHorizontal( tileA, tileB );
			}
			else if( Math.abs(diffX) == Math.abs(diffY) ) {
				return _pieceInWayDiagnol( tileA, tileB );
			}
			else {
				return false;
			}
		}
		
		private function _pieceInWayVerticle( tileA:Tile, tileB:Tile ):Boolean {
			var startY:int = tileA.getY();
			var endY:int = tileB.getY();
			
			if( tileB.getY() < tileA.getY() ) {
				startY = tileB.getY();
				endY = tileA.getY();
			}
			
			for( var y:int = startY + 1 ; y < endY ; y++ ) {
				var tile:Tile = _gameTiles[ Key.MakeKey(tileA.getX(), y)];
				if( tile.getPiece() != null ) {
					return true;
				}
			}
			
			return false;
		}
		
		private function _pieceInWayHorizontal( tileA:Tile, tileB:Tile ):Boolean {			
			var startX:int = tileA.getX();
			var endX:int = tileB.getX();
			
			if( tileB.getX() < tileA.getX() ) {
				startX = tileB.getX();
				endX = tileA.getX();
			}
				
			for( var x:int = startX + 1 ; x < endX ; x++ ) {
				var tile:Tile = _gameTiles[ Key.MakeKey(x, tileA.getY())];					
				if( tile.getPiece() != null ) {
					return true;
				}
			}
			
			return false;	
		}
		
		private function _pieceInWayDiagnol( tileA:Tile, tileB:Tile ):Boolean {		
			var x:int;
			var y:int;
			var tile:Tile;
				
			if( tileA.getX() > tileB.getX() && tileA.getY() > tileB.getY() ) {			
				for( x = tileA.getX(), y = tileA.getY() ; x > tileB.getX() ; x--, y-- ) {
					tile = _gameTiles[ Key.MakeKey(x, y)];
					if( tile == tileA )
						continue;
						
					if( tile == tileB )
						continue;
						
					if( tile.getPiece() != null ) {
						return true;
					}
				}
			}
			else if( tileA.getX() > tileB.getX() && tileA.getY() < tileB.getY() )
			{					
				for( x = tileA.getX(), y = tileA.getY() ; x > tileB.getX() ; x--, y++ ) {
					tile = _gameTiles[ Key.MakeKey(x, y)];
					if( tile == tileA )
						continue;
						
					if( tile == tileB )
						continue;
						
					if( tile.getPiece() != null ) {
						return true;
					}
				}
			}
			else if( tileA.getX() < tileB.getX() && tileA.getY() > tileB.getY() )
			{				
				for( x = tileA.getX(), y = tileA.getY() ; x < tileB.getX() ; x++, y-- ) {
					tile = _gameTiles[ Key.MakeKey(x, y)];
					if( tile == tileA )
						continue;
						
					if( tile == tileB )
						continue;
						
					if( tile.getPiece() != null ) {
						return true;
					}
				}
			}
			else if( tileA.getX() < tileB.getX() && tileA.getY() < tileB.getY() )
			{
				for( x = tileA.getX(), y = tileA.getY() ; x < tileB.getX() ; x++, y++ ) {
					tile = _gameTiles[ Key.MakeKey(x, y)];
					if( tile == tileA )
						continue;
						
					if( tile == tileB )
						continue;
						
					if( tile.getPiece() != null ) {
						return true;
					}
				}
			}
			
			return false;
		}
	}
}
