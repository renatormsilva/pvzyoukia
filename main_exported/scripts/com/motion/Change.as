package com.motion
{
   public class Change
   {
      
      public function Change()
      {
         super();
      }
      
      public function change() : Boolean
      {
         throw new Error("play--------必须被子类覆盖");
      }
   }
}

