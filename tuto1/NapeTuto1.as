//  ***********************************************************************
//	NAPE TUTO 1 - (v1.2 | April, 2012)
//	2012 Dooprod Workshop
//  ***********************************************************************

package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	import nape.space.Space;
	import nape.util.ShapeDebug
	
	[SWF(width="1024", height="768", frameRate="30", backgroundColor="#000000")]
	
	// --
	
	public class NapeTest extends Sprite {
		[Embed(source="assets/background-wood.jpg")]
		protected var BackgroundData:Class;
		[Embed(source="assets/boxtexture1.jpg")]
		protected var BoxTextureData:Class;
		
		private var myBackground:Bitmap;
		private var mySpace:Space;
		private var myBorder:Body;
		private var myBox:Sprite;
		private var myTexBox:Bitmap;
		private var myBodyBox:Body;
		
		// --
		
		public function NapeTest() {
			stage.quality = StageQuality.LOW;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.showDefaultContextMenu = false;
			
			if ( stage == null ) { addEventListener( Event.ADDED_TO_STAGE, onAddToStage ); }
			else { initApp(); }
		}
		
		
		private function onAddToStage( e:Event ):void {
			removeEventListener( Event.ADDED_TO_STAGE, onAddToStage );
			initApp();
		}
		
		
		public function initApp():void {
			// BACKGROUND --
			
			myBackground = new Bitmap( new BackgroundData().bitmapData );
			addChild( myBackground );
			
			// SPACE / SCENE --
			
			mySpace = new Space( new Vec2( 0, 600 ) );
			
			myBorder = new Body( BodyType.STATIC );
			myBorder.shapes.add( new Polygon( Polygon.rect( 0, 0, 1024, 24 ) ) ); // top
			myBorder.shapes.add( new Polygon( Polygon.rect( 0, 768, 1024, 24 ) ) ); // bottom
			myBorder.shapes.add( new Polygon( Polygon.rect( 0, 0, 24, 768 ) ) ); // left
			myBorder.shapes.add( new Polygon( Polygon.rect( 1000, 0, 24, 768 ) ) ); // right
			myBorder.space = mySpace;
			
			// EVENTS --
			
			stage.addEventListener( MouseEvent.CLICK, createBox, false, 0, true );
			addEventListener( Event.ENTER_FRAME, onUpdate, false, 0, true );
		}
		
		
		private function createBox( e:MouseEvent ):void {
			// SPRITE CONTAINER --
			
			myBox = new Sprite();
			myBox.mouseEnabled = false;
			myBox.mouseChildren = false;
			addChild( myBox );
			
			// BITMAP TEXTURE --
			
			myTexBox = new Bitmap( new BoxTextureData().bitmapData );
			myTexBox.x = -32;
			myTexBox.y = -32;
			myBox.addChild( myTexBox );
			
			// BODY --
			
			myBodyBox = new Body( BodyType.DYNAMIC );
			myBodyBox.shapes.add( new Polygon( Polygon.box( 64, 64 ) ) );
			myBodyBox.position.setxy( e.stageX, e.stageY );
			myBodyBox.graphic = myBox;;
			myBodyBox.space = mySpace;
		}
		
		
		private function onUpdate( e:Event ):void {
			mySpace.step( 1 / stage.frameRate, 8, 8 );
		}
	}
}