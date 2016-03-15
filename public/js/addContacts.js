(function(){

  $("#add_recipient").on("click",function(){
    var recipients = [];
    $(".email_from_contacts").each(function(i,el){
      if (el.checked) {

        recipients.push($(el).data("email"));
      }
    })

    $("#emailRecipient").val(recipients.join(","));
  })

  // $("#exampleInputEmail1").val("bongok@mail.com");

})();
