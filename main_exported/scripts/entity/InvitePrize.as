package entity
{
   public class InvitePrize
   {
      
      internal var orgs:Array;
      
      internal var tools:Array;
      
      internal var id:int;
      
      internal var cost:int;
      
      public function InvitePrize()
      {
         super();
      }
      
      public function setId(param1:int) : void
      {
         this.id = param1;
      }
      
      public function getId() : int
      {
         return this.id;
      }
      
      public function getCost() : int
      {
         return this.cost;
      }
      
      public function setCost(param1:int) : void
      {
         this.cost = param1;
      }
      
      public function getOrgs() : Array
      {
         return this.orgs;
      }
      
      public function getTools() : Array
      {
         return this.tools;
      }
      
      public function setOrgs(param1:Array) : void
      {
         this.orgs = param1;
      }
      
      public function setTools(param1:Array) : void
      {
         this.tools = param1;
      }
   }
}

