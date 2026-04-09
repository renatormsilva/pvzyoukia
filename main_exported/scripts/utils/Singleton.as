package utils
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class Singleton implements IEventDispatcher
   {
      
      private static var instanceDict:Dictionary = new Dictionary();
      
      protected var dispatcher:EventDispatcher = new EventDispatcher();
      
      public function Singleton()
      {
         super();
         this.onConstructor();
      }
      
      public static function getInstance(param1:Class) : *
      {
         var _loc2_:Singleton = instanceDict[param1];
         if(_loc2_ == null)
         {
            _loc2_ = Singleton(new param1());
            if(_loc2_ == null)
            {
               throw "getInstance can only be called for Classes extending Singleton";
            }
         }
         return _loc2_;
      }
      
      public static function removeInstance(param1:Class) : void
      {
         var _loc2_:Singleton = instanceDict[param1];
         if(_loc2_ != null)
         {
            delete instanceDict[param1];
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this.dispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this.dispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this.dispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this.dispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this.dispatcher.willTrigger(param1);
      }
      
      protected function onConstructor() : void
      {
         var _loc1_:String = getQualifiedClassName(this);
         var _loc2_:Class = getDefinitionByName(_loc1_) as Class;
         if(_loc2_ == Singleton)
         {
            throw "Singleton is a base class that cannot be instantiated";
         }
         var _loc3_:Singleton = instanceDict[_loc2_];
         if(_loc3_ != null)
         {
            throw "Classes extending Singleton can only be instantiated once by the getInstance method";
         }
         instanceDict[_loc2_] = this;
      }
   }
}

