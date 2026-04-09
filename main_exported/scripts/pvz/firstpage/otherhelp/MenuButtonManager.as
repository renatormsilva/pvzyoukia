package pvz.firstpage.otherhelp
{
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   
   public class MenuButtonManager
   {
      
      private static var _instance:MenuButtonManager;
      
      private var _buttonDic:Dictionary;
      
      private var _buttonVos:Array;
      
      public function MenuButtonManager()
      {
         super();
         this._buttonDic = new Dictionary();
         this._buttonVos = [];
      }
      
      public static function get instance() : MenuButtonManager
      {
         if(_instance == null)
         {
            _instance = new MenuButtonManager();
         }
         return _instance;
      }
      
      public function decodeconfig(param1:XML) : void
      {
         var _loc3_:ButtonVo = null;
         var _loc2_:int = param1.button.length();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = new ButtonVo(param1.button[_loc4_]);
            this._buttonVos.push(_loc3_);
            _loc4_++;
         }
      }
      
      private function getButtonByKey(param1:String) : DisplayObject
      {
         if(this._buttonDic[param1] != null)
         {
            return this._buttonDic[param1];
         }
         return null;
      }
      
      private function getButtonsBylimitLevel(param1:int) : Array
      {
         var _loc3_:ButtonVo = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this._buttonVos)
         {
            if(_loc3_.limitLevel == param1)
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function addButtonToDic(param1:String, param2:*) : void
      {
         if(this._buttonDic[param1] == null)
         {
            this._buttonDic[param1] = param2;
         }
      }
      
      public function updateAllButtonsWhenLevelUP(param1:int, param2:Function) : void
      {
         var _loc3_:AddButtonEffectMC = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:ButtonVo = null;
         for each(_loc5_ in this._buttonVos)
         {
            if(param1 >= _loc5_.limitLevel)
            {
               _loc4_ = this.getButtonByKey(_loc5_.key);
               if(_loc4_.visible == false)
               {
                  if(!(_loc5_.key == "firstRecharge" || _loc5_.key == "activity_btn" || _loc5_.key == "signup_btn"))
                  {
                     _loc3_ = new AddButtonEffectMC(_loc5_.lightType);
                     _loc4_.visible = true;
                     if(param2 != null)
                     {
                        param2();
                     }
                     _loc3_.show(_loc4_);
                  }
               }
            }
         }
      }
      
      public function updateAllButtonsWhenGameInit(param1:int) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:ButtonVo = null;
         for each(_loc3_ in this._buttonVos)
         {
            _loc2_ = this.getButtonByKey(_loc3_.key);
            if(param1 >= _loc3_.limitLevel)
            {
               _loc2_.visible = true;
            }
            else
            {
               _loc2_.visible = false;
            }
         }
      }
      
      public function setButtonVisibleByName(param1:String, param2:Boolean) : void
      {
         this.getButtonByKey(param1).visible = param2;
      }
      
      public function checkBtnUpLimit(param1:String, param2:int) : Boolean
      {
         var _loc3_:ButtonVo = null;
         for each(_loc3_ in this._buttonVos)
         {
            if(_loc3_.key == param1)
            {
               if(param2 >= _loc3_.limitLevel)
               {
                  return true;
               }
               if(param2 < _loc3_.limitLevel)
               {
                  return false;
               }
            }
         }
         return false;
      }
   }
}

