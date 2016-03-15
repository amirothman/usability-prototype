(function(){
  $(".clickable_contact").on("click",function(){
    $("#emailRecipient").val($(this).data("email"));
  })

})()