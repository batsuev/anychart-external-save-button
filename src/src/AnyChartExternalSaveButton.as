package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import mx.utils.Base64Decoder;
	
	public class AnyChartExternalSaveButton extends Sprite {
		
		[Embed(source="./../assets/icon-png.png")]
		private static const IconPNG:Class;
		
		private var targetChart:String;
		private var fileName:String = "anychart.png";
		
		public function AnyChartExternalSaveButton() {
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			
			this.targetChart = this.loaderInfo.parameters['targetChart'];
			
			if (ExternalInterface.available)
				this.initButton();
		}
		
		private function initButton():void {
			var btnSprite:Sprite = new Sprite();
			this.createButtonVisual(btnSprite);
			
			btnSprite.addEventListener(MouseEvent.CLICK, this.btnMouseClickHandler);
			btnSprite.x = 5;
			btnSprite.y = 5;
			btnSprite.mouseChildren = false;
			btnSprite.buttonMode = true;
			btnSprite.useHandCursor = true;
			
			this.addChild(btnSprite);
		}
		
		private function createButtonVisual(btnSprite:Sprite):void {
			btnSprite.addChild(new IconPNG());
			
			var field:TextField = new TextField();
			field.text = "Save as Image";
			field.selectable = false;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.defaultTextFormat = new TextFormat("Arial", 11, 0x3E3E3E, true);
			field.x = 20;
			field.y = 2;
			btnSprite.addChild(field);
		}
		
		private function btnMouseClickHandler(e:MouseEvent):void {
			var pngData:String = ExternalInterface.call(this.targetChart+'.getPng');
			
			if (pngData) {
				
				var decoder:Base64Decoder = new Base64Decoder();
				decoder.decode(pngData);
				
				var data:ByteArray = decoder.toByteArray();
				
				var ref:FileReference = new FileReference();
				ref.save(data, this.fileName);
			}else {
				throw new Error("No png data for chart");
			}
		}
	}
}