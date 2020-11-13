package {
	
	public class LevelGenerator {
		
		public function LevelGenerator():void {
		}
		
		public static function MakeLevel( moveLogic:MoveLogic, size:uint, possiblePieces:Array ):Level {
			var level:Level = new Level( size, size );
			
			var lowerLevelPieces:Array = new Array();
			var tier3Pieces:Array = new Array();
			for each( var p:uint in possiblePieces ) {
				switch( p ) {
					case Piece.PAWN3:
					case Piece.ROOK3:
					case Piece.BISH3:
					case Piece.QUEEN3:
						tier3Pieces.push( p );
						break;
					default:
						lowerLevelPieces.push( p );
						break;
				}
			}
			
			const row1:uint = 0;
			const row2:uint = 1;

			level.centerX = (int)(size/2);
			level.centerY = row1;

			level.playerCenterX = size - level.centerX - 1;
			level.playerCenterY = size - 1;

			level.midY = (int)(size/2);
			
			var possibleTiles:Array = new Array();
			for( var c:int = 0 ; c < size ; c++ ) {
				if( c == level.centerX )
					continue;
				
				//Only place one piece on the first level.
				if( size == 3 && c == 2 )
					continue;
					
				possibleTiles.push( new Tile( c, row1 ) );
			}
			
			//Place Flag
			var flagTile:Tile = possibleTiles[Key.MakeKey(level.centerX, level.centerY)];
			level.levelInfo.push( new LevelInfo( level.centerX, level.centerY, new Piece( moveLogic, Piece.FLAG, Constants.AI_PLAYER ) ) );
			possibleTiles = RemoveObject( flagTile, possibleTiles );
			
			possibleTiles = _PlaceNeededPieces( tier3Pieces, possibleTiles, moveLogic, level );
			
			//Add second row.
			if( size >= 6 ) {
				for( c = 0 ; c < size ; c++ ) {				
					possibleTiles.push( new Tile( c, row2 ) );
				}
			}
			
			possibleTiles = _PlaceNeededPieces( lowerLevelPieces, possibleTiles, moveLogic, level );
			_PlaceRemainingPieces( lowerLevelPieces, possibleTiles, moveLogic, level );
			
			return level;
		}
		
		private static function _PlaceRemainingPieces( 
			possiblePieces:Array, possibleTiles:Array, moveLogic:MoveLogic, level:Level ):void {
			var tiles:int = possibleTiles.length;
			for( var i:int = 0 ; i < tiles ; i++ ) {
				var index:int = Utility.GetRandomIndex( possibleTiles );
				var tile:Tile = possibleTiles[index];
				
				var piece:uint = _GetPossiblePiece( possiblePieces );
				
				level.levelInfo.push( new LevelInfo( tile.getX(), tile.getY(), new Piece( moveLogic, piece, Constants.AI_PLAYER ) ) );
				possibleTiles = RemoveElement( index, possibleTiles );
			}
		}
		
		private static function _PlaceNeededPieces( 
			possiblePieces:Array, possibleTiles:Array, moveLogic:MoveLogic, level:Level ):Array {
			for each( var pieceBeforeRandom:uint in possiblePieces ) {
				var index:int = Utility.GetRandomIndex( possibleTiles );
				var tile:Tile = possibleTiles[index];
				
				level.levelInfo.push( new LevelInfo( tile.getX(), tile.getY(), new Piece( moveLogic, pieceBeforeRandom, Constants.AI_PLAYER ) ) );
				possibleTiles = RemoveElement( index, possibleTiles );
			}
			return possibleTiles;
		}
		
		private static function _GetPossiblePiece( possiblePieces:Array ):uint {
			var index:uint = Math.floor( Math.random() * possiblePieces.length );
			return possiblePieces[index];
		}
		
		private static function RemoveElement( index:int, possibleTiles:Array):Array {
			var a:Array = new Array();
			for each( var o:Object in possibleTiles ) {
				var indexOf:int = possibleTiles.indexOf( o );
				if( indexOf != index )
					a.push( o );
			}
			return a;
		}
		
		private static function RemoveObject( objToRemove:Object, possibleTiles:Array):Array {
			var a:Array = new Array();
			for each( var o:Object in possibleTiles ) {
				if( o != objToRemove )
					a.push( o );
			}
			return a;
		}
	}
	
}
