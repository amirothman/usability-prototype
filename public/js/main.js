$(window).load(function(){
        
        var to_mark;
        var message_object;

        $("[data-toggle]").click(function() {

          var toggle_el = $(this).data("toggle");
          $(toggle_el).toggleClass("open-sidebar");
        });

         $(".swipe-area").swipe({
              swipeStatus:function(event, phase, direction, distance, duration, fingers)
                  {
                      if (phase=="move" && direction =="right") {
                           $(".container").addClass("open-sidebar");
                           return false;
                      }
                      if (phase=="move" && direction =="left") {
                           $(".container").removeClass("open-sidebar");
                           return false;
                      }
                  }
          });


         $('#mark_all').change(function() {
            if($(this).is(":checked")) {
              $('.marked').prop("checked",true);
            }
          });

         $('#mark_all').change(function() {
            if(!$(this).is(":checked")) {
              $('.marked').prop("checked",false);
            }
          });

         $('.marked').change(function(){
            if($(this).is(":checked")){
              $("#read-delete").css("visibility","visible")
            }
         });

         $('.marked').change(function(){
            if(!$(this).is(":checked")){
              $("#read-delete").css("visibility","hidden")
            }
         });


         $(".unread").click(function(){
            var class_name = $(this).attr("class");
            class_name = class_name.split(" ");
            class_name = class_name[1];
            $(".unread-mail."+class_name).toggleClass("read-mail message_view "+class_name);
         });

        var insert_to_modal = function(d){
              var message_object = JSON.parse(d);
              $(".message_title").html(message_object["Title"]);
              $(".message_sender").html(message_object["Sender"]);
              $(".message_date").html(message_object["Date"]);
              $(".message_content").html(message_object["Content"])
              
              var attachment = message_object["Attachment"];

              if(attachment!=""){
                $(".message_attachment").html('<i class="fa fa-paperclip"></i> '
                                              + attachment);
              }else{
                $(".message_attachment").html('');
              }

              $("#reply_title").attr("value","RE : "+message_object["Title"]);
              $("#reply_email").attr("value", message_object["Email"]);
              $("#forward_title").attr("value","FWD : "+message_object["Title"]);
            };

        $(".message_view").click(function(){
          to_mark = this.dataset.mailIndex;
          $.get("/get_message/"+to_mark,function(d){
            insert_to_modal(d);

          });


        })

        $(".message_view_outbox").click(function(){
          to_mark = this.dataset.mailIndex;
          $.get("/get_message_outbox/"+to_mark,function(d){
            insert_to_modal(d);
          });
        })

        $(".message_view_draft").click(function(){
          to_mark = this.dataset.mailIndex;
          $.get("/get_message_draft/"+to_mark,function(d){
            insert_to_modal(d);
          });
        })

        $(".message_view_trash").click(function(){
          to_mark = this.dataset.mailIndex;
          $.get("/get_message_trash/"+to_mark,function(d){
            insert_to_modal(d);
          });
        })
        
        $("#mark_spam").click(function(){
          location.href = "/mark_spam/"+to_mark;
        });

        $("#mark_trash").click(function(){
          location.href = "/mark_trash/"+to_mark;
        });

        $("#mark_important").click(function(){
          $('[data-mail-index="'+to_mark+'"]').toggleClass("flagged");
        });
});

        $(document).ready(function() {
            $('#contacts').DataTable();
        } );