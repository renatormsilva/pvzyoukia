package pvz.world
{
   import entity.Grid;
   import entity.Organism;
   
   public class CheckpointForeMapManager
   {
      
      public static var HEIGHT_GRID:int = 110;
      
      public static var WIDE_GRID:int = 90;
      
      private static var loction:Array = new Array(3,0,2,0,3,1,2,1,1,0,0,0,1,1,0,1);
      
      private var _all_area:int;
      
      private var _all_grids:int;
      
      private var _gridArray:Array = new Array(-1,-1,-1,-1,-1,-1,-1,-1);
      
      private var _grids:Array;
      
      private var _orgArray:Array;
      
      public function CheckpointForeMapManager()
      {
         super();
      }
      
      public function areaAndGrids(param1:Array) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._orgArray = param1;
         this._grids = new Array(this._orgArray.length);
         var _loc2_:int = 0;
         while(_loc2_ < this._orgArray.length)
         {
            this.setGird(this._orgArray[_loc2_],_loc2_,param1[_loc2_]);
            this._all_area += (this._orgArray[_loc2_] as Organism).getWidth() * (this._orgArray[_loc2_] as Organism).getHeight();
            _loc2_++;
         }
         this._all_grids = this._orgArray.length;
         this.initGridArray(this._all_area);
         this.orderGrid();
      }
      
      private function gridIntoMap(param1:Grid) : void
      {
         var area:int = 0;
         var grid:Grid = param1;
         var isInto:Function = function(param1:int):Boolean
         {
            if(param1 + area > _gridArray.length)
            {
               return false;
            }
            var _loc2_:int = param1;
            while(_loc2_ < param1 + area)
            {
               if(_gridArray[_loc2_] != 0)
               {
                  return false;
               }
               _loc2_++;
            }
            return true;
         };
         var into:Function = function(param1:int):void
         {
            if(param1 + area > _gridArray.length)
            {
               return;
            }
            var _loc2_:int = param1;
            while(_loc2_ < param1 + area)
            {
               if(_loc2_ == param1)
               {
                  _gridArray[_loc2_] = 1;
               }
               else
               {
                  _gridArray[_loc2_] = 2;
               }
               _loc2_++;
            }
            grid.setId(param1);
         };
         area = grid.getArea();
         var i:int = 0;
         while(i < this._gridArray.length)
         {
            if(isInto(i))
            {
               into(i);
               break;
            }
            i++;
         }
      }
      
      private function initGridArray(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 == 7)
         {
            this._gridArray[0] = 0;
         }
         else if(param1 > 7)
         {
            this._gridArray[0] = 0;
            this._gridArray[1] = 0;
         }
         var _loc3_:int = _loc2_;
         while(_loc3_ < param1 + _loc2_)
         {
            this._gridArray[_loc3_] = 0;
            _loc3_++;
         }
      }
      
      private function orderGrid() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._grids.length)
         {
            this.gridIntoMap(this._grids[_loc1_]);
            _loc1_++;
         }
      }
      
      private function setGird(param1:Organism, param2:int, param3:Organism) : void
      {
         this._grids[param2] = new Grid(param1.getWidth(),param1.getHeight(),param3);
      }
      
      public function setGridsLoction() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < this._gridArray.length)
         {
            if(this._gridArray[_loc2_] == 1)
            {
               this.setGridLoction(this._grids[_loc1_]);
               _loc1_++;
            }
            _loc2_++;
         }
      }
      
      private function setGridLoction(param1:Grid) : void
      {
         param1.setloaction(loction[2 * (param1.getId() + param1.getWide() - 1)] * WIDE_GRID,loction[2 * (param1.getId() + param1.getHeigth() - 1) + 1] * HEIGHT_GRID);
      }
      
      public function getGrids() : Array
      {
         return this._grids;
      }
   }
}

