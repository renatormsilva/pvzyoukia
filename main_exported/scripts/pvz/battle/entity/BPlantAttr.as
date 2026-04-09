package pvz.battle.entity
{
   import core.interfaces.IVo;
   
   public class BPlantAttr implements IVo
   {
      
      private var m_id:int = 0;
      
      private var m_attackallNum:Number = 0;
      
      private var m_attackNormal:String = "";
      
      private var m_fear:int = 0;
      
      private var m_cHp:Number = 0;
      
      private var m_cout:int = 0;
      
      private var m_dodge:Boolean;
      
      public function BPlantAttr()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this.m_id = param1["id"];
         this.m_attackallNum = param1["attack"];
         this.m_attackNormal = param1["normal_attack"];
         this.m_fear = param1["is_fear"];
         this.m_cHp = param1["hp"];
         this.m_cout = param1["boutCount"];
         this.m_dodge = param1["is_dodge"] == 1 ? true : false;
      }
      
      public function get id() : int
      {
         return this.m_id;
      }
      
      public function get attackAllNum() : Number
      {
         return this.m_attackallNum;
      }
      
      public function get attackNormal() : String
      {
         return this.m_attackNormal;
      }
      
      public function get fear() : int
      {
         return this.m_fear;
      }
      
      public function get cout() : int
      {
         return this.m_cout;
      }
      
      public function get current_Hp() : Number
      {
         return this.m_cHp;
      }
      
      public function get dodge() : Boolean
      {
         return this.m_dodge;
      }
   }
}

