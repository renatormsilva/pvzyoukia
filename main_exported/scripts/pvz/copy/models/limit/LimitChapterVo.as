package pvz.copy.models.limit
{
   import core.interfaces.IVo;
   
   public class LimitChapterVo implements IVo
   {
      
      private var _id:int;
      
      private var _openGrade:int;
      
      private var _picid:int;
      
      private var _name:String;
      
      public function LimitChapterVo()
      {
         super();
      }
      
      public function decode(param1:Object) : void
      {
         this._id = param1.id;
         this._picid = param1.img_id;
         this._name = param1.name;
         this._openGrade = param1.min_grade;
      }
      
      public function getOpenGrade() : int
      {
         return this._openGrade;
      }
      
      public function getPicid() : int
      {
         return this._picid;
      }
      
      public function getNameStr() : String
      {
         return this._name;
      }
      
      public function getId() : int
      {
         return this._id;
      }
   }
}

