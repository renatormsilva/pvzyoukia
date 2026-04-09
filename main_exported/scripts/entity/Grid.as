package entity
{
   public class Grid
   {
      
      private var _id:int = 0;
      
      private var wide:int = 0;
      
      private var heigth:int = 0;
      
      private var num:int = 0;
      
      private var x:int = 0;
      
      private var y:int = 0;
      
      private var area:int = 0;
      
      private var _org:Organism;
      
      public function Grid(param1:int, param2:int, param3:Organism)
      {
         super();
         this._org = param3;
         this.wide = param1;
         this.heigth = param2;
         this.num = param1 * param2;
         this.area = param1 * param2;
      }
      
      public function setId(param1:int) : void
      {
         this._id = param1;
      }
      
      public function getOrg() : Organism
      {
         return this._org;
      }
      
      public function getArea() : int
      {
         return this.area;
      }
      
      public function getWide() : int
      {
         return this.wide;
      }
      
      public function getHeigth() : int
      {
         return this.heigth;
      }
      
      public function getNum() : int
      {
         return this.num;
      }
      
      public function getId() : int
      {
         return this._id;
      }
      
      public function setloaction(param1:int, param2:int) : void
      {
         this.x = param1;
         this.y = param2;
      }
      
      public function getX() : int
      {
         return this.x;
      }
      
      public function getY() : int
      {
         return this.y;
      }
   }
}

