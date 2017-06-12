class NewSensorFeed extends Thread{
 
   String parameter;
 
   public NewSensorFeed(String parameter){
      this.parameter = parameter;
   }
 
   public void run(){
     while(true){
       
       if(millis()-currentTime>1000){
    
        int val  = int(map(getFeedValue(parameter),0,1023,0,180));
        for(int i = 0; i < sg.length; i++){
           sg[i].setNewTarget(val);
        }
        
        System.out.println(val);
        
        currentTime = millis();
      }
     }
   }
   
  int getFeedValue(String feed_){
    String request = "https://io.adafruit.com/api/v2/kuanju/feeds/" + feed_ + "/data?limit=1";
    try{
      lines = loadStrings(request);
      //println(lines[0]);
      data = lines[0].substring(1,lines[0].length()-1); // get rid of the first [ and last ] ;
      json = parseJSONObject(data);
      value = json.getInt("value");
    }catch(Exception e){
      e.printStackTrace();
    }
      return value;
  }
}