(function(){
  $("#clear_notification").on("click",function(){
    $.get("/close_flash",function(){
      console.log("clear flash");
    });
  });
})();