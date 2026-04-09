package zmyth.fore
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import zlib.event.ForeletEvent;
   import zlib.log.*;
   import zlib.net.*;
   import zlib.sets.ArrayList;
   import zlib.utils.GarbageCollection;
   import zmyth.load.UILoader;
   import zmyth.res.IDestroy;
   import zmyth.res.ResourceRecycle;
   
   public class Forelet extends Sprite implements IDestroy
   {
      
      private static var _mainStage:Stage;
      
      private static var mainBG:DisplayObject;
      
      private static var defaultBG:DisplayObject;
      
      public static const SUBOBJECT_LOAD:String = "Subject_Load";
      
      public static const SOUND_LIB_LOAD:String = "SoundLib_Load";
      
      private static const log:Logger = LogFactory.getLoggerClass(Forelet);
      
      protected static const TIMEOUT:int = 30000;
      
      protected var rr:ResourceRecycle;
      
      protected var cfg:Object;
      
      private var _subObject:Object;
      
      public var soundObject:Object;
      
      public var loader:UILoader;
      
      public var soundLoader:UILoader;
      
      public var container:Object;
      
      public var objArray:ArrayList;
      
      public function Forelet(param1:Object = null)
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddStage);
         this.cfg = Object["parameters"];
         if(param1 != null)
         {
            this.container = param1;
         }
         this.addEventListener(Event.ADDED,this.onAdd);
         this.objArray = new ArrayList();
      }
      
      public static function getMainStage() : Stage
      {
         return _mainStage;
      }
      
      public static function setMainStage(param1:Stage, param2:Object = null) : void
      {
         if(param2 != null)
         {
            if(_mainStage != null)
            {
               _mainStage = param1;
               param2.changeWindow();
            }
            _mainStage = param1;
         }
         else
         {
            _mainStage = param1;
         }
      }
      
      public static function initBG(param1:DisplayObject, param2:DisplayObject) : void
      {
         mainBG = param1;
         defaultBG = param2;
      }
      
      public static function showBg(param1:Boolean) : void
      {
         if(param1)
         {
            mainBG.visible = true;
            defaultBG.visible = false;
         }
         else
         {
            mainBG.visible = false;
            defaultBG.visible = true;
         }
      }
      
      public function get subObject() : Object
      {
         return this._subObject;
      }
      
      public function set subObject(param1:Object) : void
      {
         this._subObject = param1;
      }
      
      private function onAdd(param1:Event) : void
      {
         if(this.container == null)
         {
            this.container = this.parent;
         }
         this.removeEventListener(Event.ADDED,this.onAdd);
      }
      
      private function onAddStage(param1:Event) : void
      {
         _mainStage = this.stage;
      }
      
      public function doLayout() : void
      {
         throw new Error("doLayout:你没有实现此方法!");
      }
      
      protected function changeWindow(... rest) : void
      {
      }
      
      public function show() : void
      {
         this.subObject.visible = true;
      }
      
      public function hidden() : void
      {
         this.subObject.visible = false;
      }
      
      public function close() : void
      {
         if(this.parent != null)
         {
            this.parent.removeChild(this);
            this.container = null;
         }
         GarbageCollection.GC();
      }
      
      public function onLoaded(param1:ForeletEvent) : void
      {
         this.loader.removeEventListener(ForeletEvent.COMPLETE,this.onLoaded);
         this.dispatchEvent(new ForeletEvent(ForeletEvent.COMPLETE,param1.parameter));
      }
      
      public function onSoundLibLoaded(param1:ForeletEvent) : void
      {
         this.soundLoader.removeEventListener(ForeletEvent.COMPLETE,this.onSoundLibLoaded);
         this.dispatchEvent(new ForeletEvent(ForeletEvent.COMPLETE,param1.parameter));
      }
      
      public function toTop() : void
      {
         this.y = 0;
      }
      
      public function toBottom() : void
      {
         this.y = this.cfg.HEIGHT - this.height;
      }
      
      public function toLeft() : void
      {
         this.x = 0;
      }
      
      public function toRight() : void
      {
         this.x = this.cfg.WIDTH - this.width;
      }
      
      public function toCenter() : void
      {
         var _loc1_:int = this.width;
         if(_loc1_ > this.cfg.WIDTH || _loc1_ == 0)
         {
            _loc1_ = int(this.cfg.WIDTH);
         }
         if(stage != null)
         {
            this.x = int(this.stage.stageWidth / 2 - _loc1_ / 2 - this.parent.x);
         }
         if(this.x <= 0)
         {
            this.x = 0;
         }
      }
      
      public function toMiddle() : void
      {
         var _loc1_:int = this.height;
         if(_loc1_ > this.cfg.HEIGHT || _loc1_ == 0)
         {
            _loc1_ = int(this.cfg.HEIGHT);
         }
         if(stage != null)
         {
            this.y = int(stage.stageHeight / 2 - _loc1_ / 2 - this.parent.y);
         }
         if(this.y <= 0)
         {
            this.y = 0;
         }
      }
      
      public function toTopLayer() : void
      {
         if(this.container != null)
         {
            this.container.swapChildren(this.container.getChildAt(this.container.numChildren - 1),this);
         }
      }
      
      public function playSound(param1:String, param2:int = 0, param3:int = 1) : void
      {
         throw new Error("playSound:需要子类继重载");
      }
      
      public function stopSound(param1:String) : void
      {
         throw new Error("endAllSound:需要子类继重载");
      }
      
      public function destroy() : void
      {
         this.close();
      }
   }
}

