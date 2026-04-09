package entity
{
   public class ExSkill extends Skill
   {
      
      private var _orgImgIdArr:Array = [];
      
      private var _type:int;
      
      public function ExSkill()
      {
         super();
      }
      
      public function getOrgImgIdArr() : Array
      {
         return this._orgImgIdArr;
      }
      
      public function setOrgImgIdArr(param1:Array) : void
      {
         this._orgImgIdArr = param1;
      }
      
      public function getType() : int
      {
         return this._type;
      }
      
      public function setType(param1:int) : void
      {
         this._type = param1;
      }
   }
}

