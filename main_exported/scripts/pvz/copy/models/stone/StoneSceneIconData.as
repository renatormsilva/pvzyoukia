package pvz.copy.models.stone
{
   import core.interfaces.IVo;
   import manager.LangManager;
   
   public class StoneSceneIconData implements IVo
   {
      
      private var m_id:int;
      
      private var m_max:int;
      
      private var m_cur:int;
      
      private var m_name:String;
      
      private var m_open:Boolean = false;
      
      private var m_stones:Array;
      
      private var m_condition:Array;
      
      private var m_active:int;
      
      private var m_desc:String;
      
      public function StoneSceneIconData()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this.m_id = param1.id;
         this.m_name = param1.name;
         this.m_max = param1.total_star;
         this.m_cur = param1.star;
         this.m_stones = param1.stone;
         this.m_condition = param1.condition;
         this.m_desc = param1.desc;
         this.m_active = param1.actived;
      }
      
      public function getCondition() : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this.m_condition == null || this.m_condition.length == 0)
         {
            return "";
         }
         var _loc1_:String = "";
         for each(_loc2_ in this.m_condition)
         {
            _loc1_ += _loc2_;
         }
         return "<p align = \'left\'>" + LangManager.getInstance().getLanguage("copy001",_loc1_) + "</p>";
      }
      
      public function getDesc() : String
      {
         return this.m_desc;
      }
      
      public function getId() : int
      {
         return this.m_id;
      }
      
      public function getName() : String
      {
         return this.m_name;
      }
      
      public function getActive() : int
      {
         return this.m_active;
      }
      
      public function getStonesInfo() : String
      {
         var _loc2_:String = null;
         if(this.m_stones == null)
         {
            return "";
         }
         var _loc1_:String = "<p align = \'left\'>";
         for each(_loc2_ in this.m_stones)
         {
            _loc1_ += _loc2_ + "<br>";
         }
         return _loc1_ + "</p>";
      }
      
      public function getStarMax() : int
      {
         return this.m_max;
      }
      
      public function getStarNow() : int
      {
         return this.m_cur;
      }
   }
}

