package manager
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import zlib.sets.Hashtable;
   import zlib.utils.DomainAccess;
   
   public class SoundManager extends EventDispatcher
   {
      
      private static var _volume:Number;
      
      public static const BUTTON1:String = "Sound_Button1";
      
      public static const BUTTON2:String = "Sound_Button2";
      
      public static const ZOMBIES:String = "Sound_Zombies";
      
      public static const WATER:String = "Sound_Water";
      
      public static const FERTILISER:String = "Sound_Fertiliser";
      
      public static const INTO:String = "Sound_Into";
      
      public static const MONEY:String = "Sound_Money";
      
      public static const BACK:String = "Sound_Back";
      
      public static const GRADE:String = "Sound_Grade";
      
      public static const EXP:String = "Sound_Exp";
      
      public static const HIT:String = "Sound_Hit";
      
      public static const EFFECT_6:String = "Sound_6";
      
      public static const EFFECT_5:String = "Sound_5";
      
      public static const EFFECT_1:String = "Sound_1";
      
      public static const EFFECT_2:String = "Sound_2";
      
      public static const EFFECT_4:String = "Sound_4";
      
      public static const EFFECT_3:String = "Sound_3";
      
      public static const WOOD:String = "Sound_wood";
      
      public static const BIRD_SOUND:String = "Sound_bird";
      
      public static const WOUD_DOWN_SOUND:String = "Sound_wood_down";
      
      public static const EXPLOSION1:String = "Sound_explosion";
      
      private static var playLists:Hashtable = new Hashtable();
      
      private static var _isMute:Boolean = false;
      
      private var somClass:Class;
      
      public var soundObject:Sound;
      
      private var soundName:String;
      
      public function SoundManager()
      {
         super();
      }
      
      public static function stopAllSound() : void
      {
         var _loc2_:String = null;
         var _loc3_:SoundChannel = null;
         var _loc1_:int = 0;
         while(_loc1_ < playLists.keys.length)
         {
            _loc2_ = playLists.keys.getItemAt(_loc1_).toString();
            _loc3_ = playLists[_loc2_];
            if(_loc3_ != null)
            {
               playLists.remove(_loc2_);
               _loc3_.stop();
               _loc3_ = null;
            }
            _loc1_++;
         }
      }
      
      public static function get isMute() : Boolean
      {
         return _isMute;
      }
      
      public static function set isMute(param1:Boolean) : void
      {
         _isMute = param1;
      }
      
      public static function getVolume() : int
      {
         return int(_volume * 100);
      }
      
      public static function setVolume(param1:int, param2:SoundChannel = null) : void
      {
         var _loc3_:SoundTransform = null;
         var _loc4_:int = 0;
         var _loc5_:SoundChannel = null;
         _volume = Number(param1 / 100);
         if(param2 != null)
         {
            _loc3_ = param2.soundTransform;
            _loc3_.volume = _volume;
            param2.soundTransform = _loc3_;
         }
         else
         {
            if(playLists == null)
            {
               return;
            }
            _loc4_ = 0;
            while(_loc4_ < playLists.keys.length)
            {
               _loc5_ = playLists[playLists.keys[_loc4_].toString()] as SoundChannel;
               _loc3_ = _loc5_.soundTransform;
               _loc3_.volume = _volume;
               _loc5_.soundTransform = _loc3_;
               _loc4_++;
            }
         }
      }
      
      public function stopSound(param1:String) : void
      {
         var _loc2_:SoundChannel = null;
         if(playLists.keys.toArray().indexOf(param1) >= 0)
         {
            _loc2_ = playLists[param1];
            playLists.remove(param1);
            if(_loc2_ != null)
            {
               _loc2_.stop();
               _loc2_ = null;
            }
         }
      }
      
      public function playSound(param1:String, param2:Number = 0, param3:int = 1) : void
      {
         var _loc4_:SoundChannel = null;
         if(!_isMute)
         {
            this.somClass = DomainAccess.getClass(param1);
            if(this.somClass == null)
            {
               return;
            }
            this.soundName = param1;
            this.soundObject = new this.somClass();
            if(this.soundObject != null)
            {
               _loc4_ = this.soundObject.play(param2,param3);
               setVolume(getVolume(),_loc4_);
               if(_loc4_ != null)
               {
                  playLists.add(param1,_loc4_);
                  _loc4_.addEventListener(Event.SOUND_COMPLETE,this.onComplete);
               }
            }
         }
      }
      
      private function onComplete(param1:Event) : void
      {
         var _loc2_:SoundChannel = param1.target as SoundChannel;
         _loc2_.removeEventListener(Event.SOUND_COMPLETE,this.onComplete);
         playLists.remove(this.soundName);
         _loc2_.stop();
         _loc2_ = null;
      }
   }
}

