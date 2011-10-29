/*

Basic Metasequoia loading in Away3dLite

Demonstrates:

How to load a Metasequoia file.
How to load a texture from an external image.
How to clone a laoded model.

Code by Rob Bateman & Katopz
rob@infiniteturtles.co.uk
http://www.infiniteturtles.co.uk
katopz@sleepydesign.com
http://sleepydesign.com/

This code is distributed under the MIT License

Copyright (c)  

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

package
{
	import away3dlite.core.base.*;
	import away3dlite.events.*;
	import away3dlite.loaders.*;
	import away3dlite.templates.*;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(backgroundColor="#000000", frameRate="30", quality="MEDIUM", width="800", height="600")]
	
	/**
	 * Metasequoia example.
	 */
	public class Fighter extends BasicTemplate
	{  
		private var mqo:MQO;
		private var loader:Loader3D;
		private var loaded:Boolean = false;
		private var model1:Object3D; 
		//navigation variables
		private var move:Boolean = false;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var lastRotationX:Number;
		private var lastRotationY:Number;
		
		private function onSuccess(event:Loader3DEvent):void
		{
			loaded = true;
			model1 = loader.handle; 
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onInit():void
		{
			mqo = new MQO();
			loader = new Loader3D();
			loader.loadGeometry("assets/Messerschmitt_Bf_109.mqo", mqo);
			loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			scene.addChild(loader);
			
			stage.quality = StageQuality.HIGH; 
			stage.quality = StageQuality.MEDIUM; 
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function onPreRender():void
		{
			if (loaded) {
				model1.rotationY += 0.2;
			}
			if (loaded && move) {
				model1.rotationX = (mouseY - lastMouseY)/2 + lastRotationX;
				if (model1.rotationX > 90)
					model1.rotationX = 90;
				if (model1.rotationX < -90)
					model1.rotationX = -90;
				model1.rotationY = (lastMouseX - mouseX)/2 + lastRotationY;
			}
 		}
		
		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseDown(e:MouseEvent):void
		{
			lastRotationX = model1.rotationX;
			lastRotationY = model1.rotationY;
			lastMouseX = mouseX;
			lastMouseY = mouseY;
			move = true;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseUp(e:MouseEvent):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);    
		}
		
		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);     
		}
		/**
		 * stage listener for resize events
		 */
		private function onResize(event:Event = null):void
		{
			model1.x = stage.stageWidth / 16;
			model1.y = stage.stageHeight / 16;
		}
	}
}